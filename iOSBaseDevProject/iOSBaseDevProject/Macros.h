#pragma mark -
#pragma mark iOS Version

#define IOS_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define IOS_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define IOS_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define IOS_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#pragma mark -
#pragma mark UIColor

// example usage: UIColorFromHex(0x9daa76)
#define UIColorFromHexWithAlpha(hexValue,a) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:a]
#define UIColorFromHex(hexValue)            UIColorFromHexWithAlpha(hexValue,1.0)
#define UIColorFromRGBA(r,g,b,a)            [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define UIColorFromRGB(r,g,b)               UIColorFromRGBA(r,g,b,1.0)

#pragma mark -
#pragma mark Logging

#define LOG(fmt, ...) NSLog(@"%s: " fmt, __PRETTY_FUNCTION__, ## __VA_ARGS__)

#ifdef DEBUG
    #define INFO(fmt, ...) LOG(fmt, ## __VA_ARGS__)
#else
    // do nothing
    #define INFO(fmt, ...) 
#endif

#define ERROR(fmt, ...) LOG(fmt, ## __VA_ARGS__)
#define TRACE(fmt, ...) LOG(fmt, ## __VA_ARGS__)

#define METHOD_NOT_IMPLEMENTED() NSAssert(NO, @"You must override %@ in a subclass", NSStringFromSelector(_cmd))

#pragma mark -
#pragma mark NSNumber

#define NUM_INT(int) [NSNumber numberWithInt:int]
#define NUM_FLOAT(float) [NSNumber numberWithFloat:float]
#define NUM_BOOL(bool) [NSNumber numberWithBool:bool]

#pragma mark -
#pragma mark Frame Geometry

#define CENTER_VERTICALLY(parent,child) floor((parent.frame.size.height - child.frame.size.height) / 2)
#define CENTER_HORIZONTALLY(parent,child) floor((parent.frame.size.width - child.frame.size.width) / 2)

// example: [[UIView alloc] initWithFrame:(CGRect){CENTER_IN_PARENT(parentView,500,500),CGSizeMake(500,500)}];
#define CENTER_IN_PARENT(parent,childWidth,childHeight) CGPointMake(floor((parent.frame.size.width - childWidth) / 2),floor((parent.frame.size.height - childHeight) / 2))
#define CENTER_IN_PARENT_X(parent,childWidth) floor((parent.frame.size.width - childWidth) / 2)
#define CENTER_IN_PARENT_Y(parent,childHeight) floor((parent.frame.size.height - childHeight) / 2)

#define WIDTH(view) view.frame.size.width
#define HEIGHT(view) view.frame.size.height
#define X(view) view.frame.origin.x
#define Y(view) view.frame.origin.y
#define LEFT(view) view.frame.origin.x
#define TOP(view) view.frame.origin.y
#define BOTTOM(view) (view.frame.origin.y + view.frame.size.height) 
#define RIGHT(view) (view.frame.origin.x + view.frame.size.width) 

#pragma mark -
#pragma mark IndexPath

#define INDEX_PATH(a,b) [NSIndexPath indexPathWithIndexes:(NSUInteger[]){a,b} length:2]

#define ALWAYS_TRUE YES ||
#define NEVER_TRUE NO &&

#pragma mark -
#pragma mark Screen size

#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

#pragma mark -
#pragma mark Device type. 
// Corresponds to "Targeted device family" in project settings
// Universal apps will return true for whichever device they're on. 
// iPhone apps will return true for iPhone even if run on iPad.

#define TARGETED_DEVICE_IS_IPAD UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad
#define TARGETED_DEVICE_IS_IPHONE UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone
#define TARGETED_DEVICE_IS_IPHONE_568 TARGETED_DEVICE_IS_IPHONE && SCREEN_HEIGHT == 568

#pragma mark -
#pragma mark Transforms

#define DEGREES_TO_RADIANS(degrees) degrees * M_PI / 180

#define StartTag(tag) CFAbsoluteTime tag = CFAbsoluteTimeGetCurrent()
#define EndTag(tag) NSLog(@"Comsuming Time: %f Seconds", CFAbsoluteTimeGetCurrent() - tag)

#define WeakSelf(weakSelf)      __weak __typeof(&*self)    weakSelf  = self
#define StrongSelf(strongSelf)  __strong __typeof(&*self) strongSelf = weakSelf

#define BundleValue(value) [[NSBundle mainBundle] objectForInfoDictionaryKey:value];

#define RegularExpressionURL @"[a-zA-z]+://[^\\s]*"
#define SquareSize20 CGSizeMake(20, 20)

