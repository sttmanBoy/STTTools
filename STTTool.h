//
//  STTTool.h
//  ReadAPI
//
//  Created by shitaotao on 16/3/29.
//  Copyright © 2016年 shitaotao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STTTool : NSObject
/**
 *  把字符串加密成32位小写md5字符串，16位其实就是32位去除头和尾各8位
 *
 *  @param inPutText 需要被加密的字符串
 *
 *  @return 加密后的32位小写md5字符串
 */
+ (NSString*)md532BitLower:(NSString *)inPutText;

/**
 *  把字符串加密成32位大写md5字符串，16位其实就是32位去除头和尾各8位
 *
 *  @param inPutText 需要被加密的字符串
 *
 *  @return 加密后的32位大写md5字符串
 */
+ (NSString*)md532BitUpper:(NSString*)inPutText;

/**
 *  获取设备唯一标识符
 *
 *  @return 唯一标识符
 */
+ (NSString *)getUUID;
/**
 *  获取时间戳
 *
 *  @return 时间戳
 */
+ (NSString *)getTimestamp;

+ (NSString *)replaceUnicode:(NSString *)unicodeStr;

/// UTF8 转 Unicode
+ (NSString *)UTF8ToUnicode:(NSString *)string;

// Cache:
// 用户在操作过程中产生的数据, 此数据是可有可无,
// 一般是从网络拉取的数据量比较大的数据(视频, 文档, 资讯等支持离线阅读或观看的数据)
// 清理缓存: 操作的也是此目录
NSString *GetCachesPathWithFile(NSString *file);

// Document(iCloud同步的文件夹):
// 用户在操作过程中产生的数据,
// 此数据为跟用户绑定在一起的重要数据(用户名,密码,积分, 级别, 玩家等级, 虚拟金钱, 数据库文件),
// 此软件如果iCloud功能的话, 在wifi情况会自行将此文件夹的数据上传至iCloud云服务器, 每个普通用户iCloud分配的空间5GB.
NSString *GetDocumentPathWithFile(NSString *file);

// Temp:
// 临时文件, 在数据用完后就马上清空 (比如压缩包)
NSString *GetTemporaryPathWithFile(NSString *file);


void CreatePlistForDictionary(id structure, NSString *savePath);
@end
