//
//  STTTool.m
//  ReadAPI
//
//  Created by shitaotao on 16/3/29.
//  Copyright © 2016年 shitaotao. All rights reserved.
//

#import "STTTool.h"
#import <CommonCrypto/CommonDigest.h>

@implementation STTTool
/**
 *  把字符串加密成32位小写md5字符串，16位其实就是32位去除头和尾各8位
 *
 *  @param inPutText 需要被加密的字符串
 *
 *  @return 加密后的32位小写md5字符串
 */
+ (NSString*)md532BitLower:(NSString *)inPutText
{
    const char *cStr = [inPutText UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, strlen(cStr), result );
    return [[NSString stringWithFormat:
             @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
}

/**
 *  把字符串加密成32位大写md5字符串，16位其实就是32位去除头和尾各8位
 *
 *  @param inPutText 需要被加密的字符串
 *
 *  @return 加密后的32位大写md5字符串
 */
+ (NSString*)md532BitUpper:(NSString*)inPutText
{
    const char *cStr = [inPutText UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, strlen(cStr), result );
    return [[NSString stringWithFormat:
             @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] uppercaseString];
}

/**
 *  获取设备唯一标识符
 *
 *  @return 唯一标识符
 */
+ (NSString *)getUUID
{
    CFUUIDRef puuid = CFUUIDCreate(nil);
    CFStringRef uuidString = CFUUIDCreateString(nil, puuid);
    NSString *result = (NSString *)CFBridgingRelease(CFStringCreateCopy(NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    return result;
}

/**
 *  获取时间戳
 *
 *  @return 时间戳
 */
+ (NSString *)getTimestamp
{
    // timestamp
    NSDate *currentTime = [NSDate date];
    NSTimeInterval ind = [currentTime timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.f", ind];
    return timeString;
}
///Unicode转UTF-8
+ (NSString *)replaceUnicode:(NSString*)aUnicodeString
{
    NSString *tempStr1 = [aUnicodeString stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData mutabilityOption:NSPropertyListImmutable format:NULL errorDescription:NULL];
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n" withString:@"\n"];
    
}
/// UTF8 转 Unicode
+ (NSString *)UTF8ToUnicode:(NSString *)string
{
    NSUInteger length = [string length];
    NSMutableString *s = [NSMutableString stringWithCapacity:0];
    for (int i = 0;i < length; i++) {
        unichar _char = [string characterAtIndex:i];
        //判断是否为英文和数字
        if (_char <= '9' && _char >= '0') {
            [s appendFormat:@"%@",[string substringWithRange:NSMakeRange(i, 1)]];
        } else if(_char >= 'a' && _char <= 'z') {
            [s appendFormat:@"%@",[string substringWithRange:NSMakeRange(i, 1)]];
        } else if(_char >= 'A' && _char <= 'Z') {
            [s appendFormat:@"%@",[string substringWithRange:NSMakeRange(i, 1)]];
        } else if(_char > 0x4e00 && _char < 0x9fff){  // 判断是否为中文
            [s appendFormat:@"\\u%x",[string characterAtIndex:i]];
        } else {
            [s appendFormat:@"%@",[string substringWithRange:NSMakeRange(i, 1)]];
        }
    }
    return s;
}

NSString *GetCachesPathWithFile(NSString *file)
{
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains
                            (NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    if (file) {
        return [cachesPath stringByAppendingPathComponent:file];
    }
    
    return nil;
}

NSString *GetDocumentPathWithFile(NSString *file)
{
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains
                            (NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    if (file) {
        return [cachesPath stringByAppendingPathComponent:file];
    }
    return nil;
}

NSString *GetTemporaryPathWithFile(NSString *file)
{
    NSString *path = NSTemporaryDirectory();
    if (file) {
        return [path stringByAppendingPathComponent:file];
    }
    
    return nil;
}

void CreatePlistForDictionary(id structure, NSString *savePath)
{
    NSString *error = nil;
    NSData *plistData = [NSPropertyListSerialization
                         dataFromPropertyList:(id)structure
                         format:NSPropertyListXMLFormat_v1_0
                         errorDescription:&error];
    //...NSLog(@"save plist file to path:%@", savePath);
    
    if (plistData) {
        [plistData writeToFile:savePath atomically:YES];
    }
    else {
        //...NSLog(@"create plist file fail!");
        //...NSLog(@"fail reason: %@", error);
    }
}

//Unicode转UTF-8

+ (NSString *)encodeToPercentEscapeString:(NSString *)input
{
    // Encode all the reserved characters, per RFC 3986
    // (<http://www.ietf.org/rfc/rfc3986.txt>)
    NSString *outputStr = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                                (CFStringRef)input, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
    return outputStr;
    
}

+ (NSString *)decodeFromPercentEscapeString:(NSString *)input
{
    NSMutableString *outputStr = [NSMutableString stringWithString:input];
    [outputStr replaceOccurrencesOfString:@"+" withString:@" " options:NSLiteralSearch range:NSMakeRange(0, [outputStr length])];
    return [outputStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

@end
