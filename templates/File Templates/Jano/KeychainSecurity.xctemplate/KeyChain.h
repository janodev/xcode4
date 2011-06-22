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

 KeyChain.h

 */

#import <Foundation/Foundation.h>

// you don't need to interact with this class

@interface KeyChain : NSObject {

	NSMutableDictionary * data;
	
}

@property (nonatomic, retain) NSMutableDictionary * data;


// determine if a Keychain item exists, as mapped via the provided key
-(BOOL) keyExists:(NSString *) key;

-(void) addToKeyChain:(NSString *) chainKey 
	     withData:(NSMutableDictionary *) chainValue;

-(void) addValueToKeyChainItem:(NSString *) chainKey
				itemValueKey:(NSString *) valueKey
				itemValueData:(NSDictionary *) valueData;

-(void) removeKeyChainItem:(NSString *) chainKey
				itemKey:(NSString *) valueKey;

-(void) removeKeyChainItem:(NSString *) chainKey;

-(NSDictionary *) getElement:(NSString *) key;

@end


