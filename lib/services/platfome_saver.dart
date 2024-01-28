import 'dart:io';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart' as path_provider_interface;
import 'dart:async';
Future<void> saveAndLaunchFile(List<int> bytes, String fileName) async {
  String? path = await path_provider_interface.PathProviderPlatform.instance.getApplicationSupportPath();

  final String fileLocation =
  Platform.isWindows ? '$path\\$fileName' : '$path/$fileName';
  final File file = File(fileLocation);
  await file.writeAsBytes(bytes, flush: true);

  if (Platform.isWindows) {
    await Process.run('start', <String>[fileLocation], runInShell: true);
  } else if (Platform.isMacOS) {
    await Process.run('open', <String>[fileLocation], runInShell: true);
  } else if (Platform.isLinux) {
    await Process.run('xdg-open', <String>[fileLocation], runInShell: true);
  }
}