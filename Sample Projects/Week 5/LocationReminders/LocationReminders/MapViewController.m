//
//  MapViewController.m
//  LocationReminders
//
//  Created by Bradley Johnson on 2/2/15.
//  Copyright (c) 2015 BPJ. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>

@interface MapViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  //self.mapView.rotateEnabled = false;
  //self.mapView.delegate = self;
    // Do any additional setup after loading the view.
}

@end
