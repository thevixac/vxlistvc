//
//  XibUtil.h
//  vixacalog
//
//  Created by vic on 20/06/2014.
//  Copyright (c) 2014 Vixac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol VxBaseProtocol <NSObject>

-(void) initialiseVicBase;

@end

@interface XibUtil : NSObject
{
    
}
+(UIView *) buildViewFromXibName:(NSString *) xibName;
+(NSString *) getFullXibName:(NSString *) name;
+(bool) isIphone5;
+(NSString *) assetFullName:(NSString *) base;
+(float) getFixedHeightForXib:(NSString *) xibName;
@end
