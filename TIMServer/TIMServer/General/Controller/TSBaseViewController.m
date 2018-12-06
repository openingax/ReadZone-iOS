//
//  TSBaseViewController.m
//  TIMServer
//
//  Created by 谢立颖 on 2018/10/31.
//  Copyright © 2018 Viomi. All rights reserved.
//

#import "TSBaseViewController.h"
#import "TSDevice.h"
#import <objc/runtime.h>

@interface TSBaseViewController ()

@end

@implementation TSBaseViewController

- (instancetype)init {
    if (self = [super init]) {
        [self configParams];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = RGB(245, 245, 245);
    
//    u_int count;
//
//    Method *methodList = class_copyMethodList([self class], &count);
//
//    NSMutableArray *methodsArray = [[NSMutableArray alloc] init];
//
//    for (int i=0; i < count; i++) {
//        Method temp = methodList[i];
//        IMP imp = method_getImplementation(temp);
//        SEL name_f = method_getName(temp);
//        const char* name_s =sel_getName(method_getName(temp));
//        int arguments = method_getNumberOfArguments(temp);
//        const char* encoding =method_getTypeEncoding(temp);
//        NSLog(@"方法名：%@,参数个数：%d,编码方式：%@",[NSString stringWithUTF8String:name_s],
//              arguments,
//              [NSString stringWithUTF8String:encoding]);
//        [methodsArray addObject:[NSString stringWithUTF8String:name_s]];
//
//        NSLog(@"方法%d: %@", i, methodsArray[i]);
//    }
    
//    free(methodList);
    
    [self addOwnViews];
    [self configOwnViews];
    [self layoutSubviewsFrame];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self layoutOnViewWillAppear];
}

- (void)configParams {
    
}

#pragma mark -
- (BOOL)hasBackgroundView {
    return NO;
}

- (void)addBackground {
    
}

- (void)configBackground {
    
}

- (void)layoutBackground {
    
}

- (void)viewWillLayoutSubviews {
    if (![self asChild]) {
        [super viewWillLayoutSubviews];
    } else {
        if (CGSizeEqualToSize(self.childSize, CGSizeZero)) {
            [super viewWillLayoutSubviews];
        } else {
            CGSize size = [self childSize];
            self.view.bounds = CGRectMake(0, 0, size.width, size.height);
        }
    }
}

- (void)layoutSubviewsFrame {
    [super layoutSubviewsFrame];
}


#pragma makr -
- (void)callImagePickerActionSheet {
//    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"相册", nil];
//    actionSheet.cancelButtonIndex = 2;
//    [actionSheet showInView:self.view];
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePicker animated:YES completion:nil];
    
//    UIAlertAction *action0 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
//        [self presentViewController:imagePicker animated:YES completion:nil];
//    }];
//    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//        [self presentViewController:imagePicker animated:YES completion:nil];
//    }];
//    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//    [alertController addAction:action0];
//    [alertController addAction:action1];
//    [alertController addAction:action2];
//    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)addTapBlankToHideKeyboardGesture {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapBlankToHideKeyboard:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:tap];
}

- (void)onTapBlankToHideKeyboard:(UITapGestureRecognizer *)ges {
    if (ges.state == UIGestureRecognizerStateEnded) {
        [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    }
}

//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
//    
//}

//- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
//    
//    if (buttonIndex == actionSheet.cancelButtonIndex) {
//        return;
//    }
//    
//    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
//    imagePicker.delegate = self;
//    imagePicker.allowsEditing = YES;
//    if (buttonIndex == 0 && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
//    {
//        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
//    }
//    else if (buttonIndex == 1 && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
//    {
//        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//    }
//    [self presentViewController:imagePicker animated:YES completion:nil];
//}


// 添加自动布局相关的constraints
- (void)autoLayoutOwnViews
{
    // 添加自动布局相关的内容
}

@end
