// ignore_for_file: always_specify_types

import 'package:test/test.dart';

import 'package:cone_lib/src/complement.dart' show formattedAmountHint;
import 'package:cone_lib/src/types.dart' show Posting;

void main() {
  List<Posting> expandPostings(List<List<String>> abbreviatedPostings) =>
      abbreviatedPostings
          .map(
            (List<String> abbreviatedPosting) => Posting(
              account: abbreviatedPosting[0],
              amount: abbreviatedPosting[1],
              currency: abbreviatedPosting[2],
            ),
          )
          .toList();
  group('Test amount hint', () {
    test('Test amount hint', () {
      expect(
          formattedAmountHint(
              locale: 'en_US',
              index: 1,
              postings: expandPostings([
                ['A', '1', 'USD'],
                ['B', '', 'USD'],
              ])),
          '-1.00');
    });
    test('Test amount hint', () {
      expect(
          formattedAmountHint(
              locale: 'en_US',
              index: 2,
              postings: expandPostings([
                ['A', '2', 'USD'],
                ['B', '3', 'USD'],
                ['C', '', 'USD'],
              ])),
          '-5.00');
    });
  });
  group('Test amount hint for \'de\' locale', () {
    test('Test amount hint', () {
      expect(
          formattedAmountHint(
              locale: 'de',
              index: 1,
              postings: expandPostings([
                ['A', '1', 'EUR'],
                ['B', '', 'EUR'],
              ])),
          '-1,00');
    });
    test('Test amount hint', () {
      expect(
          formattedAmountHint(
              locale: 'de',
              index: 1,
              postings: expandPostings([
                ['A', '17,50', 'EUR'],
                ['B', '', 'EUR'],
              ])),
          '0,00');
    });
    test('Test amount hint', () {
      expect(
          formattedAmountHint(
              locale: 'de',
              index: 1,
              postings: expandPostings([
                ['A', '17.50', 'EUR'],
                ['B', '', 'EUR'],
              ])),
          '-175,00');
    });
  });
}
