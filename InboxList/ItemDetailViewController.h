//
//  DetailViewController.h
//  InboxList
//
//  Created by Naoki Ueda on 2014/03/03.
//  Copyright (c) 2014 Naoki Ueda. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Item.h"

@protocol ItemDetailViewControllerDelegate <NSObject>

- (void)dismissDetailView:(id)sender
                    index:(NSIndexPath *)indexPath
                itemTitle:(NSString *)itemTitle
                tagTitles:(NSArray *)tagTitles;

@end

@interface ItemDetailViewController : UIViewController

@property (strong, nonatomic) Item * detailItem;

@property id <ItemDetailViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextField *tagField;

@property (strong, nonatomic) NSIndexPath *index;

@end
