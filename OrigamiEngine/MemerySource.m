//
//  MemerySource.m
//  OrigamiEngine
//
//  Created by BigB on 2018/8/1.
//

#import "MemerySource.h"
@interface MemerySource()
{
    
    void *fileData;
    long fileSize;
    long currentPos;
}
@property (retain, nonatomic) NSURL *url;
@property (nonatomic,strong) NSData *data;
@end



@implementation MemerySource
- (void)dealloc {
    [self close];
    [_url release];
    [super dealloc];
}

#pragma mark - ORGMSource
+ (NSString *)scheme {
    return @"memory";
}

- (NSURL *)url {
    return _url;
}

- (long)size {
    return fileSize;
}

- (BOOL)open:(NSURL *)url {
    NSString *str = url.absoluteString;
    str = [str substringFromIndex:9];
    NSString *urlStr = [NSString stringWithFormat:@"%@",str];
    [self setUrl:[NSURL URLWithString:urlStr]];
    NSLog(@"need open url === %@",str);
    self.data = [NSData dataWithContentsOfURL:[NSURL URLWithString:str]];
    if (self.data != nil) {
        fileData = [self.data bytes];
        fileSize = self.data.length;
        return YES;
    }
    return NO;
}

- (BOOL)seekable {
    return YES;
}

- (BOOL)seek:(long)position whence:(int)whence {
//    return (fseek(_fd, position, whence) == 0);
    currentPos = position + whence;
    if (currentPos <= fileSize) {
        return YES;
    }
    return NO;
}

- (long)tell {
    return currentPos;
}

- (int)read:(void *)buffer amount:(int)amount {
//    if (currentPos+amount <= fileSize) {
//        void *p = fileData+currentPos;
//        memcpy(buffer, p, amount);
//        currentPos = currentPos +amount;
//        NSLog(@"end");
//        return amount;
//    }
//    else
//    {
//        if (currentPos >= fileSize ) {
//            return 0;
//        }
//        else
//        {
//            amount = fileSize - currentPos;
//            void *p = fileData+currentPos;
//            memcpy(buffer, p, amount);
//            currentPos = currentPos +amount;
//
//            return amount;
//        }
//    }
//    return 0;
    
    const void *pp = [self.data bytes];
    if (currentPos+amount <= fileSize) {
        void *p = pp+currentPos;
        memcpy(buffer, p, amount);
        currentPos = currentPos +amount;
        NSLog(@"end");
        return amount;
    }
    else
    {
        if (currentPos >= fileSize ) {
            return 0;
        }
        else
        {
            amount = fileSize - currentPos;
            void *p = pp+currentPos;
            memcpy(buffer, p, amount);
            currentPos = currentPos +amount;
            
            return amount;
        }
    }
    return 0;
}

- (void)close {
//    if (_fd) {
//        fclose(_fd);
//        _fd = NULL;
//    }
    if (self.data) {
        self.data = nil;
        fileSize = 0;
    }
}

#pragma mark - private
@end
