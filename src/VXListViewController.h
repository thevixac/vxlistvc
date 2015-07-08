//
//  ViewController.h
//  WordSwipeViews
//
//  Created by vic on 07/07/2013.
//  Copyright (c) 2013 vic. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XibUtil.h"


@interface UIView (NibLoading)
+(UIView *) loadInstanceFromNib ;
@end
@interface VCCreator :NSObject
{
    
}
@property (copy) NSString * xibName;
@property (copy) NSString * cellTitle;
@property (copy) UIViewController * (^callback)(NSString *); // yea so will use the callback indicated by hasVoidCallback
@property (copy) void (^voidCallback)(NSString *);
@property (assign) bool hasVoidCallback;
+(VCCreator *) createFromName:(NSString *) name callback:(UIViewController * (^)(NSString *)) callback;
+(VCCreator *) createFromName:(NSString *) name voidCallback:(void (^)(NSString *)) callback;
+(VCCreator *) createFromName:(NSString *) name cellTitle:(NSString *) cellTitle callback:(UIViewController * (^)(NSString *)) callback;
+(VCCreator *) createFromName:(NSString *) name cellTitle:(NSString *) cellTitle cb:(UIViewController * (^)(void)) callback;
@end
@interface VXListViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
{
    
}
@property (nonatomic, strong) IBOutlet UITableView * tView;
@property (nonatomic, strong) NSArray * vcNames;
@property (nonatomic, strong) NSArray * viewNames;

/**
 subclass this class and override this.
 */
-(void) buildXibList;
//-(void) open:(BOOL) isView row:(int) row;
-(void) openPrevious;

@end
