//
//  DataBaseHandler.m
//  Talk2Good
//
//  Created by Sandeep Kumar on 19/11/15.
//  Copyright © 2015 InfoiconTechnologies. All rights reserved.
//

#import "DataBaseHandler.h"
#import <sqlite3.h>

@class CardDetailModel;
//#import "DialogHistory.h"

@interface DataBaseHandler ()
{
        sqlite3 *_database;
}

@end

@implementation DataBaseHandler



/*!
 *@discussion Copies Database file from app' resource to app directory if it does not exist
 *@param dbName The name of the database file to be checked
 *@return Boolean value for the success of the operation
 */
+ (BOOL)createEditableCopyOfDatabaseIfNeeded:(NSString*)dbName{
        // First, test for existence.
        BOOL success;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:dbName];
        success = [fileManager fileExistsAtPath:writableDBPath];
        if (success) {
                NSLog(@"File Exist->%@",writableDBPath);
                return success;
        }
        // The writable database does not exist, so copy the default to the appropriate location.
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:dbName];
        success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
        if (!success) {
                NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
        }
        else{
                NSURL* fileURL = [NSURL fileURLWithPath:writableDBPath];
                [DataBaseHandler addSkipBackupAttributeToItemAtURL:fileURL];
        }
        return success;
}

+(void)removeFile:(NSString *)fileName {
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        NSString *filePath = [documentsPath stringByAppendingPathComponent:fileName];
        
        
        if([fileManager fileExistsAtPath:filePath]){
                NSError *error;
                BOOL success = [fileManager removeItemAtPath:filePath error:&error];
                if (success) {
                        NSLog(@"Remove File : %@",filePath);
                }
                else
                {
                        NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
                }
        }
        else
                NSLog(@"File not Exist");
}

+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL {
        if([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]){
                assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
                
                NSError *error = nil;
                BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                                              forKey: NSURLIsExcludedFromBackupKey error: &error];
                if(!success){
                        NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
                }
                return success;
        }
        else{
                NSLog(@"File Not Exist for excluding from backup->%@",URL);
                return NO;
        }
}

+ (unsigned long long int)folderSize:(NSString *)folderPath {
        NSArray *filesArray = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:folderPath error:nil];
        NSEnumerator *filesEnumerator = [filesArray objectEnumerator];
        NSString *fileName;
        unsigned long long int fileSize = 0;
        
        while (fileName = [filesEnumerator nextObject]) {
                NSDictionary *fileDictionary = [[NSFileManager defaultManager] attributesOfItemAtPath:[folderPath stringByAppendingPathComponent:fileName] error:nil];
                fileSize += [fileDictionary fileSize];
        }
        
        return fileSize;
}
+ (void)clearTmpDirectory {
        
        NSArray* tmpDirectory = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:NSTemporaryDirectory() error:NULL];
        for (NSString *file in tmpDirectory) {
                [[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@%@", NSTemporaryDirectory(), file] error:NULL];
        }
}

- (id)initWithDB:(NSString*)dbName {
        
        if(self = [super init])
        {
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentsDirectory = [paths objectAtIndex:0];
                NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:dbName];
                
                if (sqlite3_open([writableDBPath UTF8String], &_database) != SQLITE_OK) {
                        NSLog(@"could not prepare statement: %s\n", sqlite3_errmsg(_database));
                        NSLog(@"Failed to open database!");
                }
        }
        return self;
}

+ (void)resetData:(NSString*)dbName {
        
        NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
        
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"VERSION"]) {
                
                NSString* oldAppVersion=[[NSUserDefaults standardUserDefaults] objectForKey:@"VERSION"];
                if(![appVersion isEqualToString:oldAppVersion])
                {
                        
                        [self removeFile:dbName];
                }
        }
        
        
        NSLog(@"Old Version->%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"VERSION"]);
        NSLog(@"New Version->%@",appVersion);
        
        [[NSUserDefaults standardUserDefaults] setObject:appVersion forKey:@"VERSION"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
}


-(BOOL)createTableWithName:(NSString*)tableName {
        
        int rc=0;
        
        NSString* queryString=[NSString stringWithFormat:
        @"CREATE TABLE IF NOT EXISTS %@                                                                                                         (                                                                                                                               messageId INTEGER PRIMARY KEY  NOT NULL,                                                                                                           message  TEXT,                                                                                                           sender  TEXT,                                                                                                           'to'  TEXT,                                                                                                           time  TEXT)",tableName];
        
        
        char * query =(char*)[queryString UTF8String];
        char * errMsg;
        rc = sqlite3_exec(_database, query,NULL,NULL,&errMsg);
        
        if(SQLITE_OK != rc)
        {
                NSLog(@"Failed to create table rc:%d, msg=%s",rc,errMsg);
                return NO;
        }
        else    NSLog(@"Successfully created '%@' Table",tableName);
                
        return YES;
       // sqlite3_close(db);
}

-(void)deleteAllDataFromTableName:(NSString*)tableName {
        
        NSString *query = [NSString stringWithFormat:@"DELETE from %@",tableName];
        
        const char *sql = [query cStringUsingEncoding:NSUTF8StringEncoding];
        sqlite3_stmt *statement = nil;
        
        if(sqlite3_prepare_v2(_database,sql, -1, &statement, NULL)!= SQLITE_OK)
        {
                NSAssert1(0,@"error preparing statement",sqlite3_errmsg(_database));
        }
        else
        {
                sqlite3_step(statement);
        }
        sqlite3_finalize(statement);
}

- (NSString*)getCreationDate:(NSString *)query {
        NSString* creationDate;
        
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil)==SQLITE_OK)
        {
                if (sqlite3_step(statement)==SQLITE_ROW)
                {
                        if ( sqlite3_column_type(statement, 0) != SQLITE_NULL ){
                                char *nameChars = (char *) sqlite3_column_text(statement, 0);
                                creationDate = [[NSString alloc] initWithUTF8String:nameChars];
                        }
                        else creationDate=nil;
                }
                else
                {
                        creationDate=nil;
                        //NSLog(@"%s,",sqlite3_errmsg(_database));
                }
                sqlite3_finalize(statement);
                // sqlite3_close(_database);
        }
        else
                NSLog(@"Query Not Executed");
        return creationDate;
}

- (int)maxBookmark {
        
        int value;
        
         NSString *query = [NSString stringWithFormat:@"SELECT MAX(bookmark) from contents "];
        
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil)==SQLITE_OK)
        {
                if (sqlite3_step(statement)==SQLITE_ROW)
                {
                        if ( sqlite3_column_type(statement, 0) != SQLITE_NULL ){
                                
                                //int languageID = sqlite3_column_int(statement, 0);
                                //char *nameChars = (char *) sqlite3_column_text(statement, 0);
                                value = sqlite3_column_int(statement, 0);
                        }
                        else
                                value = 0;
                }
                else
                {
                        value = 0;
                        //NSLog(@"%s,",sqlite3_errmsg(_database));
                }
                sqlite3_finalize(statement);
                // sqlite3_close(_database);
        }
        else
                NSLog(@"Query Not Executed");
        return value;
}

- (NSString*)getParent_label_1_ID:(NSString*)mainID {
        
        NSString* value;
        
        NSString *query = [NSString stringWithFormat:
           @"SELECT LEVEL1_PARENT_ID   from contents_parent_map where CONTENTS_ID=\"%@\"",mainID];
        
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil)==SQLITE_OK)
        {
                if (sqlite3_step(statement)==SQLITE_ROW)
                {
                        if ( sqlite3_column_type(statement, 0) != SQLITE_NULL ){
                                char *nameChars = (char *) sqlite3_column_text(statement, 0);
                                value  = [[NSString alloc] initWithUTF8String:nameChars];
                        }
                        else
                                value = @"NULL";
                }
                else
                {
                        value = 0;
                        //NSLog(@"%s,",sqlite3_errmsg(_database));
                }
                sqlite3_finalize(statement);
                // sqlite3_close(_database);
        }
        else
                NSLog(@"Query Not Executed");
        return value;
}
- (NSString*)getParent_label_2_ID:(NSString*)mainID{
        NSString* value;
        
        NSString *query = [NSString stringWithFormat:
                           @"SELECT LEVEL2_PARENT_ID   from contents_parent_map where CONTENTS_ID=\"%@\"",mainID];
        
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil)==SQLITE_OK)
        {
                if (sqlite3_step(statement)==SQLITE_ROW)
                {
                        if ( sqlite3_column_type(statement, 0) != SQLITE_NULL ){
                                char *nameChars = (char *) sqlite3_column_text(statement, 0);
                                value  = [[NSString alloc] initWithUTF8String:nameChars];
                        }
                        else
                                value = @"NULL";
                }
                else
                {
                        value = 0;
                        //NSLog(@"%s,",sqlite3_errmsg(_database));
                }
                sqlite3_finalize(statement);
                // sqlite3_close(_database);
        }
        else
                NSLog(@"Query Not Executed");
        return value;
}

- (BOOL)executeQuery:(NSString *)query{
        BOOL isDelete=NO;
        
       
        
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil)==SQLITE_OK)
        {
                if (sqlite3_step(statement)==SQLITE_DONE)
                {
                        isDelete=YES;
                }
                else
                {
                        //NSLog(@"%s,",sqlite3_errmsg(_database));
                }
                sqlite3_finalize(statement);
                // sqlite3_close(_database);
        }
        else
                NSLog(@"Query Not Executed");
        return isDelete;

}

- (int)getUnreadCount:(NSString *)query{
        int unread=0;
        
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil)==SQLITE_OK)
        {
                if (sqlite3_step(statement)==SQLITE_ROW)
                {
                        
                        if ( sqlite3_column_type(statement, 0) != SQLITE_NULL ){
                                unread = sqlite3_column_int(statement, 0);
                        }
                }
                else
                {
                        //NSLog(@"%s,",sqlite3_errmsg(_database));
                }
                sqlite3_finalize(statement);
                // sqlite3_close(_database);
        }
        else
                NSLog(@"Query Not Executed");
        return unread;
}

- (BOOL)tableExistOrNot:(NSString *)tableName{
        BOOL recordExist=NO;
        
        NSString* query=[NSString stringWithFormat:@"SELECT name FROM sqlite_master WHERE type='table' AND name=\"%@\"",tableName];
        
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil)==SQLITE_OK)
        {
                if (sqlite3_step(statement)==SQLITE_ROW)
                {
                        if ( sqlite3_column_type(statement, 0) != SQLITE_NULL ){
                                recordExist=YES;
                                //NSLog(@"Record exist");
                        }
                }
                else
                {
                        //NSLog(@"%s,",sqlite3_errmsg(_database));
                }
                sqlite3_finalize(statement);
                // sqlite3_close(_database);
        }
        else
                NSLog(@"Query Not Executed");
        return recordExist;
}

- (BOOL)recordExistOrNot:(NSString *)query{
        BOOL recordExist=NO;
        
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil)==SQLITE_OK)
        {
                if (sqlite3_step(statement)==SQLITE_ROW)
                {
                        if ( sqlite3_column_type(statement, 0) != SQLITE_NULL ){
                                recordExist=YES;
                                //NSLog(@"Record exist");
                        }
                }
                else
                {
                        //NSLog(@"%s,",sqlite3_errmsg(_database));
                }
                sqlite3_finalize(statement);
                // sqlite3_close(_database);
        }
        else
                NSLog(@"Query Not Executed");
        return recordExist;
}



- (NSArray*)getCardDetails{
        
        NSMutableArray *retval = [[NSMutableArray alloc] init];
        NSString *query = @"SELECT * from CardDetail";
        const char* queryUTF8 = [query UTF8String];
        sqlite3_stmt *statement;
        
        @autoreleasepool {
                int response = sqlite3_prepare_v2(_database, queryUTF8, -1, &statement, nil);
                if (response == SQLITE_OK) {
                        while (sqlite3_step(statement) == SQLITE_ROW) {
                                
                                CardDetailModel* card=[[CardDetailModel alloc]init];
                                
                                
                                if ( sqlite3_column_type(statement, 0) != SQLITE_NULL ){
                                        
                                        card.ID = sqlite3_column_int(statement, 0);
                                }
                                else
                                        card.ID = 0;
                                
                                if ( sqlite3_column_type(statement, 1) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 1);
                                        card.ART_NAME  = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        card.ART_NAME=@"NULL";
                                
                                if ( sqlite3_column_type(statement, 2) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 2);
                                        card.ARTIST_NAME  = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        card.ARTIST_NAME=@"NULL";
                                
                                if ( sqlite3_column_type(statement, 3) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 3);
                                        card.ART_URL  = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        card.ART_URL=@"NULL";

                                if ( sqlite3_column_type(statement, 4) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 4);
                                        card.ART_CATEGORY  = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        card.ART_CATEGORY=@"NULL";
                                
                                if ( sqlite3_column_type(statement, 5) != SQLITE_NULL ){
                                        
                                        card.QUANTITY = sqlite3_column_int(statement, 5);
                                }
                                else
                                        card.QUANTITY = 0;                                
                                
                                if ( sqlite3_column_type(statement, 6) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 6);
                                        card.PRICE  = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        card.PRICE=@"NULL";
                                
                                if ( sqlite3_column_type(statement, 7) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 7);
                                        card.ART_SIZE  = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        card.ART_SIZE=@"NULL";
                                
                                if ( sqlite3_column_type(statement, 8) != SQLITE_NULL ){
                                        
                                        card.SORT = sqlite3_column_int(statement, 8);
                                }
                                else
                                        card.SORT = 0;
                                
                                [retval addObject:card];
                        }
                        sqlite3_finalize(statement);
                }
        }
        return retval;
}


