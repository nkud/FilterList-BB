//
//  InputHeaderCell.h
//  InboxList
//
//  Created by Naoki Ueda on 2014/09/20.
//  Copyright (c) 2014年 Naoki Ueda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InputHeaderCell : UITableViewCell
<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *inputField;

@end
