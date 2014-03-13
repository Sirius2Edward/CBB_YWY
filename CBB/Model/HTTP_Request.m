//

#import <CommonCrypto/CommonDigest.h>
#import "HTTP_Request.h"
#import "ASIHTTPRequest.h"
#import "BaseParser.h"
#import "SVProgressHUD.h"

@implementation HTTP_Request
{
    NSMutableDictionary *conEndsDic;
}
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
        conEndsDic = [NSMutableDictionary dictionary];
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
    //配置URL参数
    //选择基本URL
    if (self.connectEnd) {
        NSRange range = [api rangeOfString:@"."];
        NSString *parserName;
        if (range.length) {
            parserName = [NSString stringWithFormat:@"%@%d",[api substringToIndex:range.location],typeID];
        }
        else {
            parserName = [NSString stringWithFormat:@"%@%d",api,typeID];
        }
        if ([parserName isEqualToString:@"carduserlogin1"] || [parserName isEqualToString:@"loansuserlogin1"]) {
            parserName = @"userlogin";
        }
        [conEndsDic setObject:NSStringFromSelector(self.connectEnd) forKey:parserName];
    }
    
    url = [NSMutableString stringWithFormat:@"%@",aUrl];
    [url appendString:api];
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
    [self httpRequestWithURL:url];
}

-(void)httpRequestWithURL:(NSString *)aUrl
{
    //发送请求
    NSString *encodeURL = [aUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"请求URL———— %@",encodeURL);
    NSURL *reqURL = [NSURL URLWithString:encodeURL];
    ASIHTTPRequest * req = [ASIHTTPRequest requestWithURL:reqURL];
    [req setDefaultResponseEncoding:NSUTF8StringEncoding];
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
    if (self.connectEnd) {
        NSString *parserName = [NSString stringWithFormat:@"%@%@",file,method];
        [conEndsDic setObject:NSStringFromSelector(self.connectEnd) forKey:parserName];
    }
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
    if (aRequest.responseStatusCode == 500) {
        [SVProgressHUD showErrorWithStatus:@"网络连接异常！稍后重试" duration:0.789f];
        return;
    }
    if ([SVProgressHUD isVisible]) {
        [SVProgressHUD dismiss];
    }
    
    if ([aRequest.url.pathExtension isEqualToString:@"jpg"] || [aRequest.url.pathExtension isEqualToString:@"png"]) {
        if (aRequest.responseStatusCode == 404) {
            return;
        }
        if ([self.delegate respondsToSelector:@selector(imageGot:)]) {
            [self.delegate performSelector:@selector(imageGot:) withObject:aRequest.responseData];
        }
        return;
    }
    //解析
    NSString *parserName = [[self getParserNameFromURL:aRequest.url] copy];
    
    // 动态创建类
    NSString *parseName = [NSString stringWithFormat:@"PARSE%@",parserName];
    Class _parserClass = NSClassFromString(parseName);
    BaseParser *parser = [[_parserClass alloc] initWithStr:aRequest.responseString];
    
    id obj = [parser superParser];
    
    //响应数据存字典
    [self.response setValue:obj forKey:parserName];
    
    NSString *conEnd = [conEndsDic objectForKey:parserName];
    if ([self.delegate respondsToSelector:NSSelectorFromString(conEnd)]) {
        SuppressPerformSelectorLeakWarning([self.delegate performSelector:NSSelectorFromString(conEnd) withObject:self.response]);
    }
}

-(void)requestDidFail:(ASIHTTPRequest *)aRequest
{
    if ([SVProgressHUD isVisible]) {
        [SVProgressHUD dismissWithError:@"网络连接异常！稍后重试"];
    }
    else {
        [SVProgressHUD showErrorWithStatus:@"网络连接异常！稍后重试" duration:0.789f];
    }
}

// 队列请求完成
-(void)allRequestDone:(ASINetworkQueue *)aQueue
{
}

- (void)request:(ASIHTTPRequest *)request didSendBytes:(long long)bytes
{
    
}

- (NSString *)getParserNameFromURL:(NSURL *)aUrl
{
    NSString *api = aUrl.lastPathComponent;
    NSRange range = [api rangeOfString:@"."];
    if (range.length) {
        api = [api substringToIndex:range.location];
    }

    NSString *parserName = [NSString stringWithFormat:@"%@%@",
                            api,
                            [[self dictionaryFromQuery:[aUrl query]
                                         usingEncoding:4] objectForKey:@"typeid"]];
    if ([parserName isEqualToString:@"carduserlogin1"] || [parserName isEqualToString:@"loansuserlogin1"]) {
        parserName = @"userlogin";
    }
    return parserName;
}

- (NSDictionary*)dictionaryFromQuery:(NSString*)query usingEncoding:(NSStringEncoding)encoding
{
    NSCharacterSet *delimiterSet = [NSCharacterSet characterSetWithCharactersInString:@"&;"];
    NSMutableDictionary *pairs = [NSMutableDictionary dictionary];
    NSScanner* scanner = [[NSScanner alloc] initWithString:query];
    while (![scanner isAtEnd]) {
        NSString *pairString = nil;
        [scanner scanUpToCharactersFromSet:delimiterSet intoString:&pairString];
        [scanner scanCharactersFromSet:delimiterSet intoString:NULL];
        NSArray *kvPair = [pairString componentsSeparatedByString:@"="];
        if (kvPair.count == 2) {
            NSString *key = [(NSString *)[kvPair objectAtIndex:0]
                             stringByReplacingPercentEscapesUsingEncoding:encoding];
            NSString *value = [(NSString *)[kvPair objectAtIndex:1]
                               stringByReplacingPercentEscapesUsingEncoding:encoding];
            [pairs setObject:value forKey:key];
        }
    }
    
    return [NSDictionary dictionaryWithDictionary:pairs];
}
@end
