//
//  RMTableCellImageTwinTextType.m
//
//
//

#import "RMTableCellImageTextType.h"

#define CLIENT_IMG_WIDTH 41
#define CLIENT_IMG_HEIGHT 41

@implementation RMTableCellImageTextType

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

    }
    return self;
}

-(void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
 
    [_titleLabel release];
    [_imageview release];
    [super dealloc];
}
@end