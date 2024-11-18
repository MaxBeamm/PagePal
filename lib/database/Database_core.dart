import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cis400_final/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore databaseFirestore = FirebaseFirestore.instance;
bool dbHasInit = false;

class FirebaseStorageApi {
  // https://stackoverflow.com/questions/63459136/deleting-a-folder-from-firebase-cloud-storage-in-flutter
  static Future<void> deleteFolder({
    required String path
  }) async {
    List<String> paths = [];
    paths = await _deleteFolder(path, paths);
    for (String path in paths) {
      await FirebaseStorage.instance.ref().child(path).delete();
    }
  }
  static Future<List<String>> _deleteFolder(String folder, List<String> paths) async {
    ListResult list = await FirebaseStorage.instance.ref().child(folder).listAll();
    List<Reference> items = list.items;
    List<Reference> prefixes = list.prefixes;
    for (Reference item in items) {
      paths.add(item.fullPath);
    }
    for (Reference subfolder in prefixes) {
      paths = await _deleteFolder(subfolder.fullPath, paths);
    }
    return paths;
  }
}

Future<void> databaseInit() async {
  if (dbHasInit) return; // This is probably not needed but to be safe
  dbHasInit = true;
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  return;
}