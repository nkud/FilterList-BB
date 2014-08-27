//
//  InputItemNavigationController.m
//  InboxList
//
//  Created by Naoki Ueda on 2014/08/24.
//  Copyright (c) 2014 Naoki Ueda. All rights reserved.
//

#import "InputItemNavigationController.h"
#import "Header.h"

@interface InputItemNavigationController ()

@end

@implementation InputItemNavigationController

#pragma mark - 初期化

/**
 * @brief  初期化
 *
 * @param nibNameOrNil   nibNameOrNil description
 * @param nibBundleOrNil nibBundleOrNil description
 *
 * @return インスタンス
 */
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

/**
 * @brief  ビュー出現前処理
 *
 * @param animated アニメーション
 */
-(void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  LOG(@"ナビゲーションバー・ツールバーを非表示");
  self.navigationBarHidden = YES;
  self.toolbarHidden = YES;
}

- (void)viewDidLoad
{
  [super viewDidLoad];


}


#pragma mark - その他

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
