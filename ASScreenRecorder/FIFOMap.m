//
//  FIFOMap.m
//  
//
//  Created by 邬育靖 on 2021/8/10.
//

#import "FIFOMap.h"

@implementation FIFOMap{
    NSMutableDictionary *_values;
    NSMutableOrderedSet *_keys;
    NSTimeInterval _maxSize;
}

- (id)initWithMaxSize:(NSInteger)maxSize
{
    if (maxSize <= 0) {
        [NSException raise:@"Illegal Argument" format:@"maxSize <= 0"];
    }
    
    self = [super init];
    if (self) {
        _maxSize = maxSize;
        _values = [[NSMutableDictionary alloc] init];
        _keys = [[NSMutableOrderedSet alloc] init];
    }
    return self;
}

- (id)init
{
    return [self initWithMaxSize:0];
}

- (NSInteger)size
{
    return _keys.count;
}

- (NSInteger)maxSize
{
    return _maxSize;
}

- (id)get:(NSString *)key
{
    if (key == nil) {
        [NSException raise:@"Null Pointer" format:@"key == nil"];
    }
    
    NSString *cKey = [key copy];
    id dicValue;
    @synchronized (self) {
        dicValue = _values[cKey];
    }
    return dicValue;
}

- (void)put:(NSString *)key value:(id)value
{
    NSLog(@"put key:%@ value:%@",key,value);
    
    if (key == nil || value == nil) {
        [NSException raise:@"Null Pointer" format:@"key == nil || value == nil"];
    }
    
    NSString *cKey = [key copy];
    
    /*
    if ([self get:cKey] != nil){
        NSLog(@">>>Drop data:%@",value);
        return;
    }
     */
    
    @synchronized (self) {
        [_keys addObject:cKey];
        [_values setObject:value forKey:cKey];
    }
    
    [self trimToSize:_maxSize];
}

- (void)trimToSize:(NSInteger)maxSize
{
    @synchronized (self) {
        NSLog(@">>>keys.count:%lu",(unsigned long)_keys.count);
        if(_keys.count < _maxSize){
            return;
        }
        
        NSMutableData *data = [[NSMutableData alloc] init];
        while (_keys.count >= _maxSize/2) {
            id key = [_keys firstObject];
            id value = [_values objectForKey:key];
            
            [data appendData:value];
            
            [_keys removeObject:key];
            [_values removeObjectForKey:key];
        }
        
        if (self.outputBlock){
            self.outputBlock(data);
        }
    }
}

- (NSMutableDictionary *)snapshot
{
    return [NSMutableDictionary dictionaryWithDictionary:_values];
}
@end
