import fs from 'fs';
import path from 'path';
import crypto from 'crypto';
import { execFileSync } from 'child_process';

const nativeProjectPath = path.dirname(__dirname);
const projectRoot = path.dirname(nativeProjectPath);
const isIsolatedProject = path.basename(projectRoot) === 'harmony_project'
  && path.basename(path.dirname(projectRoot)) === '.dart_tool';
export const flutterProjectPath = isIsolatedProject
  ? projectRoot
  : path.join(projectRoot, '.dart_tool', 'harmony_project');

if (!isIsolatedProject) {
  // Refresh the Flutter source snapshot whenever DevEco loads the root project.
  execFileSync('ruby', [path.join(projectRoot, 'ohos', 'scripts', 'prepare_harmony.rb')], {
    stdio: ['ignore', 'ignore', 'inherit'],
  });
  const dependencyFingerprint = (): string => {
    const hash = crypto.createHash('sha256');
    for (const name of ['pubspec.yaml', 'ohos/scripts/harmony_overrides.yaml', 'ohos/scripts/pubspec_ohos.lock', 'ohos/scripts/flutter_oh', 'ohos/scripts/prepare_harmony.rb']) {
      hash.update(fs.readFileSync(path.join(projectRoot, name)));
    }
    hash.update(fs.readFileSync(path.join(projectRoot, '..', 'pubspec.yaml')));
    hash.update(process.env.FLUTTER_OH_HOME || '');
    return hash.digest('hex');
  };
  const expected = dependencyFingerprint();
  const stateFile = path.join(flutterProjectPath, '.native_dependencies.sha256');
  const pluginFile = path.join(flutterProjectPath, 'ohos', 'node_modules', 'flutter-hvigor-plugin', 'index.ts');
  if (!fs.existsSync(pluginFile)
      || !fs.existsSync(path.join(flutterProjectPath, '.dart_tool', 'package_config.json'))
      || !fs.existsSync(path.join(flutterProjectPath, '.flutter-plugins-dependencies'))
      || !fs.existsSync(stateFile)
      || fs.readFileSync(stateFile, 'utf8') !== expected) {
    execFileSync('/bin/bash', [path.join(projectRoot, 'ohos', 'scripts', 'flutter_oh'), 'pub', 'get'], {
      stdio: 'inherit',
    });
    fs.writeFileSync(stateFile, dependencyFingerprint());
  }
  const registrant = path.join('entry', 'src', 'main', 'ets', 'plugins', 'GeneratedPluginRegistrant.ets');
  const destination = path.join(nativeProjectPath, registrant);
  fs.mkdirSync(path.dirname(destination), { recursive: true });
  fs.copyFileSync(path.join(flutterProjectPath, 'ohos', registrant), destination);
}

// Use the SDK's existing plugin with the isolated Flutter dependency graph.
export const flutterPlugin = require(path.join(flutterProjectPath, 'ohos', 'node_modules', 'flutter-hvigor-plugin'));
