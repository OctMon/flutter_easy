#!/usr/bin/env ruby
require 'yaml'
require 'fileutils'

root = File.expand_path('../..', __dir__)
project = File.join(root, '.dart_tool', 'harmony_project')
abort 'Missing ohos/entry source directory' unless File.file?(File.join(root, 'ohos/entry/src/main/module.json5'))
FileUtils.mkdir_p(project)
# Keep SDK-specific package resolution and native build caches in this project.
%w[lib assets icons test integration_test ohos].each do |name|
  source = File.join(root, name)
  next unless File.directory?(source)
  FileUtils.mkdir_p(File.join(project, name))
  command = ['rsync', '-a', '--delete',
    '--exclude=build/', '--exclude=.hvigor/', '--exclude=.idea/',
    '--exclude=oh_modules/', '--exclude=node_modules/', '--exclude=.cxx/',
    '--exclude=local.properties', '--exclude=oh-package-lock.json5',
    '--exclude=BuildProfile.ets', '--exclude=GeneratedPluginRegistrant.ets',
    '--exclude=flutter_assets/', '--exclude=*.so',
    source + '/', File.join(project, name) + '/']
  abort "Unable to copy #{name}" unless system(*command, out: STDERR)
end
manifest = YAML.load_file(File.join(root, 'pubspec.yaml'))
# DevEco invokes Hvigor without Flutter build's version initialization.
# The SDK plugin reads these properties and otherwise replaces AppScope with 1/1.0.
version_name, version_code = manifest.fetch('version').to_s.split('+', 2)
abort 'pubspec.yaml must contain version: name+positive_build_number' unless
  !version_name.empty? && version_code && version_code.match?(/\A[0-9]+\z/) && version_code.to_i > 0
properties_path = File.join(project, 'ohos/local.properties')
properties = File.exist?(properties_path) ? File.read(properties_path) : ''
properties = properties.lines.reject { |line| line.match?(/\Aflutter\.version(?:Code|Name)\s*=/) }.join
properties += "\n" unless properties.empty? || properties.end_with?("\n")
properties += "flutter.versionName=#{version_name}\nflutter.versionCode=#{version_code}\n"
File.write(properties_path, properties)
overlay = YAML.load_file(File.join(__dir__, 'harmony_overrides.yaml'))
manifest['environment'].merge!(overlay.fetch('environment'))
manifest['dependencies'].merge!(overlay.fetch('dependencies'))
manifest['dependency_overrides'] = manifest.fetch('dependency_overrides', {}).merge(overlay.fetch('dependency_overrides', {}))
# Snapshot the library too: the example's original ../ path is outside this project.
library_root = File.dirname(root)
library = File.join(project, 'packages', 'flutter_easy')
FileUtils.mkdir_p(library)
%w[lib assets].each do |name|
  source = File.join(library_root, name)
  next unless File.directory?(source)
  FileUtils.mkdir_p(File.join(library, name))
  abort "Unable to copy flutter_easy/#{name}" unless system('rsync', '-a', '--delete',
    source + '/', File.join(library, name) + '/', out: STDERR)
end
FileUtils.cp(File.join(library_root, 'pubspec.yaml'), library)
manifest['dependencies']['flutter_easy'] = { 'path' => 'packages/flutter_easy' }
File.write(File.join(project, 'pubspec.yaml'), YAML.dump(manifest))
FileUtils.cp(File.join(root, 'analysis_options.yaml'), project)
lock = File.join(project, 'pubspec.lock')
# The checked-in HarmonyOS lock is authoritative even for an existing snapshot.
FileUtils.cp(File.join(__dir__, 'pubspec_ohos.lock'), lock)
puts project
