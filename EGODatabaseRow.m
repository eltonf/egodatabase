//
//  EGODatabaseRow.m
//  EGODatabase
//
//  Created by Shaun Harrison on 3/6/09.
//  Copyright (c) 2009 enormego
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "EGODatabaseRow.h"
#import "EGODatabaseResult.h"


@implementation EGODatabaseRow

- (id)initWithDatabaseResult:(EGODatabaseResult*)aResult {
	if((self = [super init])) {
		columnData = calloc([[aResult columnNames] count], sizeof(id));
		dataPointer = columnData;
		result = aResult;
	}
	
	return self;
}

- (void)addColumnData:(char *)theData
{
	if (!theData) {
		*dataPointer = NULL;
		dataPointer++;
		return;
	}
	int stringLength = 0;
	char *pnter = theData;
    while (*(pnter++)) {
        stringLength++;
        if(stringLength == INT_MAX) {
			*dataPointer = NULL;
			dataPointer++;
            return;
		}
    }
	char *data = calloc(stringLength+1,sizeof(char));
	memcpy(data,theData,stringLength);
	*dataPointer = (id)data;
	dataPointer++;
}

- (int)columnIndexForName:(NSString*)columnName {
	return [result.columnNames indexOfObject:columnName];
}

- (int)intForColumn:(NSString*)columnName {
    int columnIndex = [self columnIndexForName:columnName];
	if(columnIndex < 0 || columnIndex == NSNotFound) return 0;
	char *pos = (char *)*(columnData+columnIndex);
	if (!pos || !*pos) {
		return 0;	
	}
	return atoi(pos);
}

- (int)intForColumnIndex:(int)columnIndex {
	char *pos = (char *)*(columnData+columnIndex);
	if (!pos || !*pos) {
		return 0;	
	}
	return atoi(pos);
}

- (long)longForColumn:(NSString*)columnName {
    int columnIndex = [self columnIndexForName:columnName];
	if(columnIndex < 0 || columnIndex == NSNotFound) return 0;
	char *pos = (char *)*(columnData+columnIndex);
	if (!pos || !*pos) {
		return 0;	
	}
	return atol(pos);
}

- (long)longForColumnIndex:(int)columnIndex {
	char *pos = (char *)*(columnData+columnIndex);
	if (!pos || !*pos) {
		return 0;	
	}
	return atol(pos);	
}

- (BOOL)boolForColumn:(NSString*)columnName {
	return ([self intForColumn:columnName]);
}

- (BOOL)boolForColumnIndex:(int)columnIndex {
	return ([self intForColumnIndex:columnIndex]);
}

- (double)doubleForColumn:(NSString*)columnName {
    return [[self stringForColumn:columnName] doubleValue];
}

- (double)doubleForColumnIndex:(int)columnIndex {
    return [[self stringForColumnIndex:columnIndex] doubleValue];
}

- (NSString*) stringForColumn:(NSString*)columnName {
    int columnIndex = [self columnIndexForName:columnName];
	if(columnIndex < 0 || columnIndex == NSNotFound) return @"";
	char *pos = (char *)*(columnData+columnIndex);
	if (!pos || !*pos) {
		return @"";	
	}
	NSString *string = [NSString stringWithUTF8String:pos];
	if (!string) {
		return @"";
	}
	return string;
}

- (NSString*)stringForColumnIndex:(int)columnIndex {
	char *pos = (char *)*(columnData+columnIndex);
	if (!pos || !*pos) {
		return @"";	
	}
	NSString *string = [NSString stringWithUTF8String:pos];
	if (!string) {
		return @"";
	}
	return string;
}

- (NSDate*)dateForColumn:(NSString*)columnName {
    int columnIndex = [self columnIndexForName:columnName];
    if(columnIndex == -1) return nil;
    return [NSDate dateWithTimeIntervalSince1970:[self doubleForColumnIndex:columnIndex]];
}

- (NSDate*)dateForColumnIndex:(int)columnIndex {
    return [NSDate dateWithTimeIntervalSince1970:[self doubleForColumnIndex:columnIndex]];
}

- (void)dealloc {
	
	dataPointer = columnData;
	int i;
	int count = [[result columnNames] count];
	for (i=0; i<count; i++) {
		char *data = (char *)*dataPointer;
		if (data && *data) {
			free(data);
		}
		dataPointer++;
	}
	free(columnData);
	[super dealloc];
}

@end
