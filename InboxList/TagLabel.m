//
//  TagLabel.m
//  FilterList
//
//  Created by Naoki Ueda on 2014/09/23.
//  Copyright (c) 2014年 Naoki Ueda. All rights reserved.
//

#import "TagLabel.h"

@implementation TagLabel


#pragma mark -

/**
* @brief  初期化
*
* @param tags 内包するタグの文字列
*
* @return インスタンス
*/
-(instancetype)initWithTagStrings:(NSSet *)tags
{
  self = [super initWithFrame:CGRectMake(0, 0, 100, 10)];
  if (self)
  {
    for (NSString *stringForTag in tags)
    {
      UILabel *label = [[UILabel alloc] init];
      CGSize size = [stringForTag sizeWithAttributes:@{NSFontAttributeName:label.font}];
      label.frame = CGRectMake(0, 0, size.width, size.height);
      [self addSubview:label];
      NSLog(@"%f", size.width);
    }
  }
  return self;
}

#pragma mark - その他

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
