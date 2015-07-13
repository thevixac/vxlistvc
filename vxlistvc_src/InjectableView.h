//
//  InjectableView.h
//  InoutGroup
//
//  Created by vic on 10/04/2014.
//  Copyright (c) 2014 vixac. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ViewSizeProtocol <NSObject>

-(void) updatePrefferedSize:(float) size;

@end

@interface InjectableView : UIView
-(float) preferredSize;
@property (nonatomic, weak) id<ViewSizeProtocol> viewSizeDelegate;
@end

