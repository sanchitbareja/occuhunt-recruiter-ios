//
//  ServerIO.m
//  Occuhunt
//
//  Created by Sidwyn Koh on 9/4/13.
//  Copyright (c) 2013 Sidwyn Koh. All rights reserved.
//

// Managing many NSURLRequests: http://stackoverflow.com/questions/332276/managing-multiple-asynchronous-nsurlconnection-connections

#import "ServerIO.h"

#define kClientID @""
#define kClientSecret @""

@implementation ServerIO

@synthesize delegate;

- (void)makeJSONCall:(NSString *)string andTag:(int)httpCallTag{
    if (!self.delegate) {
        NSLog(@"No delegate. Please check.");
    }
    NSLog(@"Making call to %@", string);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"GET" URLString:[[NSURL URLWithString:string relativeToURL:manager.baseURL] absoluteString] parameters:nil error:nil];
    if (httpCallTag == GETFAIRS || httpCallTag == GETMAPS) {
        request.cachePolicy = NSURLRequestReturnCacheDataElseLoad;
    }
    else {
        request.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    }
    

    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        if (self.delegate) {
            [self.delegate returnData:operation response:responseObject];
        }    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", operation.responseString);
            if (self.delegate) {
                [self.delegate returnFailure:operation error:error];
            }
        }];
    operation.tag = httpCallTag;
    [manager.operationQueue addOperation:operation];
    return;

}

- (void)makeJSONPost:(NSString *)string andArgs:(NSDictionary *)args andTag:(int)httpCallTag{
    if (!self.delegate) {
        NSLog(@"No delegate. Please check.");
    }
    if ([[args allKeys] count] == 0) {
        NSLog(@"Empty dictionary");
        return;
    }
    NSLog(@"Making call to %@", string);
    
    NSMutableString *constructString = [NSMutableString stringWithString:@"{"];
    for (NSString *key in args) {
        NSString *object = [args objectForKey:key];
        [constructString appendFormat:@"\"%@\":%@,", key, object];
    }
    constructString = [NSMutableString stringWithString:[constructString substringToIndex:constructString.length-1]];
    [constructString appendString:@"}"];
    NSLog(@"construct string = %@", constructString);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:string]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData  timeoutInterval:10];
    
    [request setHTTPMethod:@"POST"];
    [request setValue: @"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:[constructString dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.tag = httpCallTag;
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON responseObject: %@ ",responseObject);
        if (self.delegate) {
            [self.delegate returnData:operation response:responseObject];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", [error localizedDescription]);
        if (self.delegate) {
            [self.delegate returnFailure:operation error:error];
        }
        
    }];
    [op start];
    return;
}