- (NSArray*)getCardDetailsWithID:(NSString*)ID{
        
        NSMutableArray *retval = [[NSMutableArray alloc] init];
        NSString *query = [NSString stringWithFormat:@"SELECT * from CardDetail where id = \"%@\"",ID];
        const char* queryUTF8 = [query UTF8String];
        sqlite3_stmt *statement;
        
        @autoreleasepool {
                int response = sqlite3_prepare_v2(_database, queryUTF8, -1, &statement, nil);
                if (response == SQLITE_OK) {
                        while (sqlite3_step(statement) == SQLITE_ROW) {
                                
                                CardDetailModel* card=[[CardDetailModel alloc]init];
                                
                                
                                if ( sqlite3_column_type(statement, 0) != SQLITE_NULL ){
                                        
                                        card.ID = sqlite3_column_int(statement, 0);
                                }
                                else
                                        card.ID = 0;
                                
                                if ( sqlite3_column_type(statement, 1) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 1);
                                        card.ART_NAME  = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        card.ART_NAME=@"NULL";
                                
                                if ( sqlite3_column_type(statement, 2) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 2);
                                        card.ARTIST_NAME  = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        card.ARTIST_NAME=@"NULL";
                                
                                if ( sqlite3_column_type(statement, 3) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 3);
                                        card.ART_URL  = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        card.ART_URL=@"NULL";
                                
                                if ( sqlite3_column_type(statement, 4) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 4);
                                        card.ART_CATEGORY  = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        card.ART_CATEGORY=@"NULL";
                                
                                if ( sqlite3_column_type(statement, 5) != SQLITE_NULL ){
                                        
                                        card.QUANTITY = sqlite3_column_int(statement, 5);
                                }
                                else
                                        card.QUANTITY = 0;
                                
                                if ( sqlite3_column_type(statement, 6) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 6);
                                        card.PRICE  = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        card.PRICE=@"NULL";
                                
                                if ( sqlite3_column_type(statement, 7) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 7);
                                        card.ART_SIZE  = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        card.ART_SIZE=@"NULL";
                                
                                if ( sqlite3_column_type(statement, 8) != SQLITE_NULL ){
                                        
                                        card.SORT = sqlite3_column_int(statement, 8);
                                }
                                else
                                        card.SORT = 0;
                                
                                [retval addObject:card];
                        }
                        sqlite3_finalize(statement);
                }
        }
        return retval;
}

- (NSInteger)getCardSortMax{
        
        int max=0;
        NSString *query = @"SELECT max(Sort) from CardDetail";
        const char* queryUTF8 = [query UTF8String];
        sqlite3_stmt *statement;
        
        @autoreleasepool {
                int response = sqlite3_prepare_v2(_database, queryUTF8, -1, &statement, nil);
                if (response == SQLITE_OK) {
                        while (sqlite3_step(statement) == SQLITE_ROW) {
                                
                                if ( sqlite3_column_type(statement, 0) != SQLITE_NULL ){
                                        
                                        max = sqlite3_column_int(statement, 0);
                                }
                                else
                                        max = 0;
                                
                                
                        }
                        sqlite3_finalize(statement);
                }
        }
        return max;
}



