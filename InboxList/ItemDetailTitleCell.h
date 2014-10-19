//
//  ItemDetailTitleCell.h
//  InboxList
//
//  Created by Naoki Ueda on 2014/09/14.
//  Copyright (c) 2014年 Naoki Ueda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemDetailTitleCell : UITableViewCell
<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *titleField;

//@property id<UITextFieldDelegate> delegate;

@end
