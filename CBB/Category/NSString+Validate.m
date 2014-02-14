//

#import "NSString+Validate.h"
//extern NSString *CTSettingCopyMyPhoneNumber();

@implementation NSString (Validate)
//+(NSString *)myPhoneNumber
//{
//    return CTSettingCopyMyPhoneNumber();
//}

-(BOOL)isEmailAddress
{
    if ([self isEqualToString:@""]) {
        [self showAlert:@"邮箱地址不能为空！"];
        return NO;
    }
    NSString *emailCheck = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailCheck];
    BOOL result = [emailTest evaluateWithObject:self];
    if (!result) {
        [self showAlert:@"这不是一个正常的Email！"];
    }    
    return result;
}

-(BOOL)isMobileNumber
{
    if ([self isEqualToString:@""]) {
        [self showAlert:@"手机号码不能为空！"];
        return NO;
    }
    NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,5-9]))\\d{8}$";    
    NSPredicate *mobileTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL result = [mobileTest evaluateWithObject:self];
    if (!result) {
        [self showAlert:@"这不是一个正常的手机号码！"];
    }
    return result;
}

-(BOOL)isAreaNumber
{
    if ([self isEqualToString:@""]) {
        [self showAlert:@"区号不能为空！"];
        return NO;
    }
    NSString *regex = @"^0\\d{2,3}|85[23]$";
    NSPredicate *areaTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL result = [areaTest evaluateWithObject:self];
    if (!result) {
        [self showAlert:@"这不是一个正常的区号！"];
    }
    return result;
}

-(BOOL)isTelNumber
{
    if ([self isEqualToString:@""]) {
        [self showAlert:@"电话号码不能为空！"];
        return NO;
    }
    NSString *regex = @"^[1-9]\\d{6,7}$";
    NSPredicate *telTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL result = [telTest evaluateWithObject:self];
    if (!result) {
        [self showAlert:@"这不是一个正常的电话号码！"];
    }
    return result;
}

-(BOOL)isBranchNumber
{
    NSString *regex = @"\\d{0,6}";
    NSPredicate *branchTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL result = [branchTest evaluateWithObject:self];
    if (!result) {
        [self showAlert:@"分机号超长！"];
    }
    return result;
}

-(BOOL)isPhoneNumber
{
    if ([self isEqualToString:@""]) {
        [self showAlert:@"联系电话不能为空！"];
        return NO;
    }
    NSArray *arr = [self componentsSeparatedByString:@"-"];
    if (arr.count<2 || arr.count>3) {
        [self showAlert:@"联系电话输入有误！"];
        return NO;
    }
    else {
        if (![[arr objectAtIndex:0] isAreaNumber]) {
            return NO;
        }
        else if (![[arr objectAtIndex:1] isTelNumber]) {
            return NO;
        }
        else if (arr.count == 3) {
            if (![[arr objectAtIndex:2] isBranchNumber]) {
                return NO;
            }
        }
    }
    return YES;
}

-(BOOL)isQQNumber
{
    NSString *regex = @"^[1-9][0-9]{3,11}$";
    NSPredicate *branchTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL result = [branchTest evaluateWithObject:self];
    if (!result) {
        [self showAlert:@"QQ号不合法！"];
    }
    return result;
}

-(NSString *)getIDfromDic:(NSDictionary *)aDic WithTypeName:(NSString *)name
{
    if ([self isEqualToString:@""]) {
        [self showAlert:[NSString stringWithFormat:@"%@不能为空！",name]];
        return nil;
    }
    NSString *key = [aDic objectForKey:self];
    if (key) {
        return key;
    }
    else
    {
        [self showAlert:[NSString stringWithFormat:@"该%@不在列表中！",name]];
        return nil;
    }    
}

-(NSArray *)getStateAndCityID:(NSDictionary *)cityDic
{
    if ([self isEqualToString:@""]) {
        [self showAlert:@"省市不能为空！"];
        return nil;
    }
    NSArray *arr = [self componentsSeparatedByString:@" - "];
    if (arr.count != 2) {
        [self showAlert:@"请按“省 - 市”格式输入！"];
        return nil;
    }
    
    NSArray *sheng = [cityDic objectForKey:[arr objectAtIndex:0]];
    if (!sheng) {
        [self showAlert:@"没有该省！"];
        return nil;
    }
    NSString *shengID = [sheng objectAtIndex:0];    
    NSDictionary *dic = [sheng objectAtIndex:1];
    NSString *cityID = [dic objectForKey:[arr objectAtIndex:1]];
    if (!cityID) {
        [self showAlert:@"没有该市！"];
        return nil;
    }
    return [NSArray arrayWithObjects:shengID, cityID, nil];
}

-(NSString *)getCityID:(NSDictionary *)cityDic
{
    if ([self isEqualToString:@""]) {
        [self showAlert:@"省市不能为空！"];
        return nil;
    }
    NSString *cityID;
    NSArray *arr = [self componentsSeparatedByString:@" - "];
    
    if (arr.count == 1) {
        for (NSString *key in [cityDic allKeys]) {
            NSDictionary *citys = [[cityDic objectForKey:key] objectAtIndex:1];
            for (NSString *cityName in [citys allKeys]) {
                if ([[cityName substringToIndex:self.length] isEqualToString:self]) {
                    cityID = [citys objectForKey:cityName];
                    return cityID;
                }
            }
        }
    }
    else if (arr.count == 2) {
        NSArray *sheng = [cityDic objectForKey:[arr objectAtIndex:0]];
        if (!sheng) {
            [self showAlert:@"没有该省！"];
            return nil;
        }
        NSDictionary *dic = [sheng objectAtIndex:1];
        cityID = [dic objectForKey:[arr objectAtIndex:1]];
        if (!cityID) {
            [self showAlert:@"没有该市！"];
            return nil;
        }
    }
    else {
        [self showAlert:@"请按“省 - 市”格式输入！"];
        return nil;
    }
    if (!cityID) {
        [self showAlert:@"没有该城市！"];
    }
    return cityID;
}

-(void)showAlert:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"重新输入"
                                          otherButtonTitles: nil];
    [alert show];
}
@end
