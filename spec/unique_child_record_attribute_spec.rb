require 'active_model'
require 'active_support'
require 'active_record/validate_unique_child_attribute'

module BasicValidation
  extend ActiveModel::Naming
  extend ActiveSupport::Concern

  def valid?
    self.validate!
    errors.empty?
  end

  def validate!
    self.class.before_validations.each { |proc| proc.call(self) }
    self.class.validations.each { |proc| proc.call(self) }
  end

  def errors
    @errors ||= ActiveModel::Errors.new(self)
  end

  module ClassMethods
    def before_validations
      @before_validations ||= []
    end

    def before_validation(&block)
      before_validations << block
    end

    def validations
      @validations ||= []
    end

    def validate(&block)
      validations << block
    end
  end
end

class ParentRecordBase
  include ActiveRecord::ValidateUniqueChildAttribute
  include BasicValidation

  attr_reader :child_records

  def initialize(child_records)
    @child_records = child_records
  end
end

class VanillaParentRecord < ParentRecordBase
  validates_uniqueness_of_child_attribute :child_records, :some_attribute
end

class ParentRecordWithValidationAndCustomErrorMessage < ParentRecordBase
  validates_uniqueness_of_child_attribute :child_records, :some_attribute,
                                                 validate: true, error_formatter: :my_error_formatter

  def my_error_formatter(_, dups)
    "You have dups: #{dups.join(', ')}"
  end
end

class ChildRecordBase
  include BasicValidation
  attr_accessor :some_attribute

  def initialize(attr)
    @some_attribute = attr
  end
end

class ChildRecord < ChildRecordBase; end

class ChildRecordWithMutatingValidation < ChildRecordBase
  before_validation do |record|
    if record.some_attribute.present?
      record.some_attribute.strip!
      record.some_attribute.downcase!
    end
  end
end

describe ActiveRecord::ValidateUniqueChildAttribute do
  let(:child_records) { [ChildRecord.new('one'), ChildRecord.new('two')] }
  let(:parent_record_class) { VanillaParentRecord }
  let(:parent_record) { parent_record_class.new(child_records) }
  subject { parent_record }

  it { should be_valid }

  context 'when the parent record has no child records' do
    let(:child_records) { [] }
    it { should be_valid }
  end

  context 'when the parent record has non-unique child records' do
    let(:child_records) { [ChildRecord.new('one'), ChildRecord.new('one')] }

    it { should_not be_valid }
    it 'has the expected error message' do
      subject.valid? # Trigger validation
      expect(subject.errors[:child_records]).to include("The following some attribute has been duplicated: 'one'. Each some attribute should be added only once.")
    end
  end

  context 'when the child record validations change the uniquified attribute' do
    let(:parent_record_class) { ParentRecordWithValidationAndCustomErrorMessage }
    it { should be_valid }

    context 'when the child records are made to be no longer unique by before_validation callbacks' do
      let(:child_records) do
        [
          ChildRecordWithMutatingValidation.new('one'),
          ChildRecordWithMutatingValidation.new('ONE'),
          ChildRecordWithMutatingValidation.new('two'),
          ChildRecordWithMutatingValidation.new('Two ')
        ]
      end

      it { should_not be_valid }
      it 'has the expected error message' do
        subject.valid? # Trigger validation
        expect(subject.errors[:child_records]).to include('You have dups: one, two')
      end
    end
  end
end
