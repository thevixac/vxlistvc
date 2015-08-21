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
    self.cellsClickable = true;
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
    if(!self.tView) {
        NSLog(@"warning, CellInjectionManager has no table");
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tView reloadData];
    });

}

-(id) initWithTable:(UITableView *) table {
    self = [super init];
    if(self) {
        [self setup];
        self.tView = table;
    }
    return self;
}
-(void) setConstructors:(NSMutableArray *)constructors {
    _constructors = constructors;
    [self refresh];
}

-(void) setConstructorsWithoutReload:(NSArray *) constructors {
    _constructors = [NSMutableArray arrayWithArray:constructors];
}

-(void) reloadCellsFromIndex:(size_t) index constructors:(NSArray *) newConstructors {
    int oldCount =[self.constructors count];

    //TODO what if theres nothing before this
    for(int i=index;i < oldCount; i++) {
        [self.constructors setObject:[newConstructors objectAtIndex:i-index] atIndexedSubscript:i];
    }
    int total = [self.constructors count];
    NSMutableArray * array = [NSMutableArray array];
    for(int i=index;i < total; i++) {
        NSIndexPath * p = [self cellNumberToIndexPath:i];
        [array addObject:p];
    }
    if([array count]==0) {
        return;
    }
    [self extractHeaders];
    [self.tView reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationNone];
    [self jumpToCell:[array lastObject]];
    
}

-(void) jumpToCell:(NSIndexPath *) path {
    [self.tView scrollToRowAtIndexPath:path
                      atScrollPosition:UITableViewScrollPositionNone
                              animated:false];
    
    
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

-(void) setCell:(int) cellNumber height:(CGFloat) height {
    CellConstructor * c = [self.constructors objectAtIndex:cellNumber];
    c.preffSize = height;
    NSIndexPath * p = [self cellNumberToIndexPath:cellNumber];
    if(p) {
        [self.tView reloadRowsAtIndexPaths:@[p] withRowAnimation:UITableViewRowAnimationNone];
    }
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if([self.headers count] > section) { //todo is that always true
        UIView * v = [[self.headers objectAtIndex:section] valueForKey:@"headerView"];
        if(v) {
            return v.frame.size.height;
        }
        return 23.0;
    }
    return 0.0;
}

-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if(self.footerView) {
        return self.footerView.frame.size.height;
    }
    return 0;
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

-(NSIndexPath *) cellNumberToIndexPath:(size_t) cellNum {
    int curCell=0;
    for(int i=0;i < [self.headers count]; i++) {
        int numCellsThisSection = [[[self.headers objectAtIndex:i] valueForKey:@"numCells"] intValue];
        if(curCell + numCellsThisSection > cellNum) { // correct section.
            return [NSIndexPath indexPathForItem:(cellNum - curCell) inSection:i];
        }
        else {
            curCell+=numCellsThisSection;
        }
    }
    return nil;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CellConstructor * constructor = [self.constructors objectAtIndex:[self indexPathToConstructorIndex:indexPath]];
    if(constructor.constructedCell) {
        NSLog(@"reusing cell");
        return constructor.constructedCell;
    }
    
    UITableViewCell * cell = constructor.buildCell();
    constructor.constructedCell = cell;
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
    [tv deselectRowAtIndexPath:indexPath animated:NO];
    if(!self.cellsClickable) {
        return;
    }
    
    
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
    return nil;
}

-(UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return self.footerView;
}

-(void) scrollToBottom {
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
