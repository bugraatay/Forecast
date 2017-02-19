//
//  Dashboard_TableViewController.m
//  Forecast
//
//  Created by M. Buğra Atay on 18/02/2017.
//  Copyright © 2017 M. Buğra Atay. All rights reserved.
//

#import "Dashboard_TableViewController.h"

@interface Dashboard_TableViewController ()

@end

@implementation Dashboard_TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.refreshControl = [UIRefreshControl new];
    [self.refreshControl addTarget:self
                        action:@selector(refreshTable)
              forControlEvents:UIControlEventValueChanged];
    [self refreshTable];
}
-(void)awakeFromNib{
    [super awakeFromNib];
    self.forecast = [NSMutableArray new];
    self.wind = [NSMutableDictionary new];
    self.atmosphere = [NSMutableDictionary new];
    self.astronomy = [NSMutableDictionary new];
}
- (BOOL)prefersStatusBarHidden {
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
    switch (section) {
        case 0:
            return 0;
            break;
            
        case 1:
            return [self.wind count];
            break;
            
        case 2:
            return [self.atmosphere count];
            break;
            
        case 3:
            return [self.astronomy count];
            break;
            
        case 4:
            return 2;
            break;
            
        case 5:
            return [self.forecast count];
            break;
        default:
            break;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 5){
        return 100;
    }else {
        return 44;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    // [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    NSMutableDictionary *dic;
    // Configure the cell...
    if (indexPath.section == 1) {
        dic = self.wind;
        NSLog(@"dic: %@", dic);
        cell.textLabel.text = [NSString stringWithFormat:@"%@", [[dic allKeys] objectAtIndex: indexPath.row]];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [[dic allValues] objectAtIndex: indexPath.row]];
        return cell;
    } else if(indexPath.section == 2){
        dic = self.atmosphere;
        NSLog(@"dic: %@", dic);
        cell.textLabel.text = [NSString stringWithFormat:@"%@", [[dic allKeys] objectAtIndex: indexPath.row]];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [[dic allValues] objectAtIndex: indexPath.row]];
        return cell;
    } else if(indexPath.section == 3){
        dic = self.astronomy;
        NSLog(@"dic: %@", dic);
        cell.textLabel.text = [NSString stringWithFormat:@"%@", [[dic allKeys] objectAtIndex: indexPath.row]];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [[dic allValues] objectAtIndex: indexPath.row]];
        return cell;
    } else if(indexPath.section == 4){
        dic = nil;
        NSLog(@"dic: %@", dic);
        cell.textLabel.text = [NSString stringWithFormat:@"%@", [[dic allKeys] objectAtIndex: indexPath.row]];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [[dic allValues] objectAtIndex: indexPath.row]];
        return cell;
    } else if(indexPath.section == 5){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell2"];

        UILabel *label1 = (UILabel *) [cell viewWithTag:1];
        UILabel *label2 = (UILabel *) [cell viewWithTag:2];
        UILabel *label3 = (UILabel *) [cell viewWithTag:3];
        UILabel *label4 = (UILabel *) [cell viewWithTag:4];
        UILabel *label5 = (UILabel *) [cell viewWithTag:5];
        UILabel *label6 = (UILabel *) [cell viewWithTag:6];

        dic = [self.forecast objectAtIndex:indexPath.row];
        Weather *weather = [[Weather alloc] init];
        weather.code = dic[@"code"];
        weather.date = dic[@"date"];
        weather.day = dic[@"day"];
        weather.high = dic[@"high"];
        weather.low = dic[@"low"];
        weather.text = dic[@"text"];

        label1.text = weather.code;
        label2.text = weather.date;
        label3.text = weather.day;
        label4.text = weather.high;
        label5.text = weather.low;
        label6.text = weather.text;

        return cell;
    }
    return nil;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    switch (section) {
        case 0:
            return self.title;
            break;
            
        case 1:
            return @"Wind";
            break;
            
        case 2:
            return @"Atmosphere";
            break;
            
        case 3:
            return @"Astronomy";
            break;
            
        case 4:
            return @"Image";
            break;
            
        case 5:
            return @"Forecast";
            break;
            
        default:
            break;
    }
    return nil;
}

-(void)getDatas{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURL *URL = [NSURL URLWithString:BASEURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDataTask *dataTask = [manager
                                      dataTaskWithRequest:request
                                      completionHandler:^(NSURLResponse *response, id responseObjects, NSError *error) {
                                          if (!error) {
                                              
                                              [self setTitle:responseObjects[@"query"][@"results"][@"channel"][@"item"][@"title"]];
                                              [self setWind:[NSMutableDictionary dictionaryWithDictionary:responseObjects[@"query"][@"results"][@"channel"][@"wind"]]];
                                              [self setAtmosphere:[NSMutableDictionary dictionaryWithDictionary:responseObjects[@"query"][@"results"][@"channel"][@"atmosphere"]]];
                                              [self setAstronomy:[NSMutableDictionary dictionaryWithDictionary:responseObjects[@"query"][@"results"][@"channel"][@"astronomy"]]];

                                              [self setForecast:responseObjects[@"query"][@"results"][@"channel"][@"item"][@"forecast"]];
                                              
                                              [self.tableView reloadData];
                                          } else{
                                              
                                              if (![[AFNetworkReachabilityManager sharedManager] isReachable]) {
                                                  UIAlertController *alert = [UIAlertController
                                                                              alertControllerWithTitle:@"Uyarı!" message:@"Verilerin güncellenebilmesi için internete bağlı olmalısınız." preferredStyle:UIAlertControllerStyleAlert];
                                                  UIAlertAction *yesButton = [UIAlertAction
                                                                              actionWithTitle:@"Ayarlara git."
                                                                              style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                                                                                                                                                [[UIApplication sharedApplication] openURL:[NSURL URLWithString: UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
                                                                              }];
                                                  
                                                  UIAlertAction *cancelButton = [UIAlertAction
                                                                                 actionWithTitle:@"Vazgeç"
                                                                                 style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                                                                                 }];
                                                  [alert addAction:yesButton];
                                                  [alert addAction:cancelButton];
                                                  
                                                  [self presentViewController:alert animated:YES completion:nil];
                                              }
                                          }
                                      }
                                      ];
    [dataTask resume];

}

- (void)refreshTable {
    [self getDatas];
    [self.refreshControl endRefreshing];
}


@end

//                                              UIImageView* imgView = (UIImageView*)[cell viewwithtag:10];
//                                              [imgView setImage: [[UIImage imageNamed:@"resimAdı"] imagewithcustomcolor]];
//                                              [imgView imagewithdata: responseObjects[@"query"][@"results"][@"channel"][@"image"]];

//                                              [imgView imagewithdata: [nsdata datawithcontentsofurl:[nsurl urlwithstring:[detailview objectforkey@""]]]];
