/*
 
 Copyright (c) 2010 Dan Byers
 
 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the "Software"), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:
 
 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
 
 SecurityService.m
 
 */

#import "SecurityService.h"
#import "Security/Security.h"
#import "KeyChain.h"

@interface SecurityService (Private)

-(void) setupQuery;

-(NSMutableDictionary *) dictionaryToSecItemFormat: (NSDictionary *) dictionaryToConvert;
-(NSMutableDictionary *) secItemFormatToDictionary: (NSDictionary *) dictionaryToConvert;

@end


@implementation SecurityService

@synthesize keychain;
@synthesize genericQuery;

static const UInt8 kKeychainItemIdentifier[]    = "com.apple.dts.KeychainUI\0";
static SecurityService * shared = nil;
static NSLock * singletonLock = nil;
static NSLock * allocLock = nil;


+(SecurityService *) getInstance {
	
	if (singletonLock == nil) { 
		singletonLock = [[NSLock alloc] init];
	}
	
	[singletonLock lock];
	if ( shared == nil ) {
		shared = [[SecurityService alloc ] init];
		[shared setupQuery];
	}
	[singletonLock unlock];
	
	return shared;
}

+(id) alloc {
	
	if (allocLock == nil) { 
		allocLock = [[NSLock alloc] init];
	}
	
	[allocLock lock];
	NSAssert(shared == nil, @"Attempted to allocate second instance of singleton");
	shared = [super alloc];
	[allocLock unlock];
	
	return shared;
}

-(void) writeToKeychain: (NSString *) keychainKey {
	
	NSDictionary * attrs = NULL;
	NSDictionary * subAttr = NULL;
	
	if (SecItemCopyMatching((CFDictionaryRef)genericQuery, (CFTypeRef *)&attrs) == noErr) {
		
		// attrs will have a dictionary of all keychain entries.  should retrieve the proper one
		for (NSDictionary * key in attrs) {
			
			NSString * acctName = [key objectForKey:@"acct"];
			
			if (! [acctName isEqualToString: keychainKey]) {
				continue;
			}
			subAttr = key;
			
			break;
		}
		
	}
	
	if ( subAttr != NULL && [subAttr count] > 0 ) { 
		
		// get the attrs returned from the keychain and add them to the dictionary that controls the update
		NSMutableDictionary * updateItem = [NSMutableDictionary dictionaryWithDictionary:subAttr];
		
		// get the class value from the generic results query dict and add to the updateItem dict
		[updateItem setObject:[genericQuery objectForKey:(id)kSecClass] forKey:(id)kSecClass];
		
		// setup the dictionary that contains the new values fro the attrs
		NSMutableDictionary * tmpCheck = [self dictionaryToSecItemFormat:[self.keychain getElement:keychainKey]];
		
		// remove the class --- not a keychain attr
		[tmpCheck removeObjectForKey:(id)kSecClass];
		
		OSStatus result;
		if (  (result = SecItemUpdate((CFDictionaryRef)updateItem, (CFDictionaryRef) tmpCheck)) == noErr) { 
			//NSLog(@"SS: successfully updated the sec item");
		} else {
			//NSLog(@"SS: Unable to update sec item %d", result);
		}
		
	} else {
		if (SecItemAdd((CFDictionaryRef)[self dictionaryToSecItemFormat:[self.keychain getElement:keychainKey]], NULL) == noErr) { 
			//NSLog(@"SS: added the item to the keychain");
		} else {
			NSLog(@"SS: ERROR: unable to add item");
		}
	}
	
}

/*
	Add a new key chain element... i.e. a new key "account"
	NOTE: will overwrite any existing element with the same key.
 */
-(void) addNewKeyToChain:(NSString *) entryName
					label: (NSString *) label
					description: (NSString *) desc
					service: (NSString *) service
					comment: (NSString *) comment
					withData: (NSDictionary *) accountData {
	
	NSMutableDictionary * tmp = [[NSMutableDictionary alloc] init];
	
	[tmp setObject:label forKey:(id)kSecAttrLabel];
	[tmp setObject:desc forKey:(id)kSecAttrDescription];
	[tmp setObject:service forKey:(id)kSecAttrService];
	[tmp setObject:comment forKey:(id)kSecAttrComment];
	[tmp setObject:entryName forKey:(id)kSecAttrAccount];
	[tmp setObject:accountData forKey:(id)kSecValueData];
	
	[self.keychain addToKeyChain:entryName withData:tmp];
	
	[tmp release];
	
	[self writeToKeychain:entryName];
	
}

-(void) addNewValueDataToKey:(NSString *) keychainKey
				withNewValueKey: (NSString *) valueKey
				withNewValueData: (NSDictionary *) valueData {
	
	[self.keychain addValueToKeyChainItem:keychainKey itemValueKey:valueKey itemValueData:valueData];
	[self writeToKeychain:keychainKey];
	
}

