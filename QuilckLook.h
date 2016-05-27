//
//  QuilckLook.h
//  StaffManagement
//
//  Created by Raymon on 16/2/17.
//  Copyright © 2016年 Raymon. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QuilckLook;
@protocol QuilckLookDelegate <NSObject>

- (void)jumpToSelectPhotoAlbumFrom:(UIViewController *)viewController;
- (void)backToQuilckLookViewForm:(UIViewController *)viewController files_id:(NSString *)files_id;
@optional
- (void)quilckLookView:(QuilckLook *)quilcklook didSelectItemAtIndex:(NSInteger)index;
- (void)deleteItemAtIndex:(NSInteger)index;
@end
@interface QuilckLook : UIView
- (instancetype)initWithFrame:(CGRect)frame type:(QuilckLookType)type;
// 添加附件类型
@property (nonatomic,assign)QuilckLookType type;
@property (nonatomic, weak)id<QuilckLookDelegate>delegate;
@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, strong)NSMutableArray *photoArray;
@property (nonatomic, copy)NSMutableArray *nameArray;
@end
