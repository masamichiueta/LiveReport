//
//  TwitterTableViewCell.h
//  LiveReport2013
//
//  Created by Ueta Masamichi on 2013/03/28.
//  Copyright (c) 2013年 Ueta Masamichi. All rights reserved.
//

#import "PrettyTableViewCell.h"
//#import "ImageStore.h"
#import "TweetData.h"

@interface TwitterTableViewCell : PrettyTableViewCell

@property (strong, nonatomic) UILabel *userNameLabel;
@property (strong, nonatomic) UILabel *statusLabel;
@property (strong, nonatomic) UILabel *createdAtLabel;

- (void)setupRowData:(TweetData *)rowData;
@end
