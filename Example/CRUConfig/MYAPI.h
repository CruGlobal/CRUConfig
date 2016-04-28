//
//  MYAPI.h
//  CRUConfig
//
//  Created by Michael Harrison on 4/28/16.
//  Copyright © 2016 Harro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CRUConfig/CRUConfig.h>

@interface MYAPI : NSObject

@property (nonatomic, strong) NSURL *baseURL;

- (instancetype)initWithConfig:(CRUConfig *)config;

@end
