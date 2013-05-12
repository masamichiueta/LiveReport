//
//  ToggleImageControl.m
//  LiveReport2013
//
//  Created by Ueta Masamichi on 2013/03/24.
//  Copyright (c) 2013年 Ueta Masamichi. All rights reserved.
//

#import "ToggleImageControl.h"

@implementation ToggleImageControl
@synthesize normalImage=_normalImage;
@synthesize selectedImage=_selectedImage;
@synthesize imageView=_imageView;
@synthesize selected=_selected;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _normalImage = [UIImage imageNamed: @"normal.png"];
        _selectedImage = [UIImage imageNamed: @"selected.png"];
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10.0, 15.0, 25.0, 25.0)];
        _imageView.image = _normalImage;
        //_imageView = [[UIImageView alloc] initWithImage: _normalImage];
        [self addSubview:_imageView];
        
        
    }
    return self;
}

- (void) togglePushed{
    _selected = !_selected;
    _imageView.image = (_selected ? _selectedImage : _normalImage);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