-(void) removeKeychainItem:(NSString *) chainKey {
	
	[self.keychain removeKeyChainItem:chainKey];
	
	NSDictionary * attrs = NULL;
	NSDictionary * subAttr = NULL;
	
	if (SecItemCopyMatching((CFDictionaryRef)genericQuery, (CFTypeRef *)&attrs) == noErr) {
		
		// attrs will have a dictionary of all keychain entries.  should retrieve the proper one
		for (NSDictionary * key in attrs) {
			
			NSString * acctName = [key objectForKey:@"acct"];
			
			if (! [acctName isEqualToString: chainKey]) {
				continue;
			}
			subAttr = key;
			
			break;
		}
	}
	
	if ( subAttr != NULL && [subAttr count] > 0 ) { 
		
		NSMutableDictionary * delItem = [NSMutableDictionary dictionaryWithDictionary:subAttr];
		[delItem setObject:[genericQuery objectForKey:(id)kSecClass] forKey:(id)kSecClass];
		
		// now remove the keychain
		if (SecItemDelete((CFDictionaryRef)delItem) == noErr) { 
			//NSLog(@"SS: removed item from the keychain");
		} else {
			//NSLog(@"SS: ERROR: unable to remove item");
		}
		
	}
	
}

-(void) removeValueDataFromKey:(NSString *) keychainKey
					valueKey:(NSString *) valueKey {
	
	[self.keychain removeKeyChainItem:keychainKey itemKey:valueKey];
	
	[self writeToKeychain:keychainKey];
	
}

-(NSDictionary *) getKeyChainItemData:(NSString *) keychainKey {
	
	if ([self.keychain getElement:keychainKey] == nil) {
		return nil;
	}
	
	return [[self.keychain getElement:keychainKey] objectForKey:(id)kSecValueData];
}

-(void) dealloc {
	[self.genericQuery release];
	[self.keychain release];
	
	shared = nil;
	
	[super dealloc];
}


@end


@implementation SecurityService (Private)

-(void) setupQuery {
	
	genericQuery = [[NSMutableDictionary alloc] init];
	[genericQuery setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
	
	NSData * kcItemId = [NSData dataWithBytes: kKeychainItemIdentifier
					   length: strlen((const char *) kKeychainItemIdentifier )];
	[genericQuery setObject:kcItemId forKey:(id)kSecAttrGeneric];
	
	// retrieve all items from the keychain
	[genericQuery setObject:(id)kSecMatchLimitAll forKey:(id)kSecMatchLimit];
	
	// get the attrs of the keychain items
	[genericQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnAttributes];
	
	// init the dictionary used to hold return data from the keychain
	NSMutableArray * outArray = nil;
	
	self.keychain = [[[KeyChain alloc] init] autorelease];
	
	if ((SecItemCopyMatching((CFDictionaryRef)genericQuery, (CFTypeRef *) &outArray)) == errSecItemNotFound) { 
		
		//NSLog(@"SS: the key chain is empty!");
		
	} else {
		
		for (NSDictionary * key in outArray) {
			
			// setup all the keychain elements properly in our KeyChain storage
			NSString * acctName = [key objectForKey:@"acct"];
			
			//NSLog(@"Keychain account key item: %@", acctName);
			[self.keychain addToKeyChain:acctName withData:[self secItemFormatToDictionary: key]];
			
		}
		
	}
	
	[outArray release];
}

// the specified dictionary contains the items required to convert
-(NSMutableDictionary *) dictionaryToSecItemFormat: (NSDictionary *) dictionaryToConvert {
	
	NSMutableDictionary * returnDict = [NSMutableDictionary dictionaryWithDictionary:dictionaryToConvert];
	
	NSData * itemId = [NSData dataWithBytes: kKeychainItemIdentifier
									 length: strlen((const char *) kKeychainItemIdentifier)];
	[returnDict setObject:itemId forKey:(id) kSecAttrGeneric];
	[returnDict setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
	
	// convert the dictionary to an info list for serialization
	// could contain multiple result sets to be handled
	NSDictionary * resultsInfo = [dictionaryToConvert objectForKey:(id)kSecValueData];
	
	NSString * error;
	NSData * xmlData = [NSPropertyListSerialization dataFromPropertyList:resultsInfo 
										format:NSPropertyListXMLFormat_v1_0 
										errorDescription:&error];
	
	if (error != nil) { 
		NSLog(@"SS: Error! %@", error);
	}
	
	[returnDict setObject:xmlData forKey:(id)kSecValueData];
	
	return returnDict;
}

-(NSMutableDictionary *) secItemFormatToDictionary: (NSDictionary *) dictionaryToConvert {
	
	NSMutableDictionary * returnDict = [NSMutableDictionary dictionaryWithDictionary:dictionaryToConvert];
	
	// to get the password data from the keychain item, add the search key and class attr required to obtain the password
	[returnDict setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
	[returnDict setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
	
	// call the keychain services to get the password
	NSData * xmlData = NULL;
	OSStatus keychainErr = noErr;
	
	keychainErr = SecItemCopyMatching((CFDictionaryRef)returnDict, (CFTypeRef *)&xmlData);
	
	if (keychainErr == noErr) { 
		
		[returnDict removeObjectForKey:(id)kSecReturnData];
		
		NSString * errorDesc = nil;
		NSPropertyListFormat fmt;
		NSDictionary * resultsInfo = (NSDictionary *) [NSPropertyListSerialization propertyListFromData:xmlData
												mutabilityOption:NSPropertyListMutableContainersAndLeaves
												format:&fmt
												errorDescription: &errorDesc];
		
		[returnDict setObject:resultsInfo forKey:(id)kSecValueData];
		
	} else { 
		NSLog(@"SS: format error.");
	}
	
	[xmlData release];
	return returnDict;
}

@end

