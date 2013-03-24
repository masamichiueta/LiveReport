//
//  ToggleImageControl.h
//  LiveReport2013
//
//  Created by Ueta Masamichi on 2013/03/24.
//  Copyright (c) 2013年 Ueta Masamichi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ToggleImageControl : UIControl
{
    BOOL selected;
}

@property(strong, nonatomic) UIImageView *imageView;
@property(strong, nonatomic) UIImage *normalImage;
@property(strong, nonatomic) UIImage *selectedImage;

@end