/*

- (NSArray*)getMediaGalleryWithID:(NSString*)ID{
        
        NSMutableArray *retval = [[NSMutableArray alloc] init];
        NSString *query = [NSString stringWithFormat:
                           @"SELECT * FROM contents_media where CONTENTS_ID =\"%@\"",ID];
        const char* queryUTF8 = [query UTF8String];
        sqlite3_stmt *statement;
        
        @autoreleasepool {
                int response = sqlite3_prepare_v2(_database, queryUTF8, -1, &statement, nil);
                if (response == SQLITE_OK) {
                        while (sqlite3_step(statement) == SQLITE_ROW) {
                                
                                MediaGallery* mg=[[MediaGallery alloc]init];
                                
                                
                                if ( sqlite3_column_type(statement, 0) != SQLITE_NULL ){
                                        
                                        mg.ID = sqlite3_column_int(statement, 0);
                                }
                                else
                                        mg.ID = 0;
                                
                                if ( sqlite3_column_type(statement, 1) != SQLITE_NULL ){
                                        
                                        mg.CONTENTS_ID = sqlite3_column_int(statement, 1);
                                }
                                else
                                        mg.CONTENTS_ID = 0;
                                if ( sqlite3_column_type(statement, 2) != SQLITE_NULL ){
                                        
                                        mg.MediaType = sqlite3_column_int(statement, 2);
                                }
                                else
                                        mg.MediaType = 0;
                                
                                if ( sqlite3_column_type(statement, 3) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 3);
                                        mg.Source  = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        mg.Source=@"NULL";
                                
                                if ( sqlite3_column_type(statement, 4) != SQLITE_NULL ){
                                        
                                        mg.SortOrder = sqlite3_column_int(statement, 4);
                                }
                                else
                                        mg.SortOrder = 0;
                                
                                
                                
                                
                                [retval addObject:mg];
                        }
                        sqlite3_finalize(statement);
                }
        }
        return retval;
}

- (NSArray*)getLanguages{
    
        NSMutableArray *retval = [[NSMutableArray alloc] init];
        NSString *query = @"SELECT                                                                                                                              ID,                                                                                                                                             Name,                                                                                                                                      MenuHome,                                                                                                                                       MenuMap,                                                                                                                                ManuTheHotel,                                                                                                                   MenuTravelGuide,                                                                                                                MenuBookmarks,                                                                                                                  MenuBookOnline,                                                                                                         MenuSettings,                                                                                                                   MenuAbout,                                                                                                                      ActionCall,                                                                                                             ActionMap,                                                                                                                      ActionNavigate,                                                                                                         SettingsSyncOnWifiOnly,                                                                                                         SettingsLanguage,                                                                                                                       SettingsChangeLanguage,                                                                                                                 AboutHotelStaySlogan,                                                                                                           AboutHotelStayURL,                                                                                                              ReadMore,                                                                                                               FromHotel,                                                                                                              FromLocation,                                                                                                                                           \"All\",                                                                                                                                    Filters,                                                                                                                        ListView,                                                                                                                       Bookmark,                                                                                                               NearHotel,                                                                                                                                      NearMe,                                                                                                                                         List,                                                                                                                                   SortBy,                                                                                                                         NearestToHotel,                                                                                                         NearestToYourLocation,                                                                                                                  \"From\",                                                                                                                           \"To\",                                                                                                                                     Hr,                                                                                                                                     Min,                                                                                                                            Km,                                                                                                                                     Mi,                                                                                                                     NoInternetMessage,                                                                                                              DistanceUnit,                                                                                                           NoLocationServices,                                                                                                     SortOrder,                                                                                                                                       IsEnabled                                                                                                                                       from languages";
        const char* queryUTF8 = [query UTF8String];
        sqlite3_stmt *statement;
        
        @autoreleasepool {
                int response = sqlite3_prepare_v2(_database, queryUTF8, -1, &statement, nil);
                if (response == SQLITE_OK) {
                        while (sqlite3_step(statement) == SQLITE_ROW) {
                            
                                Language* language=[[Language alloc]init];
                            
                            
                                if ( sqlite3_column_type(statement, 0) != SQLITE_NULL ){
                                    
                                        language.ID = sqlite3_column_int(statement, 0);
                                }
                                else
                                        language.ID = 0;

                                if ( sqlite3_column_type(statement, 1) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 1);
                                        language.Name  = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        language.Name=@"NULL";

                                if ( sqlite3_column_type(statement, 2) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 2);
                                        language.MenuHome = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        language.MenuHome=@"NULL";
                                if ( sqlite3_column_type(statement, 3) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 3);
                                        language.MenuMap = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        language.MenuMap=@"NULL";
                                if ( sqlite3_column_type(statement, 4) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 4);
                                        language.MenuTheHotel = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        language.MenuTheHotel=@"NULL";
                                if ( sqlite3_column_type(statement, 5) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 5);
                                        language.MenuTravelGuide = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        language.MenuTravelGuide=@"NULL";

                                if ( sqlite3_column_type(statement, 6) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 6);
                                        language.MenuBookmarks = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        language.MenuBookOnline=@"NULL";
                                if ( sqlite3_column_type(statement, 7) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 7);
                                        language.MenuBookOnline = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                language.MenuBookmarks=@"NULL";

                                if ( sqlite3_column_type(statement, 8) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 8);
                                        language.MenuSettings = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                language.MenuSettings=@"NULL";

                                if ( sqlite3_column_type(statement, 9) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 9);
                                        language.MenuAbout = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                language.MenuAbout=@"NULL";
                                if ( sqlite3_column_type(statement, 10) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 10);
                                        language.ActionCall = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                language.ActionCall=@"NULL";

                                if ( sqlite3_column_type(statement, 11) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 11);
                                        language.ActionMap = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                language.ActionMap=@"NULL";

                                if ( sqlite3_column_type(statement, 12) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 12);
                                        language.ActionNavigate = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                language.ActionNavigate=@"NULL";
                                if ( sqlite3_column_type(statement, 13) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 13);
                                        language.SettingsSyncOnWifiOnly = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                language.SettingsSyncOnWifiOnly=@"NULL";

                                if ( sqlite3_column_type(statement, 14) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 14);
                                        language.SettingsLanguage = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                language.SettingsLanguage=@"NULL";
                                if ( sqlite3_column_type(statement, 15) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 15);
                                        language.SettingsChangeLanguage = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                language.SettingsChangeLanguage=@"NULL";

                                if ( sqlite3_column_type(statement, 16) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 16);
                                        language.AboutHotelStaySlogan = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                language.AboutHotelStaySlogan=@"NULL";


                                if ( sqlite3_column_type(statement, 17) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 17);
                                        language.AboutHotelStayURL = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                language.AboutHotelStayURL=@"NULL";

                                if ( sqlite3_column_type(statement, 18) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 18);
                                        language.ReadMore = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        language.ReadMore=@"NULL";
                                if ( sqlite3_column_type(statement, 19) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 19);
                                        language.FromHotel = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        language.FromHotel=@"NULL";
                                if ( sqlite3_column_type(statement, 20) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 20);
                                        language.FromLocation = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        language.FromLocation=@"NULL";
                                if ( sqlite3_column_type(statement, 21) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 21);
                                        language.All = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        language.All=@"NULL";
                                if ( sqlite3_column_type(statement, 22) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 22);
                                        language.Filters = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        language.Filters=@"NULL";
                                if ( sqlite3_column_type(statement, 23) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 23);
                                        language.ListView = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        language.ListView=@"NULL";
                                if ( sqlite3_column_type(statement, 24) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 24);
                                        language.Bookmark = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        language.Bookmark=@"NULL";
                                if ( sqlite3_column_type(statement, 25) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 25);
                                        language.NearHotel = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        language.NearHotel=@"NULL";
                                if ( sqlite3_column_type(statement, 26) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 26);
                                        language.NearMe = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        language.NearMe=@"NULL";
                                if ( sqlite3_column_type(statement, 27) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 27);
                                        language.List = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        language.List=@"NULL";
                                if ( sqlite3_column_type(statement, 28) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 28);
                                        language.SortBy = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        language.SortBy=@"NULL";
                                if ( sqlite3_column_type(statement, 29) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 29);
                                        language.NearestToHotel = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        language.NearestToHotel=@"NULL";
                                if ( sqlite3_column_type(statement, 30) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 30);
                                        language.NearestToYourLocation = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        language.NearestToYourLocation=@"NULL";
                                if ( sqlite3_column_type(statement, 31) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 31);
                                        language.From = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        language.From=@"NULL";
                                if ( sqlite3_column_type(statement, 32) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 32);
                                        language.To = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        language.To=@"NULL";
                                if ( sqlite3_column_type(statement, 33) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 33);
                                        language.Hr = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        language.Hr=@"NULL";
                                if ( sqlite3_column_type(statement, 34) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 34);
                                        language.Min = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        language.Min=@"NULL";
                                if ( sqlite3_column_type(statement, 35) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 35);
                                        language.Km = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        language.Km=@"NULL";
                                if ( sqlite3_column_type(statement, 36) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 36);
                                        language.Mi = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        language.Mi=@"NULL";
                                if ( sqlite3_column_type(statement, 37) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 37);
                                        language.NoInternetMessage = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        language.NoInternetMessage=@"NULL";
                                if ( sqlite3_column_type(statement, 38) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 38);
                                        language.DistanceUnit = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        language.DistanceUnit=@"NULL";
                                if ( sqlite3_column_type(statement, 39) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 39);
                                        language.NoLocationServices = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        language.NoLocationServices=@"NULL";

                                if ( sqlite3_column_type(statement, 40) != SQLITE_NULL ){

                                        language.SortOrder = sqlite3_column_int(statement, 40);;
                                }
                                else
                                        language.SortOrder= 0;
                                
                                if ( sqlite3_column_type(statement, 41) != SQLITE_NULL ){
                                        
                                        language.IsEnabled = sqlite3_column_int(statement, 41);
                                }
                                else
                                        language.IsEnabled = 0;

                                [retval addObject:language];
                        }
                        sqlite3_finalize(statement);
                }
        }
        return retval;
}
- (NSArray*)getLanguagesWithID:(NSString*)ID{
        
        NSMutableArray *retval = [[NSMutableArray alloc] init];
        NSString *query =[NSString stringWithFormat: @"SELECT                                                                                                                              ID,                                                                                                                                             Name,                                                                                                                                      MenuHome,                                                                                                                                       MenuMap,                                                                                                                                ManuTheHotel,                                                                                                                   MenuTravelGuide,                                                                                                                MenuBookmarks,                                                                                                                  MenuBookOnline,                                                                                                         MenuSettings,                                                                                                                   MenuAbout,                                                                                                                      ActionCall,                                                                                                             ActionMap,                                                                                                                      ActionNavigate,                                                                                                         SettingsSyncOnWifiOnly,                                                                                                         SettingsLanguage,                                                                                                                       SettingsChangeLanguage,                                                                                                                 AboutHotelStaySlogan,                                                                                                           AboutHotelStayURL,                                                                                                              ReadMore,                                                                                                               FromHotel,                                                                                                              FromLocation,                                                                                                                                           \"All\",                                                                                                                                    Filters,                                                                                                                        ListView,                                                                                                                       Bookmark,                                                                                                               NearHotel,                                                                                                                                      NearMe,                                                                                                                                         List,                                                                                                                                   SortBy,                                                                                                                         NearestToHotel,                                                                                                         NearestToYourLocation,                                                                                                                  \"From\",                                                                                                                           \"To\",                                                                                                                                     Hr,                                                                                                                                     Min,                                                                                                                            Km,                                                                                                                                     Mi,                                                                                                                     NoInternetMessage,                                                                                                              DistanceUnit,                                                                                                           NoLocationServices,                                                                                                     SortOrder,                                                                                                                                       IsEnabled from languages where ID=\"%@\"",ID];
        const char* queryUTF8 = [query UTF8String];
        sqlite3_stmt *statement;
        
        @autoreleasepool {
                int response = sqlite3_prepare_v2(_database, queryUTF8, -1, &statement, nil);
                if (response == SQLITE_OK) {
                        while (sqlite3_step(statement) == SQLITE_ROW) {
                                
                                Language* language=[[Language alloc]init];
                                
                                
                                if ( sqlite3_column_type(statement, 0) != SQLITE_NULL ){
                                        
                                        language.ID = sqlite3_column_int(statement, 0);
                                }
                                else
                                        language.ID = 0;
                                
                                if ( sqlite3_column_type(statement, 1) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 1);
                                        language.Name  = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        language.Name=@"NULL";
                                
                                if ( sqlite3_column_type(statement, 2) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 2);
                                        language.MenuHome = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        language.MenuHome=@"NULL";
                                if ( sqlite3_column_type(statement, 3) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 3);
                                        language.MenuMap = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        language.MenuMap=@"NULL";
                                if ( sqlite3_column_type(statement, 4) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 4);
                                        language.MenuTheHotel = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        language.MenuTheHotel=@"NULL";
                                if ( sqlite3_column_type(statement, 5) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 5);
                                        language.MenuTravelGuide = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        language.MenuTravelGuide=@"NULL";
                                
                                if ( sqlite3_column_type(statement, 6) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 6);
                                        language.MenuBookmarks = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        language.MenuBookOnline=@"NULL";
                                if ( sqlite3_column_type(statement, 7) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 7);
                                        language.MenuBookOnline = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        language.MenuBookmarks=@"NULL";
                                
                                if ( sqlite3_column_type(statement, 8) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 8);
                                        language.MenuSettings = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        language.MenuSettings=@"NULL";
                                
                                if ( sqlite3_column_type(statement, 9) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 9);
                                        language.MenuAbout = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        language.MenuAbout=@"NULL";
                                if ( sqlite3_column_type(statement, 10) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 10);
                                        language.ActionCall = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        language.ActionCall=@"NULL";
                                
                                if ( sqlite3_column_type(statement, 11) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 11);
                                        language.ActionMap = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        language.ActionMap=@"NULL";
                                
                                if ( sqlite3_column_type(statement, 12) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 12);
                                        language.ActionNavigate = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        language.ActionNavigate=@"NULL";
                                if ( sqlite3_column_type(statement, 13) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 13);
                                        language.SettingsSyncOnWifiOnly = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        language.SettingsSyncOnWifiOnly=@"NULL";
                                
                                if ( sqlite3_column_type(statement, 14) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 14);
                                        language.SettingsLanguage = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        language.SettingsLanguage=@"NULL";
                                if ( sqlite3_column_type(statement, 15) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 15);
                                        language.SettingsChangeLanguage = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        language.SettingsChangeLanguage=@"NULL";
                                
                                if ( sqlite3_column_type(statement, 16) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 16);
                                        language.AboutHotelStaySlogan = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        language.AboutHotelStaySlogan=@"NULL";
                                
                                
                                if ( sqlite3_column_type(statement, 17) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 17);
                                        language.AboutHotelStayURL = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        language.AboutHotelStayURL=@"NULL";
                                
                                if ( sqlite3_column_type(statement, 18) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 18);
                                        language.ReadMore = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        language.ReadMore=@"NULL";
                                if ( sqlite3_column_type(statement, 19) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 19);
                                        language.FromHotel = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        language.FromHotel=@"NULL";
                                if ( sqlite3_column_type(statement, 20) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 20);
                                        language.FromLocation = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        language.FromLocation=@"NULL";
                                if ( sqlite3_column_type(statement, 21) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 21);
                                        language.All = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        language.All=@"NULL";
                                if ( sqlite3_column_type(statement, 22) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 22);
                                        language.Filters = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        language.Filters=@"NULL";
                                if ( sqlite3_column_type(statement, 23) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 23);
                                        language.ListView = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        language.ListView=@"NULL";
                                if ( sqlite3_column_type(statement, 24) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 24);
                                        language.Bookmark = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        language.Bookmark=@"NULL";
                                if ( sqlite3_column_type(statement, 25) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 25);
                                        language.NearHotel = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        language.NearHotel=@"NULL";
                                if ( sqlite3_column_type(statement, 26) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 26);
                                        language.NearMe = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        language.NearMe=@"NULL";
                                if ( sqlite3_column_type(statement, 27) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 27);
                                        language.List = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        language.List=@"NULL";
                                if ( sqlite3_column_type(statement, 28) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 28);
                                        language.SortBy = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        language.SortBy=@"NULL";
                                if ( sqlite3_column_type(statement, 29) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 29);
                                        language.NearestToHotel = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        language.NearestToHotel=@"NULL";
                                if ( sqlite3_column_type(statement, 30) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 30);
                                        language.NearestToYourLocation = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        language.NearestToYourLocation=@"NULL";
                                if ( sqlite3_column_type(statement, 31) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 31);
                                        language.From = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        language.From=@"NULL";
                                if ( sqlite3_column_type(statement, 32) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 32);
                                        language.To = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        language.To=@"NULL";
                                if ( sqlite3_column_type(statement, 33) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 33);
                                        language.Hr = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        language.Hr=@"NULL";
                                if ( sqlite3_column_type(statement, 34) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 34);
                                        language.Min = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        language.Min=@"NULL";
                                if ( sqlite3_column_type(statement, 35) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 35);
                                        language.Km = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        language.Km=@"NULL";
                                if ( sqlite3_column_type(statement, 36) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 36);
                                        language.Mi = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        language.Mi=@"NULL";
                                if ( sqlite3_column_type(statement, 37) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 37);
                                        language.NoInternetMessage = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        language.NoInternetMessage=@"NULL";
                                if ( sqlite3_column_type(statement, 38) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 38);
                                        language.DistanceUnit = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        language.DistanceUnit=@"NULL";
                                if ( sqlite3_column_type(statement, 39) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 39);
                                        language.NoLocationServices = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        language.NoLocationServices=@"NULL";
                                
                                if ( sqlite3_column_type(statement, 40) != SQLITE_NULL ){
                                        
                                        language.SortOrder = sqlite3_column_int(statement, 40);;
                                }
                                else
                                        language.SortOrder= 0;
                                
                                if ( sqlite3_column_type(statement, 41) != SQLITE_NULL ){
                                        
                                        language.IsEnabled = sqlite3_column_int(statement, 41);
                                }
                                else
                                        language.IsEnabled = 0;
                                
                                [retval addObject:language];
                        }
                        sqlite3_finalize(statement);
                }
        }
        return retval;
}

- (NSArray*)getTheme{
    
    NSMutableArray *retval = [[NSMutableArray alloc] init];
    NSString *query = @"SELECT * from theme";
    const char* queryUTF8 = [query UTF8String];
    sqlite3_stmt *statement;
    
    @autoreleasepool {
        int response = sqlite3_prepare_v2(_database, queryUTF8, -1, &statement, nil);
        if (response == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                
                Theme* theme=[[Theme alloc]init];


                if ( sqlite3_column_type(statement, 0) != SQLITE_NULL ){
                    
                    theme.LogoBG = sqlite3_column_int(statement, 0);
                }
                else
                    theme.LogoBG = 0;
                    
                if ( sqlite3_column_type(statement, 1) != SQLITE_NULL ){
                    char *nameChars = (char *) sqlite3_column_text(statement, 1);
                    theme.BackColor  = [[NSString alloc] initWithUTF8String:nameChars];
                }
                else
                    theme.BackColor=@"NULL";

                if ( sqlite3_column_type(statement, 2) != SQLITE_NULL ){
                    
                    theme.BackColorOpacity = sqlite3_column_int(statement, 2);
                }
                else
                    theme.BackColorOpacity = 0;

                if ( sqlite3_column_type(statement, 3) != SQLITE_NULL ){
                    
                    theme.ForeColor = sqlite3_column_int(statement, 3);
                }
                else
                    theme.ForeColor = 0;
                
                if ( sqlite3_column_type(statement, 4) != SQLITE_NULL ){
                    char *nameChars = (char *) sqlite3_column_text(statement, 4);
                    theme.ThemeBackColor  = [[NSString alloc] initWithUTF8String:nameChars];
                }
                else
                    theme.ThemeBackColor=@"NULL";
                
                if ( sqlite3_column_type(statement, 5) != SQLITE_NULL ){
                    char *nameChars = (char *) sqlite3_column_text(statement, 5);
                    theme.ThemeForeColor = [[NSString alloc] initWithUTF8String:nameChars];
                }
                else
                    theme.ThemeForeColor=@"NULL";
                    
                if ( sqlite3_column_type(statement, 6) != SQLITE_NULL ){
                    char *nameChars = (char *) sqlite3_column_text(statement, 6);
                    theme.ThemeSubtitleBarBackColor = [[NSString alloc] initWithUTF8String:nameChars];
                }
                else
                    theme.ThemeSubtitleBarBackColor=@"NULL";
                    
                if ( sqlite3_column_type(statement, 7) != SQLITE_NULL ){
                    char *nameChars = (char *) sqlite3_column_text(statement, 7);
                    theme.ThemeColor1 = [[NSString alloc] initWithUTF8String:nameChars];
                }
                else
                    theme.ThemeColor1=@"NULL";

                if ( sqlite3_column_type(statement, 8) != SQLITE_NULL ){
                    char *nameChars = (char *) sqlite3_column_text(statement, 8);
                    theme.ThemeColor2 = [[NSString alloc] initWithUTF8String:nameChars];
                }
                else
                    theme.ThemeColor2=@"NULL";

                if ( sqlite3_column_type(statement, 9) != SQLITE_NULL ){
                    char *nameChars = (char *) sqlite3_column_text(statement, 9);
                    theme.ThemeColor3 = [[NSString alloc] initWithUTF8String:nameChars];
                }
                else
                    theme.ThemeColor3=@"NULL";

                if ( sqlite3_column_type(statement, 10) != SQLITE_NULL ){
                    char *nameChars = (char *) sqlite3_column_text(statement, 10);
                    theme.ThemeColor4 = [[NSString alloc] initWithUTF8String:nameChars];
                }
                else
                    theme.ThemeColor4=@"NULL";
                if ( sqlite3_column_type(statement, 11) != SQLITE_NULL ){
                    char *nameChars = (char *) sqlite3_column_text(statement, 11);
                    theme.ThemeColor5 = [[NSString alloc] initWithUTF8String:nameChars];
                }
                else
                    theme.ThemeColor5=@"NULL";

                if ( sqlite3_column_type(statement, 12) != SQLITE_NULL ){
                    char *nameChars = (char *) sqlite3_column_text(statement, 12);
                    theme.ThemeColor6 = [[NSString alloc] initWithUTF8String:nameChars];
                }
                else
                    theme.ThemeColor6=@"NULL";

                if ( sqlite3_column_type(statement, 13) != SQLITE_NULL ){
                    char *nameChars = (char *) sqlite3_column_text(statement, 13);
                    theme.ThemeColor7 = [[NSString alloc] initWithUTF8String:nameChars];
                }
                else
                    theme.ThemeColor7=@"NULL";

                if ( sqlite3_column_type(statement, 14) != SQLITE_NULL ){
                    char *nameChars = (char *) sqlite3_column_text(statement, 14);
                    theme.ThemeColor8 = [[NSString alloc] initWithUTF8String:nameChars];
                }
                else
                    theme.ThemeColor8=@"NULL";

                if ( sqlite3_column_type(statement, 15) != SQLITE_NULL ){
                    char *nameChars = (char *) sqlite3_column_text(statement, 15);
                    theme.ThemeColor9 = [[NSString alloc] initWithUTF8String:nameChars];
                }
                else
                    theme.ThemeColor9=@"NULL";

                if ( sqlite3_column_type(statement, 16) != SQLITE_NULL ){
                    char *nameChars = (char *) sqlite3_column_text(statement, 16);
                    theme.ThemeColor10 = [[NSString alloc] initWithUTF8String:nameChars];
                }
                else
                    theme.ThemeColor10=@"NULL";

                    
                
                [retval addObject:theme];
            }
            sqlite3_finalize(statement);
        }
    }
    return retval;
}

- (NSArray*)getLinksWithMainID:(NSString*)Main_ID{
        
        NSMutableArray *retval = [[NSMutableArray alloc] init];
        NSString *query =[NSString stringWithFormat:
                          @"SELECT * from contents_links where CONTENTS_ID = \"%@\"",Main_ID];
        const char* queryUTF8 = [query UTF8String];
        sqlite3_stmt *statement;
        
        @autoreleasepool {
                int response = sqlite3_prepare_v2(_database, queryUTF8, -1, &statement, nil);
                if (response == SQLITE_OK) {
                        while (sqlite3_step(statement) == SQLITE_ROW) {
                                
                                Link* link=[[Link alloc]init];
                                
                                
                                if ( sqlite3_column_type(statement, 0) != SQLITE_NULL ){
                                        
                                        link.ID = sqlite3_column_int(statement, 0);
                                }
                                else
                                        link.ID = 0;
                                
                                if ( sqlite3_column_type(statement, 1) != SQLITE_NULL ){
                                        
                                        link.CONTENTS_ID = sqlite3_column_int(statement, 1);
                                }
                                else
                                        link.CONTENTS_ID = 0;
                                
                                if ( sqlite3_column_type(statement, 2) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 2);
                                        link.LinkURL = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        link.LinkURL=@"NULL";
                                if ( sqlite3_column_type(statement, 3) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 3);
                                        link.ImageURL = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        link.ImageURL =@"NULL";
                                if ( sqlite3_column_type(statement, 4) != SQLITE_NULL ){
                                        link.SortOrder = sqlite3_column_int(statement, 4);;
                                }
                                else
                                        link.SortOrder= 0;
                                

                                
                                [retval addObject:link];
                        }
                        sqlite3_finalize(statement);
                }
        }
        return retval;
}
- (NSArray*)getHotel{
    
    NSMutableArray *retval = [[NSMutableArray alloc] init];
    NSString *query = @"SELECT * from hotel";
    const char* queryUTF8 = [query UTF8String];
    sqlite3_stmt *statement;
    
    @autoreleasepool {
        int response = sqlite3_prepare_v2(_database, queryUTF8, -1, &statement, nil);
        if (response == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                
                Hotel* hotel=[[Hotel alloc]init];
                
                
                if ( sqlite3_column_type(statement, 0) != SQLITE_NULL ){
                    
                    //int languageID = sqlite3_column_int(statement, 0);
                    //char *nameChars = (char *) sqlite3_column_text(statement, 0);
                    hotel.ID = sqlite3_column_int(statement, 0);
                }
                else
                    hotel.ID = 0;
                
                if ( sqlite3_column_type(statement, 1) != SQLITE_NULL ){
                    char *nameChars = (char *) sqlite3_column_text(statement, 1);
                    hotel.Name  = [[NSString alloc] initWithUTF8String:nameChars];
                }
                else
                    hotel.Name=@"NULL";
                
                if ( sqlite3_column_type(statement, 2) != SQLITE_NULL ){
                    char *nameChars = (char *) sqlite3_column_text(statement, 2);
                    hotel.BookOnlineURL = [[NSString alloc] initWithUTF8String:nameChars];
                }
                else
                    hotel.BookOnlineURL=@"NULL";
                if ( sqlite3_column_type(statement, 3) != SQLITE_NULL ){
                    char *nameChars = (char *) sqlite3_column_text(statement, 3);
                    hotel.Phone = [[NSString alloc] initWithUTF8String:nameChars];
                }
                else
                    hotel.Phone =@"NULL";
                if ( sqlite3_column_type(statement, 4) != SQLITE_NULL ){
                   //char *nameChars = (char *) sqlite3_column_text(statement, 4);
                    hotel.hotalRootConnectID = sqlite3_column_int(statement, 4);;
                }
                else
                    hotel.hotalRootConnectID= 0;
                
                if ( sqlite3_column_type(statement, 5) != SQLITE_NULL ){
                    //char *nameChars = (char *) sqlite3_column_text(statement, 5);
                    hotel.tarvelGuideRootConnectID = sqlite3_column_int(statement, 5);;
                }
                else
                    hotel.tarvelGuideRootConnectID = 0;
                
    
                
                [retval addObject:hotel];
            }
            sqlite3_finalize(statement);
        }
    }
    return retval;
}

- (NSArray*)getContent:(NSString*)ID{
    
    
    NSMutableArray *retval = [[NSMutableArray alloc] init];
    
    NSString *query = [NSString stringWithFormat:@"SELECT * from contents where ID = \"%@\"",ID];
    
    const char* queryUTF8 = [query UTF8String];
    sqlite3_stmt *statement;
    
    @autoreleasepool {
        int response = sqlite3_prepare_v2(_database, queryUTF8, -1, &statement, nil);
        if (response == SQLITE_OK) {

            while (sqlite3_step(statement) == SQLITE_ROW) {
                
               Content * content=[[Content alloc]init];
                
                
                if ( sqlite3_column_type(statement, 0) != SQLITE_NULL ){
                    
                    //int languageID = sqlite3_column_int(statement, 0);
                    //char *nameChars = (char *) sqlite3_column_text(statement, 0);
                    content.ID = sqlite3_column_int(statement, 0);
                }
                else
                    content.ID = 0;
                
                if ( sqlite3_column_type(statement, 1) != SQLITE_NULL ){
                    char *nameChars = (char *) sqlite3_column_text(statement, 1);
                    content.postalCode  = [[NSString alloc] initWithUTF8String:nameChars];
                }
                else
                    content.postalCode = @"NULL";
                
                if ( sqlite3_column_type(statement, 2) != SQLITE_NULL ){
                    content.latitude = sqlite3_column_double(statement, 2);;
                }
                else
                    content.latitude = 0;
                
                if ( sqlite3_column_type(statement, 3) != SQLITE_NULL ){
                     content.longitude = sqlite3_column_double(statement, 3);;
                }
                else
                    content.longitude = 0;
                
                if ( sqlite3_column_type(statement, 4) != SQLITE_NULL ){
                    char *nameChars = (char *) sqlite3_column_text(statement, 4);
                    content.phone  = [[NSString alloc] initWithUTF8String:nameChars];
                }
                else
                     content.phone = @"NULL";;
                
                if ( sqlite3_column_type(statement, 5) != SQLITE_NULL ){
                    char *nameChars = (char *) sqlite3_column_text(statement, 5);
                    content.email  = [[NSString alloc] initWithUTF8String:nameChars];
                }
                else
                    content.email = @"NULL";
                
                if ( sqlite3_column_type(statement, 6) != SQLITE_NULL ){
                    char *nameChars = (char *) sqlite3_column_text(statement, 6);
                    content.websiteUrl  = [[NSString alloc] initWithUTF8String:nameChars];
                }
                else
                    content.websiteUrl = @"NULL";
                if ( sqlite3_column_type(statement, 7) != SQLITE_NULL ){
                    char *nameChars = (char *) sqlite3_column_text(statement, 7);
                    content.onlineBookingUrl  = [[NSString alloc] initWithUTF8String:nameChars];
                }
                else
                    content.onlineBookingUrl = @"NULL";
                if ( sqlite3_column_type(statement, 8) != SQLITE_NULL ){
                    char *nameChars = (char *) sqlite3_column_text(statement, 8);
                    content.mainImage = [[NSString alloc] initWithUTF8String:nameChars];
                }
                else
                    content.mainImage = @"NULL";
                    
                if ( sqlite3_column_type(statement, 9) != SQLITE_NULL ){
                    content.bookmark = sqlite3_column_int(statement, 9);
                }
                else
                    content.bookmark = 0;

                
                
                [retval addObject:content];
            }
            sqlite3_finalize(statement);
        }
    }
    return retval;
}

- (NSArray*)getContentWithCondition:(NSString*)condition{
        
        
        NSMutableArray *retval = [[NSMutableArray alloc] init];
        
        NSString *query = [NSString stringWithFormat:@"SELECT * from contents where %@",condition];
        
        const char* queryUTF8 = [query UTF8String];
        sqlite3_stmt *statement;
        
        @autoreleasepool {
                int response = sqlite3_prepare_v2(_database, queryUTF8, -1, &statement, nil);
                if (response == SQLITE_OK) {
                        
                        while (sqlite3_step(statement) == SQLITE_ROW) {
                                
                                Content * content=[[Content alloc]init];
                                
                                
                                if ( sqlite3_column_type(statement, 0) != SQLITE_NULL ){
                                        
                                        //int languageID = sqlite3_column_int(statement, 0);
                                        //char *nameChars = (char *) sqlite3_column_text(statement, 0);
                                        content.ID = sqlite3_column_int(statement, 0);
                                }
                                else
                                        content.ID = 0;
                                
                                if ( sqlite3_column_type(statement, 1) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 1);
                                        content.postalCode  = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        content.postalCode = @"NULL";
                                
                                if ( sqlite3_column_type(statement, 2) != SQLITE_NULL ){
                                        //  char *nameChars = (char *) sqlite3_column_text(statement, 2);
                                        content.latitude = sqlite3_column_double(statement, 2);;
                                }
                                else
                                        content.latitude = 0;
                                
                                if ( sqlite3_column_type(statement, 3) != SQLITE_NULL ){
                                        content.longitude = sqlite3_column_double(statement, 3);;
                                }
                                else
                                        content.longitude = 0;
                                
                                if ( sqlite3_column_type(statement, 4) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 4);
                                        content.phone  = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        content.phone = @"NULL";;
                                
                                if ( sqlite3_column_type(statement, 5) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 5);
                                        content.email  = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        content.email = @"NULL";
                                
                                if ( sqlite3_column_type(statement, 6) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 6);
                                        content.websiteUrl  = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        content.websiteUrl = @"NULL";
                                if ( sqlite3_column_type(statement, 7) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 7);
                                        content.onlineBookingUrl  = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        content.onlineBookingUrl = @"NULL";
                                if ( sqlite3_column_type(statement, 8) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 8);
                                        content.mainImage = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        content.mainImage = @"NULL";
                                if ( sqlite3_column_type(statement, 9) != SQLITE_NULL ){
                                        content.bookmark = sqlite3_column_int(statement, 9);
                                }
                                else
                                        content.bookmark = 0;
                                
                                
                                [retval addObject:content];
                        }
                        sqlite3_finalize(statement);
                }
        }
        return retval;
}

- (NSArray*)getContentLocationWithMainId:(NSString*)MainIds{
        
        
        NSMutableArray *retval = [[NSMutableArray alloc] init];
        
        NSString *query = [NSString stringWithFormat:@"SELECT * from contents where ID IN (%@)",MainIds];
        
        const char* queryUTF8 = [query UTF8String];
        sqlite3_stmt *statement;
        
        @autoreleasepool {
                int response = sqlite3_prepare_v2(_database, queryUTF8, -1, &statement, nil);
                if (response == SQLITE_OK) {
                        
                        while (sqlite3_step(statement) == SQLITE_ROW) {
                                
                                Content * content=[[Content alloc]init];
                                
                                
                                if ( sqlite3_column_type(statement, 0) != SQLITE_NULL ){
                                        
                                        content.ID = sqlite3_column_int(statement, 0);
                                }
                                else
                                        content.ID = 0;
                                
                                if ( sqlite3_column_type(statement, 1) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 1);
                                        content.postalCode  = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        content.postalCode = @"NULL";
                                
                                if ( sqlite3_column_type(statement, 2) != SQLITE_NULL ){
                                        content.latitude = sqlite3_column_double(statement, 2);;
                                }
                                else
                                        content.latitude = 0;
                                
                                if ( sqlite3_column_type(statement, 3) != SQLITE_NULL ){
                                        content.longitude = sqlite3_column_double(statement, 3);;
                                }
                                else
                                        content.longitude = 0;
                                
                                if ( sqlite3_column_type(statement, 4) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 4);
                                        content.phone  = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        content.phone = @"NULL";;
                                
                                if ( sqlite3_column_type(statement, 5) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 5);
                                        content.email  = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        content.email = @"NULL";
                                
                                if ( sqlite3_column_type(statement, 6) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 6);
                                        content.websiteUrl  = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        content.websiteUrl = @"NULL";
                                if ( sqlite3_column_type(statement, 7) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 7);
                                        content.onlineBookingUrl  = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        content.onlineBookingUrl = @"NULL";
                                if ( sqlite3_column_type(statement, 8) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 8);
                                        content.mainImage = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        content.mainImage = @"NULL";
                                if ( sqlite3_column_type(statement, 9) != SQLITE_NULL ){
                                        content.bookmark = sqlite3_column_int(statement, 9);
                                }
                                else
                                        content.bookmark = 0;
                                
                                
                                [retval addObject:content];
                        }
                        sqlite3_finalize(statement);
                }
        }
        return retval;
}

- (NSArray*)getMapLocationWithMainId:(NSString*)MainIds{
        
        
        NSMutableArray *retval = [[NSMutableArray alloc] init];
        
        NSString *query = [NSString stringWithFormat:
                           @"SELECT * from contents where                                                                                                             contents.Latitude!='' and                                                                                                                       contents.Longitude!='' and   ID IN (%@)",MainIds];
        
        const char* queryUTF8 = [query UTF8String];
        sqlite3_stmt *statement;
        
        @autoreleasepool {
                int response = sqlite3_prepare_v2(_database, queryUTF8, -1, &statement, nil);
                if (response == SQLITE_OK) {
                        
                        while (sqlite3_step(statement) == SQLITE_ROW) {
                                
                                Content * content=[[Content alloc]init];
                                
                                
                                if ( sqlite3_column_type(statement, 0) != SQLITE_NULL ){
                                        
                                        content.ID = sqlite3_column_int(statement, 0);
                                }
                                else
                                        content.ID = 0;
                                
                                if ( sqlite3_column_type(statement, 1) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 1);
                                        content.postalCode  = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        content.postalCode = @"NULL";
                                
                                if ( sqlite3_column_type(statement, 2) != SQLITE_NULL ){
                                        content.latitude = sqlite3_column_double(statement, 2);;
                                }
                                else
                                        content.latitude = 0;
                                
                                if ( sqlite3_column_type(statement, 3) != SQLITE_NULL ){
                                        content.longitude = sqlite3_column_double(statement, 3);;
                                }
                                else
                                        content.longitude = 0;
                                
                                if ( sqlite3_column_type(statement, 4) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 4);
                                        content.phone  = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        content.phone = @"NULL";;
                                
                                if ( sqlite3_column_type(statement, 5) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 5);
                                        content.email  = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        content.email = @"NULL";
                                
                                if ( sqlite3_column_type(statement, 6) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 6);
                                        content.websiteUrl  = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        content.websiteUrl = @"NULL";
                                if ( sqlite3_column_type(statement, 7) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 7);
                                        content.onlineBookingUrl  = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        content.onlineBookingUrl = @"NULL";
                                if ( sqlite3_column_type(statement, 8) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 8);
                                        content.mainImage = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        content.mainImage = @"NULL";
                                if ( sqlite3_column_type(statement, 9) != SQLITE_NULL ){
                                        content.bookmark = sqlite3_column_int(statement, 9);
                                }
                                else
                                        content.bookmark = 0;
                                
                                
                                [retval addObject:content];
                        }
                        sqlite3_finalize(statement);
                }
        }
        return retval;
}

- (NSArray*)getContentsLang:(NSString*)language_ID  mainID:(NSString*)Main_ID{

    NSMutableArray *retval = [[NSMutableArray alloc] init];
    
    NSString *query = [NSString stringWithFormat:@"SELECT * from contents_lang where LANGUAGES_ID = \"%@\" AND MAIN_ID = \"%@\"",language_ID,Main_ID];
    
    
    const char* queryUTF8 = [query UTF8String];
    sqlite3_stmt *statement;
    
    @autoreleasepool {
        int response = sqlite3_prepare_v2(_database, queryUTF8, -1, &statement, nil);
        if (response == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                
                ContentLanguage* content=[[ContentLanguage alloc]init];
                
                
                if ( sqlite3_column_type(statement, 0) != SQLITE_NULL ){
                    
                    content.ID_ML = sqlite3_column_int(statement, 0);
                }
                else
                    content.ID_ML = 0;
                    
                if ( sqlite3_column_type(statement, 1) != SQLITE_NULL ){
                    
                    content.MAIN_ID = sqlite3_column_int(statement, 1);
                }
                else
                    content.MAIN_ID = 0;
                if ( sqlite3_column_type(statement, 2) != SQLITE_NULL ){
                    
                    content.LANGUAGES_ID = sqlite3_column_int(statement, 2);
                }
                else
                    content.LANGUAGES_ID = 0;
                if ( sqlite3_column_type(statement, 3) != SQLITE_NULL ){
                    
                    content.IsActive = sqlite3_column_int(statement, 3);
                }
                else
                    content.IsActive = 0;
                
                if ( sqlite3_column_type(statement, 4) != SQLITE_NULL ){
                    char *nameChars = (char *) sqlite3_column_text(statement, 4);
                    content.Name  = [[NSString alloc] initWithUTF8String:nameChars];
                }
                else
                    content.Name=@"NULL";
                
                if ( sqlite3_column_type(statement, 5) != SQLITE_NULL ){
                    char *nameChars = (char *) sqlite3_column_text(statement, 5);
                    content.Description = [[NSString alloc] initWithUTF8String:nameChars];
                }
                else
                    content.Description = @"NULL";
                if ( sqlite3_column_type(statement, 6) != SQLITE_NULL ){
                    char *nameChars = (char *) sqlite3_column_text(statement, 6);
                    content.Address = [[NSString alloc] initWithUTF8String:nameChars];
                }
                else
                    content. Address = @"NULL";
                if ( sqlite3_column_type(statement, 7) != SQLITE_NULL ){
                    char *nameChars = (char *) sqlite3_column_text(statement, 7);
                    content.City = [[NSString alloc] initWithUTF8String:nameChars];
                }
                else
                    content.City=@"NULL";
                if ( sqlite3_column_type(statement, 8) != SQLITE_NULL ){
                    char *nameChars = (char *) sqlite3_column_text(statement, 8);
                    content.Country = [[NSString alloc] initWithUTF8String:nameChars];
                }
                else
                    content.Country=@"NULL";
                    
                
               
                
                [retval addObject:content];
            }
            sqlite3_finalize(statement);
        }
    }
    return retval;



}

- (NSArray*)getContentsParentMap:(NSString*)language_ID  isPinCondition:(NSString*)isPinCondition{
        
        NSMutableArray *retval = [[NSMutableArray alloc] init];
        
        NSString *query = [NSString stringWithFormat:@"select * from contents_parent_map where languages_ID=\"%@\" and ispin %@",language_ID,isPinCondition];
        
        
        const char* queryUTF8 = [query UTF8String];
        sqlite3_stmt *statement;
        
        @autoreleasepool {
                int response = sqlite3_prepare_v2(_database, queryUTF8, -1, &statement, nil);
                if (response == SQLITE_OK) {
                        while (sqlite3_step(statement) == SQLITE_ROW) {
                                
                                ContentsParentMap* content=[[ContentsParentMap alloc]init];
                                
                                
                                if ( sqlite3_column_type(statement, 0) != SQLITE_NULL ){
                                        
                                        content.ID = sqlite3_column_int(statement, 0);
                                }
                                else
                                        content.ID = 0;
                                
                                if ( sqlite3_column_type(statement, 1) != SQLITE_NULL ){
                                        
                                        content.LANGUAGES_ID = sqlite3_column_int(statement, 1);
                                }
                                else
                                        content.LANGUAGES_ID = 0;
                                if ( sqlite3_column_type(statement, 2) != SQLITE_NULL ){
                                        
                                        content.CONTENTS_ID = sqlite3_column_int(statement, 2);
                                }
                                else
                                        content.CONTENTS_ID = 0;
                                if ( sqlite3_column_type(statement, 3) != SQLITE_NULL ){
                                        
                                        content.LEVEL1_PARENT_ID = sqlite3_column_int(statement, 3);
                                }
                                else
                                        content.LEVEL1_PARENT_ID = 0;
                                if ( sqlite3_column_type(statement, 4) != SQLITE_NULL ){
                                        
                                        content.LEVEL2_PARENT_ID = sqlite3_column_int(statement, 4);
                                }
                                else
                                        content.LEVEL2_PARENT_ID = 0;
                                if ( sqlite3_column_type(statement, 5) != SQLITE_NULL ){
                                        
                                        content.IsPin = sqlite3_column_int(statement, 5);
                                }
                                else
                                        content.IsPin = 0;
                                if ( sqlite3_column_type(statement, 6) != SQLITE_NULL ){
                                        
                                        content.SortOrder = sqlite3_column_int(statement, 6);
                                }
                                else
                                        content.SortOrder = 0;
                                
                                
                                
                                [retval addObject:content];
                        }
                        sqlite3_finalize(statement);
                }
        }
        return retval;
        
        
        
}

- (NSArray*)getAllContentsMap:(NSString*)language_ID  isPinCondition:(NSString*)isPinCondition{
        
        NSMutableArray *retval = [[NSMutableArray alloc] init];
        
        NSString *query = [NSString stringWithFormat:
                           @"SELECT * FROM contents INNER JOIN contents_lang ON contents.ID=contents_lang.MAIN_ID                                                                                                                                                            where  contents_lang.LANGUAGES_ID=\"%@\" and                                                                                                                            contents_lang.IsActive=1 and                                                                                                                                            contents.ID in                                                                                                                                                  (select CONTENTS_ID from contents_parent_map where                                                                                                              LANGUAGES_ID=\"%@\" and ispin %@)",language_ID,language_ID,isPinCondition];
        
        
        const char* queryUTF8 = [query UTF8String];
        sqlite3_stmt *statement;
        
        @autoreleasepool {
                int response = sqlite3_prepare_v2(_database, queryUTF8, -1, &statement, nil);
                if (response == SQLITE_OK) {
                        while (sqlite3_step(statement) == SQLITE_ROW) {
                                
                                MapLocation * content=[[MapLocation alloc]init];
                                
                                //Conetnt
                                
                                if ( sqlite3_column_type(statement, 0) != SQLITE_NULL ){
                                        
                                        content.content.ID = sqlite3_column_int(statement, 0);
                                }
                                else
                                        content.content.ID = 0;
                                
                                if ( sqlite3_column_type(statement, 1) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 1);
                                        content.content.postalCode  = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        content.content.postalCode = @"NULL";
                                
                                if ( sqlite3_column_type(statement, 2) != SQLITE_NULL ){
                                        content.content.latitude = sqlite3_column_double(statement, 2);;
                                }
                                else
                                        content.content.latitude = 0;
                                
                                if ( sqlite3_column_type(statement, 3) != SQLITE_NULL ){
                                        content.content.longitude = sqlite3_column_double(statement, 3);;
                                }
                                else
                                        content.content.longitude = 0;
                                
                                if ( sqlite3_column_type(statement, 4) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 4);
                                        content.content.phone  = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        content.content.phone = @"NULL";;
                                
                                if ( sqlite3_column_type(statement, 5) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 5);
                                        content.content.email  = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        content.content.email = @"NULL";
                                
                                if ( sqlite3_column_type(statement, 6) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 6);
                                        content.content.websiteUrl  = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        content.content.websiteUrl = @"NULL";
                                if ( sqlite3_column_type(statement, 7) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 7);
                                        content.content.onlineBookingUrl  = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        content.content.onlineBookingUrl = @"NULL";
                                if ( sqlite3_column_type(statement, 8) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 8);
                                        content.content.mainImage = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        content.content.mainImage = @"NULL";
                                if ( sqlite3_column_type(statement, 9) != SQLITE_NULL ){
                                        content.content.bookmark = sqlite3_column_int(statement, 9);
                                }
                                else
                                        content.content.bookmark = 0;
                                
                                //Conetnt Language
                                
                                if ( sqlite3_column_type(statement, 10) != SQLITE_NULL ){
                                        content.contentLanguage.ID_ML = sqlite3_column_int(statement, 10);
                                }
                                else
                                        content.contentLanguage.ID_ML = 0;
                                
                                if ( sqlite3_column_type(statement, 11) != SQLITE_NULL ){
                                        content.contentLanguage.MAIN_ID = sqlite3_column_int(statement, 11);
                                }
                                else
                                        content.contentLanguage.MAIN_ID = 0;
                                
                                if ( sqlite3_column_type(statement, 12) != SQLITE_NULL ){
                                        content.contentLanguage.LANGUAGES_ID = sqlite3_column_int(statement, 12);
                                }
                                else
                                        content.contentLanguage.LANGUAGES_ID = 0;
                                
                                if ( sqlite3_column_type(statement, 13) != SQLITE_NULL ){
                                        content.contentLanguage.IsActive = sqlite3_column_int(statement, 13);
                                }
                                else
                                        content.contentLanguage.IsActive = 0;
                                
                                if ( sqlite3_column_type(statement, 14) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 14);
                                        content.contentLanguage.Name = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        content.contentLanguage.Name = @"NULL";
                                
                                if ( sqlite3_column_type(statement, 15) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 15);
                                        content.contentLanguage.Description = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        content.contentLanguage.Description = @"NULL";
                                
                                if ( sqlite3_column_type(statement, 16) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 16);
                                        content.contentLanguage.Address = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        content.contentLanguage.Address = @"NULL";
                                
                                if ( sqlite3_column_type(statement, 17) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 17);
                                        content.contentLanguage.City = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        content.contentLanguage.City = @"NULL";
                                
                                if ( sqlite3_column_type(statement, 18) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 18);
                                        content.contentLanguage.Country = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        content.contentLanguage.Country = @"NULL";
                                
                                
                                [retval addObject:content];
                        }
                        sqlite3_finalize(statement);
                }
        }
        return retval;
        
        
        
}

- (NSArray*)getAllBookmarkMapData:(NSString*)language_ID{
        
        NSMutableArray *retval = [[NSMutableArray alloc] init];
        
        NSString *query = [NSString stringWithFormat:
        @"SELECT * FROM contents INNER JOIN contents_lang ON contents.ID=contents_lang.MAIN_ID                                                                                                                                                           where  contents_lang.LANGUAGES_ID=\"%@\" and                                                                                                                            contents_lang.IsActive=1 and                                                                                                             contents.Latitude!='' and                                                                                                                       contents.Longitude!='' and                                                                                            contents.Bookmark>0                                                                                                                                          ",language_ID];
        
        
        const char* queryUTF8 = [query UTF8String];
        sqlite3_stmt *statement;
        
        @autoreleasepool {
                int response = sqlite3_prepare_v2(_database, queryUTF8, -1, &statement, nil);
                if (response == SQLITE_OK) {
                        while (sqlite3_step(statement) == SQLITE_ROW) {
                                
                                MapLocation * content=[[MapLocation alloc]init];
                                
                                //Conetnt
                                
                                if ( sqlite3_column_type(statement, 0) != SQLITE_NULL ){
                                        
                                        content.content.ID = sqlite3_column_int(statement, 0);
                                }
                                else
                                        content.content.ID = 0;
                                
                                if ( sqlite3_column_type(statement, 1) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 1);
                                        content.content.postalCode  = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        content.content.postalCode = @"NULL";
                                
                                if ( sqlite3_column_type(statement, 2) != SQLITE_NULL ){
                                        content.content.latitude = sqlite3_column_double(statement, 2);;
                                }
                                else
                                        content.content.latitude = 0;
                                
                                if ( sqlite3_column_type(statement, 3) != SQLITE_NULL ){
                                        content.content.longitude = sqlite3_column_double(statement, 3);;
                                }
                                else
                                        content.content.longitude = 0;
                                
                                if ( sqlite3_column_type(statement, 4) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 4);
                                        content.content.phone  = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        content.content.phone = @"NULL";;
                                
                                if ( sqlite3_column_type(statement, 5) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 5);
                                        content.content.email  = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        content.content.email = @"NULL";
                                
                                if ( sqlite3_column_type(statement, 6) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 6);
                                        content.content.websiteUrl  = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        content.content.websiteUrl = @"NULL";
                                if ( sqlite3_column_type(statement, 7) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 7);
                                        content.content.onlineBookingUrl  = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        content.content.onlineBookingUrl = @"NULL";
                                if ( sqlite3_column_type(statement, 8) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 8);
                                        content.content.mainImage = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        content.content.mainImage = @"NULL";
                                if ( sqlite3_column_type(statement, 9) != SQLITE_NULL ){
                                        content.content.bookmark = sqlite3_column_int(statement, 9);
                                }
                                else
                                        content.content.bookmark = 0;
                                
                                //Conetnt Language
                                
                                if ( sqlite3_column_type(statement, 10) != SQLITE_NULL ){
                                        content.contentLanguage.ID_ML = sqlite3_column_int(statement, 10);
                                }
                                else
                                        content.contentLanguage.ID_ML = 0;
                                
                                if ( sqlite3_column_type(statement, 11) != SQLITE_NULL ){
                                        content.contentLanguage.MAIN_ID = sqlite3_column_int(statement, 11);
                                }
                                else
                                        content.contentLanguage.MAIN_ID = 0;
                                
                                if ( sqlite3_column_type(statement, 12) != SQLITE_NULL ){
                                        content.contentLanguage.LANGUAGES_ID = sqlite3_column_int(statement, 12);
                                }
                                else
                                        content.contentLanguage.LANGUAGES_ID = 0;
                                
                                if ( sqlite3_column_type(statement, 13) != SQLITE_NULL ){
                                        content.contentLanguage.IsActive = sqlite3_column_int(statement, 13);
                                }
                                else
                                        content.contentLanguage.IsActive = 0;
                                
                                if ( sqlite3_column_type(statement, 14) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 14);
                                        content.contentLanguage.Name = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        content.contentLanguage.Name = @"NULL";
                                
                                if ( sqlite3_column_type(statement, 15) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 15);
                                        content.contentLanguage.Description = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        content.contentLanguage.Description = @"NULL";
                                
                                if ( sqlite3_column_type(statement, 16) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 16);
                                        content.contentLanguage.Address = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        content.contentLanguage.Address = @"NULL";
                                
                                if ( sqlite3_column_type(statement, 17) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 17);
                                        content.contentLanguage.City = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        content.contentLanguage.City = @"NULL";
                                
                                if ( sqlite3_column_type(statement, 18) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 18);
                                        content.contentLanguage.Country = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        content.contentLanguage.Country = @"NULL";
                                
                                
                                [retval addObject:content];
                        }
                        sqlite3_finalize(statement);
                }
        }
        return retval;
        
        
        
}

- (NSArray*)getAllContentsMapTravelGuideData:(NSString*)language_ID{
        
        NSMutableArray *retval = [[NSMutableArray alloc] init];
        
        NSString *query = [NSString stringWithFormat:
        @"SELECT * FROM contents INNER JOIN contents_lang ON contents.ID=contents_lang.MAIN_ID                                                                                                                                                           where  contents_lang.LANGUAGES_ID=\"%@\" and                                                                                                                            contents_lang.IsActive=1 and                                                                                                            contents.Latitude!='' and                                                                                                                       contents.Longitude!=''                                                                                                                                          ",language_ID];
        
        
        const char* queryUTF8 = [query UTF8String];
        sqlite3_stmt *statement;
        
        @autoreleasepool {
                int response = sqlite3_prepare_v2(_database, queryUTF8, -1, &statement, nil);
                if (response == SQLITE_OK) {
                        while (sqlite3_step(statement) == SQLITE_ROW) {
                                
                                MapLocation * content=[[MapLocation alloc]init];
                                
                                //Conetnt
                                
                                if ( sqlite3_column_type(statement, 0) != SQLITE_NULL ){
                                        
                                        content.content.ID = sqlite3_column_int(statement, 0);
                                }
                                else
                                        content.content.ID = 0;
                                
                                if ( sqlite3_column_type(statement, 1) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 1);
                                        content.content.postalCode  = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        content.content.postalCode = @"NULL";
                                
                                if ( sqlite3_column_type(statement, 2) != SQLITE_NULL ){
                                        content.content.latitude = sqlite3_column_double(statement, 2);;
                                }
                                else
                                        content.content.latitude = 0;
                                
                                if ( sqlite3_column_type(statement, 3) != SQLITE_NULL ){
                                        content.content.longitude = sqlite3_column_double(statement, 3);;
                                }
                                else
                                        content.content.longitude = 0;
                                
                                if ( sqlite3_column_type(statement, 4) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 4);
                                        content.content.phone  = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        content.content.phone = @"NULL";;
                                
                                if ( sqlite3_column_type(statement, 5) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 5);
                                        content.content.email  = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        content.content.email = @"NULL";
                                
                                if ( sqlite3_column_type(statement, 6) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 6);
                                        content.content.websiteUrl  = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        content.content.websiteUrl = @"NULL";
                                if ( sqlite3_column_type(statement, 7) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 7);
                                        content.content.onlineBookingUrl  = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        content.content.onlineBookingUrl = @"NULL";
                                if ( sqlite3_column_type(statement, 8) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 8);
                                        content.content.mainImage = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        content.content.mainImage = @"NULL";
                                if ( sqlite3_column_type(statement, 9) != SQLITE_NULL ){
                                        content.content.bookmark = sqlite3_column_int(statement, 9);
                                }
                                else
                                        content.content.bookmark = 0;
                                
                                //Conetnt Language
                                
                                if ( sqlite3_column_type(statement, 10) != SQLITE_NULL ){
                                        content.contentLanguage.ID_ML = sqlite3_column_int(statement, 10);
                                }
                                else
                                        content.contentLanguage.ID_ML = 0;
                                
                                if ( sqlite3_column_type(statement, 11) != SQLITE_NULL ){
                                        content.contentLanguage.MAIN_ID = sqlite3_column_int(statement, 11);
                                }
                                else
                                        content.contentLanguage.MAIN_ID = 0;
                                
                                if ( sqlite3_column_type(statement, 12) != SQLITE_NULL ){
                                        content.contentLanguage.LANGUAGES_ID = sqlite3_column_int(statement, 12);
                                }
                                else
                                        content.contentLanguage.LANGUAGES_ID = 0;
                                
                                if ( sqlite3_column_type(statement, 13) != SQLITE_NULL ){
                                        content.contentLanguage.IsActive = sqlite3_column_int(statement, 13);
                                }
                                else
                                        content.contentLanguage.IsActive = 0;

                                if ( sqlite3_column_type(statement, 14) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 14);
                                        content.contentLanguage.Name = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        content.contentLanguage.Name = @"NULL";

                                if ( sqlite3_column_type(statement, 15) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 15);
                                        content.contentLanguage.Description = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        content.contentLanguage.Description = @"NULL";

                                if ( sqlite3_column_type(statement, 16) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 16);
                                        content.contentLanguage.Address = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        content.contentLanguage.Address = @"NULL";
                                
                                if ( sqlite3_column_type(statement, 17) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 17);
                                        content.contentLanguage.City = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        content.contentLanguage.City = @"NULL";
                                
                                if ( sqlite3_column_type(statement, 18) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 18);
                                        content.contentLanguage.Country = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        content.contentLanguage.Country = @"NULL";
                                
                                
                                [retval addObject:content];
                        }
                        sqlite3_finalize(statement);
                }
        }
        return retval;
        
        
        
}

- (NSArray*)getChildContentsMap:(NSString*)language_ID  parentID:(NSString*)parentID{
        
        NSMutableArray *retval = [[NSMutableArray alloc] init];
        
        NSString *query = [NSString stringWithFormat:
        @"SELECT * from contents_lang  INNER JOIN contents_parents ON  contents_parents.CONTENTS_ID=contents_lang.MAIN_ID                                                    INNER JOIN contents ON contents.ID=contents_lang.MAIN_ID                                                                           where contents_lang.LANGUAGES_ID =\"%@\" AND                                                                                            contents_lang.MAIN_ID IN                                                                                                           (select CONTENTS_ID from contents_parents                                                                                               where PARENTCONTENTS_ID=\"%@\")",language_ID,parentID];
        
        
        const char* queryUTF8 = [query UTF8String];
        sqlite3_stmt *statement;
        
        @autoreleasepool {
                int response = sqlite3_prepare_v2(_database, queryUTF8, -1, &statement, nil);
                if (response == SQLITE_OK) {
                        while (sqlite3_step(statement) == SQLITE_ROW) {
                                
                                MapLocation * content=[[MapLocation alloc]init];
                                
                                 //Conetnt Language
                                
                                if ( sqlite3_column_type(statement, 0) != SQLITE_NULL ){
                                        content.contentLanguage.ID_ML = sqlite3_column_int(statement, 0);
                                }
                                else
                                        content.contentLanguage.ID_ML = 0;
                                
                                if ( sqlite3_column_type(statement, 1) != SQLITE_NULL ){
                                        content.contentLanguage.MAIN_ID = sqlite3_column_int(statement, 1);
                                }
                                else
                                        content.contentLanguage.MAIN_ID = 0;
                                
                                if ( sqlite3_column_type(statement, 2) != SQLITE_NULL ){
                                        content.contentLanguage.LANGUAGES_ID = sqlite3_column_int(statement, 2);
                                }
                                else
                                        content.contentLanguage.LANGUAGES_ID = 0;
                                
                                if ( sqlite3_column_type(statement, 3) != SQLITE_NULL ){
                                        content.contentLanguage.IsActive = sqlite3_column_int(statement, 3);
                                }
                                else
                                        content.contentLanguage.IsActive = 0;
                                
                                if ( sqlite3_column_type(statement, 4) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 4);
                                        content.contentLanguage.Name = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        content.contentLanguage.Name = @"NULL";
                                
                                if ( sqlite3_column_type(statement, 5) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 5);
                                        content.contentLanguage.Description = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        content.contentLanguage.Description = @"NULL";
                                
                                if ( sqlite3_column_type(statement, 6) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 6);
                                        content.contentLanguage.Address = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        content.contentLanguage.Address = @"NULL";
                                
                                if ( sqlite3_column_type(statement, 7) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 7);
                                        content.contentLanguage.City = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        content.contentLanguage.City = @"NULL";
                                
                                if ( sqlite3_column_type(statement, 8) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 8);
                                        content.contentLanguage.Country = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        content.contentLanguage.Country = @"NULL";
                                
                                if ( sqlite3_column_type(statement, 12) != SQLITE_NULL ){
                                        
                                        content.contentLanguage.SortOrder = sqlite3_column_int(statement, 12);
                                }
                                else
                                        content.contentLanguage.SortOrder = 0;
                                
                                
                                //Conetnt
                                
                                if ( sqlite3_column_type(statement, 13) != SQLITE_NULL ){
                                        
                                        content.content.ID = sqlite3_column_int(statement, 13);
                                }
                                else
                                        content.content.ID = 0;
                                
                                if ( sqlite3_column_type(statement, 14) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 14);
                                        content.content.postalCode  = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        content.content.postalCode = @"NULL";
                                
                                if ( sqlite3_column_type(statement, 15) != SQLITE_NULL ){
                                        content.content.latitude = sqlite3_column_double(statement, 15);;
                                }
                                else
                                        content.content.latitude = 0;
                                
                                if ( sqlite3_column_type(statement, 16) != SQLITE_NULL ){
                                        content.content.longitude = sqlite3_column_double(statement, 16);;
                                }
                                else
                                        content.content.longitude = 0;
                                
                                if ( sqlite3_column_type(statement, 17) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 17);
                                        content.content.phone  = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        content.content.phone = @"NULL";;
                                
                                if ( sqlite3_column_type(statement, 18) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 18);
                                        content.content.email  = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        content.content.email = @"NULL";
                                
                                if ( sqlite3_column_type(statement, 19) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 19);
                                        content.content.websiteUrl  = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        content.content.websiteUrl = @"NULL";
                                if ( sqlite3_column_type(statement, 20) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 20);
                                        content.content.onlineBookingUrl  = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        content.content.onlineBookingUrl = @"NULL";
                                if ( sqlite3_column_type(statement, 21) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 21);
                                        content.content.mainImage = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        content.content.mainImage = @"NULL";
                                if ( sqlite3_column_type(statement, 22) != SQLITE_NULL ){
                                        content.content.bookmark = sqlite3_column_int(statement, 22);
                                }
                                else
                                        content.content.bookmark = 0;
                                

                                
                                
                                [retval addObject:content];
                        }
                        sqlite3_finalize(statement);
                }
        }
        return retval;
        
        
        
}

- (NSArray*)getAllContentsData:(NSString*)language_ID  mainID:(NSString*)Main_ID{
        
        NSMutableArray *retval = [[NSMutableArray alloc] init];
        
        NSString *query = [NSString stringWithFormat:
                @"SELECT * FROM contents INNER JOIN contents_lang ON contents.ID=contents_lang.MAIN_ID where contents.ID = \"%@\" and LANGUAGES_ID = \"%@\"",Main_ID,language_ID];
        
        
        const char* queryUTF8 = [query UTF8String];
        sqlite3_stmt *statement;
        
        @autoreleasepool {
                int response = sqlite3_prepare_v2(_database, queryUTF8, -1, &statement, nil);
                if (response == SQLITE_OK) {
                        while (sqlite3_step(statement) == SQLITE_ROW) {
                                
                                MapLocation * content=[[MapLocation alloc]init];
                                
                                //Conetnt
                                
                                if ( sqlite3_column_type(statement, 0) != SQLITE_NULL ){
                                        
                                        content.content.ID = sqlite3_column_int(statement, 0);
                                }
                                else
                                        content.content.ID = 0;
                                
                                if ( sqlite3_column_type(statement, 1) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 1);
                                        content.content.postalCode  = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        content.content.postalCode = @"NULL";
                                
                                if ( sqlite3_column_type(statement, 2) != SQLITE_NULL ){
                                        content.content.latitude = sqlite3_column_double(statement, 2);;
                                }
                                else
                                        content.content.latitude = 0;
                                
                                if ( sqlite3_column_type(statement, 3) != SQLITE_NULL ){
                                        content.content.longitude = sqlite3_column_double(statement, 3);;
                                }
                                else
                                        content.content.longitude = 0;
                                
                                if ( sqlite3_column_type(statement, 4) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 4);
                                        content.content.phone  = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        content.content.phone = @"NULL";;
                                
                                if ( sqlite3_column_type(statement, 5) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 5);
                                        content.content.email  = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        content.content.email = @"NULL";
                                
                                if ( sqlite3_column_type(statement, 6) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 6);
                                        content.content.websiteUrl  = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        content.content.websiteUrl = @"NULL";
                                if ( sqlite3_column_type(statement, 7) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 7);
                                        content.content.onlineBookingUrl  = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        content.content.onlineBookingUrl = @"NULL";
                                if ( sqlite3_column_type(statement, 8) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 8);
                                        content.content.mainImage = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        content.content.mainImage = @"NULL";
                                if ( sqlite3_column_type(statement, 9) != SQLITE_NULL ){
                                        content.content.bookmark = sqlite3_column_int(statement, 9);
                                }
                                else
                                        content.content.bookmark = 0;
                                
                                //Conetnt Language
                                
                                if ( sqlite3_column_type(statement, 10) != SQLITE_NULL ){
                                        content.contentLanguage.ID_ML = sqlite3_column_int(statement, 10);
                                }
                                else
                                        content.contentLanguage.ID_ML = 0;
                                
                                if ( sqlite3_column_type(statement, 11) != SQLITE_NULL ){
                                        content.contentLanguage.MAIN_ID = sqlite3_column_int(statement, 11);
                                }
                                else
                                        content.contentLanguage.MAIN_ID = 0;
                                
                                if ( sqlite3_column_type(statement, 12) != SQLITE_NULL ){
                                        content.contentLanguage.LANGUAGES_ID = sqlite3_column_int(statement, 12);
                                }
                                else
                                        content.contentLanguage.LANGUAGES_ID = 0;
                                
                                if ( sqlite3_column_type(statement, 13) != SQLITE_NULL ){
                                        content.contentLanguage.IsActive = sqlite3_column_int(statement, 13);
                                }
                                else
                                        content.contentLanguage.IsActive = 0;
                                
                                if ( sqlite3_column_type(statement, 14) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 14);
                                        content.contentLanguage.Name = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        content.contentLanguage.Name = @"NULL";
                                
                                if ( sqlite3_column_type(statement, 15) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 15);
                                        content.contentLanguage.Description = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        content.contentLanguage.Description = @"NULL";
                                
                                if ( sqlite3_column_type(statement, 16) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 16);
                                        content.contentLanguage.Address = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        content.contentLanguage.Address = @"NULL";
                                
                                if ( sqlite3_column_type(statement, 17) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 17);
                                        content.contentLanguage.City = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        content.contentLanguage.City = @"NULL";
                                
                                if ( sqlite3_column_type(statement, 18) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 18);
                                        content.contentLanguage.Country = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        content.contentLanguage.Country = @"NULL";
                                
                                
                                [retval addObject:content];
                        }
                        sqlite3_finalize(statement);
                }
        }
        return retval;
        
        
        
}

- (NSArray*)getChildContentsLang:(NSString*)language_ID  mainID:(NSString*)Main_ID{
        
        NSMutableArray *retval = [[NSMutableArray alloc] init];
        
        NSString *query = [NSString stringWithFormat:
        @"SELECT * from contents_lang INNER JOIN contents_parents ON contents_parents.CONTENTS_ID=contents_lang.MAIN_ID                                                                                                                                                                   where contents_lang.LANGUAGES_ID = \"%@\" AND                                                                                                                                         contents_lang.MAIN_ID IN                                                                                                                                                                                      (select CONTENTS_ID from contents_parents                                                                                                                                                       where PARENTCONTENTS_ID=\"%@\")",language_ID,Main_ID];
        
        
        const char* queryUTF8 = [query UTF8String];
        sqlite3_stmt *statement;
        
        @autoreleasepool {
                int response = sqlite3_prepare_v2(_database, queryUTF8, -1, &statement, nil);
                if (response == SQLITE_OK) {
                        while (sqlite3_step(statement) == SQLITE_ROW) {
                                
                                ContentLanguage* content=[[ContentLanguage alloc]init];
                                
                                
                                if ( sqlite3_column_type(statement, 0) != SQLITE_NULL ){
                                        
                                        content.ID_ML = sqlite3_column_int(statement, 0);
                                }
                                else
                                        content.ID_ML = 0;
                                
                                if ( sqlite3_column_type(statement, 1) != SQLITE_NULL ){
                                        
                                        content.MAIN_ID = sqlite3_column_int(statement, 1);
                                }
                                else
                                        content.MAIN_ID = 0;
                                if ( sqlite3_column_type(statement, 2) != SQLITE_NULL ){
                                        
                                        content.LANGUAGES_ID = sqlite3_column_int(statement, 2);
                                }
                                else
                                        content.LANGUAGES_ID = 0;
                                if ( sqlite3_column_type(statement, 3) != SQLITE_NULL ){
                                        
                                        content.IsActive = sqlite3_column_int(statement, 3);
                                }
                                else
                                        content.IsActive = 0;
                                
                                if ( sqlite3_column_type(statement, 4) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 4);
                                        content.Name  = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        content.Name=@"NULL";
                                
                                if ( sqlite3_column_type(statement, 5) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 5);
                                        content.Description = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        content.Description = @"NULL";
                                if ( sqlite3_column_type(statement, 6) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 6);
                                        content.Address = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        content. Address = @"NULL";
                                if ( sqlite3_column_type(statement, 7) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 7);
                                        content.City = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        content.City=@"NULL";
                                if ( sqlite3_column_type(statement, 8) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 8);
                                        content.Country = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        content.Country=@"NULL";
                                
                                if ( sqlite3_column_type(statement, 12) != SQLITE_NULL ){
                                        
                                        content.SortOrder = sqlite3_column_int(statement, 12);
                                }
                                else
                                        content.SortOrder = 0;
                                
                                
                                
                                
                                [retval addObject:content];
                        }
                        sqlite3_finalize(statement);
                }
        }
        return retval;
        
        
        
}

- (NSArray*)getContentsChildWithParentID:(NSString*)parentID{
        
        NSMutableArray *retval = [[NSMutableArray alloc] init];
        
        NSString *query = [NSString stringWithFormat:
                           @"select CONTENTS_ID from contents_parents where PARENTCONTENTS_ID=\"%@\"",parentID];
        
        
        const char* queryUTF8 = [query UTF8String];
        sqlite3_stmt *statement;
        
        @autoreleasepool {
                int response = sqlite3_prepare_v2(_database, queryUTF8, -1, &statement, nil);
                if (response == SQLITE_OK) {
                        while (sqlite3_step(statement) == SQLITE_ROW) {
                                
                                long contentsId;
                                
                                
                                if ( sqlite3_column_type(statement, 0) != SQLITE_NULL ){
                                        
                                        contentsId = sqlite3_column_int(statement, 0);
                                }
                                else
                                        contentsId = 0;
                                
                                [retval addObject:[NSNumber numberWithLong:contentsId]];
                        }
                        sqlite3_finalize(statement);
                }
        }
        return retval;
        
        
        
}


- (NSArray*)getAllBookmarkContentsData:(NSString*)language_ID{
        
        NSMutableArray *retval = [[NSMutableArray alloc] init];
        
        NSString *query = [NSString stringWithFormat:
        @"SELECT * FROM contents INNER JOIN contents_lang ON contents.ID=contents_lang.MAIN_ID where contents.Bookmark > 0 and LANGUAGES_ID = \"%@\"",language_ID];
        
        
        const char* queryUTF8 = [query UTF8String];
        sqlite3_stmt *statement;
        
        @autoreleasepool {
                int response = sqlite3_prepare_v2(_database, queryUTF8, -1, &statement, nil);
                if (response == SQLITE_OK) {
                        while (sqlite3_step(statement) == SQLITE_ROW) {
                                
                                MapLocation * content=[[MapLocation alloc]init];
                                
                                //Conetnt
                                
                                if ( sqlite3_column_type(statement, 0) != SQLITE_NULL ){
                                        
                                        content.content.ID = sqlite3_column_int(statement, 0);
                                }
                                else
                                        content.content.ID = 0;
                                
                                if ( sqlite3_column_type(statement, 1) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 1);
                                        content.content.postalCode  = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        content.content.postalCode = @"NULL";
                                
                                if ( sqlite3_column_type(statement, 2) != SQLITE_NULL ){
                                        content.content.latitude = sqlite3_column_double(statement, 2);;
                                }
                                else
                                        content.content.latitude = 0;
                                
                                if ( sqlite3_column_type(statement, 3) != SQLITE_NULL ){
                                        content.content.longitude = sqlite3_column_double(statement, 3);;
                                }
                                else
                                        content.content.longitude = 0;
                                
                                if ( sqlite3_column_type(statement, 4) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 4);
                                        content.content.phone  = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        content.content.phone = @"NULL";;
                                
                                if ( sqlite3_column_type(statement, 5) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 5);
                                        content.content.email  = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        content.content.email = @"NULL";
                                
                                if ( sqlite3_column_type(statement, 6) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 6);
                                        content.content.websiteUrl  = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        content.content.websiteUrl = @"NULL";
                                if ( sqlite3_column_type(statement, 7) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 7);
                                        content.content.onlineBookingUrl  = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        content.content.onlineBookingUrl = @"NULL";
                                if ( sqlite3_column_type(statement, 8) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 8);
                                        content.content.mainImage = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        content.content.mainImage = @"NULL";
                                if ( sqlite3_column_type(statement, 9) != SQLITE_NULL ){
                                        content.content.bookmark = sqlite3_column_int(statement, 9);
                                }
                                else
                                        content.content.bookmark = 0;
                                
                                //Conetnt Language
                                
                                if ( sqlite3_column_type(statement, 10) != SQLITE_NULL ){
                                        content.contentLanguage.ID_ML = sqlite3_column_int(statement, 10);
                                }
                                else
                                        content.contentLanguage.ID_ML = 0;
                                
                                if ( sqlite3_column_type(statement, 11) != SQLITE_NULL ){
                                        content.contentLanguage.MAIN_ID = sqlite3_column_int(statement, 11);
                                }
                                else
                                        content.contentLanguage.MAIN_ID = 0;
                                
                                if ( sqlite3_column_type(statement, 12) != SQLITE_NULL ){
                                        content.contentLanguage.LANGUAGES_ID = sqlite3_column_int(statement, 12);
                                }
                                else
                                        content.contentLanguage.LANGUAGES_ID = 0;
                                
                                if ( sqlite3_column_type(statement, 13) != SQLITE_NULL ){
                                        content.contentLanguage.IsActive = sqlite3_column_int(statement, 13);
                                }
                                else
                                        content.contentLanguage.IsActive = 0;
                                
                                if ( sqlite3_column_type(statement, 14) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 14);
                                        content.contentLanguage.Name = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        content.contentLanguage.Name = @"NULL";
                                
                                if ( sqlite3_column_type(statement, 15) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 15);
                                        content.contentLanguage.Description = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        content.contentLanguage.Description = @"NULL";
                                
                                if ( sqlite3_column_type(statement, 16) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 16);
                                        content.contentLanguage.Address = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        content.contentLanguage.Address = @"NULL";
                                
                                if ( sqlite3_column_type(statement, 17) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 17);
                                        content.contentLanguage.City = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        content.contentLanguage.City = @"NULL";
                                
                                if ( sqlite3_column_type(statement, 18) != SQLITE_NULL ){
                                        char *nameChars = (char *) sqlite3_column_text(statement, 18);
                                        content.contentLanguage.Country = [[NSString alloc] initWithUTF8String:nameChars];
                                }
                                else
                                        content.contentLanguage.Country = @"NULL";
                                
                                
                                [retval addObject:content];
                        }
                        sqlite3_finalize(statement);
                }
        }
        return retval;
        
        
        
}

 */
