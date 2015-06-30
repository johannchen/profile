describe "Normal User", ->
	it "should create contact after login", (done) ->
		# login and wait for callback
		Meteor.loginWithPassword "normal@profile.com", "normal123", (err) ->
			# check if login successfully
			expect(err).toBeUndefined()
			loginUser = Meteor.user()
			expect(Roles.userIsInRole(loginUser, ['normal'])).toBe(true)
			contact = new Contact(null, "test", "12345", null)
			id = contact.save (error, result) ->
				# check saved successfully
				expect(error).toBeUndefined()
				# keep database clean
				Contacts.remove(id)
				Meteor.logout ->
					# announce the completion of the test with async calls
					done()



