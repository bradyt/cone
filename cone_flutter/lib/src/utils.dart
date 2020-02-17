import 'package:intl/intl.dart' show NumberFormat;
import 'package:intl/number_symbols.dart' show NumberSymbols;
import 'package:intl/number_symbols_data.dart' show numberFormatSymbols;

import 'package:cone_lib/cone_lib.dart'
    show AccountDirective, Journal, JournalItem, Posting, Transaction;

int reducePostingFields(Posting posting) =>
    ((posting.account?.isEmpty ?? true) ? 0 : 1) +
    ((posting.amount?.quantity?.isEmpty ?? true) ? 0 : 2);

List<bool> emptyPostingFields(Posting posting) {
  return <bool>[
    posting.account?.isEmpty ?? true,
    posting.amount?.quantity?.isEmpty ?? true,
  ];
}

// bool validTransaction(Transaction transaction) {
//   final bool descriptionIsValid = transaction
//   .description?.isNotEmpty ?? false;

//   final List<PostingStatus> postingStatuses =
//       transaction.postings.map((Posting posting) {
//     if (posting.account?.isEmpty ?? true) {
//       if (posting.amount?.quantity?.isEmpty ?? true) {
//         return PostingStatus.noAccountNoQuantity;
//       } else {
//         return PostingStatus.amountOnly;
//       }
//     } else {
//       if (posting.amount?.quantity?.isEmpty ?? true) {
//         return PostingStatus.accountNoQuantity;
//       } else {
//         return PostingStatus.accountAndAmount;
//       }
//     }
//   }).toList();

//   return descriptionIsValid;
// }

int localeSpacing(String locale) =>
    ((numberFormatSymbols[locale] as NumberSymbols)
            .CURRENCY_PATTERN
            .contains('\u00A0'))
        ? 1
        : 0;

bool localeCurrencyOnLeft(String locale) =>
    numberFormatSymbols[locale].CURRENCY_PATTERN.endsWith('0') as bool;

String localeCurrency(String locale) =>
    NumberFormat.currency(locale: locale).currencyName;

List<String> descriptions(Journal journal) => journal.journalItems
    .whereType<Transaction>()
    .map<String>((Transaction transaction) => transaction.description)
    .where(
        (String description) => description.isNotEmpty && description != null)
    .toList();

List<String> accounts(Journal journal) {
  final List<String> result = <String>[];
  for (final JournalItem item in journal.journalItems) {
    if (item is Transaction) {
      result.addAll(
        item.postings
            .map<String>((Posting posting) => posting.account)
            .where((String account) => account.isNotEmpty)
            .toList(),
      );
    } else if (item is AccountDirective) {
      result.add(item.account);
    }
  }
  return result;
}

List<String> sortSuggestions(List<String> original) {
  final Map<String, int> frequencyMap = <String, int>{};
  for (final String s in original) {
    frequencyMap.update(
      s,
      (int frequency) => frequency + 1,
      ifAbsent: () => 1,
    );
  }

  return frequencyMap.keys.toList()
    ..sort((String s, String t) {
      if (frequencyMap[s] > frequencyMap[t]) {
        return -1;
      } else if (frequencyMap[s] < frequencyMap[t]) {
        return 1;
      } else if (original.lastIndexOf(s) > original.lastIndexOf(t)) {
        return -1;
      } else if (original.lastIndexOf(s) < original.lastIndexOf(t)) {
        return 1;
      } else {
        return 0;
      }
    });
}

List<String> filterSuggestions(String input, List<String> candidates) {
  final List<String> fuzzyText = input.split(' ');
  return candidates
      .where((String candidate) => fuzzyText.every((String subtext) =>
          candidate.toLowerCase().contains(subtext.toLowerCase())))
      .toList();
}

String generateAlias(String uri, String displayName) {
  final Map<String, String> providerMap = <String, String>{
    'com.android.providers.downloads.documents': 'Downloads',
    'com.box.android.documents': 'Box.com',
    'com.google.android.apps.docs.storage': 'Google Drive',
    'com.microsoft.skydrive.content.storageaccessprovider': 'OneDrive',
    'org.nextcloud.documents': 'Nextcloud',
  };

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
