//
//  PhotoGallery.m
//  RevealControllerProject
//
//  Created by Ted Hooban on 3/6/15.
//
//

#import "PhotoGallery.h"
#import "JT3DScrollView.h"
#import "GalleryView.h"


@interface PhotoGallery () {
    
    NSMutableArray *pictureData;
    
}

@property (nonatomic,strong) JT3DScrollView *scrollView;

@end



@implementation PhotoGallery

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.userInteractionEnabled = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    _scrollView = [[JT3DScrollView alloc]initWithFrame:CGRectMake(40, 60, self.view.frame.size.width - 40, self.view.frame.size.height -80)];
    
    self.scrollView.effect = JT3DScrollViewEffectTranslation;
    self.scrollView.delegate = self;
    

    UIImageView *background = [[UIImageView alloc]initWithFrame:CGRectMake(0, -30, self.view.frame.size.width, self.view.frame.size.height)];
    [background setImage:[UIImage imageNamed:@"white-blue-bg-1136x640"]];
    background.alpha = 0.5;
    
    [self.view addSubview:background];
    [self.view addSubview:_scrollView];
    
    _photoArray = [[NSMutableArray alloc]init];
    
    NSString *pListData = [[NSBundle mainBundle]
                           pathForResource:@"Picture-Data"
                           ofType:@"plist"];
    
    pictureData = [[NSMutableArray alloc] initWithContentsOfFile:pListData];
    
    for (NSString *imageName in pictureData) {
        
        CGFloat width = CGRectGetWidth(self.scrollView.frame);
        CGFloat height = CGRectGetHeight(self.scrollView.frame);
        CGFloat x = self.scrollView.subviews.count * width;
        
        NSString *captionString = @"Just loving it";
        
        GalleryView *cardTopic = [[GalleryView alloc]initWithFrame:CGRectMake(x, 0, width, height)
                                                           andData:imageName
                                                        andCaption:captionString];
        
        self.scrollView.contentSize = CGSizeMake(x+width,height);
        [self.scrollView addSubview:cardTopic];
        
        /*NSString *photoFileName = [NSString stringWithFormat:@"photo%i.JPG",i];
        UIImageView *photoFrame = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 280, 280)];
        [photoFrame setImage:[UIImage imageNamed:photoFileName]];
        [_photoArray addObject:photoFrame];*/
        
        
        
    }

    
    
    /*UPCardsCarousel *carousel = [[UPCardsCarousel alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height-20)];
    [carousel setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
    [carousel.labelBanner setBackgroundColor:[UIColor colorWithRed:112./255. green:47./255. blue:168./255. alpha:1.]];
    [carousel setLabelFont:[UIFont boldSystemFontOfSize:17.0f]];
    [carousel setLabelTextColor:[UIColor whiteColor]];
    [carousel setDelegate:self];
    [carousel setDataSource:self];
    [self.view addSubview:carousel];*/
    

    
}

- (NSUInteger)numberOfCardsInCarousel:(UPCardsCarousel *)carousel
{
    NSUInteger thecount = [_photoArray count];
    NSLog(@"returning count: %lu",thecount);
    return thecount;
}

- (UIView*)carousel:(UPCardsCarousel *)carousel viewForCardAtIndex:(NSUInteger)index
{
    //NSString *label = [NSString stringWithFormat:@"%i", (int)index];
    //return [self createCardViewWithLabel:label];
    return [self createCardViewWithImage:[_photoArray objectAtIndex:index]];
    
    //return [_photoArray objectAtIndex:index];
}

- (NSString*)carousel:(UPCardsCarousel *)carousel labelForCardAtIndex:(NSUInteger)index
{
    return [NSString stringWithFormat:@"Crash is not happy about being crammed in the back seat", (int)index];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)carousel:(UPCardsCarousel *)carousel didTouchCardAtIndex:(NSUInteger)index
{
    NSString *message = [NSString stringWithFormat:@"Card %i touched", (int)index];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:message
                                                    message:nil
                                                   delegate:nil
                                          cancelButtonTitle:@"Ok"
                                          otherButtonTitles:nil];
    [alert show];
}

- (UIView*)createCardViewWithLabel:(NSString*)label
{
    UIView *cardView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 440, 440)];
    [cardView setBackgroundColor:[UIColor colorWithRed:180./255. green:180./255. blue:180./255. alpha:1.]];
    [cardView.layer setShadowColor:[UIColor blackColor].CGColor];
    [cardView.layer setShadowOpacity:.5];
    [cardView.layer setShadowOffset:CGSizeMake(0, 0)];
    [cardView.layer setBorderColor:[UIColor whiteColor].CGColor];
    [cardView.layer setBorderWidth:10.];
    [cardView.layer setCornerRadius:4.];
    
    
    UILabel *labelView = [[UILabel alloc] initWithFrame:CGRectInset(cardView.frame, 20, 40)];
    [labelView setCenter:CGPointMake(cardView.frame.size.width/2, cardView.frame.size.height/2)];
    [labelView setFont:[UIFont fontWithName:@"Lato-Regular" size:16 ]];
    [labelView setTextAlignment:NSTextAlignmentCenter];
    [labelView setTextColor:[UIColor grayColor]];
    [labelView setText:@"Chillin' in the trunk of the VW"];
    [cardView addSubview:labelView];
    
    return cardView;
}

- (UIView*)createCardViewWithImage:(UIImageView*)image
{
    UIView *cardView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 290, 290)];
    [cardView setBackgroundColor:[UIColor colorWithRed:180./255. green:180./255. blue:180./255. alpha:1.]];
    [cardView.layer setShadowColor:[UIColor blackColor].CGColor];
    [cardView.layer setShadowOpacity:.5];
    [cardView.layer setShadowOffset:CGSizeMake(0, 0)];
    [cardView.layer setBorderColor:[UIColor whiteColor].CGColor];
    [cardView.layer setBorderWidth:10.];
    [cardView.layer setCornerRadius:4.];

    [cardView addSubview:image];
    
    return cardView;
}




- (void)loadNextPage:(id)sender
{
    
    
}


- (void)loadPageIndex:(NSUInteger)index animated:(BOOL)animated
{
    
}

@end
