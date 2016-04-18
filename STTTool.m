//
//  STTTool.m
//  ReadAPI
//
//  Created by shitaotao on 16/3/29.
//  Copyright © 2016年 shitaotao. All rights reserved.
//

#import "STTTool.h"
#import <CommonCrypto/CommonDigest.h>
#import "KeyChainStore.h"

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
    NSString * strUUID = (NSString *)[KeyChainStore load:@"com.company.app.usernamepassword"];
    
    //首次执行该方法时，uuid为空
    if ([strUUID isEqualToString:@""] || !strUUID)
    {
        //生成一个uuid的方法
        CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
        
        strUUID = (NSString *)CFBridgingRelease(CFUUIDCreateString (kCFAllocatorDefault,uuidRef));
        
        //将该uuid保存到keychain
        [KeyChainStore save:KEY_USERNAME_PASSWORD data:strUUID];
        
    }
    return strUUID;
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
                            (NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    if (file) {
        return [cachesPath stringByAppendingPathComponent:file];
    }
    
    return nil;
}

NSString *GetDocumentPathWithFile(NSString *file)
{
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains
                            (NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
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

/*手机号码验证 MODIFIED BY HELENSONG*/
BOOL validateMobile(NSString* mobile)
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    NSLog(@"phoneTest is %@",phoneTest);
    return [phoneTest evaluateWithObject:mobile];
}

/**车牌号验证 MODIFIED BY HELENSONG*/
BOOL validateCarNo(NSString* carNo)
{
    NSString *carRegex = @"^[A-Za-z]{1}[A-Za-z_0-9]{5}$";
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",carRegex];
    NSLog(@"carTest is %@",carTest);
    return [carTest evaluateWithObject:carNo];
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
