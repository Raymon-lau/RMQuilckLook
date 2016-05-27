//
//  QuilckLook.m
//  StaffManagement
//
//  Created by Raymon on 16/2/17.
//  Copyright © 2016年 Raymon. All rights reserved.
//

#import "QuilckLook.h"
#import "AttachmentCell.h"
#import "RequestPostUploadViewController.h"
#import <QuickLook/QuickLook.h>

NSString *kTMP_UPLOAD_IMG_PATH=@"";
@interface QuilckLook ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>//QLPreviewControllerDataSource,QLPreviewControllerDelegate,
{
    UIImage *_portraintImage;
    UIImagePickerController *_picker;
    NSString *_httpString ;
    NSString *_files_id;

}

@end
@implementation QuilckLook
- (NSMutableArray *)nameArray
{
    if (_nameArray) {
        return _nameArray;
    }
    _nameArray = [NSMutableArray array];
    return _nameArray;
}

- (instancetype)initWithFrame:(CGRect)frame type:(QuilckLookType)type
{
    self = [super initWithFrame:frame];
    if (self) {
        [self attachmentStateWith:type];
        [self initLoadUI];
        [self setCollectionFrameWithtype:type];

    }
    return self;
}

- (void)setCollectionFrameWithtype:(QuilckLookType)type
{
    if (type == QuilckLookTypeExecutePerson) {
        self.collectionView.frame = CGRectMake(20, 10, kScreenWidth - 40, 200);
    }else{
        self.collectionView.frame = CGRectMake(20, 10, kScreenWidth - 40, 100);
    }
}

- (void)attachmentStateWith:(QuilckLookType)type
{
    self.type = type;
    UIImage * image = nil;
    if (type == QuilckLookTypeAddPicture) {
        image = [UIImage imageNamed:@"picture"];
    }else if (type == QuilckLookTypeTakePicture){
        image = [UIImage imageNamed:@"take_picture"];
    }else if (type == QuilckLookTypeExecutePerson){
        image = [UIImage imageNamed:@"picture"];
    }
    _photoArray = [[NSMutableArray alloc]initWithObjects:image, nil];
}

// 加载画面
- (void)initLoadUI
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake((kScreenWidth - 40)/3 - 10, (kScreenWidth - 40)/3 - 10);
    flowLayout.minimumInteritemSpacing = 8;
    flowLayout.minimumLineSpacing = 10;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(20, 10, kScreenWidth - 40, 100) collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.scrollEnabled = YES;
    [_collectionView registerClass:[AttachmentCell class] forCellWithReuseIdentifier:@"attachmentCell"];
    [self addSubview:_collectionView];
    
    // 查看附件画面
//    _previewController = [[QLPreviewController alloc] init];
//    _previewController.delegate = self;
//    _previewController.dataSource = self;
    
}

#pragma mark - collectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.type != QuilckLookTypeExecutePerson) {
        if (_photoArray.count > 4) {
            [RMUtils showMessage:@"最多上传4张图片!"];
            return 4;
        }
    }else{
        return _photoArray.count;
    }
    return _photoArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"attachmentCell";
    AttachmentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.image = nil;
    if (indexPath.row == _photoArray.count - 1) {
        if (self.type == QuilckLookTypeTakePicture) {
            cell.image = [UIImage imageNamed:@"take_picture"];
        }else{
            cell.image = [UIImage imageNamed:@"picture"];
        }
        [cell setHideDeleteButton:YES];
        [cell setHideNameLabel:YES];
    }else{
        if (self.type == QuilckLookTypeExecutePerson) {
            [cell setHideDeleteButton:NO];
            [cell setHideNameLabel:NO];
            cell.nameLabel.text = [NSString ridObject:self.nameArray[indexPath.row]];
        }else{
            [cell setHideDeleteButton:NO];
            [cell setHideNameLabel:NO];
        }
        [cell setDeleteAction:@selector(deleteAttachment:) target:self tag:indexPath.row];
        cell.image = _photoArray[indexPath.row];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(55, 70);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    RMLog(@"%ld",(long)indexPath.item);
    if (indexPath.row == _photoArray.count - 1) {
        if (self.type == QuilckLookTypeExecutePerson) {
            if ([self.delegate respondsToSelector:@selector(quilckLookView:didSelectItemAtIndex:)]) {
                [self.delegate quilckLookView:self didSelectItemAtIndex:indexPath.row];
            }
        }else{
            // 增加附近
            [self addAttachment:nil];
        }
    }else{
        RMLog(@"查看图片");
        AttachmentCell *cell = (AttachmentCell *)[collectionView cellForItemAtIndexPath:indexPath];
        [RMAvatarBrowser showImage:cell.imageView];
    }
}



#pragma mark - 删除
- (void)deleteAttachment:(UIButton *)button
{
    if (self.type == QuilckLookTypeExecutePerson) {
        if ([self.delegate respondsToSelector:@selector(deleteItemAtIndex:)]) {
            [self.delegate deleteItemAtIndex:button.tag];
        }
    }
    [_photoArray removeObjectAtIndex:button.tag ];
    [_collectionView reloadData];
}

- (void)addAttachment:(UIButton *)button
{
    [RMUtils showActionSheetInView:self delegate:self tag:AttachmentViewTagForTakePhotoActionSheet title:nil cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"相册"];
}

