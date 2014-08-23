//
//  InputTagViewController.m
//  InboxList
//
//  Created by Naoki Ueda on 2014/08/17.
//  Copyright (c) 2014年 Naoki Ueda. All rights reserved.
//

#import "InputTagViewController.h"
#import "Header.h"

@interface InputTagViewController ()

@end

@implementation InputTagViewController

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil
                           bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];

  [self.saveButton addTarget:self
                      action:@selector(save:)
            forControlEvents:UIControlEventTouchUpInside];
  [self.titleField becomeFirstResponder];
}

/**
 *  入力を保存して戻る
 */
-(void)save:(id)sender
{
  LOG(@"入力を保存して戻る");
  [self.delegate saveTags:[NSSet setWithObject:self.titleField.text]];
  [self.navigationController popToRootViewControllerAnimated:YES];
}

/**
 *  メモリー警告
 */
- (void)didReceiveMemoryWarning
{
  LOG(@"メモリー警告");
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end