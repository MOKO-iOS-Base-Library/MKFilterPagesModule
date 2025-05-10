#import "MKMacroDefines.h"
#import "NSString+MKAdd.h"

typedef NS_ENUM(NSInteger, mk_filterByOther) {
    mk_filterByOther_A,                 //Filter by A condition.
    mk_filterByOther_AB,                //Filter by A & B condition.
    mk_filterByOther_AOrB,              //Filter by A | B condition.
    mk_filterByOther_ABC,               //Filter by A & B & C condition.
    mk_filterByOther_ABOrC,             //Filter by (A & B) | C condition.
    mk_filterByOther_AOrBOrC,           //Filter by A | B | C condition.
};

@interface MKFilterRawAdvDataModel : NSObject

@property (nonatomic, copy)NSString *dataType;

/// Data location to start filtering.
@property (nonatomic, assign)NSInteger minIndex;

/// Data location to end filtering.
@property (nonatomic, assign)NSInteger maxIndex;

/// The currently filtered content. If minIndex==0,maxIndex must be 0.The data length should be maxIndex-minIndex, if maxIndex=0&&minIndex==0, the item length is not checked whether it meets the requirements.MAX length:29 Bytes
@property (nonatomic, copy)NSString *rawData;

- (BOOL)validParams;

@end

@implementation MKFilterRawAdvDataModel

- (BOOL)validParams {
    if (!ValidStr(self.dataType)) {
        //新需求，DataType为空等同于00，
        self.dataType = @"00";
    }
    if ([self.dataType isEqualToString:@"00"]) {
        self.minIndex = 0;
        self.maxIndex = 0;
    }
    if (!ValidStr(self.dataType) || self.dataType.length != 2 || ![self.dataType regularExpressions:isHexadecimal]) {
        return NO;
    }
    if (self.minIndex == 0 && self.maxIndex == 0) {
        if (!ValidStr(self.rawData) || self.rawData.length > 58 || ![self.rawData regularExpressions:isHexadecimal] || (self.rawData.length % 2 != 0)) {
            return NO;
        }
        return YES;
    }
    if (self.minIndex < 0 || self.minIndex > 29 || self.maxIndex < 0 || self.maxIndex > 29) {
        return NO;
    }
    if (self.minIndex == 0 && self.maxIndex != 0) {
        return NO;
    }
    if (self.maxIndex < self.minIndex) {
        return NO;
    }
    if (!ValidStr(self.rawData) || self.rawData.length > 58 || ![self.rawData regularExpressions:isHexadecimal]) {
        return NO;
    }
    NSInteger totalLen = (self.maxIndex - self.minIndex + 1) * 2;
    if (totalLen > 58 || self.rawData.length != totalLen) {
        return NO;
    }
    return YES;
}

@end

@protocol MKFilterByOtherProtocol <NSObject>

@property (nonatomic, copy)NSString *pageTitle;

@property (nonatomic, assign)BOOL isOn;

/*
 0:A
 1:A & B
 2:A | B
 3:A & B & C
 4:(A & B) | C
 5:A | B | C
 */
@property (nonatomic, assign)NSInteger relationship;

@property (nonatomic, strong)NSArray *rawDataList;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

- (void)configWithRawDataList:(NSArray <MKFilterRawAdvDataModel *>*)list
                 relationship:(mk_filterByOther)relationship
                     sucBlock:(void (^)(void))sucBlock
                  failedBlock:(void (^)(NSError *error))failedBlock;

@end
