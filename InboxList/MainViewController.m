//
//  MainViewController.m
//  InboxList
//
//  Created by Naoki Ueda on 2014/06/23.
//  Copyright (c) 2014年 Naoki Ueda. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
/* ===  FUNCTION  ==============================================================
 *        Name:
 * Description:
 * ========================================================================== */
-(id)init
{
  NSLog(@"%s", __FUNCTION__);
  self = [super init];
  return self;
}
/* ===  FUNCTION  ==============================================================
 *        Name:
 * Description:
 * ========================================================================== */
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  self.masterViewController = [[MasterViewController alloc] initWithStyle:UITableViewStylePlain];
//  self.navigationController = [[NavigationController alloc] initWithRootViewController:self.masterViewController];
  self.menuViewController = [[MenuViewController alloc] initWithNibName:nil bundle:nil];
//  [self.view addSubview:self.navigationController.view];
  [self.view addSubview:self.masterViewController.view];
  [self.view addSubview:self.menuViewController.view];

  [self.view bringSubviewToFront:self.masterViewController.view];
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
