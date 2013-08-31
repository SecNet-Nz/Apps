//
//  Box.m
//  Box
//
//  Created by MajorTom on 9/7/10.
//  Copyright iphonegametutorials.com 2010. All rights reserved.
//

#import "Box.h"

@implementation Box
@synthesize layer;
@synthesize size;
@synthesize lock;

-(id) initWithSize: (CGSize) aSize imgValue: (int) aImgValue{
	self = [super init];
	imgValue = aImgValue;
	size = aSize;
	OutBorderTile = [[Tile alloc] initWithX:-1 Y:-1];
	content = [NSMutableArray arrayWithCapacity: size.height];
	
	readyToRemoveTiles = [NSMutableSet setWithCapacity:50];
	
	for (int y=0; y<size.height; y++) {
		
		NSMutableArray *rowContent = [NSMutableArray arrayWithCapacity:size.width];
		for (int x=0; x < size.width; x++) {
			Tile *tile = [[Tile alloc] initWithX:x Y:y];
			[rowContent addObject:tile];
			[readyToRemoveTiles addObject:tile];
			[tile release];
		}
		[content addObject:rowContent];
		[content retain];
	}
	
	[readyToRemoveTiles retain];
	
	return self;
}

-(Tile *) objectAtX: (int) x Y: (int) y{
	if (x < 0 || x >= kBoxWidth || y < 0 || y >= kBoxHeight) {
		return OutBorderTile;
	}
	return [[content objectAtIndex: y] objectAtIndex: x];
}

-(BOOL) check{
	
	NSArray *objects = [[readyToRemoveTiles objectEnumerator] allObjects];
	if ([objects count] == 0) {
		return NO;
	}
	
	int countTile = [objects count];
	for (int i=0; i<countTile; i++) {

		Tile *tile = [objects objectAtIndex:i];
		tile.value = 0;
		if (tile.sprite) {
			[layer removeChild: tile.sprite cleanup:YES];
		}
	}

	[readyToRemoveTiles removeAllObjects];

	NSString *name = [NSString stringWithFormat:@"%d.png",imgValue];	
	CCTexture2D * texture = [[CCTextureCache sharedTextureCache] addImage:name];
	NSMutableArray *imgFrames = [NSMutableArray array];
	[imgFrames removeAllObjects];
	
	for (int i = 0; i < 7; i++) {
		for (int j = 6; j >= 0; j--) {
			CCSpriteFrame *imgFrame = [CCSpriteFrame frameWithTexture:texture rect:CGRectMake(i*40, j*40, 40, 40) offset:CGPointZero];
			[imgFrames addObject:imgFrame];
		}
	}
	
	/*
	NSUInteger count = [imgFrames count];
    for (NSUInteger i = 0; i < count; ++i) {
        // Select a random element between i and end of array to swap with.
        int nElements = count - i;
        int n = (arc4random() % nElements) + i;
        [imgFrames exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
	*/
	
	for (int x=0; x<size.width; x++) {
		int extension = 0;
		for (int y=0; y<size.height; y++) {
			Tile *tile = [self objectAtX:x Y:y];
			if(tile.value == 0){
				extension++;
			}else if (extension == 0) {
				
			}
		}
				
		for (int i=0; i<extension; i++) {
			Tile *destTile = [self objectAtX:x Y:kBoxHeight-extension+i];
			CCSpriteFrame * img = [imgFrames objectAtIndex:0];
			CCSprite *sprite = [CCSprite spriteWithSpriteFrame:img];
			[imgFrames removeObjectIdenticalTo:img];
			sprite.position = ccp(kStartX + x * kTileSize + kTileSize/2, kStartY + (kBoxHeight + i) * kTileSize + kTileSize/2 - kTileSize * extension);
			[layer addChild: sprite];

			destTile.value = imgValue;
			destTile.sprite = sprite;
		}
	}
	
	return YES;
}


@end
