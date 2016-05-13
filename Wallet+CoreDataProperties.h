//
//  Wallet+CoreDataProperties.h
//  bit
//
//  Created by Joanne Lim on 13/5/16.
//  Copyright © 2016 abdoassem. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Wallet.h"

NS_ASSUME_NONNULL_BEGIN

@interface Wallet (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *walletValue;

@end

NS_ASSUME_NONNULL_END
