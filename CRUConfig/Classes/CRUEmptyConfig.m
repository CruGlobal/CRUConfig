//
//  CRUEmptyConfig.m
//  voke
//
//  Created by Michael Harrison on 2/8/16.
//  Copyright © 2016 Cru Global. All rights reserved.
//

#import "CRUEmptyConfig.h"
#import "CRUConfig+setter.h"
#import "NSString+CaseTransformations.h"
#import "NSObject+PropertyTypeMatching.h"

#define STR(x) #x
#define STRINGIFY(x) STR(x)
#define CURRENT_BUILD_CONFIGURATION_STRING @ STRINGIFY(CRUCONFIG_CURRENT_BUILD_CONFIGURATION)

@implementation CRUEmptyConfig

+ (instancetype)sharedConfig {
	
	static id _sharedConfig;
	static dispatch_once_t onceToken;
	
	dispatch_once(&onceToken, ^{
		
		_sharedConfig					= [[self alloc] init];
		
	});
	
	return _sharedConfig;
	
}

- (id)init {
	
	self = [super init];
	
	if (self) {
		
		_configurationName			= CURRENT_BUILD_CONFIGURATION_STRING.lowercaseString;
		NSString *configFileName	= [NSString stringWithFormat:@"config.%@", self.configurationName];
		
		//read config file
		NSString *configFilePath	= [[NSBundle mainBundle] pathForResource:configFileName ofType:@"plist"];
		
		if (!configFilePath) {
			configFilePath			= [[NSBundle mainBundle] pathForResource:@"config.default" ofType:@"plist"];
		}
		
		if (!configFilePath) {
			configFilePath			= [[NSBundle mainBundle] pathForResource:@"config" ofType:@"plist"];
		}
		
		NSDictionary *configDictionary	= [NSDictionary dictionaryWithContentsOfFile:configFilePath] ?: @{};
		
		[self setPropertiesWithContentsOfConfigDictionary:configDictionary];
		
	}
	
	return self;
}

- (void)setPropertiesWithContentsOfConfigDictionary:(NSDictionary *)configDictionary {
	
    [configDictionary enumerateKeysAndObjectsUsingBlock:^(NSString *  _Nonnull key, id  _Nonnull value, BOOL * _Nonnull stop) {
       
        NSString *propertyName = nil;
        
        if ([self respondsToSelector:NSSelectorFromString(key)]) {
            propertyName = key;
        } else if ([self respondsToSelector:NSSelectorFromString(key.snakeCaseToCamelCase)]) {
            propertyName = key.snakeCaseToCamelCase;
        }
        
        if (!propertyName) {
            return;
        }
        
        id convertedValue = [self convertValue:value toTypeOfPropertyWithName:propertyName];
        
        if (!convertedValue) {
            return;
        }
        
        [self setValue:convertedValue forKey:propertyName];
    }];
    
}

@end
