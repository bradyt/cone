import 'package:flutter/services.dart';

import 'package:uri_picker/uri_picker.dart';

import 'package:cone/src/utils.dart';

class FileModel {
  FileModel({String uri})
      : _uri = uri,
        _isRefreshingContents = false,
        _saveInProgress = false;

  String _uri;
  String _displayName;
  String _contents;
  String _dateFormat;
  bool _isRefreshingContents;
  bool _saveInProgress;

  String get uri => _uri;
  String get displayName => _displayName;
  String get alias => generateAlias(uri, displayName);
  String get contents => _contents;
  String get dateFormat => _dateFormat;
  bool get isRefreshingContents => _isRefreshingContents;
  bool get saveInProgress => _saveInProgress;

  Future<void> pickUri({bool debugMode}) async {
    String candidateUri;
    try {
      candidateUri = await UriPicker.pickUri();
      if (candidateUri != null) {
        _uri = candidateUri;
        _displayName = await UriPicker.getDisplayName(_uri);
        await UriPicker.takePersistablePermission(_uri);
      } else if (debugMode) {
        _uri = null;
        _displayName = null;
      }
    } catch (_) {} finally {}
  }

  Future<void> refreshContents({void Function() notifyListeners}) async {
    if (_uri == null) {
      _contents = null;
      notifyListeners();
    } else {
      try {
        _isRefreshingContents = true;
        notifyListeners();
        _contents = await UriPicker.readTextFromUri(_uri);
        // Get the date format by matching the date in the file
        RegExp slashRegExp = RegExp(r'^[0-9]+/', multiLine: true);
        if (slashRegExp.hasMatch(_contents)) {
          _dateFormat = "yyyy/MM/dd";
        } else {
          _dateFormat = "yyyy-MM-dd";
        }
      } catch (_) {} finally {
        _isRefreshingContents = false;
        notifyListeners();
      }
    }
  }

  Future<void> appendTransaction({
    String transaction,
    void Function() notifyListeners,
  }) async {
    if (!saveInProgress) {
      _saveInProgress = true;
      notifyListeners();
      try {
        await appendFile(uri, transaction);
      } on PlatformException catch (_) {
        rethrow;
      } finally {
        _saveInProgress = false;
        notifyListeners();
      }
    }
  }
}

Map<String, String> providerMap = <String, String>{
  'com.android.providers.downloads.documents': 'Downloads',
  'com.box.android.documents': 'Box.com',
  'com.google.android.apps.docs.storage': 'Google Drive',
  'com.microsoft.skydrive.content.storageaccessprovider': 'OneDrive',
  'org.nextcloud.documents': 'Nextcloud',
};

String generateAlias(String uri, String displayName) {
  if (displayName == null) {
    if (uri == null) {
      return null.toString();
    }
    return uri;
  }
  final String authority = Uri.parse(uri).authority;
  final String path = Uri.parse(Uri.decodeFull(uri)).path;
  if (authority == 'com.android.externalstorage.documents') {
    if (path.startsWith('/document/home:')) {
      return '/Documents/${path.split(':')[1]}';
    } else if (path.startsWith('/document/primary:')) {
      return '/${path.split(':')[1]}';
    }
  } else if (providerMap.keys.contains(authority)) {
    return '${providerMap[authority]} - $displayName';
  }
  return '$displayName\n$authority';
}
