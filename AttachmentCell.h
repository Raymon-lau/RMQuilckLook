//
//  AttachmentCell.h
//  StaffManagement
//
//  Created by Raymon on 16/2/5.
//  Copyright © 2016年 Raymon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AttachmentCell : UICollectionViewCell

@property (nonatomic)BOOL hideDeleteButton;
@property (nonatomic)BOOL hideNameLabel;
@property (nonatomic, strong)UIImage *image;
@property (nonatomic, strong)UIImageView *imageView;
@property (nonatomic, strong)UILabel *nameLabel;

- (void)setDeleteAction:(SEL)action target:(id)target tag:(NSInteger)tag;

@end
