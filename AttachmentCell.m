//
//  AttachmentCell.m
//  StaffManagement
//
//  Created by Raymon on 16/2/5.
//  Copyright © 2016年 Raymon. All rights reserved.
//

#import "AttachmentCell.h"

@interface AttachmentCell ()
{
    UIButton    *_deleteButton;
}
@end
@implementation AttachmentCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initContentUI];
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)initContentUI
{
    [self setBackgroundColor:[RMUtils defaultBackColor]];
    
    CGFloat width = self.frame.size.width;
    CGFloat height = 50;
    
    // 图片
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    [_imageView setImage:[UIImage imageNamed:@"take_picture"]];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    _imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _imageView.clipsToBounds = YES;
    _imageView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_imageView];
    
    // 执行人名字
    _nameLabel = [RMUtils labelWith:CGRectMake(0, CGRectGetMaxY(_imageView.frame)+5, width, 20) font:[RMUtils expenseFontWith:12.0] text:@"" textColor:[UIColor blackColor]];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_nameLabel];
    
    // 删除按钮
    UIImage *deleteImage = [UIImage imageNamed:@"red_sign"];
    CGFloat deleteButtonWidth = deleteImage.size.width;
    _deleteButton = [RMUtils buttonWith:CGRectMake(width - deleteButtonWidth, 0, deleteButtonWidth, deleteImage.size.height) text:nil backColor:[UIColor clearColor] textColor:nil tag:0];
    [_deleteButton setHidden:YES];
    [_deleteButton setImage:deleteImage forState:UIControlStateNormal];
    [self.contentView addSubview:_deleteButton];
    
    
}

- (void)setDeleteAction:(SEL)action target:(id)target tag:(NSInteger)tag
{
    [_deleteButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    _deleteButton.tag = tag;
}

- (void)setHideDeleteButton:(BOOL)hideDeleteButton
{
    _hideDeleteButton = hideDeleteButton;
    if (hideDeleteButton) {
        [_deleteButton setHidden:YES];
        CGRect frame = _imageView.frame;
        frame.size.width = 54;
        frame.size.height = 54;
        frame.origin.x = (self.width - frame.size.width) / 2;
        _imageView.frame = frame;
        
    } else {
        _imageView.frame = CGRectMake(0, 0, self.width, self.height - 21);
        [_deleteButton setHidden:NO];
    }
}

- (void)setHideNameLabel:(BOOL)hideNameLabel
{
    if (hideNameLabel) {
        self.nameLabel.hidden = YES;
    }else{
        self.nameLabel.hidden = NO;
    }
}

- (void)setImage:(UIImage *)image
{
    _imageView.image = image;
}


@end
