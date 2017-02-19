//
//  Dashboard_TableViewController.h
//  Forecast
//
//  Created by M. Buğra Atay on 18/02/2017.
//  Copyright © 2017 M. Buğra Atay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFHTTPSessionManager.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import "Reachability.h"
#import <AFNetworkReachabilityManager.h>

#define BASEURL @"https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20weather.forecast%20where%20woeid%20in%20(select%20woeid%20from%20geo.places(1)%20where%20text%3D%22nome%2C%20ak%22)&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys"

@interface Dashboard_TableViewController : UITableViewController

@property (weak, nonatomic) Reachability* reachability;

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSMutableDictionary *wind;
@property (strong, nonatomic) NSMutableDictionary *atmosphere;
@property (strong, nonatomic) NSMutableDictionary *astronomy;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSMutableArray *forecast;
@property UIRefreshControl *refreshControl;

- (void)getDatas;

@end
