//
//  MRDTableViewCell.m
//  HomeworkOne
//
//  Created by Michael Dorsey on 4/28/13.
//  Copyright (c) 2013 Michael Dorsey. All rights reserved.
//

#import "MRDTableViewCell.h"

@implementation MRDTableViewCell

- (void)prepareForReuse {
	[super prepareForReuse];
	
	self.imageView.image = nil;
}

@end
