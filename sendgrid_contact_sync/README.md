Integrate in Rails through callbacks

```ruby
class User
  attr_accessor :firstname, :gender, :age_bracket, :status 

  after_create :add_to_sendgrid_users_list
  after_update :sync_user_properties_on_sendgrid
  after_destroy :delete_from_sendgrid_users_list

  def add_to_sendgrid_users_list
    SendgridUserSyncService.new(self.email,
self).delay_add_to_users_list
  end 

  def sync_user_properties_on_sendgrid
    SendgridUserSyncService.new(self.email, self).sync_user_properties
  end 

  def delete_from_sendgrid_users_list
    SendgridUserSyncService.new(self.email).delay_delete_from_users_list
  end
end
```
