require 'spec_helper'

module ElDap
  describe Constants do
    class TestThing
      include ElDap::Constants
    end
    
    it "should define LDAP_ATTRS" do
      TestThing.const_get('LDAP_ATTRS').
        should == ['cn', 'samaccountname', 'displayname', 'name', 'telephonenumber', 'userprincipalname', 'mail']
    end

    it "should define LDAP_FILTERS" do
      TestThing.const_get('LDAP_FILTERS').should == Net::LDAP::Filter.eq("objectcategory", "person")
    end
    
    it "should define LDAP_SEARCH_FIELD" do
      TestThing.const_get('LDAP_SEARCH_FIELD').should == 'cn'
    end
    
  end
end
