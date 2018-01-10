//
//  LoginViewController.m
//  RCIDemo
//
//  Created by Rci Cts on 14/12/17.
//  Copyright © 2017 Rci Cts. All rights reserved.
//

#import "LoginViewController.h"
#import "HomeViewController.h"

@interface NSURLOperationQueue : NSOperationQueue

+(NSURLOperationQueue *)operationQueue;

@end

@implementation NSURLOperationQueue

static NSURLOperationQueue *queue = NULL;

+(NSURLOperationQueue *)operationQueue
{
    
    static dispatch_once_t _singletonPredicate;
    
    dispatch_once(&_singletonPredicate, ^{
        queue = [[super allocWithZone:nil] init];
    });
    
    return queue;
}

@end

@interface LoginViewController (){
    NSString* user;
    NSString* pass;
    NSString* memberType;
}
@property (weak, nonatomic) IBOutlet UITextField *userNameInput;
@property (weak, nonatomic) IBOutlet UITextField *passwordInput;
@property (weak, nonatomic) IBOutlet UIButton *signInBtn;
@property (weak, nonatomic) IBOutlet UIButton *switchPwdBtn;
@property bool pwdSecured;
@property (weak, nonatomic) IBOutlet UILabel *userNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *pwdLbl;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   // Do any additional setup after loading the view.
    [self updateUI];
    _userNameInput.delegate = self;
    _passwordInput.delegate = self;
    [_userNameInput addTarget:self
                       action:@selector(textFieldDidChange:)
        forControlEvents:UIControlEventEditingChanged];
    [_passwordInput addTarget:self
                       action:@selector(textFieldDidChange:)
             forControlEvents:UIControlEventEditingChanged];
    user = @"moorpow";
    pass = @"moorpow";
   memberType = @"POINTS";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)updateUI{
    [self.userNameInput setBackgroundColor:[UIColor clearColor]];
    [self.passwordInput setBackgroundColor:[UIColor clearColor]];
    self.signInBtn.layer.cornerRadius = 20; // this value vary as per your desire
    self.signInBtn.clipsToBounds = YES;
    UIColor *color = [[UIColor whiteColor] colorWithAlphaComponent:0.50];
    _userNameInput.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"User Name" attributes:@{NSForegroundColorAttributeName: color}];
    _passwordInput.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: color}];
    _passwordInput.secureTextEntry = true;
    _pwdSecured = true;
    _userNameLbl.hidden = true;
    _pwdLbl.hidden = true;
}
- (IBAction)switchPwdEntryMode:(id)sender {
    UIImage *btnImage;
    if(_pwdSecured){
        _passwordInput.secureTextEntry = false;
        _pwdSecured = false;
        btnImage = [UIImage imageNamed:@"passwordShow.png"];
        [_switchPwdBtn setImage:btnImage forState:UIControlStateNormal];
    }
    else
    {
        _passwordInput.secureTextEntry = true;
        _pwdSecured = true;
        btnImage = [UIImage imageNamed:@"passwordHide.png"];
        [_switchPwdBtn setImage:btnImage forState:UIControlStateNormal];
    }
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField.tag == 1)
    {
        textField.placeholder = nil;
        _userNameLbl.hidden = false;
    }
    else
    {
        textField.placeholder = nil;
        _pwdLbl.hidden = false;
    }
}
-(void)textFieldDidChange :(UITextField *)theTextField{
    NSLog( @"text changed: %@", theTextField.text);
     UIColor *color = [[UIColor whiteColor] colorWithAlphaComponent:0.50];
    if([theTextField.text isEqualToString:@""])
    {
        if(theTextField.tag == 1)
        {
            _userNameInput.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"User Name" attributes:@{NSForegroundColorAttributeName: color}];
        _userNameLbl.hidden = true;
    }
        else if (theTextField.tag == 2)
        {
             _passwordInput.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: color}];
            _pwdLbl.hidden = true;
        }
}
}
- (IBAction)signInBtnClckd:(id)sender {
      //[self retrieveData];
    [self RCIMemberAuthentication];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


-(void)createRequestWithURL:(NSString *)url withParams:(NSDictionary *)params andCompletion:(void (^)(id JSON, NSError *error))completion
{
NSMutableURLRequest *request = [self createCommonRequestForUrl:url withParams:params];

// rg - special case i set up to ease passing the session id to this pre-existing function
if (params[@"SYV_PHPSessionId"])
{
    
    // 2/28 - this code commented out... cookies are now handled automatically by the NSURLConnection
    
    //NSString* phpSessionId = [NSString stringWithFormat: @"PHPSESSID=%@", params[@"SYV_PHPSessionId"]];
    //NSString* cookieValue = params[@"SYV_PHPSessionId"];
    //[request setValue: params[@"SYV_PHPSessionId"] forHTTPHeaderField:@"COOKIE"];
    
}

//NSLog(@"request url = %@", [[request URL] absoluteString]);

//NSHTTPCookieStorage* cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//NSArray* cookies = [cookieStorage cookiesForURL: [NSURL URLWithString: url]];
//NSLog(@"cookies = %@", cookies);

[NSURLConnection sendAsynchronousRequest:request
                                   queue:[NSURLOperationQueue operationQueue]
                       completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                           dispatch_async(dispatch_get_main_queue(), ^{
                               
                               if (connectionError != nil)
                               {
                                   completion(nil, connectionError);
                               }
                               else
                               {
                                   NSDictionary *rawJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                                   
                                   
                                   NSMutableDictionary* json = [NSMutableDictionary dictionaryWithDictionary: rawJSON];
                                   
                                   if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                                       NSDictionary *headerFields = [(NSHTTPURLResponse*)response allHeaderFields]; //This would give you all the header fields;
                                       //NSLog(@"headers = %@", headerFields);
                                       [json setObject: headerFields forKey: @"responseHeaderFields"];
                                   }
                                   
                                   completion(json, connectionError);
                               }
                           });
                       }];


}
-(NSMutableURLRequest *)createCommonRequestForUrl:(NSString *)url withParams :(NSDictionary *)params
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    // setup url and method (post/get)
    [request setURL:[NSURL URLWithString:url]];
    
    if (params != nil)
    {
        [request setHTTPMethod:@"POST"];
        NSMutableString *paramString = [NSMutableString string];
        
        for (NSString *key in [params allKeys]) {
            if ([[[params allKeys] lastObject] isEqualToString:key]) {
                [paramString appendFormat:@"%@=%@", key, params[key]];
            } else {
                
                [paramString appendFormat:@"%@=%@&", key, params[key]];
            }
        }
        NSData *bodyData = [paramString dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:bodyData];
        
    }
    else
    {
        [request setHTTPMethod:@"GET"];
    }
    
    
    [request setHTTPShouldHandleCookies:YES];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setTimeoutInterval:75];
    NSMutableDictionary * headers = [[NSHTTPCookie requestHeaderFieldsWithCookies:[NSHTTPCookieStorage sharedHTTPCookieStorage].cookies] mutableCopy];
    [headers addEntriesFromDictionary: [request allHTTPHeaderFields]];
    [request setAllHTTPHeaderFields:headers];
    return request;
}
- (void) retrieveData {
    
    [self getHomeFeaturedContent:nil
                            andCompletion:^(NSDictionary *browseDetails, NSError *error) {
                                //[self hideActivityIndicators];
                                
                                if (error != nil)
                                {
//                                    [self handleError:error];
                                }
                                else
                                {
                                    [self loadData:browseDetails ];
                                }
                            }];
    
    
    
}
- (void) loadData:(NSDictionary *)downloadedData  {
    
    NSLog(@"%@",downloadedData);
    
    
}
-(void)getHomeFeaturedContent:(NSString *)identifier andCompletion:(void (^)(NSDictionary *, NSError *))completion
{
    
    NSString *url = @"https://rcimobileapp.rci.com/services/experienceServices/list";
    [self createRequestWithURL:url
                    withParams:nil
                 andCompletion:^(id JSON, NSError *error) {
                     if (error != nil)
                     {
                         completion(nil, error);
                     }
                     else
                     {
                         completion(JSON, nil);
                     }
                 }];
}
-(void) RCIServiceForVacationInfoWithUserName: (NSString*) user password: (NSString*) password pointsOrWeeks: (NSString*) pointsOrWeeks andCompletion:(void (^)(NSDictionary* JSON, NSError *))completion
{
 //   NSString* urlString = [NFEndPoints SYVMemberAuthentication];
    NSString *urlString = @"https://rcimobileapp.rci.com/services/memberAuthServices/authenticate";
    [self createRequestWithURL: urlString
                    withParams: @{ @"requestId" : @"1", @"memberType": pointsOrWeeks, @"username" : user, @"password" : password }
                 andCompletion:^(id JSON, NSError* error) {
                     if(error != nil)
                     {
                         completion(nil, error);
                     }
                     else
                     {
                         completion(JSON, nil);
                     }
                     
                 }
     ];
}
-(void) RCIMemberAuthentication
{
    //NSLog(@"Start secondary login");
    // secondary RCI Service
    [self RCIServiceForVacationInfoWithUserName: user
                                                password: pass
                                           pointsOrWeeks: memberType
                                           andCompletion: ^(NSDictionary* dictionary, NSError * error) {
                                             //  globals.secondaryLoginDone = YES;
                                               if (error)
                                               {
                                                   NSLog(@"error = %@", error.description);
                                                  // [ADMSTrackerHelper trackSignInError];
                                                   
                                                   //                                                   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"There was an issue retrieving your member data." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:Nil, nil];
                                                   //                                                   [alert show];
                                               }
                                               else
                                               {
                                                  NSLog(@"Secondary login succeeded");
                                                   // dictionary contains their vacation history and future vacations
                                                   
                                                   if(![dictionary[@"status"] isEqualToString:@"Error"])
                                                   {
                                                       //NSLog(@"dict = %@", dictionary);
                                                       
                                                    //   globals.succeededSecondaryLogin = YES;
                                                       NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithDictionary: dictionary[@"response"]];
                                                       NSLog(@"---------------------------------- Doctionary----------------- %@",dict);
                                                       [dict setObject: memberType forKey: @"memberType"];
                                                       
//                                                       if (globals.succeededSecondaryLogin) {
//                                                           [dict setObject: @"YES" forKey: @"succeededSecondaryLogin"];
//                                                       }
//
//                                                       if (globals.succeededPrimaryLogin) {
//                                                           [dict setObject: @"YES" forKey: @"succeededPrimaryLogin"];
//                                                       }
//
                                                       NSString *userTierLevel = @"";
                                                       
                                                       if ([memberType isEqualToString:@"WEEKS"]) {
                                                           userTierLevel = dictionary[@"response"][@"memberTierType"];
                                                       } else {
                                                           userTierLevel = dictionary[@"response"][@"memberTier"];
                                                       }
                                                       
                                                       
                                                       // [ADMSTrackerHelper configureAppMeasurement];
                                                       NSString* memberUID = dictionary[@"response"][@"memberUID"]; // was dictionary[@"response"][@"subscriberID"]
                                                       
                                                       
                                                       NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
                                                       [defaults setObject: dict forKey: @"authenticatedMemberInfo"];
                                                       [defaults setObject: dict forKey: @"authenticatedMemberInfo_cached"];
                                                       [defaults synchronize];
                                                       
                                                    //   [ADMSTrackerHelper trackLogins: memberUID andMemberType:memberType andTierLevel: userTierLevel];
                                                       
                                                   }
                                                    [self performSegueWithIdentifier:@"navigateToHome" sender:self];
                                               }
                                              // [self checkAmIDone];
                                           }
     ];
}
//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    if ([[segue identifier] isEqualToString:@"navigateToHome"])
//    {
//
//        [[segue destinationViewController] setDetailItem:object];
//    }
//}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"navigateToHome"]) {
      //  NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        HomeViewController *homeViewController = segue.destinationViewController;
       // segue.destinationViewController = homeViewController;
      //  destViewController.recipeName = [recipes objectAtIndex:indexPath.row];
    }
}

@end
