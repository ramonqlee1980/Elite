//
//  RMTableCellImageTwinTextType.m
//
//
//

#import "RMTableCellImageTwinTextType.h"

#define CLIENT_IMG_WIDTH 41
#define CLIENT_IMG_HEIGHT 41

@implementation RMTableCellImageTwinTextType

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
    [_subTitleLabel release];
    [_imageview release];
    [super dealloc];
}
@end
