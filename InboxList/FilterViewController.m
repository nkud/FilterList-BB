//
//  FilterViewController.m
//  InboxList
//
//  Created by Naoki Ueda on 2014/07/12.
//  Copyright (c) 2014 Naoki Ueda. All rights reserved.
//

#import "FilterViewController.h"
#import "InputFilterViewController.h"
#import "Header.h"

@interface FilterViewController ()

@end

@implementation FilterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
      [self.view setBackgroundColor:RGBA(0, 0, 0, 0.5)];
    }
    return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];

  [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"FilterCell"];

  /**
   *  ボタン
   */
  UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [button setFrame:CGRectMake(0, 30, 100, 50)];
  [button setTitle:@"add" forState:UIControlStateNormal];
  [button addTarget:self
             action:@selector(dismissInput)
   forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:button];
}

- (void)dismissInput
{
  ;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
