### 0.2.19 (2020-01-14)

* Remove duplicates in description suggestions

* Remove comments and newlines from account suggestions

* Fix amounts like 83,29 being formatted as 83,29000000000001

* Fix text is too dark in Android 10's auto brightness

### 0.2.18 (2019-10-06)

* Fix amount hint for locales with comma decimal separator

### 0.2.17 (2019-09-29)

* Fix bug. Number locale is now used to zero pad amounts in hint text
  and new transactions written to file.

### 0.2.16 (2019-09-27)

* Fixes bug, where currency symbols were wrapped in double quotes

### 0.2.15 (2019-09-27)

* Fix bug calling `where` on `null`

### 0.2.14 (2019-09-27)

* View of file contents is updated
  * Colors are taken from Emacs and ledger-mode.el
  * Comments and directives are dropped from view

* Dark theme option added to settings

* Parser returns tokens, which provide location in buffer

### 0.2.13 (2019-09-26)

* Add option to reverse sort

* Journal items are displayed as cards

* Comment chunks have same color as comments in emacs

* Use PetitParser to split file into chunks

### 0.2.12 (2019-09-25)

* Fix save button

* Parse payee directives

* Collapse settings expansion tile by default

* Wrap non-alphabetic commodities in quotes

* Add example cli to project

### 0.2.11 (2019-09-24)

* Fix NoSuchMethodError

### 0.2.10 (2019-09-23)

* Add zero padding according to new "number locale" option

* Add option for spacing between amount and currency

* Number of decimals is according to currency. E.g.,
  * USD: 2
  * JPY: 0

### 0.2.9 (2019-09-20)

* Add Russian localization back

* Add localizations via Google Translate for the following locales:
  de, fr, hi, in, it, ja, th, tl, zh

* Add localization for "Ledger file"

### 0.2.8 (2019-09-18)

* Restructure codebase

* Swipe to dismiss previous posting will lose focus of current field

* Pull down to refresh home page, file contents

* Introduce ModalBarrier to prevent interaction with form while saving

### 0.2.7 (2019-09-14)

* Add Russian localization

### 0.2.6 (2019-09-03)

* Persist write permissions

### 0.2.5 (2019-08-24)

* Fix issue with last lines not visible

### 0.2.4 (2019-08-23)

* Allow selection of files with mimetype application/octet-stream

### 0.2.3 (2019-08-01)

* Rethrow exceptions when appending

* Dark theme for Android Q and Samsung's Android P

* Reading and writing over Platform Channel is factored out into
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
