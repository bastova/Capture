//
//  tbnParseManager.m
//  Capture
//
//  Created by Sacha Best on 4/14/14.
//  Copyright (c) 2014 The Best Network. All rights reserved.
//

#import "tbnParseManager.h"

@implementation tbnParseManager

+ (void) capturePoint:(PFObject *)point withNewArmy:(int)army withTarget:(id)target selector:(SEL)selector {
    [point setObject:[NSNumber numberWithInt:army] forKey:kParseCapturePointDefense];
    [point setObject:[PFUser currentUser] forKey:kParseCapturePointOwner];
    if (!target || !selector) {
        [point saveInBackground];
    } else {
        [point saveInBackgroundWithTarget:target selector:selector];
    }
}
+ (void) createPoint:(NSArray *)nodes atPointID:(NSString *)pointID withTarget:(id)target selector:(SEL)selector {
    PFObject *newPoint = [[PFObject alloc] initWithClassName:kParseCapturePointClass];
    [newPoint setObject:0 forKey:kParseCapturePointDefense];
    [newPoint setObject:nodes forKey:kParseCapturePointNodes];
    [newPoint setObject:pointID forKey:kParseCapturePointID];
    if (!target || !selector) {
        [newPoint saveInBackground];
    } else {
        [newPoint saveInBackgroundWithTarget:target selector:selector];
    }
}
+ (PFObject *) getPointByID:(NSString *)pointID {
    PFQuery *forID = [PFQuery queryWithClassName:kParseCapturePointClass];
    [forID whereKey:kParseCapturePointID equalTo:pointID];
    NSArray *results = [forID findObjects];
    if (results.count > 0) {
        return results[0];
    } else {
        return NULL;
    }
}
+ (NSArray *) getBuildingsByOwner:(PFUser *)owner {
    PFQuery *search = [[PFQuery alloc] initWithClassName:kParseCapturePointClass];
    [search whereKey:kParseCapturePointOwner equalTo:owner];
    return [search findObjects];
}
+ (NSArray *) getBuildingsOwnersIDs:(NSArray *)buildings {
    PFQuery *search = [[PFQuery alloc] initWithClassName:kParseCapturePointClass];
    [search whereKey:kParseCapturePointID containedIn:buildings];
    return [search findObjects];
}
+ (NSArray *) makeArrayOfOwners:(NSArray *)objects {
    if (!objects)
        return NULL;
    NSMutableArray *results = [[NSMutableArray alloc] initWithCapacity:objects.count];
    NSMutableArray *objs = [[NSMutableArray alloc] initWithCapacity:objects.count];
    for (int i = 0; i < objs.count; i++) {
        if (objects[i]) {
            results[i] = [objects[i] objectForKey:kParseCapturePointID];
        } else {
            results[i] = NULL;
        }
    }
    return [results copy];
}

@end
