//
//  AllTable.m
//  SchlumbergerApp
//
//  Created by DeviceBee on 11/26/14.
//  Copyright (c) 2014 devicebee. All rights reserved.
//

#import "AllTable.h"

@implementation AllTable
- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:self.GMaverageCaptured forKey:@"GMaverageCaptured"];
    [aCoder encodeObject:self.GMaverageExpected forKey:@"GMaverageExpected"];
    [aCoder encodeObject:self.geoMarket forKey:@"geoMarket"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.GMInitiatives] forKey:@"GMInitiatives"];
    
    [aCoder encodeObject:self.FuncAverageCaptured forKey:@"FuncAverageCaptured"];
    [aCoder encodeObject:self.FuncAaverageExpected forKey:@"FuncAaverageExpected"];
    [aCoder encodeObject:self.function forKey:@"function"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.FuncInitiatives] forKey:@"FuncInitiatives"];
    
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super init]){
        
        self.GMaverageCaptured = [aDecoder decodeObjectForKey:@"GMaverageCaptured"];
        self.GMaverageExpected = [aDecoder decodeObjectForKey:@"GMaverageExpected"];
        self.geoMarket = [aDecoder decodeObjectForKey:@"geoMarket"];
        self.GMInitiatives = [[aDecoder decodeObjectForKey:@"GMInitiatives"]integerValue];
        
        self.FuncAverageCaptured = [aDecoder decodeObjectForKey:@"FuncAverageCaptured"];
        self.FuncAaverageExpected = [aDecoder decodeObjectForKey:@"FuncAaverageExpected"];
        self.function = [aDecoder decodeObjectForKey:@"function"];
        self.FuncInitiatives = [[aDecoder decodeObjectForKey:@"FuncInitiatives"]integerValue];
    }
    return self;
}

@end
