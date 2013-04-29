//
//  MRDImage.h
//  HomeworkOne
//
//  Created by Michael Dorsey on 4/28/13.
//  Copyright (c) 2013 Michael Dorsey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MRDImage : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSString *uuid;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
