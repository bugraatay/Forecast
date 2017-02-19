//
//  Weather.h
//  Forecast
//
//  Created by Akbank1 on 19.02.2017.
//  Copyright © 2017 M. Buğra Atay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Weather : NSObject

@property(nonatomic, strong)NSString *code;
@property(nonatomic, strong)NSString *date;
@property(nonatomic, strong)NSString *day;
@property(nonatomic, strong)NSString *high;
@property(nonatomic, strong)NSString *low;
@property(nonatomic, strong)NSString *text;

@end
