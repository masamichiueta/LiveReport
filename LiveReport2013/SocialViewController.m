//
//  SocialViewController.m
//  LiveReport2013
//
//  Created by Ueta Masamichi on 2013/03/28.
//  Copyright (c) 2013年 Ueta Masamichi. All rights reserved.
//

#import "SocialViewController.h"

#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import "PostInfoUtil.h"

#import "PrettyKit.h"

@interface SocialViewController ()

@end

@implementation SocialViewController
@synthesize socialTable=_socialTable;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)FromInterfaceOrientation {
    if(bannerIsVisible){
        adBannerView.frame = CGRectMake(adBannerView.frame.origin.x, adBannerView.frame.origin.y, self.view.frame.size.width, adBannerView.frame.size.height);
        _socialTable.frame = CGRectMake(_socialTable.frame.origin.x, _socialTable.frame.origin.y + adBannerView.frame.size.height, _socialTable.frame.size.width, _socialTable.frame.size.height - adBannerView.frame.size.height);
    }
    else{
        _socialTable.frame = CGRectMake(_socialTable.frame.origin.x, 0, _socialTable.frame.size.width, self.view.frame.size.height);
    }
    
}

#pragma mark -
#pragma mark Pretty Kit
- (void) customizeNavBar {
    PrettyNavigationBar *navBar = (PrettyNavigationBar *)self.navigationController.navigationBar;
    
    navBar.topLineColor = [UIColor darkGrayColor];
    navBar.gradientStartColor = [UIColor darkGrayColor];
    navBar.gradientEndColor = [UIColor colorWithHex:0x000000];
    navBar.bottomLineColor = [UIColor colorWithHex:0xCC3599];
    navBar.shadowOpacity = 0.0;
    navBar.roundedCornerRadius = 10;
    self.navigationItem.title = NSLocalizedString(@"Post to SNS", @"Post to SNS");
    
}

#pragma mark -
#pragma mark Initialization
- (void) initTableView{
    _socialTable.delegate = self;
    _socialTable.dataSource = self;
    _socialTable.scrollsToTop = YES;
    [_socialTable dropShadows];
    _socialTable.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
}

-(void) initIAd{
    adBannerView = [[ADBannerView alloc] initWithAdType:ADAdTypeBanner];
    adBannerView.delegate = self;
    adBannerView.frame = CGRectOffset(adBannerView.frame, 0.0, -adBannerView.frame.size.height);
    bannerIsVisible=NO;
    [self.view addSubview:adBannerView];
}




