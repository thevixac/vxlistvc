//
//  CellConstructor.m
//  vixacalog
//
//  Created by vic on 17/02/2014.
//  Copyright (c) 2014 Vixac. All rights reserved.
//

#import "CellConstructor.h"
#import "InjectableView.h"


@implementation CellConstructor

-(id) initWithBuilder:(UITableViewCell * (^)(void)) builder handlerWithCell:(void (^)(UITableViewCell *)) handler height:(float) cellHeight
{
    self = [super init];
    if(self)
    {
        self.buildCell = builder;
        self.preffSize = cellHeight;
        self.handleCellSelectedWithCell = handler;
        
        /*
        //TODO rm
        self.buildHeader =^UIView *{
            UIView * v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
            [v setBackgroundColor:[UIColor greenColor]];
            return v;
        };
         */
        
    }
    return self;
}
-(id) initWithBuilder:(UITableViewCell * (^)(void)) builder handler:(void (^)(void)) handler
{
    return [self initWithBuilder:builder handler:handler height:50];
}


-(id) initWithBuilder:(UITableViewCell * (^)(void)) builder handler:(void (^)(void)) handler height:(float) cellHeight

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

