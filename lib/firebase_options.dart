// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web – run the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos – run the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows – run the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux – run the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCUuutQuJtam1O1SHQSmQmDE5tRJahao-c',
    appId: '1:477598499756:android:f13c12f5e49be4807f3009',
    messagingSenderId: '477598499756',
    projectId: 'inventorymanagement-af53a',
    databaseURL: 'https://inventorymanagement-af53a-default-rtdb.firebaseio.com',
    storageBucket: 'inventorymanagement-af53a.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDRJHEzsZKpG5lz6Oa9EtGsmEp95u2xIQ4',
    appId: '1:477598499756:ios:e165124e9a1648d97f3009',
    messagingSenderId: '477598499756',
    projectId: 'inventorymanagement-af53a',
    databaseURL: 'https://inventorymanagement-af53a-default-rtdb.firebaseio.com',
    storageBucket: 'inventorymanagement-af53a.firebasestorage.app',
    androidClientId:
        '477598499756-798lrpfp75llf97d2ltmvutop7j58sbu.apps.googleusercontent.com',
    iosClientId:
        '477598499756-ajrev60j6op98spihkhoceser3o8ud9m.apps.googleusercontent.com',
    iosBundleId: 'com.jjbic.inventorymanagement',
  );
}
