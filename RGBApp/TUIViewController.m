//
//  TUIViewController.m
//  RGBApp
//
//  Created by Diego Lafuente Garcia on 08/05/14.
//  Copyright (c) 2014 Diego Lafuente Garcia. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "TUIViewController.h"

static const NSInteger MAX_RSSI = -60;
static const NSInteger MIN_RSSI = -80;


@interface TUIViewController () <CLLocationManagerDelegate>

// Beacons
@property (strong, nonatomic) CLBeaconRegion *beaconRegion;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation TUIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    // Do any additional setup after loading the view.
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    [self initRegion];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Beacons -

- (void)initRegion
{
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"54fbdbd7-621f-4153-9466-47c86ecf886b"];
    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:@"com.tuitravel-ad.kontakt"];
    [self.locationManager startMonitoringForRegion:self.beaconRegion];
}


#pragma mark - CLLocationManagerDelegate methods -

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    [_locationManager startRangingBeaconsInRegion:_beaconRegion];
    NSLog(@"Entered region");
}

-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    [_locationManager stopRangingBeaconsInRegion:_beaconRegion];
    NSLog(@"Exited region");
}

-(void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    CGFloat red = 0.0;
    CGFloat green = 0.0;
    CGFloat blue = 0.0;
    CGFloat opacity = 1.0;
    
    for (CLBeacon *beacon in beacons)
    {
        if ([beacon.minor intValue] == 1)
        {
            NSLog(@"detected red beacon");
            red = [self intensityForRSSI:beacon.rssi];
        }
        else if ([beacon.minor intValue] == 2)
        {
            NSLog(@"detected green beacon");
            green = [self intensityForRSSI:beacon.rssi];
        }
        else if ([beacon.minor intValue] == 3)
        {
            NSLog(@"detected blue beacon");
            blue = [self intensityForRSSI:beacon.rssi];
        }
    }
    
    self.view.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:opacity];
}

- (CGFloat)intensityForRSSI:(NSInteger)rssi
{
    rssi = rssi > MAX_RSSI ? MAX_RSSI : rssi;
    rssi = rssi < MIN_RSSI ? MIN_RSSI : rssi;
    
    return 0.05*rssi + 4.0;
}

@end
