
/// Returns the localized string for the given key.
#define localize(key) [[UIApplication sharedApplication]localization]localizedStringForKey:key]

/**
 * Implementation for the localize(key) macro.
 *
 * This class assumes that your localization strings are inside files with path 
 * `<localizationName>.lproj/Localizable.strings`, where `localizationName` is a language code.
 *
 * The singleton initializes the class using the user preferred language and english ('en') as
 * fallback language.
 */
@interface Localization : NSObject

@property (nonatomic, retain) NSBundle* fallbackBundle;
@property (nonatomic, retain) NSBundle* preferredBundle;


/**
 * Return a localized text for the given key.
 *
 * The returned value is the first hit for the given key in the preferred or fallback bundle.
 * If a value is not found, the key itself is returned. 
 *
 * @param key Key to localize.
 * @return Localized text.
 */
-(NSString*) localizedStringForKey:(NSString*)key;


@end
