//
//  TwitterTableViewCell.m
//  LiveReport2013
//
//  Created by Ueta Masamichi on 2013/03/28.
//  Copyright (c) 2013年 Ueta Masamichi. All rights reserved.
//

#import "TwitterTableViewCell.h"


@implementation TwitterTableViewCell
@synthesize userNameLabel=_userNameLabel;
@synthesize statusLabel=_statusLabel;
@synthesize createdAtLabel=_createdAtLabel;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _userNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _userNameLabel.backgroundColor = [UIColor clearColor];
        _userNameLabel.font = [UIFont boldSystemFontOfSize:10.0f];
        [self.contentView addSubview:_userNameLabel];
        
        _statusLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _statusLabel.backgroundColor = [UIColor clearColor];
        _statusLabel.font = [UIFont systemFontOfSize:10.0f];
        _statusLabel.numberOfLines = 0;
        _statusLabel.lineBreakMode = NSLineBreakByWordWrapping; // UILineBreakModeWordWrap is deprecated
        [self.contentView addSubview:_statusLabel];
        
        _createdAtLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _createdAtLabel.backgroundColor = [UIColor clearColor];
        _createdAtLabel.font = [UIFont systemFontOfSize:10.0f];
        _createdAtLabel.lineBreakMode = NSLineBreakByWordWrapping; // UILineBreakModeWordWrap is deprecated
        _createdAtLabel.textColor = [UIColor grayColor];
        [self.contentView addSubview:_createdAtLabel];
    }
    return self;
}

- (void)setupRowData:(TweetData *)rowData
{
    
    TweetData *tweet = (TweetData *)rowData;
    _userNameLabel.text = tweet.userName;
    _statusLabel.text = tweet.status;
    _createdAtLabel.text = tweet.createdAt.description;
}

/**
 * Override UIView method
 */
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake(TweetMargin,TweetMargin,TweetUserIconSize,TweetUserIconSize);
    
    CGRect bounds = self.bounds;
    [self sizeThatFits:bounds.size withLayout:YES];
}

/**
 * Override UIView method
 */
- (CGSize)sizeThatFits:(CGSize)size
{
    return [self sizeThatFits:size withLayout:NO];
}

/**
 * @param size Bounds size
 * @param withLayout YES if set frame of subviews.
 */
- (CGSize)sizeThatFits:(CGSize)size withLayout:(BOOL)withLayout
{
    CGRect userIconViewFrame;
    userIconViewFrame.origin.x = TweetMargin;
    userIconViewFrame.origin.y = TweetMargin;
    userIconViewFrame.size.width = TweetUserIconSize;
    userIconViewFrame.size.height = TweetUserIconSize;
    
    
    CGFloat minHeight = userIconViewFrame.origin.y + userIconViewFrame.size.height + TweetMargin;
    
    CGRect usernameLabelFrame;
    usernameLabelFrame.origin.x = userIconViewFrame.origin.x + userIconViewFrame.size.width + TweetMargin;
    usernameLabelFrame.origin.y = TweetMargin;
    usernameLabelFrame.size.width = size.width - usernameLabelFrame.origin.x - TweetMarginRight;
    usernameLabelFrame.size.height = size.height - usernameLabelFrame.origin.y;
    usernameLabelFrame.size = [_userNameLabel sizeThatFits:usernameLabelFrame.size];
    if (withLayout) {
        _userNameLabel.frame = usernameLabelFrame;
    }
    
    CGRect statusLabelFrame;
    statusLabelFrame.origin.x = usernameLabelFrame.origin.x;
    statusLabelFrame.origin.y = usernameLabelFrame.origin.y + usernameLabelFrame.size.height;
    statusLabelFrame.size.width = size.width - statusLabelFrame.origin.x - TweetMarginRight;
    statusLabelFrame.size.height = size.height - statusLabelFrame.origin.y;
    statusLabelFrame.size = [_statusLabel sizeThatFits:statusLabelFrame.size];
    if (withLayout) {
        _statusLabel.frame = statusLabelFrame;
    }
    
    CGRect createdAtLabelFrame;
    createdAtLabelFrame.origin.x = statusLabelFrame.origin.x;
    createdAtLabelFrame.origin.y = statusLabelFrame.origin.y + statusLabelFrame.size.height;
    createdAtLabelFrame.size.width = size.width - createdAtLabelFrame.origin.x  - TweetMarginRight;
    createdAtLabelFrame.size.height = size.height - createdAtLabelFrame.origin.y;
    createdAtLabelFrame.size = [_createdAtLabel sizeThatFits:createdAtLabelFrame.size];
    if (withLayout) {
        _createdAtLabel.frame = createdAtLabelFrame;
    }
    
    size.height = createdAtLabelFrame.origin.y + createdAtLabelFrame.size.height + TweetMargin;
    if (size.height < minHeight) {
        size.height = minHeight;
    }
    
    return size;
}


@end
