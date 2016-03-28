//
//  SSCheckMark.h
//  PhotoPrintUA
//
//  Created by atMamont on 18.03.16.
//  Copyright © 2016 Andrey Mamchenko. All rights reserved.
//

#ifndef SSCheckMark_h
#define SSCheckMark_h


#endif /* SSCheckMark_h */

#import <UIKit/UIKit.h>

typedef NS_ENUM( NSUInteger, SSCheckMarkStyle )
{
    SSCheckMarkStyleOpenCircle,
    SSCheckMarkStyleGrayedOut
};

@interface SSCheckMark : UIView

@property (readwrite) bool checked;
@property (readwrite) SSCheckMarkStyle checkMarkStyle;

@end