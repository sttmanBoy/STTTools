//
//  APPNetworking.m
//  project
//
//  Created by shitaotao on 16/4/1.
//  Copyright © 2016年 shitaotao. All rights reserved.
//

#import "APPNetworking.h"
#import "STTNetworking.h"
#import "MGOrderedDictionary.h"

@implementation APPNetworking
+ (void)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    // 必传参数
    MGOrderedDictionary *ordered = [MGOrderedDictionary dictionaryWithObjects:@[
                                                                                @"500",
                                                                                [STTTool getUUID],
                                                                                @"0.1",
                                                                                [STTTool getTimestamp],
                                                                                @"03C2B80F1E71680B6A80240FE5021212"
                                                                                ]
                                                                      forKeys:@[
                                                                                @"appID",
                                                                                @"uuid",
                                                                                @"version",
                                                                                @"timestamp",
                                                                                @"key"
                                                                                ]];
    
    // 不同接口添加参数
    if (params.count) {
        [params enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [ordered insertObject:obj forKey:key atIndex:ordered.count - 1];
        }];
    }
    
    NSString *mutableString = [STTNetworking enumerateKeysAndObjectsSplicedIntoTheParameters:ordered];
    NSString *md5 = [STTTool md532BitUpper:mutableString];
    [ordered insertObject:md5 forKey:@"sign" atIndex:ordered.count];
    [ordered removeObjectForKey:@"key"];
    NSData *data = [NSJSONSerialization dataWithJSONObject:ordered options:0 error:nil];
//    NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    
    STTNetworking *net = [STTNetworking sharedSTTNetworking];
    [net POST:url parametersBody:data success:^(NSURLResponse *response, id responseObject) {
        NSString *code = responseObject[@"code"];
        if (code.intValue == 4002) { // 在其他设备上登陆
            [SVProgressHUD showInfoWithStatus:responseObject[@"info"]];
            [[NSNotificationCenter defaultCenter] postNotificationName:DRAW_sign_out_NOTIFICATION object:nil];
        } else {
            success(responseObject);
        }
    } failure:^(NSURLResponse *response, NSError *error) {
        failure(error);
    }];
}

+ (void)upload:(NSString *)name filename:(NSString *)filename mimeType:(NSString *)mimeType data:(NSData *)data parmas:(NSDictionary *)params success:(void (^)(id responseObject))success failure:(void (^)( NSError *error))failure
{
    STTNetworking *net = [STTNetworking sharedSTTNetworking];
    NSString *url = [APP_BASEURL stringByAppendingString:@"Media/uploadfile?type=image"];
    [net upload:url name:name filename:filename mimeType:mimeType data:data parmas:params success:^(NSURLResponse *response, id responseObject) {
        success(responseObject);
    } failure:^(NSURLResponse *response, NSError *error) {
        failure(error);
    }];
}
@end
