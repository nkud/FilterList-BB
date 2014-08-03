//
//  ResultControllerFactory.h
//  InboxList
//
//  Created by Naoki Ueda on 2014/07/27.
//  Copyright (c) 2014 Naoki Ueda. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString const *predicateFormat = @"ANY SELF.tags.title == %@";

@interface ResultControllerFactory : NSObject

/**
 *  通常のリザルトコントローラー
 *
 *  @param controller デリゲートを設定するコントローラー
 *
 *  @return リザルトコントローラー
 */
+ (NSFetchedResultsController *)fetchedResultsController:(id<NSFetchedResultsControllerDelegate>)controller;

+ (NSFetchedResultsController *)fetchedResultsControllerForTags:(NSSet *)tagStringSet
                                                       delegate:(id<NSFetchedResultsControllerDelegate>)controller;
@end
