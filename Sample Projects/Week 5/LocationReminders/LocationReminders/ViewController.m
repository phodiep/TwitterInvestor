//
//  ViewController.m
//  LocationReminders
//
//  Created by Bradley Johnson on 2/2/15.
//  Copyright (c) 2015 BPJ. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"


@interface ViewController ()


@end

@implementation ViewController

//we are only doing this because we have custom setter and getter for this property
@synthesize name = _name;

- (void)viewDidLoad {
  [super viewDidLoad];
  
  //using dot notation to use the setter
  self.name = @"Brad";
  //using the getter because we are on the right hand side of the equals sign
  //NSString *myName = self.name;
  //using the setter
  [self setName:@"Brad"];
  
  //[NSString stringWithString:self.name];
  

  
  Person *person = [[Person alloc] initWithName:@"Brad"];
  
  //new is equal plain alloc init
  Person *anotherPerson = [Person new];
  
  //shorthand for collection types
  NSArray *people = @[person,anotherPerson,self];
  
  NSDictionary *peopleInfo = @{@"Brad" : person, @"Russell" : anotherPerson};
  
  NSArray *myArray = [[NSArray alloc] initWithObjects:person,anotherPerson,nil];
  

  UIColor *blueColor = [UIColor blueColor];
  
  //ivar
  _name = @"Brad";
  
  //setter
  [self setName:@"Brad"];
  
  //getter
  [self name];
  
  //getter for the view
  [self view];
  
  
  [self setupColorForView:self.view forViewController:self withColor:blueColor];
  
  // Do any additional setup after loading the view, typically from a nib.
}

- (void) setName:(NSString *)name {
  
}

//- (void)setName:(NSString *)name {
//  _name = name;
//}

-(NSString *)name {
  return _name;
}

- (void)setupColorForView:(UIView*)setupView forViewController:(UIViewController *)vc withColor:(UIColor *)color {
 
}

@end
