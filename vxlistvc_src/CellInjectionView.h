//
//  CellInjectionView.h
//  vixacalog
//
//  Created by vic on 17/02/2014.
//  Copyright (c) 2014 Vixac. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CellConstructor.h"
#import "CellInjectionManager.h"
#include <vector>
#include <map>

@protocol CellInjectionProtocol <NSObject>

-(void) configureCell:(InjectableCell *) cell;

@end

@interface CellInjectionView : UIView<UITableViewDelegate, UITableViewDataSource>
{
    std::vector<CellConstructor *> constructors_;
    CellInjectionManager * manager_;

}


//an array of CellConstructors. Set this
@property (nonatomic, weak) id<CellInjectionProtocol> delegate; //in case init with frame wasnt called.


-(InjectableCell *) cellForReuseIdentifier:(NSString *) identifier;
-(InjectableCell *) newCell:(NSString *) identifier;


-(CellConstructor *) getConstructor:(size_t) row;
-(void) addConstructor:(CellConstructor *) constructor;
-(void) setConstructors:(std::vector<CellConstructor *> const&) constructors;




@end

