//
//  PhotoGallery.h
//  RevealControllerProject
//
//  Created by Ted Hooban on 3/6/15.
//
//

#import <UIKit/UIKit.h>
#import "UPCardsCarousel.h"

@interface PhotoGallery : UIViewController <UPCardsCarouselDataSource, UPCardsCarouselDelegate, UIScrollViewDelegate>


@property (nonatomic,strong) NSMutableArray *photoArray;
@property (nonatomic,strong) UIImageView *favoriteIcon;

@end
