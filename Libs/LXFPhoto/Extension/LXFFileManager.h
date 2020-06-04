//
//  FileManager.h
//  iBuilding
//
//  Created by 梁啸峰 on 2017/8/7.
//
//

#import <Foundation/Foundation.h>

@interface LXFFileManager : NSObject

+ (BOOL)saveImageWithImageData:(NSData *)imageData andName:(NSString *)imageName;
+ (NSData *)fetchImageDataWithImageName:(NSString *)imageName;
+ (NSString *)fetchImageFileUrlWithImageName:(NSString *)name;

+ (BOOL)saveExcelWithData:(NSData *)imageData andName:(NSString *)imageName;
+ (NSString *)fetchExcelPathWithName:(NSString *)name;

///临时存储视频
+ (BOOL)saveTempVideoDataToCache:(NSData *)data;
+ (NSString *)fetchTempVideoFilePath;

// 删除图片缓存
+ (BOOL)deleteDirInCache:(NSString *)dirName;

+ (BOOL)createDirInDocuments:(NSString *)dirName;

+ (NSString *)pathInDocuments:(NSString *)fileName;

+ (BOOL)saveDataToCacheDir:(NSString *)directoryPath data:(NSData *)data dataName:(NSString *)dataName;
+ (NSData*)loadDataWithPath:(NSString *)directoryPath name:(NSString *)name;

+ (BOOL)saveArrayToCacheDir:(NSString *)directoryPath array:(NSArray *)array arrayName:(NSString *)arrayName;
+ (NSArray *)loadArrWithPath:(NSString *)directoryPath name:(NSString *)name;

+ (BOOL)saveDictToCacheDir:(NSString *)directoryPath dict:(NSDictionary *)dict arrayName:(NSString *)arrayName;
+ (NSDictionary *)loadDictWithPath:(NSString *)directoryPath name:(NSString *)name;

@end
