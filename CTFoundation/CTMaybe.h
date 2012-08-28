//
//  Maybe.h
//
//  Created by Ryoichi Izumita on 11/05/19.
//  Copyright 2011 CAPH. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CTMaybe;

typedef CTMaybe *(^MaybeTask)(id obj);

/** Asynchronous task used with maybeWaitUntilDone function.
 @param obj Maybe object.
 @param outMaybe Maybe returned. It has to be set. It should be retained. If this param is set, this task is end.
 */
typedef void (^MaybeAsynchronousTask)(id obj, CTMaybe **outMaybe);

/** Maybe task treating asynchronous task
 @param asynchronousTask Task typed MaybeAsynchronousTask
 */
MaybeTask maybeWaitUntilDone(MaybeAsynchronousTask asynchronousTask);

@interface CTMaybe : NSObject

@property (nonatomic, strong) id object;
@property (nonatomic, readonly, getter = isJust) BOOL just;

+ (CTMaybe *)maybeWithObject:(id)obj;

- (CTMaybe *)initWithObject:(id)obj;

- (CTMaybe *)bind:(MaybeTask)task;

- (CTMaybe *)bindArray:(NSArray *)tasks;

@end

@interface CTJust : CTMaybe {} @end
@interface CTNothing : CTMaybe {} @end
