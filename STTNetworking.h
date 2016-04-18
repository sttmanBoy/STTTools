//
//  STTNetworking.h
//  ReadAPI
//
//  Created by shitaotao on 16/3/29.
//  Copyright © 2016年 shitaotao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
#import "STTTool.h"
@interface STTNetworking : NSObject

singleton_h(STTNetworking);
/**
 *  post request, you can set the body but without any arguments
 *
 *  @param URLString url request
 *  @param dataBody  url request
 *  @param success   Successful block
 *  @param failure  Failed block
 */
- (void)POST:(NSString *)URLString parametersBody:(NSData *)dataBody success:(void (^)(NSURLResponse *response, id responseObject))success failure:(void (^)(NSURLResponse *response, NSError *error))failure;
/**
 *  File Upload
 *  @param Url file upload url
 *  @param Name specified parameter name (must be consistent with the server-side)
 *  @param Filename filename
 *  @param MimeType file format
 *  @param Data file data
 *  @param Params parameter added
 *  @param Success success callback
 *  @param Failure callback failed
 */
- (void)upload:(NSString *)url name:(NSString *)name filename:(NSString *)filename mimeType:(NSString *)mimeType data:(NSData *)data parmas:(NSDictionary *)params success:(void (^)(NSURLResponse *response, id responseObject))success failure:(void (^)(NSURLResponse *response, NSError *error))failure;
/**
 *  The dictionary spliced into the parameters
 *
 *  @param dict parameters dictionary
 *
 *  @return parameters string
 */
+ (NSString *)enumerateKeysAndObjectsSplicedIntoTheParameters:(NSDictionary *)dict;

/// dict with key
+ (NSArray *)keyEnumeratorWith:(NSDictionary *)dict;

/// dict with objcet
+ (NSArray *)objectEnumeratorWith:(NSDictionary *)dict;
@end
