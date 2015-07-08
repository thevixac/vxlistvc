//
//  XibUtil.m
//  vixacalog
//
//  Created by vic on 20/06/2014.
//  Copyright (c) 2014 Vixac. All rights reserved.
//

#import "XibUtil.h"


@implementation XibUtil

+(NSString *) assetFullName:(NSString *) base
{
    NSString * fullName;
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
    {
        fullName = [base stringByAppendingString:@"_phone"];
    }
    else
    {
        fullName = [base stringByAppendingString:@"_ipad"];
    }
    return fullName;
}


+(bool) isIphone5
{
    UIDevice * thisDevice = [UIDevice currentDevice];
    return  thisDevice.userInterfaceIdiom == UIUserInterfaceIdiomPhone && [[UIScreen mainScreen] bounds].size.height == 568;
}

+(NSString *) getFullXibName:(NSString *) name
{
    if([XibUtil isIphone5])
    {
        NSString *fiveName= [name stringByAppendingString:@"-5"];
        if([[NSBundle mainBundle] pathForResource:fiveName ofType:@"nib"] != nil)
        {
            return fiveName;
        }
    }
    return name;
    
}

+(UIView *) buildViewFromXibName:(NSString *) xibName
{
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:xibName owner:self options:nil];
    UIView * v= [topLevelObjects objectAtIndex:0];
    if([v  respondsToSelector:@selector(initialiseVicBase)])
    {
        
        id<VxBaseProtocol> d = (id<VxBaseProtocol>)v;
        [d initialiseVicBase];
    }
    return v;
}

+(float) getFixedHeightForXib:(NSString *) xibName
{
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:xibName owner:self options:nil];
    UIView * v = (UIView *) [topLevelObjects objectAtIndex:0];
    return v.frame.size.height;
}

@end
