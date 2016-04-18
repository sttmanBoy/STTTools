//
//  STTNetworking.m
//  ReadAPI
//
//  Created by shitaotao on 16/3/29.
//  Copyright © 2016年 shitaotao. All rights reserved.
//

#import "STTNetworking.h"
#define YYEncode(str) [str dataUsingEncoding:NSUTF8StringEncoding]

@implementation STTNetworking
singleton_m(STTNetworking);
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
/**
 *  post request, you can set the body but without any arguments
 *
 *  @param URLString url request
 *  @param dataBody  request body
 *  @param success   Successful block
 *  @param failure  Failed block
 */
- (void)POST:(NSString *)url parametersBody:(NSData *)dataBody success:(void (^)(NSURLResponse *response, id responseObject))success failure:(void (^)(NSURLResponse *response, NSError *error))failure
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    
    //set headers
    NSString *contentType = [NSString stringWithFormat:@"text/xml"];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    [request setHTTPBody:dataBody];
    [request setTimeoutInterval:120]; // timeout 120
    
    //get response
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            if ([self showResponseCode:response]) {
                if (data) {
                    NSError *er = nil;
                    id responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&er];
                    if (er) {
                        failure(response , er);
                    } else {
                        success(response, responseObject);
                    }
                } else {
                    failure(response, error);
                }
            } else {
                failure(response, error);
            }
        });
    }];
    
    [task resume];
}
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
- (void)upload:(NSString *)url name:(NSString *)name filename:(NSString *)filename mimeType:(NSString *)mimeType data:(NSData *)data parmas:(NSDictionary *)params success:(void (^)(NSURLResponse *response, id responseObject))success failure:(void (^)(NSURLResponse *response, NSError *error))failure
{
    // 文件上传
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    request.HTTPMethod = @"POST";
    NSMutableData *body = [NSMutableData data];
    
    /***************文件参数***************/
    // 参数开始的标志
    [body appendData:YYEncode(@"--YY\r\n")];
    NSString *disposition = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", name, filename];
    [body appendData:YYEncode(disposition)];
    NSString *type = [NSString stringWithFormat:@"Content-Type: %@\r\n", mimeType];
    [body appendData:YYEncode(type)];
    
    [body appendData:YYEncode(@"\r\n")];
    [body appendData:data];
    [body appendData:YYEncode(@"\r\n")];
    
    /***************普通参数***************/
    [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        // 参数开始的标志
        [body appendData:YYEncode(@"--YY\r\n")];
        NSString *disposition = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n", key];
        [body appendData:YYEncode(disposition)];
        
        [body appendData:YYEncode(@"\r\n")];
        [body appendData:YYEncode(obj)];
        [body appendData:YYEncode(@"\r\n")];
    }];
    
    /***************参数结束***************/
    [body appendData:YYEncode(@"--YY--\r\n")];
    request.HTTPBody = body;
    [request setValue:[NSString stringWithFormat:@"%zd", body.length] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"multipart/form-data; boundary=YY" forHTTPHeaderField:@"Content-Type"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            if ([self showResponseCode:response]) {
                if (data) {
                    NSError *er = nil;
                    id responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&er];
                    if (er) {
                        failure(response , er);
                    } else {
                        success(response, responseObject);
                    }
                } else {
                    failure(response, error);
                }
            } else {
                failure(response, error);
            }
        });
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
    NSArray *keyArray =  [STTNetworking keyEnumeratorWith:dict];
    NSArray *objArray = [STTNetworking objectEnumeratorWith:dict];
    NSString *string = nil;
    for (int i = 0; i < [keyArray count]; i++) {
        NSString *keyString = keyArray[i];
        NSString *objString = objArray[i];
        string = [NSString stringWithFormat:@"%@%@",string,[NSString stringWithFormat:@"%@=%@&",keyString,objString]];
    }
    string = [string substringWithRange:NSMakeRange(6, string.length - 6 - 1)];
    return string;
}
/// dict with key
+ (NSArray *)keyEnumeratorWith:(NSDictionary *)dict
{
    NSMutableArray *keyArray = [NSMutableArray array];
    for (NSString *key in [dict keyEnumerator]) {
        [keyArray addObject:key];
    }
    return keyArray;
}
/// dict with objcet
+ (NSArray *)objectEnumeratorWith:(NSDictionary *)dict
{
    NSMutableArray *objArray = [NSMutableArray array];
    for (NSString *obj in [dict objectEnumerator]) {
        [objArray addObject:obj];
    }
    return objArray;
}
@end
