//

#import <CommonCrypto/CommonDigest.h>
#import "HTTP_Request.h"
#import "ASIHTTPRequest.h"
#import "BaseParser.h"
#import "SVProgressHUD.h"

@implementation HTTP_Request
@synthesize apiName;
@synthesize apiType;
@synthesize delegate;
@synthesize connectEnd;
@synthesize connectFailded;
@synthesize queue;
@synthesize response;

-(id)init
{
    if (self = [super init]) {
        CBB = STATE ? @"cbb!@#$%^&*()123456789" : @"cbbtest";
        KEY = STATE ? @"cbbclient" : @"cbbtest";
        
        ASINetworkQueue *aQueue=[[ASINetworkQueue alloc] init];
        aQueue.showAccurateProgress = YES;
		aQueue.delegate=self;
        aQueue.uploadProgressDelegate = self;
		aQueue.requestDidFinishSelector=@selector(requestDidFinish:);
		aQueue.requestDidFailSelector=@selector(requestDidFail:);
        aQueue.queueDidFinishSelector=@selector(allRequestDone:);
		self.queue = aQueue;
        self.response = [NSMutableDictionary dictionary];
    }
    return self;
}


//MD5加密算法
-(NSString *)md5:(NSString *)str {
    const char *cStr = [str UTF8String];
    unsigned char result[32];
    CC_MD5( cStr, strlen(cStr), result );
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

//附加MD5参数
- (NSString *) getMD5String {
	NSString *date = [self getBeijingDate];
    //    md5(cbb+key+t+cbb)
	NSString *md5src = [NSString stringWithFormat:@"%@%@%@%@",CBB,KEY,date,CBB];
	NSString *md5Result = [self md5:md5src];
	NSString *result = [NSString stringWithFormat:@"&md=%@&t=%@", md5Result, date];
	return result;
}

-(NSString *)getBeijingDate{
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-M-d HH:mm:ss"];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSDate* sourceDate = [NSDate date];
    NSDate* destinationDate = [[NSDate alloc] initWithTimeInterval:28800 sinceDate:sourceDate];
    NSString *date = [formatter stringFromDate:destinationDate];
    return date;
}

//密码参数加密
- (NSString *)passwordEncode:(NSString *)password
{
    //明码加密
    NSString *rsPWD = [self md5:password];
    //mdp=md5(cbb&rs("password")&key)
    NSString *md5src = [NSString stringWithFormat:@"%@%@%@",CBB,rsPWD,KEY];
    return [self md5:md5src];
}


-(void)httpRequestWithAPI:(NSString *)api TypeID:(NSInteger)typeID Dictionary:(NSDictionary *)aDic
{
    NSString *prefixURL = STATE ? @"http://www.cardbaobao.com/cbbjk/":@"http://test.cardbaobao.com/cbbjk/";
    [self httpRequestWithURL:prefixURL API:api TypeID:typeID Dictionary:aDic];
}
-(void)httpRequestWithURL:(NSString *)aUrl API:(NSString *)api TypeID:(NSInteger)typeID Dictionary:(NSDictionary *)aDic
{
    [self.queue cancelAllOperations];
    //配置URL参数
    //选择基本URL
    self.apiName = api;
    self.apiType = [NSString stringWithFormat:@"%d",typeID];
    
    url = [NSMutableString stringWithFormat:@"%@",aUrl];
    [url appendFormat:@"%@.asp",api];
    [url appendFormat:@"?key=%@",KEY];
    if (typeID) {
        [url appendFormat:@"&typeid=%d",typeID];
    }    
    [url appendString:[self getMD5String]];
    
    //从字典读取附加参数
    for (NSString *k in [aDic allKeys]) {
        NSString *value = [aDic objectForKey:k];
        if ([k isEqualToString:@"password"]) {
            value = [self passwordEncode:value];
        }
        else if ([k isEqualToString:@"newpassword"]) {
            value = [self md5:value];
        }
        [url appendFormat:@"&%@=%@",k,value];
    }
    
    //发送请求
    NSString *encodeURL = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"请求URL———— %@",encodeURL);
    ASIHTTPRequest * req = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:encodeURL]];
    [self.queue addOperation:req];
    [self.queue go];
}

