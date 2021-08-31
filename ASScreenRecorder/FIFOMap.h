//
//  FIFOMap.h
//  
//
//  Created by 邬育靖 on 2021/8/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FIFOMap : NSObject

/**
 *  For caches that do not override sizeOf:, this is the maximum number of entries in the cache.
 *  For all other caches, this is the maximum sum of the sizes of the entries in this cache.
 */
- (id)initWithMaxSize:(NSInteger)maxSize;

/**
 * Returns the value for key if it exists in the cache or can be created by create:.
 * If a value was returned, it is moved to the head of the queue.
 * This returns null if a value is not cached and cannot be created.
 */
- (id)get:(NSString *)key;

/**
 * Caches value for key and return the previous value mapped by key.
 * The value is moved to the head of the queue.
 */
- (void)put:(NSString *)key value:(id)value;

/**
 * Remove the eldest entries until the total of remaining entries is at or below the requested size.
 * maxSize is the maximum size of the cache before returning. May be -1 to evict even 0-sized elements.
 */
- (void)trimToSize:(NSInteger)maxSize;

/**
 * For caches that do not override size:, this is the number of entries in the cache.
 * For all other caches, this returns the sum of the sizes of the entries in this cache.
 */
@property (readonly) NSInteger size;
@property (readonly) NSInteger maxSize;

@property (nonatomic, copy) void (^outputBlock)(id data) ;
@end

NS_ASSUME_NONNULL_END
