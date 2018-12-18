//
// Copyright (c) 2016 Redbeard Services Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Redbeard/RBManagedFormValidationRule.h>

/**
 *  A validator for an `RBManagedFormView` object.
 */
@interface RBManagedFormValidator : NSObject

/**
 *  The result (NSNumber boolean) of each form field by it's name.
 */
@property (nonatomic, readonly, nonnull) NSDictionary<NSString *, NSNumber *> *results;

/**
 *  The error messages for each field that failed validation.
 */
@property (nonatomic, readonly, nonnull) NSDictionary<NSString *, NSString *> *messages;

/**
 *  The last form values that were validated.
 */
@property (nonatomic, readonly, nonnull) NSDictionary *lastValues;

/**
 *  Whether or not the last set of form values processed were valid.
 */
@property (nonatomic, readonly) BOOL formIsValid;

/**
 *  Add a validation rule to the validator.
 *
 *  @param rule         The validation rule to add.
 *  @param identifier   The name of the identifier that this rule validates.
 */
- (void)addRule:(nonnull RBManagedFormValidationRule *)rule toFieldWithIdentifier:(nonnull NSString *)identifier;

/**
 *  Remove all of the validation rules for the given field name.
 *
 *  @param identifier   The identifier of the field.
 */
- (void)removeAllRulesForFieldWithIdentifier:(nonnull NSString *)identifier;

/**
 *  Remove all validation rules.
 */
- (void)removeAllRules;

/**
 *  Validate the given set of form values.
 *
 *  @param values The form values to validate.
 */
- (void)validateFormWithValues:(nonnull NSDictionary *)values;

/**
 *  Validate the given form field with a value.
 *
 *  @param identifier   The identifier of the field.
 *  @param value        The current value of the field.
 *
 *  @return Whether or not the field value was valid.
 */
- (BOOL)validateFormFieldWithIdentifier:(nonnull NSString *)identifier value:(nullable id)value;

/**
 *  Whether or not the named field validated in the last set of values.
 *
 *  @param identifier   The identifier of the field.
 *
 *  @return Whether the field was valid.
 */
- (BOOL)fieldIsValid:(nonnull NSString *)identifier;

@end
