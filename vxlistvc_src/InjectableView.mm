//
//  InjectableView.m
//  InoutGroup
//
//  Created by vic on 10/04/2014.
//  Copyright (c) 2014 vixac. All rights reserved.
//

#import "InjectableView.h"

@implementation InjectableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(float) preferredSize
{
    return 33;
}
-(void) setViewSizeDelegate:(id<ViewSizeProtocol>)viewSizeDelegate
{
    _viewSizeDelegate = viewSizeDelegate;
    NSLog(@"WEHEY , set view size delegate to %@", viewSizeDelegate);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
