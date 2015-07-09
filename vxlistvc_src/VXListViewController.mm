//
//  ViewController.m
//  WordSwipeViews
//
//  Created by vic on 07/07/2013.
//  Copyright (c) 2013 vic. All rights reserved.
//

#import "VXListViewController.h"
//#import "VXSettings.h"
//TODO take this out of there. it needs to be in the subclass
#define SHOW_BACK_BUTTON 0

@implementation VCCreator
@synthesize  callback;
@synthesize xibName;
@synthesize cellTitle;
+(VCCreator *) createFromName:(NSString *) name callback:(UIViewController * (^)(NSString *)) callback
{
    return [VCCreator createFromName:name cellTitle:name callback:callback];
}

+(VCCreator *) createFromName:(NSString *) name cellTitle:(NSString *) cellTitle cb:(UIViewController * (^)(void)) callback
{
    VCCreator * c = [[VCCreator alloc] init];
    c.xibName = name;
    c.cellTitle = cellTitle;
    c.hasVoidCallback = false;
    c.callback = ^(NSString *) {
        return callback();
    };
    return c;
}

+(VCCreator *) createFromName:(NSString *) name cellTitle:(NSString *) cellTitle callback:(UIViewController * (^)(NSString *)) callback
{
    VCCreator * c = [[VCCreator alloc] init];
    c.callback = callback;
    c.xibName = name;
    c.cellTitle = cellTitle;
    c.hasVoidCallback = false;
    return c;
}

+(VCCreator *) createFromName:(NSString *) name voidCallback:(void (^)(NSString *)) callback
{
    
    VCCreator * c = [[VCCreator alloc] init];
    c.voidCallback = callback;
    c.xibName = name;
    c.cellTitle = name;
    c.hasVoidCallback = true;
    return c;
    
}
@end

@interface VXListViewController ()
@end

@implementation VXListViewController


-(void) buildXibList
{
    
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
#pragma mark UITableView Delegate & DataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if(section ==0)
    {
        return [self.vcNames count];
    }
    if(section ==1)
    {
        return [self.viewNames count];
    }
    return 0;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if(indexPath.section ==0)
    {
        VCCreator * c =[self.vcNames objectAtIndex:indexPath.row];
        cell.textLabel.text =c.cellTitle;
        
    }
    else if(indexPath.section ==1)
    {
        VCCreator * c =[self.viewNames objectAtIndex:indexPath.row];
        cell.textLabel.text = c.cellTitle;
    }
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
    return cell;
}

-(void) openPrevious
{/*
    VXSettings * s= [[VXSettings alloc] init];
    [s addPlist:@"vxp_VXListViewController.plist"];
    
    int row = [s getInt:@"row" orJust:0];
    bool isView = [s getBool:@"isView" orJust:false];
    if(row < (isView ? [self.viewNames count] : [self.vcNames count]))
    {
        [self handleClick :isView row:row];
    }
  */
}

-(void) handleClick:(BOOL) isView row:(int) row
{
    /*
    VXSettings * s= [[VXSettings alloc] init];
    [s addPlist:@"vxp_VXListViewController.plist"];
    [s setItem:@"isView" value:[NSNumber numberWithBool:isView]];
    [s setItem:@"vx_uint_row" value:[NSNumber numberWithInt:row]];
    */
    
    UIViewController *  vc = [[UIViewController alloc] init];

    VCCreator * c = [(!isView ? self.vcNames : self.viewNames) objectAtIndex:row];
  //  vc.navigationController.title = c.xibName;
    
    if(c.hasVoidCallback)
    {
        c.callback(c.xibName);

    }
    else
    {
        vc =c.callback(c.xibName);
    
#if SHOW_BACK_BUTTON
    {
        
        UIButton * button =[UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button setFrame:CGRectMake(10, 20, 80, 50)];
        button.backgroundColor = [UIColor blueColor];
        [button setTitle:@"<- Back" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(backPressed:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.hidden = false;
        [vc.view addSubview:button];
    
    }
#endif
    
        [vc setTitle:c.xibName];
        [self.navigationController pushViewController:vc animated:YES];
        
    }

}
- (void) tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tv deselectRowAtIndexPath:indexPath animated:YES];

    [self handleClick:indexPath.section ==1  row:indexPath.row];
}

-(void) backPressed:(id) sender
{
    NSLog(@"button pressed");
    [self.navigationController popViewControllerAnimated:true];
}
- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	if(section ==0)
    {
        return @"ViewControllers";
    }
    if(section ==1)
    {
        return @"Views";
    }
    return nil;
}

- (NSString *) tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
	return @"";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
     [[self.navigationController navigationBar] setTranslucent:NO];
    self.tView= [[UITableView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.tView];

    [self buildXibList];
    [self.tView setDelegate:self];
    [self.tView setDataSource:self];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
