//
//  APPNetworking.h
//  project
//
//  Created by shitaotao on 16/4/1.
//  Copyright © 2016年 shitaotao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APPNetworking : NSObject

+ (void)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

+ (void)upload:(NSString *)name filename:(NSString *)filename mimeType:(NSString *)mimeType data:(NSData *)data parmas:(NSDictionary *)params success:(void (^)(id responseObject))success failure:(void (^)( NSError *error))failure;
@end
