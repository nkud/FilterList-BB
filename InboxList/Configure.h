//
//  Configure.h
//  InboxList
//
//  Created by Naoki Ueda on 2014/08/23.
//  Copyright (c) 2014 Naoki Ueda. All rights reserved.
//

#ifndef InboxList_Configure_h
#define InboxList_Configure_h

#include "Header.h"

/**
 * @brief  スワイプする時間
 */
#define SWIPE_DURATION 0.2

#define SWIPE_DISTANCE SCREEN_BOUNDS.size.width

/**
 * @brief  リストのタイトル
 */
#define TAG_LIST_TITLE @"TAG"
#define ITEM_LIST_TITLE @"ITEM"
#define FILTER_LIST_TITLE @"FILTER"

#define ITEM_COLOR RGB(0, 0, 0)
#define TAG_COLOR RGB(74, 144, 226);
#define FILTER_COLOR RGB(255, 166, 35)

#define ITEM_NAVBAR_COLOR RGB(230, 230, 0)

/**
 * @brief セルの高さ
 */
//#define TAG_CELL_HEIGHT 50


#endif