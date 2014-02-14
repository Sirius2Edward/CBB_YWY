//

#import "UploadPicture.h"
#import "Request_API.h"
#import "NSData+Base64Encode.h"

@interface UploadPicture ()
{
    UIPopoverController *popover;
    UIButton *uploadButton;
    UISegmentedControl *seg;
    Request_API *req;
}
@end

@implementation UploadPicture
@synthesize photoDic;
@synthesize businessType;
-(id)init
{
    if (self = [super init]) {
        self.photoDic = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGFloat y = 10;
    seg = nil;
    if (self.businessType) {
        seg = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"身份证",@"工作证", nil]];
        seg.frame = CGRectMake(80, y, 160, 30);
        seg.selectedSegmentIndex = 0;
        [seg addTarget:self action:@selector(segmentValueChange:) forControlEvents:UIControlEventValueChanged];
        y += 35;
        [self.scrollView addSubview:seg];
    }
    self.title = @"上传工作名片";
	uploadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [uploadButton setBackgroundImage:[UIImage imageNamed:@"uploadPic.png"] forState:0];
    uploadButton.frame = CGRectMake(7.75, y, 304.5, 143.5);
    [uploadButton addTarget:self action:@selector(uploadAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:uploadButton];
    
    req = [Request_API shareInstance];
    req.delegate = self;
}

-(void)uploadAction:(UIButton *)sender
{
    UIActionSheet *menu = [[UIActionSheet alloc]
                           initWithTitle: @"更改图片"
                           delegate:self
                           cancelButtonTitle:@"取消"
                           destructiveButtonTitle:nil
                           otherButtonTitles:@"拍照",@"从相册上传",nil];
    menu.actionSheetStyle =UIActionSheetStyleBlackTranslucent;
    [menu showInView:self.navigationController.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0){
        [self snapImage];
    }
    else if(buttonIndex ==1){
        [self pickImage];
    }
}

//从相册中选取
- (void) pickImage
{
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    ipc.delegate =self;
    ipc.allowsEditing =NO;
    if ([[[UIDevice currentDevice] model] isEqualToString:@"iPad"]) {
        popover = [[UIPopoverController alloc] initWithContentViewController:ipc];
        [popover presentPopoverFromRect:CGRectMake(0, 0, 300, 300) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
    else
    {
        [self presentViewController:ipc animated:YES completion:nil];
    }
}

//启动相机拍摄
- (void) snapImage
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
	{
        UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
		ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
        ipc.delegate =self;
        ipc.allowsEditing =NO;
		ipc.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        [self presentViewController:ipc animated:YES completion:nil];
	}
	else
	{
//		NSLog(@"Camera not exist");
		return;
	}
}

- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0,0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    //返回新的改变大小后的图片
    return scaledImage;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *pic = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    CGFloat multi = pic.size.width/304.5;
    CGFloat newH = pic.size.height/multi;
    CGFloat y = 10;
    
    pic = [self scaleToSize:pic size:CGSizeMake(304.5, newH)];
    
    if (seg) {
        [self.photoDic setObject:pic forKey:[NSString stringWithFormat:@"%d",seg.selectedSegmentIndex]];
        y += 35;
    }
    else {
        [self.photoDic setObject:pic forKey:@"0"];
    }
    uploadButton.frame = CGRectMake(7.75, y, 304.5, newH);
    [uploadButton setBackgroundImage:pic forState:0];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)submit
{
    NSString *typePara = @"0";
    if (seg) {
        typePara = [NSString stringWithFormat:@"%d",seg.selectedSegmentIndex];
    }
    UIImage *image = [self.photoDic objectForKey:typePara];
    if (image) {
        NSData *imgData = UIImageJPEGRepresentation(image, 0.95);
        NSString *encodeImage = [imgData base64Encoding];

        UserInfo *info = [UserInfo shareInstance];
        NSArray *para = [NSArray arrayWithObjects:
                         @"title",@"title",
                         @"content",@"contect",
                         info.ID,@"userId",
                         typePara,@"type",
                         [NSString stringWithFormat:@"%d",self.businessType+1],@"loginType",
                         encodeImage,@"bytestr",
                         info.password,@"password",nil];
        [req uploadImageWithParams:para];
    }
}

-(void)uploadEnd:(id)aDic
{
    
}

-(void)segmentValueChange:(UISegmentedControl *)sender
{
    UIImage *image = [self.photoDic objectForKey:[NSString stringWithFormat:@"%d",sender.selectedSegmentIndex]];
    if (image) {
        CGSize size = image.size;
        uploadButton.frame = CGRectMake(7.75, 45, size.width, size.height);
        [uploadButton setBackgroundImage:image forState:0];
    }
    else {
        uploadButton.frame = CGRectMake(7.75, 45, 304.5, 143.5);
        [uploadButton setBackgroundImage:[UIImage imageNamed:@"uploadPic.png"] forState:0];
    }
}
@end
