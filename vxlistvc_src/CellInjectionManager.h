//
//  CellInjectionManager.h
//  vixacalog
//
//  Created by vic on 12/07/2015.
//  Copyright (c) 2015 Vixac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CellConstructor.h"



@interface CellInjectionManager : NSObject<UITableViewDelegate, UITableViewDataSource>
{
    
}

@property (nonatomic, strong) NSArray * constructors;
@property (copy) void (^scrolledToTopCallback)(void);
@property (nonatomic, weak) IBOutlet UITableView * tView;

-(UITableViewCell *) cellForReuseIdentifier:(NSString *) identifier;
-(UITableViewCell *) newCell:(NSString *) identifier;

-(id) initWithTable:(UITableView *) table;

-(void) scrollToBottom;
-(void) scrollToBottom:(BOOL) animated;
@end