#pragma mark -
-(ASIHTTPRequest *)postRequestWithAPI:(NSString *)api file:(NSString *)fileName Data:(NSData *)data
{
    //请求发送到的路径
    url = [NSMutableString stringWithFormat:@"%@%@.asmx", api, fileName];
    NSString *encodeURL = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    ASIHTTPRequest * req = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:encodeURL]];
    [req setRequestMethod:@"POST"];
    [req appendPostData:data];
    [req setDefaultResponseEncoding:NSUTF8StringEncoding];
    return req;
}

-(void)postSOAPwithAPI:(NSString *)api File:(NSString *)file Method:(NSString *)method xmlNS:(NSString *)xmlns Params:(NSArray *)params
{
    self.apiName = file;
    self.apiType = method;
    //1、初始化SOAP消息体
    
    NSString * soapMsgBody1 = [[NSString alloc] initWithFormat:
                               @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                               "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" \n"
                               "xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" \n"
                               "xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                               "<soap:Body>\n"
                               "<%@ xmlns=\"%@\">\n", method, xmlns];
    NSString * soapMsgBody2 = [[NSString alloc] initWithFormat:
                               @"</%@>\n"
                               "</soap:Body>\n"
                               "</soap:Envelope>", method];
    
    //2、生成SOAP调用参数
    NSString * soapParas = @"";
    if (params) {
        for (int i = 0; i < params.count/2; i++) {
            NSString *paraKey = [params objectAtIndex:i*2+1];
            NSString *content = [params objectAtIndex:i*2];
            if ([paraKey isEqualToString:@"password"]) {
                content = [self md5:content];
            }
            soapParas = [soapParas stringByAppendingFormat:@"<%@>%@</%@>",paraKey,content,paraKey];
        }
    }
    
    //3、生成SOAP消息
    NSString * soapMsg = [soapMsgBody1 stringByAppendingFormat:@"%@%@", soapParas, soapMsgBody2];
    
    //请求发送到的路径
    ASIHTTPRequest * req = [self postRequestWithAPI:api file:file Data:[soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMsg length]];
    
    //以下对请求信息添加属性前四句是必有的，第五句是soap信息。
    [req addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];
    [req addRequestHeader:@"SOAPAction" value:[NSString stringWithFormat:@"%@%@", xmlns, method]];
    [req addRequestHeader:@"Content-Length" value:msgLength];
    [self.queue addOperation:req];
    [self.queue go];
}

#pragma mark -
// 单个网络请求完成
-(void)requestDidFinish:(ASIHTTPRequest *)aRequest
{
    if ([SVProgressHUD isVisible]) {
        [SVProgressHUD dismiss];
    }
    //解析
    NSString *parserName = [NSString stringWithFormat:@"PARSE%@%@",self.apiName,self.apiType];
    if ([parserName isEqualToString:@"PARSEcarduserlogin1"] || [parserName isEqualToString:@"PARSEloansuserlogin1"]) {
        parserName = @"PARSEuserlogin";
    }
//    NSLog(@"%@",parserName);
    // 动态创建类
    Class _parserClass = NSClassFromString(parserName);
    BaseParser *parser = [[_parserClass alloc] initWithStr:aRequest.responseString];
    
    id obj = [parser superParser];
    
    //响应数据存字典
    [self.response setValue:obj forKey:parserName];
}

-(void)requestDidFail:(ASIHTTPRequest *)aRequest
{
    if ([SVProgressHUD isVisible]) {
        [SVProgressHUD dismissWithError:@"网络连接异常！稍后重试"];
    }
    else {
        [SVProgressHUD showErrorWithStatus:@"网络连接异常！稍后重试" duration:1.5f];
    }
}

// 队列请求完成
-(void)allRequestDone:(ASINetworkQueue *)aQueue
{
    if (!self.connectEnd)
    {
        self.connectEnd = @selector(connectEnd:);
    }
    
    [self.delegate performSelector:self.connectEnd
                        withObject:self.response];
}

- (void)request:(ASIHTTPRequest *)request didSendBytes:(long long)bytes
{
    
}
@end