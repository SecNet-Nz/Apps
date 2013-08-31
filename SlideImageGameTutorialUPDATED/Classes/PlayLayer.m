//
//  PlayLayer.m
//  PlayLayer
//
//  Created by MajorTom on 9/7/10.
//  Copyright iphonegametutorials.com 2010. All rights reserved.
//

#import "PlayLayer.h"

@implementation PlayLayer

-(id) init{
	self = [super init];
	
	value = (arc4random() % kKindCount+1);
	box = [[Box alloc] initWithSize:CGSizeMake(kBoxWidth,kBoxHeight) imgValue:value];
	box.layer = self;
	box.lock = YES;	
	
	[box check];
	
	self.isTouchEnabled = YES;

	return self;
}


- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch* touch = [touches anyObject];
	CGPoint location = [touch locationInView: touch.view];
	location = [[CCDirector sharedDirector] convertToGL: location];
	
	if (location.y < (kStartY) || location.y > (kStartY + (kTileSize * kBoxHeight))) {
		return;
	}
	
	int x = (location.x - kStartX) / (kTileSize);
	int y = (location.y - kStartY) / (kTileSize);
	
	if (selectedTile && selectedTile.x == x && selectedTile.y == y) {
		selectedTile = nil;
		return;
	}
	
	Tile *tile = [box objectAtX:x Y:y];
	if (tile.x >= 0 && tile.y >= 0) {
		if (selectedTile && [selectedTile nearTile:tile]) {
			[box setLock:YES];
			[self changeWithTileA: selectedTile TileB: tile sel: @selector(check:data:)];
			selectedTile = nil;
		}
		else {
			if (selectedTile) {
				if (selectedTile.x == x && selectedTile.y == y) {
					selectedTile = nil;
				}
			}
			selectedTile = tile;
		}
	}
}

-(void) changeWithTileA: (Tile *) a TileB: (Tile *) b sel : (SEL) sel{
	CCAction *actionA = [CCSequence actions:
						 [CCMoveTo actionWithDuration:kMoveTileTime position:[b pixPosition]],
						 [CCCallFuncND actionWithTarget:self selector:sel data: a],
						 nil
						 ];
	
	CCAction *actionB = [CCSequence actions:
						 [CCMoveTo actionWithDuration:kMoveTileTime position:[a pixPosition]],
						 [CCCallFuncND actionWithTarget:self selector:sel data: b],
						 nil
						 ];
	[a.sprite runAction:actionA];
	[b.sprite runAction:actionB];
	
	[a trade:b];
}

-(void) check: (id) sender data: (id) data{

}


@end
