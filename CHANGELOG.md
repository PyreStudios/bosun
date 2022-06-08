## 0.2.2
- Adjusted how help commands are generated.

## 0.2.1
- Add support for root commands with a processable body while supporting sub-commands off of that root.

## 0.2.0
- Add support for suggesting similar commands when an incorrect one is used.

## 0.1.0
- Add supportedFlags Command property
- Documentation around the Command class.

## 0.0.4
- Fix an issue where commands were double printing the example as their help text instead of the example and the description.

## 0.0.3
- Revert part of the changes in 0.0.2. Bosun shouldn't care assume that you pass the app name as an arg.

## 0.0.2
- Fix an issue where commands would not process properly due to the app name being considered as an argument (which Dart does not do).

## 0.0.1

- Initial version.
