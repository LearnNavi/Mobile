//
//  Root.m
//  Learn Navi iPhone App
//
//  Created by Michael Gillogly on 1/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Root.h"

@interface Root(Private)
@end


@implementation Root


- (id) initWithParent:(UIView *)parent {
	self = [super initWithParent:parent];
	if(self == nil) { return nil; }
	
	self.userInteractionEnabled = YES;
	
	self.size = self.window.size;
	[[UIImageView viewWithParent:self] setImageWithName:@"HomeScreenBackground.png"];
	[[UIImageView viewWithParent:self] setImageWithName:@"DictionaryMainScreen.png"];
	[[UIImageView viewWithParent:self] setImageWithName:@"DictionaryMainScreen2.png"];
	self.pageIndex = 0;
	
	return self;
	
}

@synthesize pageIndex = _pageIndex;

- (void) setPageIndex:(int)index {
	if(index < 0 ) {return;}
	if(index >= [self.subviews count]){
		index -= 2;
	}
	
	if(_pageIndex == 1 && index == 0){
		[UIView beginAnimations:@"anim" context:NULL];
		[UIView setAnimationDuration:0.4];
	}
	
	_pageIndex = index;
	
	for(int i = 0; i < [self.subviews count]; i++) {
		UIImageView* page = [self.subviews objectAtIndex:i];
		page.x = (i < _pageIndex) ? -self.width : (i > _pageIndex) ?self.width : 0;
	}
	
	[UIView commitAnimations];	
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	
	BOOL wasTouchAtTop = ([[touches anyObject] locationInView:self].y < 70) && ([[touches anyObject] locationInView:self].x < 80);
	
	if (wasTouchAtTop) {
		self.pageIndex--;
	} else {
		self.pageIndex++;
	}
		
}

@end
