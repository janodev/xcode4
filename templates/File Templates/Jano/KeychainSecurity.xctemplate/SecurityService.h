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
 
 SecurityService.h
 */

// This class requires the Security.framework
// See http://www.manicgaming.com/2010/10/simple-secure-storage-in-ios/

#import <Foundation/Foundation.h>

@class KeyChain;

@interface SecurityService : NSObject {
	
	KeyChain * keychain;
	NSMutableDictionary * genericQuery;
	
}

@property (nonatomic, retain) KeyChain * keychain;
@property (nonatomic, retain) NSMutableDictionary * genericQuery;

+(SecurityService *) getInstance;

// create and persist a NEW Keychain item to the device's Keychain
-(void) addNewKeyToChain:(NSString *) entryName
			label: (NSString *) label
			description: (NSString *) desc
			service: (NSString *) service
			comment: (NSString *) comment
			withData: (NSDictionary *) accountData;

// add or update a dictionary of data mapped by the valueKey
-(void) addNewValueDataToKey:(NSString *) keychainKey
				withNewValueKey: (NSString *) valueKey
				withNewValueData: (NSDictionary *) valueData;

// remove a specific key/value pair from the Keychain item
-(void) removeValueDataFromKey:(NSString *) keychainKey
					valueKey:(NSString *) valueKey;

// return an NSDictionary for the specified Keychain item
-(NSDictionary *) getKeyChainItemData:(NSString *) keychainKey;

// remove the Keychain item from the Keychain
-(void) removeKeychainItem:(NSString *) settingsKey;


@end