#pragma Using Transaction

-(void)insertAndUpdateCardDetailWithArrayUsingTrasaction:(NSArray*)arr{
        
        int insert=0,delete=0;
        NSLog(@"CardDetail data saving------->%lu",(unsigned long)arr.count);
        
        if(arr.count){
                
                const char *queryInsertAndUpdate =
                "INSERT OR REPLACE INTO CardDetail (                                                                                                                                                                                                                   ID,                                                                                                                            ART_NAME,                                                                                                                                  ARTIST_NAME,                                                                                                                                  ART_URL,                                                                                                                                  ART_CATEGORY,                                                                                                                                  QUANTITY,                                                                                                                                  PRICE,                                                                                                                                  ART_SIZE,                                                                                                                                  SORT)                                                                                                                                       VALUES(?,?,?,?,?,?,?,?,?)";
                
                
                sqlite3_stmt *compiledStatement1 = nil;
                sqlite3_stmt *compiledStatement2 = nil;
                
                sqlite3_exec(_database, "BEGIN EXCLUSIVE TRANSACTION", 0, 0, 0);
                
                BOOL insertPrepare=(sqlite3_prepare(_database, queryInsertAndUpdate, -1, &compiledStatement1, NULL) == SQLITE_OK) ? YES : NO;
                
                if(insertPrepare)
                        for (int i = 0; i < arr.count; i++) {
                                CardDetailModel * card = [arr objectAtIndex:i];
                                
                                // Insert or Replace
                                
                                if(card!=nil && insertPrepare){
                                        sqlite3_bind_int(compiledStatement1, 1, (int)card.ID );
                                        sqlite3_bind_text(compiledStatement1, 2, [card.ART_NAME UTF8String], -1, SQLITE_STATIC);
                                        sqlite3_bind_text(compiledStatement1, 3, [card.ARTIST_NAME UTF8String], -1, SQLITE_STATIC);
                                        sqlite3_bind_text(compiledStatement1, 4, [card.ART_URL UTF8String], -1, SQLITE_STATIC);
                                        sqlite3_bind_text(compiledStatement1, 5, [card.ART_CATEGORY UTF8String], -1, SQLITE_STATIC);
                                        sqlite3_bind_int(compiledStatement1, 6, (int)card.QUANTITY );
                                        sqlite3_bind_text(compiledStatement1, 7, [card.PRICE UTF8String], -1, SQLITE_STATIC);
                                        sqlite3_bind_text(compiledStatement1, 8, [card.ART_SIZE UTF8String], -1, SQLITE_STATIC);
                                        sqlite3_bind_int(compiledStatement1, 9, (int)card.SORT );
                                        
                                        if (sqlite3_step(compiledStatement1) != SQLITE_DONE)
                                                NSLog(@"Values not inserted. Error: %s",sqlite3_errmsg(_database));
                                        if (sqlite3_reset(compiledStatement1) != SQLITE_OK)
                                                NSLog(@"SQL Error: %s",sqlite3_errmsg(_database));
                                        
                                        insert+=1;
                                }
                                
                                
                        }
                
                //Close transaction for insert & update
                if (sqlite3_finalize(compiledStatement1) != SQLITE_OK)
                        NSLog(@"SQL Error: %s",sqlite3_errmsg(_database));
                
                //Close transaction for delete
                if (sqlite3_finalize(compiledStatement2) != SQLITE_OK)
                        NSLog(@"SQL Error: %s",sqlite3_errmsg(_database));
                
                if (sqlite3_exec(_database, "COMMIT TRANSACTION", 0, 0, 0) != SQLITE_OK)
                        NSLog(@"SQL Error: %s",sqlite3_errmsg(_database));
        }
        
        NSLog(@"Record Add or Update->%d",insert);
        NSLog(@"Record Delete->%d",delete);
}
/*
-(void)updateSettingWithArray:(NSArray*)arr{
        
        int insert=0,delete=0;
        NSLog(@"settings data saving------->%lu",(unsigned long)arr.count);
        
        if(arr.count){
                
                const char *queryInsertAndUpdate =
                "UPDATE settings set                                                                                                                                                                                                                    SyncOnWifi = ?,                                                                                                                            AppLanguage =?,                                                                                                                                 DistanceUnit=? where rowid=1";
                
                
                sqlite3_stmt *compiledStatement1 = nil;
                sqlite3_stmt *compiledStatement2 = nil;
                
                sqlite3_exec(_database, "BEGIN EXCLUSIVE TRANSACTION", 0, 0, 0);
                
                BOOL insertPrepare=(sqlite3_prepare(_database, queryInsertAndUpdate, -1, &compiledStatement1, NULL) == SQLITE_OK) ? YES : NO;
                
                if(insertPrepare)
                        for (int i = 0; i < arr.count; i++) {
                                Settings * setting = [arr objectAtIndex:i];
                                
                                // Insert or Replace
                                
                                if(setting!=nil && insertPrepare){
                                        
                                        sqlite3_bind_text(compiledStatement1, 1, [[@(setting.SyncOnWifiOnly) stringValue] UTF8String], -1, SQLITE_STATIC);
                                        sqlite3_bind_text(compiledStatement1, 2, [[@(setting.AppLanguage) stringValue] UTF8String], -1, SQLITE_STATIC);
                                        sqlite3_bind_text(compiledStatement1, 3, [[@(setting.DistanceUnit) stringValue] UTF8String], -1, SQLITE_STATIC);
                                        
                                        if (sqlite3_step(compiledStatement1) != SQLITE_DONE)
                                                NSLog(@"Values not inserted. Error: %s",sqlite3_errmsg(_database));
                                        if (sqlite3_reset(compiledStatement1) != SQLITE_OK)
                                                NSLog(@"SQL Error: %s",sqlite3_errmsg(_database));
                                        
                                        insert+=1;
                                }
                                
                                
                        }
                
                //Close transaction for insert & update
                if (sqlite3_finalize(compiledStatement1) != SQLITE_OK)
                        NSLog(@"SQL Error: %s",sqlite3_errmsg(_database));
                
                //Close transaction for delete
                if (sqlite3_finalize(compiledStatement2) != SQLITE_OK)
                        NSLog(@"SQL Error: %s",sqlite3_errmsg(_database));
                
                if (sqlite3_exec(_database, "COMMIT TRANSACTION", 0, 0, 0) != SQLITE_OK)
                        NSLog(@"SQL Error: %s",sqlite3_errmsg(_database));
        }
        
        NSLog(@"Record Add or Update->%d",insert);
        NSLog(@"Record Delete->%d",delete);
}

-(void)updateBookmarkWithArray:(NSArray*)arr Main_ID:(NSString*)Main_ID{
        
        int insert=0,delete=0;
        NSLog(@"contents data saving------->%lu",(unsigned long)arr.count);
        
        if(arr.count){
                
                NSString *queryInsertAndUpdate =
                [NSString stringWithFormat:
                 @"UPDATE contents set Bookmark = ? where ID=\"%@\"",Main_ID];
                
                
                const char* query=[queryInsertAndUpdate UTF8String];
                sqlite3_stmt *compiledStatement1 = nil;
                sqlite3_stmt *compiledStatement2 = nil;
                
                sqlite3_exec(_database, "BEGIN EXCLUSIVE TRANSACTION", 0, 0, 0);
                
                BOOL insertPrepare=(sqlite3_prepare(_database, query, -1, &compiledStatement1, NULL) == SQLITE_OK) ? YES : NO;
                
                if(insertPrepare)
                        for (int i = 0; i < arr.count; i++) {
                                Content * content = [arr objectAtIndex:i];
                                
                                // Insert or Replace
                                
                                if(content!=nil && insertPrepare){
                                        
                                        sqlite3_bind_int(compiledStatement1, 1, (int)content.bookmark );
                                        
                                        if (sqlite3_step(compiledStatement1) != SQLITE_DONE)
                                                NSLog(@"Values not inserted. Error: %s",sqlite3_errmsg(_database));
                                        if (sqlite3_reset(compiledStatement1) != SQLITE_OK)
                                                NSLog(@"SQL Error: %s",sqlite3_errmsg(_database));
                                        
                                        insert+=1;
                                }
                                
                                
                        }
                
                //Close transaction for insert & update
                if (sqlite3_finalize(compiledStatement1) != SQLITE_OK)
                        NSLog(@"SQL Error: %s",sqlite3_errmsg(_database));
                
                //Close transaction for delete
                if (sqlite3_finalize(compiledStatement2) != SQLITE_OK)
                        NSLog(@"SQL Error: %s",sqlite3_errmsg(_database));
                
                if (sqlite3_exec(_database, "COMMIT TRANSACTION", 0, 0, 0) != SQLITE_OK)
                        NSLog(@"SQL Error: %s",sqlite3_errmsg(_database));
        }
        
        NSLog(@"Record Add or Update->%d",insert);
        NSLog(@"Record Delete->%d",delete);
}

*/

- (void)dealloc {
        sqlite3_close(_database);
}



@end
