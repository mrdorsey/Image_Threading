//
//  MRDImage.m
//  HomeworkOne
//
//  Created by Michael Dorsey on 4/28/13.
//  Copyright (c) 2013 Michael Dorsey. All rights reserved.
//

#import "MRDImage.h"

@implementation MRDImage

- (instancetype)initWithDictionary:(NSDictionary *)dict {
	self = [super init];
	if (self) {
		NSParameterAssert(dict);
		CFUUIDRef uuidRef = CFUUIDCreate(NULL);
		_uuid = CFBridgingRelease(CFUUIDCreateString(NULL, uuidRef));
		CFRelease(uuidRef);
		_title = [dict valueForKey:@"title"];
		_url = [NSURL URLWithString:[dict valueForKey:@"url"]];
	}
	
	return self;
}

@end
