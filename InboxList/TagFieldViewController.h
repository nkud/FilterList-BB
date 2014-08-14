//
//  TagFieldViewController.h
//  InboxList
//
//  Created by Naoki Ueda on 2014/07/27.
//  Copyright (c) 2014 Naoki Ueda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TagField.h"

@interface TagFieldViewController : UIViewController
<TagFieldDelegate>

@property (strong, nonatomic) NSMutableArray *textFieldArray;

-(NSSet *)getFields;

@end
