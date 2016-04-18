//
//  STTImagePicker.h
//  project
//
//  Created by shitaotao on 16/3/22.
//  Copyright © 2016年 shitaotao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ImagePickerFinishAction)(UIImage *image);

@interface STTImagePicker : NSObject
/**
 @param viewController  用于present UIImagePickerController对象
 @param allowsEditing   是否允许用户编辑图像
 */
+ (void)showImagePickerFromViewController:(UIViewController *)viewController
                            allowsEditing:(BOOL)allowsEditing
                             finishAction:(ImagePickerFinishAction)finishAction;
@end
