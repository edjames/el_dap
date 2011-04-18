module ElDap
  module Constants
    LDAP_ATTRS        = ['cn', 'samaccountname', 'displayname', 'name', 'telephonenumber', 'userprincipalname', 'mail']
    LDAP_FILTERS      = ::Net::LDAP::Filter.eq("objectcategory", "person")
    LDAP_SEARCH_FIELD = "cn"
  end
end
