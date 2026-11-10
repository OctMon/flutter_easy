import { flutterPlugin, flutterProjectPath } from './scripts/flutter-project';

flutterPlugin.injectNativeModules(__dirname, flutterProjectPath);
