//
//  Cell.h
//  InboxList
//
//  Created by Naoki Ueda on 2014/05/03.
//  Copyright (c) 2014年 Naoki Ueda. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Cell;

@protocol CellDelegate <NSObject>

- (void)tappedCheckBox:(Cell *)cell touch:(UITouch *)touch;

@end


@interface Cell : UITableViewCell

@property (strong, nonatomic) UIView *checkBox; /* チェックボックス */

@property (nonatomic, assign) id <CellDelegate> delegate;

- (BOOL)updateCheckBox:(BOOL)isChecked;

@end
