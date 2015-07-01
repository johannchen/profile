Meteor.publish 'users', ->
	Meteor.users.find()

Meteor.publish 'contacts', ->
	Contacts.find() if @userId and Roles.userIsInRole(@userId, ['admin', 'normal'])