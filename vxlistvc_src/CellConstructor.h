//
//  CellConstructor.h
//  vixacalog
//
//  Created by vic on 17/02/2014.
//  Copyright (c) 2014 Vixac. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "InjectableView.h"




@interface CellConstructor : NSObject<ViewSizeProtocol>
{
}
-(id) initWithBuilder:(UITableViewCell * (^)(void)) builder handler:(void (^)(void)) handler;
-(id) initWithBuilder:(UITableViewCell * (^)(void)) builder handler:(void (^)(void)) handler height:(float) cellHeight;
-(id) initWithBuilder:(UITableViewCell * (^)(void)) builder handlerWithCell:(void (^)(UITableViewCell *)) handler  height:(float) cellHeight;
@property (copy) UITableViewCell * (^buildCell)(void);
@property (copy) void (^handleCellSelected)(void);
@property (copy) void (^handleCellSelectedWithCell)(UITableViewCell *);
@property (assign) float preffSize;
@property (assign) int64_t constructorId;
@property (nonatomic, copy) NSString * sectionHeader; //if set, this cell becomes the start of a new section



@property (nonatomic, weak) UITableView * table;
@property (nonatomic, strong) NSIndexPath * indexPath;
@end
