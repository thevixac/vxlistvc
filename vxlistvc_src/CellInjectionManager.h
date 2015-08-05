//
//  CellInjectionManager.h
//  vixacalog
//
//  Created by vic on 12/07/2015.
//  Copyright (c) 2015 Vixac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CellConstructor.h"



@interface CellInjectionManager : NSObject<UITableViewDelegate, UITableViewDataSource, UISearchControllerDelegate, UISearchBarDelegate>
{
    
}


@property (nonatomic, assign) bool cellsClickable;
@property (nonatomic, strong) NSMutableArray * constructors;
@property (copy) void (^scrolledToTopCallback)(void);
@property (nonatomic, weak) IBOutlet UITableView * tView;
@property (nonatomic, strong) UIView * footerView;
-(UITableViewCell *) cellForReuseIdentifier:(NSString *) identifier;
-(UITableViewCell *) newCell:(NSString *) identifier;

-(id) initWithTable:(UITableView *) table;

-(void) setConstructorsWithoutReload:(NSArray *) constructors;
-(void) scrollToBottom;
-(void) scrollToBottom:(BOOL) animated;
-(void) setCell:(int) cellNumber height:(CGFloat) height;

-(void) reloadCellsFromIndex:(size_t) index constructors:(NSArray *) array;
@end
