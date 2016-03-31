//
//  STTNetworking.m
//  ReadAPI
//
//  Created by shitaotao on 16/3/29.
//  Copyright © 2016年 shitaotao. All rights reserved.
//

#import "STTNetworking.h"

@implementation STTNetworking
singleton_m(STTNetworking);

/**
 *  post request, you can set the body but without any arguments
 *
 *  @param URLString url request
 *  @param dataBody  request body
 *  @param success   Successful block
 *  @param failure  Failed block
 */
+ (void)POST:(NSString *)URLString parametersBody:(NSData *)dataBody success:(void (^)(NSURLResponse *response, id responseObject))success failure:(void (^)(NSURLResponse *response, NSError *error))failure
{
    STTNetworking *networking = [STTNetworking sharedSTTNetworking];
    [networking POST:URLString parametersBody:dataBody success:success failure:failure];
}

/**
 *  post request, you can set the body but without any arguments, add paramenters
 *
 *  @param URLString  url request
 *  @param dataBody   url request
 *  @param parameter  url parameter
 *  @param success    Successful block
 *  @param failure   Failed block
 */
+ (void)POST:(NSString *)URLString parametersBody:(NSData *)dataBody parameters:(id)parameter success:(void (^)(NSURLResponse *response, id responseObject))success failure:(void (^)(NSURLResponse *response, NSError *error))failure
{
    STTNetworking *networking = [STTNetworking sharedSTTNetworking];
    if ([parameter isKindOfClass:[NSString class]]) {
        URLString = [URLString stringByAppendingString:[NSString stringWithFormat:@"?%@",parameter]];
    } else if ([parameter isKindOfClass:[NSDictionary class]]) {
        URLString = [URLString stringByAppendingString:[NSString stringWithFormat:@"?%@",[networking enumerateKeysAndObjectsSplicedIntoTheParameters:parameter]]];
    } else {
        NSParameterAssert(parameter);
    }
    [networking POST:URLString parametersBody:dataBody success:success failure:failure];
}

/**
 *  The dictionary spliced into the parameters
 *
 *  @param dict parameters dictionary
 *
 *  @return parameters string
 */
+ (NSString *)enumerateKeysAndObjectsSplicedIntoTheParameters:(NSDictionary *)dict
{
    return [[STTNetworking sharedSTTNetworking] enumerateKeysAndObjectsSplicedIntoTheParameters:dict];
}

- (void)POST:(NSString *)url parametersBody:(NSData *)dataBody success:(void (^)(NSURLResponse *response, id responseObject))success failure:(void (^)(NSURLResponse *response, NSError *error))failure
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    
    //set headers
    NSString *contentType = [NSString stringWithFormat:@"text/xml"];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    [request setHTTPBody:dataBody];
    
    //get response
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if ([self showResponseCode:response]) {
            id responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            success(response, responseObject);
        } else {
            failure(response, error);
        }
    }];
    
    [task resume];
}

- (BOOL)showResponseCode:(NSURLResponse *)response {
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    NSInteger responseStatusCode = [httpResponse statusCode];
    return responseStatusCode = 200 ? YES : NO;
}

- (NSString *)enumerateKeysAndObjectsSplicedIntoTheParameters:(NSDictionary *)dict
{
    NSMutableArray *keyArray = [NSMutableArray array];
    for (NSString *key in [dict keyEnumerator]) {
        [keyArray addObject:key];
    }
    NSMutableArray *objArray = [NSMutableArray array];
    for (NSString *obj in [dict objectEnumerator]) {
        [objArray addObject:obj];
    }
    NSString *string = nil;
    for (int i = 0; i < [keyArray count]; i++) {
        NSString *keyString = keyArray[i];
        NSString *objString = objArray[i];
        string = [NSString stringWithFormat:@"%@%@",string,[NSString stringWithFormat:@"%@=%@&",keyString,objString]];
    }
    string = [string substringWithRange:NSMakeRange(6, string.length - 6 - 1)];
    return string;
}

@end
