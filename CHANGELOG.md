### 0.2.3 (2019-08-01)

* Rethrow exceptions when appending

* Dark theme for Android P

* Reading and writing over Platform Channnel is factored out into
  plugin

### 0.2.2 (2019-07-26)

* Save button is disabled before writing to disk

* Switch to font with more currency symbols

* Don't insert line with two spaces after transaction

* Pad amount with zeros if currency matches locale's

* Try to align on decimal separator

### 0.2.1 (2019-07-22)

* Fixes back button

* Trim trailing whitespace from postings with no amounts

* Save button now exits the form

* Autocompletion for account field opens on focus

* Autocompletion for descriptions field

* Fix case sensitivity for autocomplete

* Project now has some tests

### 0.2.0 (2019-07-09)

* Breaking change: At least for now, cone requires Android >= 19.

* Location of ledger file is now configurable. Implemented via Storage
  Access Framework and `ACTION_OPEN_DOCUMENT`.

  - Works with external storage, such as Documents.

  - Currently works with Google Drive and OneDrive.

* No longer need to query user for permission

* Home page now shows simply the contents of the ledger file.

### 0.1.5 (2019-06-28)

* Add completion of account names via those found in ledger file

* User can configure app to put currencies to the left of amount

* Borrows several UI ideas from the MoLe app. 1. Removal of button to
  add a posting row. 2. Save button is disabled until entry is
  valid. 3. Balancing amount appears in first empty amount field.

### 0.1.4 (2019-06-22)

* Fixes error involving developing with "hot reload"

* When app is first used, it will set the default currency to that of
  user's preferred device locale

* Added language localization for `es_MX` and `pt_BR` (introduction
  has not been translated)

* Improve data entry UI layout, so that Description and Account fields
  are easier to read

### 0.1.3 (2019-06-05)

* Make defaults configurable (prepopulating currency, accounts)

* Remove open file feature for now, to ease development in other
  features

### 0.1.2 (2019-03-03)

* Fix issue with reliability of build

* Add a button to open file in an external text editor

### 0.1.1 (2019-02-23)

* Fix permissions to write to Documents

### 0.1.0 (2019-02-17)

* Add cone app, with data entry form, logo, etc

### 0.0.0 (2019-02-14)

* Sample flutter app
