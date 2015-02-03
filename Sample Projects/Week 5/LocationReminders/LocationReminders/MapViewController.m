//
//  MapViewController.m
//  LocationReminders
//
//  Created by Bradley Johnson on 2/2/15.
//  Copyright (c) 2015 BPJ. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MapViewController () <CLLocationManagerDelegate, MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong,nonatomic) CLLocationManager *locationManager;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  self.locationManager = [[CLLocationManager alloc] init];
  self.locationManager.delegate = self;
  self.mapView.delegate = self;
//  [self setLocationManager:[[CLLocationManager alloc] init]];
  
  if ([CLLocationManager locationServicesEnabled]) {
    
    NSLog(@"current status is %d", [CLLocationManager authorizationStatus]);
    
    if ([CLLocationManager authorizationStatus] == 0) {
      [self.locationManager requestAlwaysAuthorization];

    } else {
      self.mapView.showsUserLocation = true;
      //[self.locationManager startUpdatingLocation];
      [self.locationManager startMonitoringSignificantLocationChanges];
    }
      } else {
    //warn the user that location services are not currently enabled
  }
  
  UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(mapLongPressed:)];
  
  [self.mapView addGestureRecognizer:longPress];

//  __weak MapViewController *weakSelf = self;
//  [UIView animateWithDuration:0.4 animations:^{
//    weakSelf.view.backgroundColor = [UIColor blueColor];
//  }];
  
//  [self doSomethingWithString:@"Brad" andCompletionHandler:^(NSString *title) {
//    
//  }];
  
  
//  NSInteger myInt = 32;
//  //int anotherInt = 31;
//  NSLog(@"The title of this view controller is %@ and my number is %li ",self.title, (long)myInt);
//  
 
}


-(void)mapLongPressed:(id)sender {
  
  UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
  NSLog(@"long press fired");
  if (longPress.state == 3 ) {
    NSLog(@"long press ended");
    CGPoint location = [longPress locationInView:self.mapView];
    NSLog(@"location y: %f location x: %f",location.y, location.x);
    CLLocationCoordinate2D coordinates = [self.mapView convertPoint:location toCoordinateFromView:self.mapView];
     NSLog(@"coordinate long: %f coordinate lat x: %f",coordinates.longitude, coordinates.latitude);
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = coordinates;
    annotation.title = @"New Location";
    [self.mapView addAnnotation:annotation];
  }
  
  
}
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
  
  NSLog(@" the new status is %d", status);
  
  
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
  CLLocation *location = locations.firstObject;
  NSLog(@"latitide: %f and longitude: %f",location.coordinate.latitude, location.coordinate.longitude);
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
  MKPinAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"AnnotationView"];
  annotationView.animatesDrop = true;
  annotationView.pinColor = MKPinAnnotationColorPurple;
  annotationView.canShowCallout = true;
  annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeContactAdd];

  return annotationView;
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
  MKPointAnnotation *annotation = view.annotation;
  
  [self performSegueWithIdentifier:@"SHOW_DETAIL" sender:self];
  
  NSLog(@"button tapped");
}


- (void)doSomethingWithString:(NSString *)string andCompletionHandler:(void (^)(NSString *))completionHandler {
  completionHandler(@"Brad");
}

- (IBAction)buttonPressed:(id)sender {
  
  
}

@end
