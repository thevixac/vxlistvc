//
//  InjectableVC.m
//  InoutGroup
//
//  Created by vic on 31/03/2014.
//  Copyright (c) 2014 vixac. All rights reserved.
//

#import "InjectableVC.h"

@interface InjectableVC ()

@end

@implementation InjectableVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        

        self.cellView = [[CellInjectionView alloc] initWithFrame:CGRectZero ];
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.cellView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.cellView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:self.cellView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
