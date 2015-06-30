Meteor.startup ->
	# fixtures need to remove on deployment
	if Meteor.users.find().count() == 0
		users = [
			{name: "Guest", email: "guest@profile.com", roles:[], password: "guest123"},
			{name: "Normal User", email: "normal@profile.com", roles:['normal'], password: "normal123"},
			{name: "Admin", email: "admin@profile.com", roles:['admin'], password: "admin123"}
		]
		for user in users
			id = Accounts.createUser
				email: user.email
				password: user.password
				profile: {name: user.name}
			Roles.addUsersToRoles(id, user.roles) if user.roles.length > 0
	myContact = new Contact()
	if myContact.isEmpty()
		normalUser = Meteor.users.findOne("profile.name": "Normal User")
		myContact.generateTestContacts(normalUser._id) if normalUser		