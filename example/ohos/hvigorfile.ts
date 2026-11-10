import { appTasks } from '@ohos/hvigor-ohos-plugin';
// Flutter OH detects the TypeScript builder by the literal flutter-hvigor-plugin.
// Keep this marker when loading the SDK plugin through the isolated project.
import { flutterPlugin, flutterProjectPath } from './scripts/flutter-project';

export default {
  system: appTasks,
  plugins: [flutterPlugin.flutterHvigorPlugin(flutterProjectPath)],
};
