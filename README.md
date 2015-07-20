# activerecord-validate_unique_child_attribute

Guarantee uniqueness of a single attribute value across one or more children of an ActiveRecord object

A simplistic but functional workaround for https://github.com/rails/rails/issues/4568

# Usage

Install the gem:

```
gem 'activerecord-validate_unique_child_attribute',
  require: 'active_record/validate_unique_child_attribute'
```

Add the functionality to your ActiveRecord class:

```
class MyParentRecord < ActiveRecord::Base
  include ActiveRecord::ValidateUniqueChildAttribute

  has_many :children
  accepts_nested_attributes_for :children

  # Add an error to the MyParentRecord object whenever two or
  # more children have the same value of some_attribute
  validates_uniqueness_of_child_attribute :children, :some_attribute
end
```

# But wait, Rails already does this!

Yeah, in theory it does.

However, if you use `accepts_nested_attributes_for` in your parent class then the `validates_uniqueness_of` validations in your child class will only be triggered for existing records. This means that nested attributes in a standard controller `#create` method will only fail at the DB constraint level, which often results in a very ugly error experience for the end user.

This is a long-standing [Rails bug](https://github.com/rails/rails/issues/4568) that is not expected to be fixed any time soon.

# Additional Options


```
validates_uniqueness_of_child_attribute :children, :some_attribute,
  validate: true, error_formatter: :my_error_formatter
  
def my_error_formatter(attribute, duplicates)
  "Oh no! Duplicate #{attribute.singularize.humanize} values: #{duplicates.join(', ')}"
end
```

* `validate`: Whether to call `valid?` on each of the `children` before looking for duplicate values of `some_attribute`. This is useful if your `before_validation` code munges the value of `some_attribute` by stripping, downcasing, or otherwise normalizing its value.
* `error_formatter`: A method for formatting the error message that is attached to the parent record's `errors[:children]` array. A default formatter is provided. Alternatively you can pass a block to the `validates_uniqueness_of_child_attribute` class method:

```
  validates_uniqueness_of_child_attribute :children, :some_attribute do |attribute, duplicates|
    "Oh no! Duplicate #{attribute.singularize.humanize} values: #{duplicates.join(', ')}"
  end
```

# Contributing

This is a really simple implementation! Please open a pull request if you've got ideas on how to improve it.

# Compatibility

Tested with active* versions 3.2.14, 4.0.13, 4.1.12, and 4.2.3. See `Appraisals`.

# Code Status

[![Build Status](https://travis-ci.org/GSA/activerecord-validate_unique_child_attribute.svg?branch=master)](https://travis-ci.org/RapidRiverSoftware/activerecord-validate_unique_child_attribute)

# License

This gem is released under the [MIT License](http://www.opensource.org/licenses/MIT)
