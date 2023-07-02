import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uri_picker/uri_picker.dart';
import 'package:cone_lib/cone_lib.dart';

import 'package:cone/src/redux/actions.dart';
import 'package:cone/src/redux/state.dart';
import 'package:cone/src/reselect.dart';
import 'package:cone/src/services.dart';

dynamic isolateRefreshConeMiddleware(
    Store<ConeState> store, dynamic action, NextDispatcher next) {
  if (action == Actions.refreshFileContents) {
    if (store.state.ledgerFileUri != null) {
      UriPicker.readTextFromUri(store.state.ledgerFileUri!).then<void>(
        (String? contents) {
          if (contents != null && contents != store.state.contents) {
            compute<String, String>(topLevelParser, contents).then(
              (String jsonJournal) {
                final Journal? journal = serializers.deserializeWith(
                  Journal.serializer,
                  jsonDecode(jsonJournal),
                );
                store
                  ..dispatch(UpdateJournalAction(journal))
                  ..dispatch(UpdateContentsAction(contents));
              },
            );
          } else {
            store.dispatch(Actions.cancelRefresh);
          }
        },
      );
    }
  }
  next(action);
}

dynamic widgetTestRefreshConeMiddleware(
    Store<ConeState> store, dynamic action, NextDispatcher next) {
  if (action == Actions.refreshFileContents) {
    if (store.state.ledgerFileUri != null) {
      UriPicker.readTextFromUri(store.state.ledgerFileUri!).then<void>(
        (String? contents) {
          if (contents != store.state.contents) {
            final String jsonJournal = topLevelParser(contents!);
            final Journal? journal = serializers.deserializeWith(
              Journal.serializer,
              jsonDecode(jsonJournal),
            );
            store
              ..dispatch(UpdateJournalAction(journal))
              ..dispatch(UpdateContentsAction(contents));
          } else {
            store.dispatch(Actions.cancelRefresh);
          }
        },
      );
    }
  }
  next(action);
}

dynamic firstConeMiddleware(
    Store<ConeState> store, dynamic action, NextDispatcher next) {
  if (action == Actions.getPersistentSettings) {
    PersistentSettings.getSettings().then(
      (PersistentSettings persistentSettings) {
        store
          ..dispatch(InitializeSettingsAction(settings: persistentSettings))
          ..dispatch(Actions.markInitialized);
        if (store.state.ledgerFileUri != null) {
          store.dispatch(Actions.refreshFileContents);
        }
      },
    );
  } else if (action == Actions.pickLedgerFileUri) {
    UriPicker.pickUri().then(
      (String? uri) {
        UriPicker.getDisplayName(uri!).then(
          (String? displayName) {
            UriPicker.takePersistablePermission(uri).then(
              (_) {
                store
                  ..dispatch(UpdateSettingsAction('ledger_file_uri', uri))
                  ..dispatch(UpdateSettingsAction(
                      'ledger_file_display_name', displayName))
                  ..dispatch(Actions.refreshFileContents);
              },
            );
          },
        );
      },
    );
  } else if (action == Actions.putEmptyFile) {
    UriPicker.putEmptyFile().then(
      (String? uri) {
        UriPicker.getDisplayName(uri!).then(
          (String? displayName) {
            UriPicker.takePersistablePermission(uri).then(
              (_) {
                store
                  ..dispatch(UpdateSettingsAction('ledger_file_uri', uri))
                  ..dispatch(UpdateSettingsAction(
                      'ledger_file_display_name', displayName))
                  ..dispatch(Actions.refreshFileContents);
              },
            );
          },
        );
      },
    );
  } else if (action == Actions.submitTransaction) {
    if (store.state.ledgerFileUri == null) {
      return;
    }
    appendFile(store.state.ledgerFileUri!, formattedTransaction(store.state))
        .then((_) {
      store.dispatch(Actions.refreshFileContents);
    });
  } else if (action is UpdateSettingsAction) {
    SharedPreferences.getInstance().then((SharedPreferences prefs) {
      switch (action.value.runtimeType.toString()) {
        case 'bool':
          prefs.setBool(action.key, action.value as bool);
          break;
        case 'int':
          prefs.setInt(action.key, action.value as int);
          break;
        case 'Spacing':
          prefs.setInt(action.key, action.value.index as int);
          break;
        case 'String':
          prefs.setString(action.key, action.value as String);
          break;
        default:
      }
    });
  } else if (action is SetBrightness) {
    SharedPreferences.getInstance().then((SharedPreferences prefs) {
      prefs.setInt('brightness', action.brightness.index);
    });
  } else if (action == Actions.today) {
    store.dispatch(UpdateTodayAction(DateTime.now()));
  }
  next(action);
}