#pragma mark - delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag != AttachmentViewTagForTakePhotoActionSheet) {
        return;
    }
    // 打开照相机
    if (buttonIndex == 0) {
        [self openCamera];
    }else if (buttonIndex == 1) {
        [self openPhotoAlbum];
    }
}

- (void)openCamera
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        _picker = [[UIImagePickerController alloc] init];
        _picker.delegate = self;
        _picker.allowsEditing = YES;
        // 摄像头
        _picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([self.delegate respondsToSelector:@selector(jumpToSelectPhotoAlbumFrom:)]) {
            [self.delegate jumpToSelectPhotoAlbumFrom:_picker];
        }
    }else{
        [RMUtils showMessage:@"您的设备没有摄像头"];
    }
}

- (void)openPhotoAlbum
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        _picker = [[UIImagePickerController alloc] init];
        _picker.delegate = self;
        _picker.allowsEditing = YES;
        _picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        // 进入相册
        if ([self.delegate respondsToSelector:@selector(jumpToSelectPhotoAlbumFrom:)]) {
            [self.delegate jumpToSelectPhotoAlbumFrom:_picker];
        }
    }
}

#pragma mark - 拍摄完成后或者选择相册完成后自动调用的方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    // 得到照片
    UIImage *img = [info objectForKey:UIImagePickerControllerEditedImage];
    _portraintImage = [self imageWithImageSimple:img scaledToSize:CGSizeMake(150, 150)];
    [self saveImage:_portraintImage WithName:[NSString stringWithFormat:@"%@%@",[self generateUuidString],@".jpg"]];

    if ([self.delegate respondsToSelector:@selector(backToQuilckLookViewForm:files_id:)]) {
        [self.delegate backToQuilckLookViewForm:_picker files_id:_files_id];
    }
    [_photoArray insertObject:_portraintImage atIndex:_photoArray.count - 1];
    [_collectionView reloadData];
}

- (NSString *)generateUuidString
{
    // create a new UUID which you own
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    NSString *uuidString = (NSString *)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, uuid));
    
    return uuidString;
}


-(UIImage *)imageWithImageSimple:(UIImage*) image scaledToSize:(CGSize)newSize
{
    newSize.height=image.size.height*(newSize.width/image.size.width);
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return  newImage;
}

// 保存图片
- (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName
{
    NSData *imageData = UIImagePNGRepresentation(tempImage);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    
    kTMP_UPLOAD_IMG_PATH = fullPathToFile;
    [imageData writeToFile:fullPathToFile atomically:NO];

#pragma mark -
    NSString *headString = [RMUtils getRequestHeadString];
    NSString *requestString = [RMUtils getResquestCoderWithRGuid:@"upload/index" Content:nil];
    NSDictionary *param = @{@"Head":headString,@"Request":requestString};
    
    if ([[RMNetWork shareInstance] rechability]) {
        if ([kTMP_UPLOAD_IMG_PATH isEqualToString:@""]) {
            _httpString = [RequestPostUploadViewController postRequestWithURL:kRequestLoadImageURL postParems:[param mutableCopy] picFilePath:nil picFileName:nil FORM_FLE_INPUT:@"images_files"];

        }else{
            NSArray *nameArray = [kTMP_UPLOAD_IMG_PATH componentsSeparatedByString:@"/"];
            _httpString = [RequestPostUploadViewController postRequestWithURL:kRequestLoadImageURL postParems:[param mutableCopy] picFilePath:kTMP_UPLOAD_IMG_PATH picFileName:[nameArray objectAtIndex:[nameArray count]-1] FORM_FLE_INPUT:@"images_files"];
        }

        /*
    NSString *URLString = [RMUtils requestURL:@"upload"];
    NSDictionary *dictionData=[RMUtils userBaseMessage];
    if ([[RMNetWork shareInstance] rechability]) {
        if ([kTMP_UPLOAD_IMG_PATH isEqualToString:@""]) {
            _httpString = [RequestPostUploadViewController postRequestWithURL:URLString postParems:[@{@"uid":dictionData[@"uid"],@"sign":dictionData[@"sign"]}mutableCopy] picFilePath:nil picFileName:nil FORM_FLE_INPUT:@"images_files"];
        }else{
            NSArray *nameArray = [kTMP_UPLOAD_IMG_PATH componentsSeparatedByString:@"/"];
            _httpString = [RequestPostUploadViewController postRequestWithURL:URLString postParems:[@{@"uid":dictionData[@"uid"],@"sign":dictionData[@"sign"]}mutableCopy] picFilePath:kTMP_UPLOAD_IMG_PATH picFileName:[nameArray objectAtIndex:[nameArray count]-1] FORM_FLE_INPUT:@"images_files"];
        }
         */
        if (_httpString == nil) {
            [RMUtils showMessage:@"图片上传失败,请稍候再添加"];
            return;
        }
        NSDictionary *bigDic = [RMUtils parseJSONStringToNSDictionary:[NSString ridObject:_httpString]];
        NSDictionary *dataDic = bigDic[@"data"];
        NSDictionary *imagesDic = dataDic[@"images_files"];
        NSString *files_id = imagesDic[@"files_id"];
        _files_id = files_id;
    }else{
        // 菊花加载
    }

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
