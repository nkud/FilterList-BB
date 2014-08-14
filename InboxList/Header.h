//
//  Header.h
//  InboxList
//
//  Created by Naoki Ueda on 2014/06/21.
//  Copyright (c) 2014 Naoki Ueda. All rights reserved.
//

#ifndef InboxList_Header_h
#define InboxList_Header_h

//#define MIN(a,b)  ((a)<(b) ? (a) : (b))
//#define MAX(a,b)  ((a)<(b) ? (b) : (a))

// Debug
#define LOG(A, ...) NSLog(@"[ MESSAGE ] %s(%d) %@",__PRETTY_FUNCTION__,__LINE__,[NSString stringWithFormat:A,##__VA_ARGS__]);

// UIColor
#define RGB(r, g, b)      [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define RGBA(r, g, b, a)  [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

// Bounds
#define SCREEN_BOUNDS   ([UIScreen mainScreen].bounds)

// Default Height
#define STATUSBAR_H 20
#define TABBAR_H    48
#define NAVBAR_H    44
#define TOOLBAR_H   44

#endif