- (void)makeJSONPut:(NSString *)string andArgs:(NSDictionary *)args andTag:(int)httpCallTag{
    if (!self.delegate) {
        NSLog(@"No delegate. Please check.");
    }
    if ([[args allKeys] count] == 0) {
        NSLog(@"Empty dictionary");
        return;
    }
    NSLog(@"Making call to %@", string);
    
    NSMutableString *constructString = [NSMutableString stringWithString:@"{"];
    for (NSString *key in args) {
        NSString *object = [args objectForKey:key];
        NSMutableString *s = [NSMutableString stringWithString:object];
        [s replaceOccurrencesOfString:@"\"" withString:@"\\\"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
        [s replaceOccurrencesOfString:@"/" withString:@"\\/" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
        [s replaceOccurrencesOfString:@"\n" withString:@"\\n" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
        [s replaceOccurrencesOfString:@"\b" withString:@"\\b" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
        [s replaceOccurrencesOfString:@"\f" withString:@"\\f" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
        [s replaceOccurrencesOfString:@"\r" withString:@"\\r" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
        [s replaceOccurrencesOfString:@"\t" withString:@"\\t" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
        
        // ONLY VALID FOR STRINGS PLEASE CHECK
        [constructString appendFormat:@"\"%@\":\"%@\",", key, s];
    }
    constructString = [NSMutableString stringWithString:[constructString substringToIndex:constructString.length-1]];
    [constructString appendString:@"}"];
    NSLog(@"construct string = %@", constructString);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:string]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData  timeoutInterval:10];
    
    [request setHTTPMethod:@"PUT"];
    [request setValue: @"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue: @"json" forHTTPHeaderField:@"Data-Type"];
    [request setHTTPBody:[constructString dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.tag = httpCallTag;
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON responseObject: %@ ",responseObject);
        if (self.delegate) {
            [self.delegate returnData:operation response:responseObject];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", [error localizedDescription]);
        if (self.delegate) {
            [self.delegate returnFailure:operation error:error];
        }
        
    }];
    [op start];
    return;
}



- (void)makeJSONPutWithNumbers:(NSString *)string andArgs:(NSDictionary *)args andTag:(int)httpCallTag{
    if (!self.delegate) {
        NSLog(@"No delegate. Please check.");
    }
    if ([[args allKeys] count] == 0) {
        NSLog(@"Empty dictionary");
        return;
    }
    NSLog(@"Making call to %@", string);
    
    NSMutableString *constructString = [NSMutableString stringWithString:@"{"];
    for (NSString *key in args) {
        NSString *object = [args objectForKey:key];
        // ONLY VALID FOR STRINGS PLEASE CHECK
        [constructString appendFormat:@"\"%@\":%@,", key, object];
    }
    constructString = [NSMutableString stringWithString:[constructString substringToIndex:constructString.length-1]];
    [constructString appendString:@"}"];
    NSLog(@"construct string = %@", constructString);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:string]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData  timeoutInterval:10];
    
    [request setHTTPMethod:@"PUT"];
    [request setValue: @"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue: @"json" forHTTPHeaderField:@"Data-Type"];
    [request setHTTPBody:[constructString dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.tag = httpCallTag;
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON responseObject: %@ ",responseObject);
//        if (self.delegate) {
//            [self.delegate returnData:operation response:responseObject];
//        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", [error localizedDescription]);
//        if (self.delegate) {
//            [self.delegate returnFailure:operation error:error];
//        }
        
    }];
    [op start];
    return;
}

- (void)makeJSONPatch:(NSString *)string andArgs:(NSArray *)args andTag:(int)httpCallTag{
    if (!self.delegate) {
        NSLog(@"No delegate. Please check.");
    }
    if ([args count] == 0) {
        NSLog(@"Empty dictionary");
        return;
    }
    NSLog(@"Making call to %@", string);
    NSLog(@"args are %@",  args);
    NSMutableString *constructString = [NSMutableString stringWithString:@""];
    for (NSDictionary *dictionary in args) {
        [constructString appendFormat:@"{"];
        for (NSString *key in [dictionary allKeys]) {
            NSString *object = [dictionary objectForKey:key];
            if ([object isKindOfClass:[NSNumber class]]) {
                if ([object intValue] > 0) {
                    [constructString appendFormat:@"\"%@\":%i,", key, [object intValue]];
                    continue;
                }
            }
            [constructString appendFormat:@"\"%@\":%@,", key, object];
        }
        constructString = [NSMutableString stringWithString:[constructString substringToIndex:constructString.length-1]];
        [constructString appendFormat:@"},"];
    }
    constructString = [NSMutableString stringWithString:[constructString substringToIndex:constructString.length-1]];
//    [constructString appendString:@"}"];
    NSString *newString = [NSString stringWithFormat:@"{\"objects\":[%@]}", constructString];
    NSLog(@"new string = %@", newString);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:string]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData  timeoutInterval:10];
    
    [request setHTTPMethod:@"PATCH"];
    [request setValue: @"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:[newString dataUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.tag = httpCallTag;
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON responseObject: %@ ",responseObject);
        if (self.delegate) {
            [self.delegate returnData:operation response:responseObject];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", [error localizedDescription]);
        if (self.delegate) {
            [self.delegate returnFailure:operation error:error];
        }
        
    }];
    [op start];
    return;
}


- (void)makeJSONPostLogin:(NSString *)string andArgs:(NSDictionary *)args andTag:(int)httpCallTag{
    if (!self.delegate) {
        NSLog(@"No delegate. Please check.");
    }
    if ([[args allKeys] count] == 0) {
        NSLog(@"Empty dictionary");
        return;
    }
    NSLog(@"Making call to %@", string);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:@"http://occuhunt.com/recruiter/login/third_party/" parameters:args success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        if (self.delegate) {
            [self.delegate returnData:operation response:responseObject];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        if (self.delegate) {
            [self.delegate returnFailure:operation error:error];
        }
    }];
    return;
}


- (void)serverSanityCheck {
    NSString *url = @"http://occuhunt.com/";
    [self makeJSONCall:url andTag:SERVERSANITYCHECK];
}

- (void)getAccessToken {
//    NSURL *url = [NSURL URLWithString:@"http://example.com/"];
//    AFOAuth2Client *oauthClient = [AFOAuth2Client clientWithBaseURL:url clientID:kClientID secret:kClientSecret];
//    
//    [oauthClient authenticateUsingOAuthWithPath:@"/oauth/token"
//                                       username:@"username"
//                                       password:@"password"
//                                          scope:@"email"
//                                        success:^(AFOAuthCredential *credential) {
//                                            NSLog(@"I have a token! %@", credential.accessToken);
//                                            [AFOAuthCredential storeCredential:credential withIdentifier:oauthClient.serviceProviderIdentifier];
//                                        }
//                                        failure:^(NSError *error) {
//                                            NSLog(@"Error: %@", error);
//                                        }];
    
}


- (void)getUser:(NSString *)userID{
    NSMutableString *url = [NSMutableString stringWithString:@"http://occuhunt.com/api/v1/users"];
    [url appendFormat:@"/?linkedin_uid=%@", userID];
    [self makeJSONCall:url andTag:GETUSER];
}

- (void)getFairs {
    NSString *url = @"http://occuhunt.com/api/v1/fairs";
    [self makeJSONCall:url andTag:GETFAIRS];
}

- (void)getCompanies {
    NSString *url = @"http://occuhunt.com/api/v1/companies";
    [self makeJSONCall:url andTag:GETCOMPANIES];
}

- (void)getCompany:(NSString *)companyID {
    NSString *url = [NSString stringWithFormat:@"http://occuhunt.com/api/v1/companies/?id=%@", companyID];
    [self makeJSONCall:url andTag:GETCOMPANY];
}

- (void)getCategories {
    NSString *url = @"http://occuhunt.com/api/v1/categories";
    [self makeJSONCall:url andTag:GETCATEGORIES];
}

- (void)getMaps {
    NSString *url = @"http://occuhunt.com/api/v1/maps";
    [self makeJSONCall:url andTag:GETMAPS];
}

- (void)getHunts:(NSString *)userID{
    NSString *url = [NSString stringWithFormat:@"http://occuhunt.com/api/v1/hunts/?user_id=%@", userID];
    [self makeJSONCall:url andTag:GETHUNTS];
}

- (void)getAttendees:(NSString *)eventID {
    NSString *url = [NSString stringWithFormat:@"http://occuhunt.com/api/v1/applications/?unique_students=true&fair_id=%@", eventID];
    [self makeJSONCall:url andTag:GETATTENDEES];
}

- (void)getAttendeesWithStatus:(NSString *)eventID andCompanyID:(NSString *)companyID {
    NSString *url = [NSString stringWithFormat:@"http://occuhunt.com/api/v1/applications/?unique_students=true&fair_id=%@&company_id=%@", eventID, companyID];
    [self makeJSONCall:url andTag:GETATTENDEESWITHSTATUS];
}

- (void)getSpecificApplicationWithUserID:(NSString *)userID andCompanyID:(NSString *)companyID andEventID:(NSString *)eventID {
    NSString *url = [NSString stringWithFormat:@"http://occuhunt.com/api/v1/applications/"];
    [self makeJSONPost:url andArgs:@{@"company_id":companyID, @"fair_id":eventID, @"user_id":userID} andTag:GETSPECIFICAPPLICATION];
}

- (void)updateApplicationWithApplicationID:(NSString *)applicationID andNote:(NSString *)note{
    NSString *url = [NSString stringWithFormat:@"http://occuhunt.com/api/v1/applications/%@/", applicationID];
    [self makeJSONPut:url andArgs:@{@"note":note} andTag:UPDATEAPPLICATION];
}

- (void)updateApplicationWithApplicationID:(NSString *)applicationID andStatus:(NSString *)status{
    NSString *url = [NSString stringWithFormat:@"http://occuhunt.com/api/v1/applications/%@/", applicationID];
    [self makeJSONPutWithNumbers:url andArgs:@{@"status":status} andTag:UPDATESTATUS];
}

- (void)loginWithUsername:(NSString *)username andPassword:(NSString *)password {
    NSString *url = [NSString stringWithFormat:@"http://occuhunt.com/recruiter/login/third_party/"];
    [self makeJSONPostLogin:url andArgs:@{@"username":username, @"password":password} andTag:LOGINRECRUITER];
    
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Recruiter - Logged In"];
}

@end
