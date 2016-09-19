//
//  main.m
//  LVPlistToHtml
//
//  Created by 石茗伟 on 16/9/19.
//  Copyright © 2016年 驴妈妈. All rights reserved.
//

#import <Foundation/Foundation.h>

const char* stringFromDate(NSDate * date) {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return [destDateString cStringUsingEncoding:NSASCIIStringEncoding];
}


int main(int argc, const char * argv[]) {
    @autoreleasepool {
        if (argc - 1 < 2) {
            printf("参数不匹配\n");
            return 0;
        }
        NSString *plistFilePath = [NSString stringWithFormat:@"%s", argv[1]];
        NSString *htmlFilePath = [NSString stringWithFormat:@"%s", argv[2]];
        NSString *svnLog = [NSString stringWithFormat:@"%s", argv[3]];
        NSDictionary *plistDic = [NSDictionary dictionaryWithContentsOfFile:plistFilePath];
        if (!plistDic) {
            printf("plist文件未发现内容\n");
            return 0;
        }
        NSString *appIdName = [plistDic objectForKey:@"AppIDName"];
        NSDate *createDate = [plistDic objectForKey:@"CreationDate"];
        NSArray *platform = [plistDic objectForKey:@"Platform"];
        NSDate *expirationDate = [plistDic objectForKey:@"ExpirationDate"];
        NSString *name = [plistDic objectForKey:@"Name"];
        NSArray *provisionedDevices = [plistDic objectForKey:@"ProvisionedDevices"];
        NSArray *teamIdentifier = [plistDic objectForKey:@"TeamIdentifier"];
        NSString *teamName = [plistDic objectForKey:@"TeamName"];
        NSString *uuid = [plistDic objectForKey:@"UUID"];
        NSNumber *version = [plistDic objectForKey:@"Version"];
        
        NSMutableString *content = [NSMutableString string];
        [content appendString:@"<html><head><title>app info</title><meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\"><style type=\"text/css\">table{ background-color:#aaa; line-height:25px;}th{ background-color:#fff;}td{ background-color:#fff; text-align:left}</style></heade><body>"];
        if (svnLog) {
            [content appendString:svnLog];
        }
        [content appendString:@"<table width=\"500\" cellpadding=\"10\" cellspacing=\"1\">"];
        if (appIdName) {
            [content appendString:@"<tr>"];
            [content appendString:@"<td height=44>AppIDName</td>"];
            [content appendFormat:@"<td>%@</td>", appIdName];
            [content appendString:@"</tr>"];
        }
        if (name) {
            [content appendString:@"<tr>"];
            [content appendString:@"<td height=44>Name</td>"];
            [content appendFormat:@"<td>%@</td>", name];
            [content appendString:@"</tr>"];
        }
        if (teamName) {
            [content appendString:@"<tr>"];
            [content appendString:@"<td height=44>TeamName</td>"];
            [content appendFormat:@"<td>%@</td>", teamName];
            [content appendString:@"</tr>"];
        }
        if (uuid) {
            [content appendString:@"<tr>"];
            [content appendString:@"<td height=44>UUID</td>"];
            [content appendFormat:@"<td>%@</td>", uuid];
            [content appendString:@"</tr>"];
        }
        if (version) {
            [content appendString:@"<tr>"];
            [content appendString:@"<td height=44>Version</td>"];
            [content appendFormat:@"<td>%@</td>", version];
            [content appendString:@"</tr>"];
        }
        if (teamIdentifier) {
            [content appendString:@"<tr>"];
            [content appendString:@"<td height=44>Version</td>"];
            [content appendFormat:@"<td><li>%@</td>", [teamIdentifier componentsJoinedByString:@"<li>"]];
            [content appendString:@"</tr>"];
        }
        if (createDate) {
            [content appendString:@"<tr>"];
            [content appendString:@"<td height=44>CreateDate</td>"];
            [content appendFormat:@"<td>%s</td>", stringFromDate(createDate)];
            [content appendString:@"</tr>"];
        }
        if (expirationDate) {
            [content appendString:@"<tr>"];
            [content appendString:@"<td height=44>ExpirationDate</td>"];
            [content appendFormat:@"<td>%s</td>", stringFromDate(expirationDate)];
            [content appendString:@"</tr>"];
        }
        if (platform) {
            [content appendString:@"<tr>"];
            [content appendString:@"<td height=44>Platform</td>"];
            [content appendFormat:@"<td><li>%@</td>", [platform componentsJoinedByString:@"<li>"]];
            [content appendString:@"</tr>"];
        }
        if (provisionedDevices) {
            [content appendString:@"<tr>"];
            [content appendString:@"<td height=44>ProvisionedDevices</td>"];
            [content appendFormat:@"<td><li>%@</td>", [provisionedDevices componentsJoinedByString:@"<li>"]];
            [content appendString:@"</tr>"];
        }
        [content appendString:@"</table></body></html>"];
        
        NSError *error;
        [content writeToFile:htmlFilePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
        if (error) {
            printf("导出html文件失败:%s\n", [error.localizedDescription cStringUsingEncoding:NSASCIIStringEncoding]);
        }else{
            printf("导出成功\n");
        }
    }
    return 0;
}
