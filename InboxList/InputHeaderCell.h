//
//  InputHeaderCell.h
//  InboxList
//
//  Created by Naoki Ueda on 2014/09/20.
//  Copyright (c) 2014年 Naoki Ueda. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InputHeaderCellDelegate <UITextFieldDelegate>

-(void)didInputtedNewItem:(NSString *)titleForItem;

@end

/// クイック入力用のセル
@interface InputHeaderCell : UITableViewCell
<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *inputField;

@property id<InputHeaderCellDelegate> delegate;

@end
