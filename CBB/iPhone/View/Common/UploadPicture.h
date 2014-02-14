//
//  UploadPicture.h
//  CBB
//
//  Created by 卡宝宝 on 13-9-9.
//  Copyright (c) 2013年 卡宝宝. All rights reserved.
//

#import "BaseEditView.h"

@interface UploadPicture : BaseEditView<UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property(nonatomic,retain)NSMutableDictionary *photoDic;
@property(nonatomic,assign)NSInteger businessType;
@end
