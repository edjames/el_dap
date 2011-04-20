require 'spec_helper'

module ElDap
  describe Validator do
    
    it "should return false when a string is not nil or empty" do
      Validator.blank?('string').should be_false
    end
    
    it "should return false when all the strings are not nil or empty" do
      Validator.blank?('string', 'thing').should be_false
    end
    
    it "should return true when a string is nil or empty" do
      Validator.blank?('').should be_true
      Validator.blank?(nil).should be_true
      Validator.blank?(nil, '').should be_true
    end
    
    it "should return true when any string is nil or empty" do
      Validator.blank?('', '').should be_true
      Validator.blank?(nil, nil).should be_true
      Validator.blank?('', 'string', nil).should be_true
    end
    
    it "should return false when all strings are not nil or empty" do
      Validator.blank?('string', 'string', 'string').should be_false
    end
    
  end
end
