//
//  CellInjectionView.m
//  vixacalog
//
//  Created by vic on 17/02/2014.
//  Copyright (c) 2014 Vixac. All rights reserved.
//

#import "CellInjectionView.h"


#include <iostream>

@interface CellInjectionView()

@property (nonatomic, strong)  UITableView * tView;
@end

@implementation CellInjectionView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
       
    }
    return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self) {
        [self setup];
    }
    return self;
}

-(void) setup {

    self.tView= [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self addSubview:self.tView];
    manager_ =  [[CellInjectionManager alloc] initWithTable:self.tView];
}

-(void) setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self.tView setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
}

-(UITableViewCell *) newCell:(NSString *) identifier
{
    return [manager_ newCell:identifier];
}

-(UITableViewCell *) cellForReuseIdentifier:(NSString *) identifier
{
    return [manager_ cellForReuseIdentifier:identifier];
}

//TODO rm
-(void) setDelegate:(id<CellInjectionProtocol>)delegate {
    _delegate = delegate;
}

-(void) setConstructors:(std::vector<CellConstructor *> const&) constructors {
    NSMutableArray * array = [NSMutableArray array];
    for(int i=0; i < constructors.size(); i++) {
        [array addObject:constructors[i]];
    }
    manager_.constructors =array;
}


//TODO put this into cellInjectionManager
-(void) addConstructor:(CellConstructor *) constructor {
    NSLog(@"WARN, not using manager. TODO pass this work onto the manager_.");
    constructors_.push_back(constructor);
    size_t lastRowNumber =[self.tView numberOfRowsInSection:0];
    [self.tView  beginUpdates];
    [self.tView insertRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:lastRowNumber inSection:0 ], nil] withRowAnimation:UITableViewRowAnimationRight];
    [self.tView endUpdates];
}



@end
