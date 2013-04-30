//
//  MRDTableViewController.m
//  HomeworkOne
//
//  Created by Michael Dorsey on 4/27/13.
//  Copyright (c) 2013 Michael Dorsey. All rights reserved.
//

#import "MRDDataController.h"
#import "MRDImage.h"
#import "MRDTableViewCell.h"
#import "MRDTableViewController.h"
#import "UIImage+UWCEAdditions.h"

@interface MRDTableViewController ()

@property (nonatomic) NSArray *items;

@end

@implementation MRDTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
	self = [super initWithStyle:style];
	if (self) {
		
	}
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	[self.tableView registerClass:[MRDTableViewCell class] forCellReuseIdentifier:@"Cell"];
	
	__weak typeof(*self) *weakSelf = self;
	[[MRDDataController sharedInstance] fetchImageList:^(NSArray *images, NSError *error) {
		typeof(*weakSelf) *strongSelf = weakSelf;
		if (strongSelf) {
			dispatch_async(dispatch_get_main_queue(), ^(void) {
				if (images) {
					self.items = [self _modelObjectsFromJSON:images];
				}
				else {
					self.items = nil;
					NSLog(@"%@", error);
				}
				[self.tableView reloadData];
			});
		}
	}];
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"Cell";
	MRDTableViewCell *cell = (MRDTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
	MRDImage *image = [self.items objectAtIndex:indexPath.row];
	cell.textLabel.text = image.title;
	[self fetchImageForCell:cell row:indexPath.row];
	return cell;
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(MRDTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	[self cancelImageForRow:indexPath.row];
}

#pragma mark - load image
- (void)fetchImageForCell:(MRDTableViewCell *)cell row:(NSInteger)row {
	MRDImage *image = [self.items objectAtIndex:row];
	NSString *uuid = image.uuid;
	NSURL *url = image.url;
	if (!url) {
		return;
	}
	
	cell.uuid = image.uuid;
	__weak typeof(*cell) *weakCell = cell;
	[[MRDDataController sharedInstance] fetchImageForURL:url completionBlock:^(UIImage *image, NSError *error) {
		if (image) {
			dispatch_async(dispatch_get_main_queue(), ^(void) {
				NSString *currentUUID = cell.uuid;
				if ([currentUUID isEqualToString:uuid]) {
					weakCell.imageView.image = image;
					[weakCell setNeedsLayout];
					NSLog(@"Assign image %@ to cell %@", image, weakCell);
					NSLog(@"%d", row);
				}
			});
		}
		else {
			NSLog(@"%@", error);
		}
	}];
}

- (void)cancelImageForRow:(NSInteger)row {
	MRDImage *image = [self.items objectAtIndex:row];
	NSURL *url = image.url;
	if (!url) {
		return;
	}
	
	[[MRDDataController sharedInstance] cancelImageRequestForURL:url];
}

#pragma mark - private
- (NSMutableArray *)_modelObjectsFromJSON:(NSArray *)imagesDict {
	NSMutableArray *images = [NSMutableArray array];
	for (NSDictionary *imageJSON in imagesDict) {
		MRDImage *image = [[MRDImage alloc] initWithDictionary:imageJSON];
		[images addObject:image];
	}

	return images;
}

@end
