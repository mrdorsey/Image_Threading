//
//  MRDDataController.m
//  HomeworkOne
//
//  Created by Michael Dorsey on 4/27/13.
//  Copyright (c) 2013 Michael Dorsey. All rights reserved.
//

#import "MRDDataController.h"
#import "UWCEHTTPOperation.h"

static NSString *const kMRDImageFeedURLString = @"http://f.cl.ly/items/1K3Z0U1M3X0t3k0P3c0k/images.json";
static NSString *const kMRDImagesKey = @"images";

@interface MRDDataController ()

@property (nonatomic, strong) NSOperationQueue *networkQueue;
@property (nonatomic, strong) NSOperationQueue *workQueue;

@end

@implementation MRDDataController

+ (instancetype)sharedInstance {
	static id instance;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		instance = [self new];
	});
	return instance;
}

- (instancetype)init {
	self = [super init];
	
	if (self)
	{
		_networkQueue = [NSOperationQueue new];
		_networkQueue.name = @"com.uwce.networkqueue";
		_networkQueue.maxConcurrentOperationCount = 10;
		_workQueue = [NSOperationQueue new];
		_workQueue.name = @"com.uwce.workqueue";
	}
	
	return self;
}

- (void)fetchImageList:(void (^)(NSArray *images, NSError *error))completionBlock {
	NSParameterAssert(completionBlock);
	NSURL *url = [NSURL URLWithString:kMRDImageFeedURLString];
	UWCEHTTPOperation *op = [[UWCEHTTPOperation alloc] initWithURL:url];
	NSParameterAssert(op);
	__weak UWCEHTTPOperation *weakOp = op;
	[op setCompletionBlock:^{
		UWCEHTTPOperation *strongOp = weakOp;
		if (strongOp.error) {
			completionBlock(nil, strongOp.error);
		}
		else {
			NSData *result = strongOp.result;
			NSParameterAssert(result);
			NSParameterAssert(self.workQueue);
			[self.workQueue addOperationWithBlock:^{
				NSError *error;
				id object = [NSJSONSerialization JSONObjectWithData:result options:0 error:&error];
				if (object) {
					if ([object isKindOfClass:[NSDictionary class]]) {
						NSArray *images = ((NSDictionary *)object)[kMRDImagesKey];
						if ([images isKindOfClass:[NSArray class]]) {
							completionBlock(images, nil);
							return;
						}
						else {
							error = [NSError errorWithDomain:@"" code:0 userInfo:nil];
						}
					}
					else {
						error = [NSError errorWithDomain:@"" code:0 userInfo:nil];
					}
				}
				completionBlock(nil, error);
			}];
		}
	}];
	
	[self.networkQueue addOperation:op];
}

- (void)fetchImageForURL:(NSURL *)url completionBlock:(void (^)(UIImage *, NSError *))completionBlock {
	if (url == nil) {
		NSParameterAssert(NO);
		return;
	}
	
	NSParameterAssert(completionBlock);
	UWCEHTTPOperation *op = [[UWCEHTTPOperation alloc] initWithURL:url];
	__weak UWCEHTTPOperation *weakOp = op;
	NSParameterAssert(op);
	[op setCompletionBlock:^{
		UWCEHTTPOperation *strongOp = weakOp;
		if (strongOp.error) {
			completionBlock(nil, strongOp.error);
		}
		else {
			UIImage *image = [[UIImage alloc] initWithData:strongOp.result];
			if (image) {
				completionBlock(image, nil);
			}
			else {
				completionBlock(nil, [NSError errorWithDomain:@"" code:0 userInfo:nil]);
			}
		}
	}];
	
	[self.networkQueue addOperation:op];
}

- (void)cancelImageRequestForURL:(NSURL *)url {
	NSParameterAssert(url);
	NSArray *operations = [[self.networkQueue operations] copy];
	for (UWCEHTTPOperation *operation in operations) {
		NSParameterAssert([operation isKindOfClass:[UWCEHTTPOperation class]]);
		if ([[[operation url] absoluteString] isEqualToString:[url absoluteString]]) {
			[operation cancel];
	//		NSLog(@"Canceling %@", [operation url]);
		}
	}
}

@end
