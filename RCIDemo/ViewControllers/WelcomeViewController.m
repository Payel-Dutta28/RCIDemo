//
//  WelcomeViewController.m
//  RCIDemo
//
//  Created by Rci Cts on 14/12/17.
//  Copyright © 2017 Rci Cts. All rights reserved.
//

#import "WelcomeViewController.h"

@interface WelcomeViewController ()
@property (weak, nonatomic) IBOutlet UIButton *signInBtn;

@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.signInBtn.layer.cornerRadius = 20; // this value vary as per your desire
    self.signInBtn.clipsToBounds = YES;
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
