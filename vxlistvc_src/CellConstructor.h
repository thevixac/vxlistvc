//
//  CellConstructor.h
//  vixacalog
//
//  Created by vic on 17/02/2014.
//  Copyright (c) 2014 Vixac. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "InjectableView.h"


//its just a placeholder tableviewcell that knows how big it needs to be, maybe it can ask the topLevelView what size is good.
@interface InjectableCell : UITableViewCell

//@property (nonatomic, assign) float prefferedSize;

@property (nonatomic, strong) UIView * topLevelView;
@property (assign) float prefHeight;

@end



@interface CellConstructor : NSObject<ViewSizeProtocol>
{
}
-(id) initWithBuilder:(InjectableCell * (^)(void)) builder handler:(void (^)(void)) handler;
-(id) initWithBuilder:(InjectableCell * (^)(void)) builder handler:(void (^)(void)) handler height:(float) cellHeight;
-(id) initWithBuilder:(InjectableCell * (^)(void)) builder handlerWithCell:(void (^)(InjectableCell *)) handler  height:(float) cellHeight;
@property (copy) InjectableCell * (^buildCell)(void);
@property (copy) void (^handleCellSelected)(void);
@property (copy) void (^handleCellSelectedWithCell)(InjectableCell *);
@property (assign) float preffSize;
@property (assign) int64_t constructorId;
@property (nonatomic, copy) NSString * sectionHeader; //if set, this cell becomes the start of a new section



@property (nonatomic, weak) UITableView * table;
@property (nonatomic, strong) NSIndexPath * indexPath;
@end
