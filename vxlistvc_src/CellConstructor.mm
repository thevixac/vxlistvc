//
//  CellConstructor.m
//  vixacalog
//
//  Created by vic on 17/02/2014.
//  Copyright (c) 2014 Vixac. All rights reserved.
//

#import "CellConstructor.h"
#import "InjectableView.h"

@implementation InjectableCell

-(void) setTopLevelView:(UIView *)topLevelView
{

    if(_topLevelView)
    {
        [_topLevelView removeFromSuperview];
    }
    _topLevelView = topLevelView;
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, topLevelView.frame.size.width, topLevelView.frame.size.height)];
    [self addSubview:topLevelView];
    self.prefHeight = topLevelView.frame.size.height;

}

@end

@implementation CellConstructor

-(id) initWithBuilder:(InjectableCell * (^)(void)) builder handlerWithCell:(void (^)(InjectableCell *)) handler height:(float) cellHeight
{
    self = [super init];
    if(self)
    {
        self.buildCell = builder;
        self.preffSize = cellHeight;
        self.handleCellSelectedWithCell = handler;
        
    }
    return self;
}
-(id) initWithBuilder:(InjectableCell * (^)(void)) builder handler:(void (^)(void)) handler
{
    return [self initWithBuilder:builder handler:handler height:50];
}


-(id) initWithBuilder:(InjectableCell * (^)(void)) builder handler:(void (^)(void)) handler height:(float) cellHeight

{
    self = [super init];
    if(self)
    {
        self.handleCellSelectedWithCell = nil;
        self.buildCell = builder;
        self.handleCellSelected = handler;
        self.preffSize = cellHeight;
    }
    return self;
}

-(void) updatePrefferedSize:(float)size
{
    self.preffSize = size;
    UITableView *  t = self.table;
    if(t)
    {
        [t reloadRowsAtIndexPaths:[NSArray arrayWithObject:self.indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }

}

@end

