//
//  Person.m
//  LocationReminders
//
//  Created by Bradley Johnson on 2/2/15.
//  Copyright (c) 2015 BPJ. All rights reserved.
//

#import "Person.h"

@interface Person()

@property (strong,nonatomic) NSString *myName;

@end

@implementation Person

-(instancetype)initWithName:(NSString *)name {
  self = [super init];
  
  //also done like this
//  if (self = [super init]) {
//    
//  }
  //checking if self isnt nil
  if (self) {
    //both of these lines do the same thing
    self.myName = name;
    [self setMyName:name];
  }
  return self;
}




@end
