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
//    [self.tableView setContentInset:UIEdgeInsetsMake(20, 0, 0, 0)];
    self.refreshControl = [UIRefreshControl new];
    [self.refreshControl addTarget:self
                        action:@selector(refreshTable)
              forControlEvents:UIControlEventValueChanged];
    [self getDatas];
}
-(void)awakeFromNib{
    [super awakeFromNib];
    self.forecast = [NSMutableDictionary new];
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
            
//        case 5:
//           return [[self.forecast objectForKey:@"key"] count];
//            break;
            
        default:
            break;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    NSMutableDictionary *dic;
    // Configure the cell...
    if (indexPath.section == 1) {
        dic = self.wind;
    } else if(indexPath.section == 2){
        dic = self.atmosphere;
    } else if(indexPath.section == 3){
        dic = self.astronomy;
    } else if(indexPath.section == 5){
//        dic = self.forecast;
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [[dic allKeys] objectAtIndex: indexPath.row]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [[dic allValues] objectAtIndex: indexPath.row]];
    return cell;
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

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)getDatas{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURL *URL = [NSURL URLWithString:BASEURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDataTask *dataTask = [manager
                                      dataTaskWithRequest:request
                                      completionHandler:^(NSURLResponse *response, id responseObjects, NSError *error) {
                                          if (!error) {
                                              
                                              NSLog(@"%@", responseObjects);
                                              for (NSString* forecast in [[[[responseObjects objectForKey:@"query"] objectForKey:@"results"] objectForKey:@"channel"]objectForKey:@"wind"]) {
                                                  NSLog(@"forlu olan %@", forecast);
                                              }
                                              
                                              self.title = responseObjects[@"query"][@"results"][@"channel"][@"item"][@"title"];
                                              self.wind = [NSMutableDictionary dictionaryWithDictionary:responseObjects[@"query"][@"results"][@"channel"][@"wind"]];
                                              
                                              self.atmosphere =[NSMutableDictionary dictionaryWithDictionary:responseObjects[@"query"][@"results"][@"channel"][@"atmosphere"]];
                                              self.astronomy = [NSMutableDictionary dictionaryWithDictionary:responseObjects[@"query"][@"results"][@"channel"][@"astronomy"]];
                                              
                                              self.forecast = [NSMutableDictionary dictionaryWithObject: responseObjects[@"query"][@"results"][@"channel"][@"item"][@"forecast"]forKey:@"key"];
                                              NSLog(@"forecast %lu", [[self.forecast objectForKey:@"key"] count]);
                                              //                                              UIImageView* imgView = (UIImageView*)[cell viewwithtag:10];
                                              //                                              [imgView setImage: [[UIImage imageNamed:@"resimAdı"] imagewithcustomcolor]];
                                              //                                              [imgView imagewithdata: responseObjects[@"query"][@"results"][@"channel"][@"image"]];
                                              
                                              //                                              [imgView imagewithdata: [nsdata datawithcontentsofurl:[nsurl urlwithstring:[detailview objectforkey@""]]]];
                                              [self.tableView reloadData];
                                          } else
                                              NSLog(@"getContacts  metodunda bi hata var: %@", error);
                                      }
                                      ];
    [dataTask resume];

}
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
////    if (section == 0) {
////        return 80;
////    }
////    return 0;
//}
- (void)refreshTable {
    [self.refreshControl endRefreshing];
    [self.tableView reloadData];
}
@end
