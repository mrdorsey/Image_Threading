//
//  MRDDataController.h
//  HomeworkOne
//
//  Created by Michael Dorsey on 4/27/13.
//  Copyright (c) 2013 Michael Dorsey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MRDDataController : UIViewController

+ (instancetype)sharedInstance;

- (void)fetchImageList:(void (^)(NSArray *images, NSError *error))completionBlock;

- (void)fetchImageForURL:(NSURL *)url completionBlock:(void (^)(UIImage *image, NSError *error))completionBlock;

- (void)cancelImageRequestForURL:(NSURL *)url;

@end
