describe "Guest", ->
	# set up guest to login
	beforeEach (done) ->
		Meteor.loginWithPassword "guest@profile.com", "guest123", (err) ->
			# check if login successfully
			# expect(err).toBeUndefined()
			done()

	it "should not create contact", ->
		contact = new Contact(null, "test", "12345")
		contact.save (error, result) ->
			expect(error.error).toBe(403)
	it "should not see any contact", ->
		contact = new Contact()
		myContacts = contact.all()
		expect(myContacts.count()).toBe(0)
	it "should see notice", ->
		notice = "Please wait for the admin approval."
		expect($("#notice").html()).toBe(notice)
	
	it "should be able to logout and not see the notice", (done) ->
		Meteor.logout (err) ->
			expect(err).toBeUndefined()
			# manually force DOM flush after reactive var changed 
			Tracker.flush()
			# matcher from jasmine jquery 
			expect($("#notice")).not.toExist()
			done()


						
