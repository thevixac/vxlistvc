//
//  CellInjectionManager.m
//  vixacalog
//
//  Created by vic on 12/07/2015.
//  Copyright (c) 2015 Vixac. All rights reserved.
//

#import "CellInjectionManager.h"
@interface CellInjectionManager ()
@property (nonatomic, strong) NSMutableArray * headers;

@end

@implementation CellInjectionManager

-(id) init {
    self = [super init];
    if(self) {
        [self setup];
    }
    return self;
}

-(void) setup {
        self.headers = [NSMutableArray array];
}
-(void) setTView:(UITableView *)tView {
    _tView = tView;
    [_tView setDelegate:self];
    [_tView setDataSource:self];
    [self refresh];
    
}

-(void) refresh {
    [self extractHeaders];
    [self.tView reloadData];
}

-(id) initWithTable:(UITableView *) table {
    self = [super init];
    if(self) {
        self.tView = table;
    }
    return self;
}

-(void) setConstructors:(NSArray *)constructors {
    _constructors = constructors;
    [self refresh];
}

-(void) extractHeaders {
    self.headers = [NSMutableArray array];
    size_t indexOfLastHeader=0;
    const size_t count = [self.constructors count];
    for(size_t i=0;i < count; i++) {
        CellConstructor * constructor = [self.constructors objectAtIndex:i];
        if(constructor.sectionHeader  == nil && constructor.buildHeader == nil) { // no header for this cell
            continue;
        }
        if([self.headers count] >0) { // set cell count for last section
            [[self.headers lastObject] setValue:[NSNumber numberWithUnsignedLong:(i - indexOfLastHeader)] forKey:@"numCells"];
        }

        //add a new section
        NSMutableDictionary * dict = [NSMutableDictionary dictionary];
        if(constructor.buildHeader) {
            [dict setObject:constructor.buildHeader() forKey:@"headerView"];
        }
        else if(constructor.sectionHeader) {
            [dict setObject:constructor.sectionHeader forKey:@"title"];
        }
        [self.headers addObject:dict];

        indexOfLastHeader = i;
    }
    if([self.headers count]) {
        [[self.headers lastObject] setValue:[NSNumber numberWithUnsignedLong:(count - indexOfLastHeader)] forKey:@"numCells"];
    }
}

#pragma mark UITableView Delegate & DataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.headers count] ? [self.headers count] : 1;
}


- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if([self.headers count] > 0) {
        return [[[self.headers objectAtIndex:section] valueForKey:@"numCells"] intValue];
    }
    else {
        return [self.constructors count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CellConstructor * c =[self.constructors objectAtIndex:[self indexPathToConstructorIndex:indexPath]];
    return c.preffSize;
}


-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if([self.headers count] > section) { //todo is that always true
        UIView * v = [[self.headers objectAtIndex:section] valueForKey:@"headerView"];
        if(v) {
            return v.frame.size.height;
        }
    }
    return 20.0; // normal height for title headers. TODO make property
}
-(UITableViewCell *) newCell:(NSString *) identifier {
    return  [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
}

-(UITableViewCell *) cellForReuseIdentifier:(NSString *) identifier {
    return [self.tView dequeueReusableCellWithIdentifier:identifier];
}


//TODO speed this up.
-(size_t) indexPathToConstructorIndex:(NSIndexPath *) indexPath {
    int offset=0;
    for(int i=0; i < indexPath.section; i++) {
        offset+=[[[self.headers objectAtIndex:i] valueForKey:@"numCells"] intValue];
        
    }
    return offset + indexPath.row;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CellConstructor * constructor = [self.constructors objectAtIndex:[self indexPathToConstructorIndex:indexPath]];
    UITableViewCell * cell = constructor.buildCell();
    constructor.table = tableView;
    constructor.indexPath=  indexPath;
    cell.userInteractionEnabled = YES;
    return (UITableViewCell *)cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y == 0) {
        if(self.scrolledToTopCallback) {
            self.scrolledToTopCallback();
        }
    }
}


- (void) tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tv deselectRowAtIndexPath:indexPath animated:YES];
    
    CellConstructor * c= [self.constructors objectAtIndex:[self indexPathToConstructorIndex:indexPath]];
    if(c.handleCellSelectedWithCell) {
        UITableViewCell * cell = (UITableViewCell *) [self.tView cellForRowAtIndexPath:indexPath];
        c.handleCellSelectedWithCell(cell);
    }
    else {
        c.handleCellSelected();
    }
}

-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if([self.headers count] <= section) {
        return nil;
    }
    NSDictionary * headerDetail = [self.headers objectAtIndex:section];
    UIView * v = [headerDetail valueForKey:@"headerView"];
    if(v) {
        return v;
    }
    return  nil;
}
-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.headers count] ? [[self.headers objectAtIndex:section] valueForKey:@"title"] : nil;
}


- (NSString *) tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return @"";
}

-(void) scrollToBottom
{
    [self scrollToBottom:true];
}

-(void) scrollToBottom:(BOOL) animated {
    const size_t count = [self.constructors count];
    if(!self.tView || count ==0) {
        return;
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:count-1 inSection:0];
    [self.tView scrollToRowAtIndexPath:indexPath
                      atScrollPosition:UITableViewScrollPositionBottom
                              animated:animated];
    
}
@end
