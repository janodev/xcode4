
#import "Localization.h"

@interface Localization()
- (NSBundle*) languageBundle:(NSString*) languageCode;
- (id)initWithLocalizationsPreferred:(NSString*)preferred andFallback:(NSString*)fallback;
@end


@implementation Localization

@synthesize fallbackBundle  = _fallbackBundle;
@synthesize preferredBundle = _preferredBundle;


/**
 * Initialize with the language of the device and english (en) as fallback.
 */
- (id)init {
    if ((self = [super init])) {
        NSString *preferred = [[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0];
        NSString *fallback = @"en";
        _preferredBundle = [self languageBundle:preferred];
        _fallbackBundle = [self languageBundle:fallback];
    } 
    return self;
}


/**
 * Initialize the bundles for the given localization names.
 * For each localization name there should be a `<localizationName>.lproj/Localizable.strings` file.
 * 
 * @param preferred Preferred localization name.
 * @param fallback Fallback localization name, usually @"en".
 */
- (id)initWithLocalizationsPreferred:(NSString*)preferred andFallback:(NSString*)fallback {
    if ((self = [super init])) {
        _preferredBundle = [self languageBundle:preferred];
        _fallbackBundle = [self languageBundle:fallback];
        // there should always be a fallback bundle
        NSAssert(_fallbackBundle, @"Fallback bundle for %@ not found.", fallback);
    }
    return self;
}


/**
 * Return a NSBundle containing a `<localizationName>.lproj/Localizable.strings` file.
 * 
 * @param localizationName The localization name.
 * @return NSBundle for the given localization name.
 */
-(NSBundle*) languageBundle:(NSString*) localizationName {
    NSString *bundlePath = [[NSBundle mainBundle] 
                            pathForResource:@"Localizable" ofType:@"strings" inDirectory:nil forLocalization:localizationName];
    NSString *fallbackBundlePath = [bundlePath stringByDeletingLastPathComponent];
    NSBundle *bundle = [[NSBundle alloc] initWithPath:fallbackBundlePath];    
    return bundle;
}


/**
 * Return a localized text for the given key.
 *
 * The returned value is the first hit for the given key in the preferred or fallback bundle.
 * If a value is not found, the key itself is returned. 
 *
 * @param key Key to localize.
 * @return Localized text.
 */
- (NSString*) localizedStringForKey:(NSString*)key {
    
    NSString* result = nil;
    if (self.preferredBundle!=nil) {
        result = [self.preferredBundle localizedStringForKey:key value:nil table:nil];
    }
    if (result == nil) {
        result = [self.fallbackBundle localizedStringForKey:key value:nil table:nil];
    }
    if (result == nil) {
        result = key;
    }
    
    return result;
}


@end
