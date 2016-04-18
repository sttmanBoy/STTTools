//
//  STTImagePicker.m
//  project
//
//  Created by shitaotao on 16/3/22.
//  Copyright © 2016年 shitaotao. All rights reserved.
//

#import "STTImagePicker.h"
#import <UIKit/UIKit.h>

@interface STTImagePicker ()<UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, weak) UIViewController *viewController;
@property (nonatomic, copy) ImagePickerFinishAction finishAction;
@property (nonatomic, assign) BOOL allowsEditing;

@end

static STTImagePicker *ImagePickerInstance = nil;

@implementation STTImagePicker

+ (void)showImagePickerFromViewController:(UIViewController *)viewController allowsEditing:(BOOL)allowsEditing finishAction:(ImagePickerFinishAction)finishAction {
    if (ImagePickerInstance == nil) {
        ImagePickerInstance = [[STTImagePicker alloc] init];
    }
    
    [ImagePickerInstance showImagePickerFromViewController:viewController
                                             allowsEditing:allowsEditing
                                              finishAction:finishAction];
}

- (void)showImagePickerFromViewController:(UIViewController *)viewController
                            allowsEditing:(BOOL)allowsEditing
                             finishAction:(ImagePickerFinishAction)finishAction {
    _viewController = viewController;
    _finishAction = finishAction;
    _allowsEditing = allowsEditing;
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:@"拍照", @"从相册选择", nil];
    
    
    UIView *window = [UIApplication sharedApplication].keyWindow;
    [sheet showInView:window];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([title isEqualToString:@"拍照"]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
            picker.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        }
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.allowsEditing = _allowsEditing;
        [_viewController presentViewController:picker animated:YES completion:nil];
        
    }else if ([title isEqualToString:@"从相册选择"]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
            picker.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        }
        picker.delegate = self;
        picker.allowsEditing = YES;
        [_viewController presentViewController:picker animated:YES completion:nil];
    }else {
        ImagePickerInstance = nil;
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = info[UIImagePickerControllerEditedImage];
    if (image == nil) {
        image = info[UIImagePickerControllerOriginalImage];
    }
    
    if (_finishAction) {
        _finishAction(image);
    }
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    ImagePickerInstance = nil;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if (_finishAction) {
        _finishAction(nil);
    }
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    ImagePickerInstance = nil;
}


@end
