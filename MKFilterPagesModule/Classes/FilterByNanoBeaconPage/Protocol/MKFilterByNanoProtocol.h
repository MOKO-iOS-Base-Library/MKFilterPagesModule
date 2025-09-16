
@protocol MKFilterByNanoProtocol <NSObject>

@property (nonatomic, copy)NSString *pageTitle;

@property (nonatomic, assign)BOOL isOn;

/// 0: All  1:Normal Adv Type   2:Trigger Adv Type
@property (nonatomic, assign)NSInteger advType;

/// 0: All  1:No Alarm   2:Cut-off Alarm    3:Button Alarm  4:Button Alarm and Cut-off Alarm
@property (nonatomic, assign)NSInteger triggerStatus;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

- (void)configDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@end
