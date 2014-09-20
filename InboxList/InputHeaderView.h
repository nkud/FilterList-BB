//
//  InputHeaderView.h
//  FilterList
//
//  Created by Naoki Ueda on 2014/09/20.
//  Copyright (c) 2014年 Naoki Ueda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InputHeaderView : UIView
<UITextFieldDelegate>

@property UITextField *inputField;


-(instancetype)initWithTable:(UITableView *)table;

@end
