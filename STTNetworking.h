//
//  STTNetworking.h
//  ReadAPI
//
//  Created by shitaotao on 16/3/29.
//  Copyright © 2016年 shitaotao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
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
+ (void)POST:(NSString *)URLString parametersBody:(NSData *)dataBody success:(void (^)(NSURLResponse *response, id responseObject))success failure:(void (^)(NSURLResponse *response, NSError *error))failure;
/**
 *  post request, you can set the body but without any arguments, add paramenters
 *
 *  @param URLString  url request
 *  @param dataBody   url request
 *  @param parameter  url parameter
 *  @param success    Successful block
 *  @param failure   Failed block
 */
+ (void)POST:(NSString *)URLString parametersBody:(NSData *)dataBody parameters:(id)parameter success:(void (^)(NSURLResponse *response, id responseObject))success failure:(void (^)(NSURLResponse *response, NSError *error))failure;
/**
 *  The dictionary spliced into the parameters
 *
 *  @param dict parameters dictionary
 *
 *  @return parameters string
 */
+ (NSString *)enumerateKeysAndObjectsSplicedIntoTheParameters:(NSDictionary *)dict;
@end
