//
//  NSData+MD5.m
//  
//
//  Created by 邬育靖 on 2021/8/10.
//

#import "NSData+MD5.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSData (MD5)
- (NSString *)md5 {
    
    
    // Create byte array of unsigned chars
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
        
    // Create 16 byte MD5 hash value, store in buffer
    CC_MD5(self.bytes, (unsigned int)self.length, md5Buffer);
        
    // Convert unsigned char buffer to NSString of hex values
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x",md5Buffer[i]];
    
    return output;
     
    /*
    CC_MD5_CTX c;
    CC_MD5_Init(&c);

    BOOL didSucceed = NO;

    // Use default value for the chunk size for reading data.
    const size_t chunkSizeForReadingData = 1024; // 1KB

    long chunkSize=chunkSizeForReadingData;

    CFIndex readBytesCount = 0;
    long totalOffset=0;

    long dataLength=[self length];
    NSLog(@"filesize of data:%lu",dataLength);

    long dataTobeReadLeft=dataLength;
    while (dataTobeReadLeft) {
        if (dataTobeReadLeft<chunkSize) {
            uint8_t buffer[dataTobeReadLeft];
            [self getBytes:buffer range:NSMakeRange(totalOffset,dataTobeReadLeft)];
            readBytesCount=dataTobeReadLeft;
            CC_MD5_Update(&c, buffer, (CC_LONG)dataTobeReadLeft);
            dataTobeReadLeft=0;
            didSucceed=YES;
        }else{
            uint8_t buffer[chunkSize];
            [self getBytes:buffer range:NSMakeRange(totalOffset,chunkSize)];
            totalOffset = totalOffset + chunkSize;
            dataTobeReadLeft=dataLength-totalOffset;
            CC_MD5_Update(&c, buffer, (CC_LONG)chunkSize);

        }

    }

    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    if (didSucceed) {
        unsigned char digest[CC_MD5_DIGEST_LENGTH];
        CC_MD5_Final(digest, &c);
        // Convert unsigned char buffer to NSString of hex values
        for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
            [output appendFormat:@"%02x",digest[i]];

    }

    return output;
     */
}
@end
