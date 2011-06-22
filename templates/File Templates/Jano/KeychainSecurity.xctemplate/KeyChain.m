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
 
 KeyChain.m
 
 */

#import "KeyChain.h"


@implementation KeyChain


@synthesize data;


-(id) init {
	self = [super init];
	if (self) {
		self.data = [[NSMutableDictionary alloc] init];
	}
	return self;
}

-(BOOL) keyExists:(NSString *) key {
	
	if ([self.data objectForKey:key] != nil) {
		return TRUE;
	}
	return FALSE;
}

-(void) addToKeyChain:(NSString *) chainKey 
			withData:(NSMutableDictionary *) chainValue {
	[self.data setObject:chainValue forKey:chainKey];
}

-(void) addValueToKeyChainItem:(NSString *) chainKey
				itemValueKey:(NSString *) valueKey
				itemValueData:(NSDictionary *) valueData {
	
	NSDictionary * keyItem = [self.data objectForKey:chainKey];
	NSMutableDictionary * newKeyItem = [NSMutableDictionary dictionaryWithDictionary:keyItem];
	
	NSDictionary * currentData = [newKeyItem objectForKey:(id)kSecValueData];
	NSMutableDictionary * newData = [NSMutableDictionary dictionaryWithDictionary:currentData];
	[newData setObject:valueData forKey:valueKey];
	
	[newKeyItem setObject:newData forKey:(id)kSecValueData];
	[self.data setObject:newKeyItem forKey:chainKey];

}

-(void) removeKeyChainItem:(NSString *) chainKey
				itemKey:(NSString *) valueKey {
	
	[[[self.data objectForKey:chainKey] objectForKey:(id)kSecValueData] removeObjectForKey:valueKey];
}

-(void) removeKeyChainItem:(NSString *) chainKey {
	[self.data removeObjectForKey:chainKey];
}

-(NSDictionary *) getElement:(NSString *) key {
	return [self.data objectForKey:key];
}

-(void) dealloc {
	[self.data release];
	
	[super dealloc];
}

@end