#pragma mark -
#pragma mark View Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self customizeNavBar];
    [self initTableView];
    [self initIAd];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark UITableView Delegate Methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:{
            //Localize
            NSString* tableHeader = NSLocalizedString(@"Facebook", @"Facebook");
            return tableHeader;
        }
            break;
        
        case 1:{
            //Localize
            NSString* tableHeader = NSLocalizedString(@"Twitter", @"Twitter");
            return tableHeader;
        }
            break;
            
        default:
            break;
    }
    return 0;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    
    PrettyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[PrettyTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.tableViewBackgroundColor = tableView.backgroundColor;
    }
    
    //PrettyKitSetting
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.textLabel.numberOfLines = 2;
    cell.textLabel.minimumScaleFactor = 10;
    cell.textLabel.font = [UIFont boldSystemFontOfSize:10];
    cell.cornerRadius = 5;
    cell.customSeparatorColor = [UIColor colorWithHex:0xCC3599];
    cell.borderColor = [UIColor colorWithHex:0xCC3599];
    [cell prepareForTableView:tableView indexPath:indexPath];
    
    //Cell Content
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text = NSLocalizedString(@"Post to Facebook", @"Post to Facebook");
            cell.imageView.image = [UIImage imageNamed:@"facebook"];
            break;
        
        case 1:
            cell.textLabel.text = NSLocalizedString(@"Post to Twitter", @"Post to Twitter");
            cell.imageView.image = [UIImage imageNamed:@"twitter"];
            break;
            
        default:
            break;
    }
    
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [_socialTable deselectRowAtIndexPath:[_socialTable indexPathForSelectedRow] animated:NO];
    PostInfoUtil *postInfo = [PostInfoUtil sharedCenter];
    switch (indexPath.section) {
        case 0:{
            if([postInfo.place length] == 0 || [postInfo.songList count] == 0){
                UIAlertView *alert =
                [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Item Not Set", @"Item Not Set") message:NSLocalizedString(@"Items are not set.", @"Items are not set") delegate:self cancelButtonTitle:NSLocalizedString(@"No", @"No") otherButtonTitles:nil, nil];
                [alert show];
            } else{
                SLComposeViewController *facebookPostViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
                NSString *postString = [self getFBPostString];
                [facebookPostViewController setInitialText:postString];
                //[facebookPostVC addImage:[UIImage imageNamed:@"EUI.jpg"]];
                [self presentViewController:facebookPostViewController animated:YES completion:nil];
            }
        }
            break;
            
        case 1:{
            if([postInfo.place length] == 0 || [postInfo.songList count] == 0){
                UIAlertView *alert =
                [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Item Not Set", @"Item Not Set") message:NSLocalizedString(@"Items are not set.", @"Items are not set") delegate:self cancelButtonTitle:NSLocalizedString(@"No", @"No") otherButtonTitles:nil, nil];
                [alert show];
            } else{
                SLComposeViewController *twitterPostViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
                NSArray *postStringArray = [self getTWPostStringArray];
                if([postStringArray count] == 1){
                    [twitterPostViewController setInitialText:[postStringArray objectAtIndex:0]];
                    [self presentViewController:twitterPostViewController animated:YES completion:nil];
                } else{
                    UIAlertView *alert =
                    [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Post to Twitter", @"Post to Twitter") message:NSLocalizedString(@"Post Multiple tweets to twitter because tweet is over 140 characters", @"Post Multiple tweets to twitter because tweet is over 140 characters") delegate:self cancelButtonTitle:NSLocalizedString(@"No", @"No") otherButtonTitles:NSLocalizedString(@"Yes", @"Yes"), nil];
                    alert.tag = 1;
                    [alert show];
                }
                
            }
        }
            
            break;
        default:
            break;
    }
}


#pragma mark -
#pragma mark AdBannerView Delegate Methods
-(void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    if (!bannerIsVisible)
    {
        [UIView beginAnimations:@"animateAdBannerOn" context:NULL];
        banner.frame = CGRectOffset(banner.frame, 0, adBannerView.frame.size.height);
        [UIView commitAnimations];
        
        bannerIsVisible = YES;
        adBannerView.frame = CGRectMake(adBannerView.frame.origin.x, adBannerView.frame.origin.y, self.view.frame.size.width, adBannerView.frame.size.height);
        _socialTable.frame = CGRectMake(_socialTable.frame.origin.x, _socialTable.frame.origin.y + adBannerView.frame.size.height, _socialTable.frame.size.width, _socialTable.frame.size.height - adBannerView.frame.size.height);
    }
}


-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    if (bannerIsVisible)
    {
        [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
        banner.frame = CGRectOffset(banner.frame, 0, -adBannerView.frame.size.height);
        [UIView commitAnimations];
        bannerIsVisible = NO;
        _socialTable.frame = CGRectMake(_socialTable.frame.origin.x, 0, _socialTable.frame.size.width, self.view.frame.size.height);
    }
}

#pragma mark -
#pragma mark UIAlertView Delegate Methods
-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(alertView.tag == 1){
        switch (buttonIndex) {
            case 0:
                break;
            case 1:
            {
                NSArray *postStringArray = [self getTWPostStringArray];
                
                if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
                    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
                    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
                    [accountStore
                     requestAccessToAccountsWithType:accountType
                     options:nil
                     completion:^(BOOL granted, NSError *error) {
                         if (granted) {
                             for(int i=0; i<[postStringArray count]; i++){
                                 NSArray *accountArray = [accountStore accountsWithAccountType:accountType];
                                 if (accountArray.count > 0) {
                                     NSURL *url = [NSURL URLWithString:@"http://api.twitter.com/1/statuses/update.json"];
                                     NSDictionary *params = [NSDictionary dictionaryWithObject:[postStringArray objectAtIndex:i] forKey:@"status"];
                                     
                                     SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                                             requestMethod:SLRequestMethodPOST
                                                                                       URL:url
                                                                                parameters:params];
                                     [request setAccount:[accountArray objectAtIndex:0]];
                                     [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                                         NSLog(@"responseData=%@", [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
                                     }];
                                 }
                             }
                         } else{
                             UIAlertView *alert =
                             [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Account is not set", @"Account is not set") message:NSLocalizedString(@"Can't post to twitter.", @"Can't post to twitter.") delegate:self cancelButtonTitle:NSLocalizedString(@"No", @"No") otherButtonTitles:nil, nil];
                             [alert show];
                         }
                     }];
                }
                
            }
                break;
        }
    }
    
}


#pragma mark -
#pragma mark StringFormat Method
-(NSString*) getFBPostString{
    PostInfoUtil *postInfo = [PostInfoUtil sharedCenter];
    
    NSString *placeString =postInfo.place;
    NSMutableString *songString = [NSMutableString string];
    for(int i=0; i<[postInfo.songList count]; i++){
        [songString appendString:[[postInfo.songList objectAtIndex:i] objectForKey:@"songName"]];
        [songString appendString:@"/"];
    }
    
    NSString *postString = [NSString stringWithFormat:@"【岡平健治ソロ28都道府県弾語り自走ツアー】【会場】 %@ 【セットリスト】 %@  #岡平健治 %@", placeString, songString, APPLICATION_LINK];
    
    return postString;
}

-(NSMutableArray*) getTWPostStringArray{
    PostInfoUtil *postInfo = [PostInfoUtil sharedCenter];
    
    NSString *placeString =postInfo.place;
    NSMutableString *songString = [NSMutableString string];
    for(int i=0; i<[postInfo.songList count]; i++){
        [songString appendString:[[postInfo.songList objectAtIndex:i] objectForKey:@"songName"]];
        [songString appendString:@"/"];
    }
    
    NSMutableString *postString = [NSMutableString stringWithFormat:@"【岡平健治ソロ28都道府県弾語り自走ツアー】【会場】 %@ 【セットリスト】 %@", placeString, songString];
    NSMutableArray *postStringArray = [NSMutableArray array];
    
    if([postString length] > 100){
        while([postString length] > 100){
            NSString *formatString = [NSString stringWithFormat:@"%@ #岡平健治 %@",[postString substringToIndex:100], APPLICATION_LINK];
            [postString deleteCharactersInRange:NSMakeRange(0, 99)];
            [postStringArray addObject:formatString];
        }
        [postString appendString:@" #岡平健治 "];
        [postString appendString:APPLICATION_LINK];
        [postStringArray addObject:postString];
    } else{
        [postString appendString:@" #岡平健治 "];
        [postString appendString:APPLICATION_LINK];
        [postStringArray addObject:postString];
    }
    return postStringArray;
}



@end
