
This class lets you change the localization language in runtime. If you don't need this feature, 
just use NSLocalizedString.


How to localize with this class:

  - Create one file per language with path `<localizationName>.lproj/Localizable.strings`.
    Replace localizationName with the ISO code for your language. eg: 'es' or 'it' or whatever.
    Write this file in UTF-16. 
    Each line should be formatted like this: `"key"="value";` (don't forget the semicolon!).
    I include a sample Localizable.strings file.

  - Create an ivar Localization*localization in the application delegate, and initialize it
    in the applicationDidFinish.

  - Import Localization.h in the target .pch so it is available for every class.

  - Replace strings to be localized with `localize(@"key")`.

  - Delete this file.

I made you a singleton too but I ate it.
