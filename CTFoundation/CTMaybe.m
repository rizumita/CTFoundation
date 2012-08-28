//
//  Maybe.m
//
//  Created by Ryoichi Izumita on 11/05/19.
//  Copyright 2011 CAPH. All rights reserved.
//

#import "CTMaybe.h"

MaybeTask maybeWaitUntilDone(MaybeAsynchronousTask asynchronousTask) {
    return [^(id obj) {
        __block CTMaybe *maybe;
        
        asynchronousTask(obj, &maybe);
        
        while (!maybe) {
            [[NSRunLoop currentRunLoop] runUntilDate:[NSDate distantFuture]];
        }

        return maybe;
    } copy];
}

@implementation CTMaybe

@synthesize object=_object;
@synthesize just;

+ (CTMaybe *)maybeWithObject:(id)obj {
    return [[self alloc] initWithObject:obj];
}

- (CTMaybe *)initWithObject:(id)obj {
    self = [super init];
    if (self) {
        self.object = obj;
    }
    return self;
}

- (CTMaybe *)bind:(MaybeTask)task {
    if (self.just) {
        return task(self.object);
    } else {
        return self;
    }
}

- (CTMaybe *)bindArray:(NSArray *)tasks {
    CTMaybe *maybe = self;

    for (MaybeTask task in tasks) {
        maybe = [maybe bind:task];
    }
    
    return maybe;
}

- (BOOL)isJust {
    return ![self isMemberOfClass:[CTNothing class]];
}

@end

@implementation CTJust @end
@implementation CTNothing @end
