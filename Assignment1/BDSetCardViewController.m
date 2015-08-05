//
//  BDSetCardViewController.m
//  Assignments
//
//  Created by Amr Lotfy on 8/5/15.
//  Copyright (c) 2015 Amr Lotfy. All rights reserved.
//

#import "BDSetCardViewController.h"

@interface BDSetCardViewController ()

@end

@implementation BDSetCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
}

-(void) notifyParent{
    [self parentViewController];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
