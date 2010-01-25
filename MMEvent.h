//
//  MMEvent.h
//
//  Copyright 2008, 2009 Medialets, Inc.. All rights reserved.
//
//  This is just a storage thing to stuff a bunch of data into to create an MMTrackedEvent object.
//  This is exposed to the application developer, where MMTrackedEvent is private.
//  This class is also used to collect data from the JavaScript bridge (MMJSBridge).
//  

#import <Foundation/Foundation.h>


@interface MMEvent : NSObject {
	NSString *_eventKey;
	NSMutableDictionary *_strings;
	NSMutableDictionary *_numbers;
	NSMutableDictionary *_durations;
	NSMutableDictionary *_timers;
	NSMutableArray *_breadcrumbs;  // NSDictionary objects with these keys: "URL" (an NSURL) & "Timestamp" (an NSDate)
    NSDate *_adViewStartTime;  // Will get reset to [NSDate date] each time the ad becomes visible. See -startRecordingViewDuration.
}

@property (nonatomic, copy) NSString *eventKey;
@property (nonatomic, retain) NSMutableDictionary *strings;
@property (nonatomic, retain) NSMutableDictionary *numbers;
@property (nonatomic, retain) NSMutableDictionary *durations;
@property (nonatomic, retain) NSMutableDictionary *timers;
@property (nonatomic, retain) NSMutableArray *breadcrumbs;
@property (nonatomic, retain) NSDate *adViewStartTime;

	// Setup & Teardown
- (id)initWithKey:(NSString *)eventKey;

	// Strings
- (void)setString:(NSString *)string forKey:(NSString *)key;
- (void)addStringsFromDictionary:(NSDictionary *)dictionary;

	// Numbers
- (void)setNumber:(NSNumber *)number forKey:(NSString *)key;
- (void)addNumbersFromDictionary:(NSDictionary *)dictionary;
- (void)incrementNumberForKey:(NSString *)key;

	// Durations
- (void)setDuration:(NSTimeInterval)duration forKey:(NSString *)key;
- (void)addDurationsFromDictionary:(NSDictionary *)dictionary;
- (void)startTimerForKey:(NSString *)key;
- (void)endTimerForKey:(NSString *)key;

	// Breadcrumbs
- (void)startRecordingViewDuration;
- (void)stopRecordingViewDuration;
- (void)trackURLEvent:(NSString *)urlString;


@end
