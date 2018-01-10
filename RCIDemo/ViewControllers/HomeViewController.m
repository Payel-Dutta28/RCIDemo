//
//  HomeViewController.m
//  RCIDemo
//
//  Created by Rci Cts on 02/01/18.
//  Copyright © 2018 Rci Cts. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()
{
    NSString *formattedName;
    
}
@property (weak, nonatomic) IBOutlet UICollectionView *regionCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *experienceCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *popularDestCollectionView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLbl;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
_regionsImgs = [NSMutableArray arrayWithObjects:@"image1",@"image2",@"image3",@"image4",@"image5",@"image6",@"image7",@"image8",@"image9", nil];
    _regions = [NSMutableArray arrayWithObjects:@"USA",@"Carribean& Bermuda",@"Canada",@"Australia & South Pacific",@"Mexico",@"Central America",@"Europe",@"South America",@"Asia", nil];
    _experienceImgs = [NSMutableArray arrayWithObjects:@"image4",@"image5",@"image6",nil];
    _experiences = [NSMutableArray arrayWithObjects:@"Adventure",@"Beach",@"Kids", nil];
    _popularDestImgs = [NSMutableArray arrayWithObjects:@"image7",@"image8",@"image9", nil];
    _popularDestinations = [NSMutableArray arrayWithObjects:@"Carribean & Bermuda",@"Canada",@"Australia & South Pacific", nil];
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary* userDictionary = [defaults objectForKey: @"authenticatedMemberInfo_cached"];
    if (userDictionary)
    {
        NSString* first = @"firstName";
        if (userDictionary[first])
        {
            formattedName = [userDictionary[first] lowercaseString];
            formattedName = [formattedName stringByReplacingCharactersInRange:NSMakeRange(0,1)
                                                                   withString:[[formattedName substringToIndex:1] capitalizedString]];
            //            self.loggedInHeaderMessage.text = [NSString stringWithFormat: @"Welcome back, %@!", formattedName];
           
            
        }
        _userNameLbl.text = [NSString stringWithFormat: @"Hi, %@", formattedName];
    }
    
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self.scrollView setContentSize:CGSizeMake(375, 1425)];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if(collectionView == self.regionCollectionView)
    {
         return _regionsImgs.count;
    }
    else if (collectionView == self.experienceCollectionView)
    {
        return _experienceImgs.count;
    }
    else if (collectionView == self.popularDestCollectionView)
    {
        return _popularDestImgs.count;
    }
    return 0;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell;
    if(collectionView == self.regionCollectionView)
    {
    static NSString *identifier = @"Cell";

    
   cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    UIImageView *regionImageView = (UIImageView *)[cell viewWithTag:100];
    regionImageView.image = [UIImage imageNamed:[_regionsImgs objectAtIndex:indexPath.row]];
    UILabel *regionName = (UILabel *)[cell viewWithTag:200];
    regionName.text = [_regions objectAtIndex:indexPath.row];
    }
    else if(collectionView == self.experienceCollectionView)
    {
        static NSString *identifier = @"ExpCell";
        
        
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        
        UIImageView *experienceImageView = (UIImageView *)[cell viewWithTag:300];
        experienceImageView.image = [UIImage imageNamed:[_experienceImgs objectAtIndex:indexPath.row]];
        UILabel *experienceName = (UILabel *)[cell viewWithTag:400];
        experienceName.text = [_experiences objectAtIndex:indexPath.row];
    }
    else if(collectionView == self.popularDestCollectionView)
    {
        static NSString *identifier = @"DestCell";
        
        
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        
        UIImageView *destImageView = (UIImageView *)[cell viewWithTag:500];
        destImageView.image = [UIImage imageNamed:[_popularDestImgs objectAtIndex:indexPath.row]];
        UILabel *destName = (UILabel *)[cell viewWithTag:600];
        destName.text = [_popularDestinations objectAtIndex:indexPath.row];
    }
    
    return cell;
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
