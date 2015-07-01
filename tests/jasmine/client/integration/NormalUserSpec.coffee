#selectContactAdam = (callback) ->
#	Session.set "contactId", Contacts.findOne(name: "Adam")._id
#	Tracker.afterFlush(callback) if callback

describe "Normal User", ->
	beforeEach (done) ->
		# login and wait for callback
		Meteor.loginWithPassword "normal@profile.com", "normal123", (err) ->
			# check if login successfully
			# expect(err).toBeUndefined()
			# loginUser = Meteor.user()
			# expect(Roles.userIsInRole(loginUser, ['normal'])).toBe(true)
									
			# announce the completion of the test with async calls
			done()
	it "should be able to create contact", ->
		contact = new Contact(null, "test", "123", null)
		id = contact.save (error, result) ->
			# check saved successfully
			expect(error).toBeUndefined()
			# keep database clean
			Contacts.remove(id)
	it "should see all the contacts", ->
		# fixture has total 5 contacts	
		contact = new Contact()
		expect(contact.all().count()).toBe(5)
		# match name
		expect($("li")).toContainText("Adam")
		
	describe "Selecting Contact Adam", ->
		#beforeEach (done) ->
			# set Session variable
			#Tracker.autorun (c) ->
			#	adam = Contacts.findOne(name: "Adam")
			#	if adam
			#		c.stop()
			#		selectContactAdam(done)	
		beforeEach ->
			Session.set "contactId", Contacts.findOne(name: "Adam")._id
			Tracker.flush()
					
		it "should see the contact details", ->
			# how to do acceptance test, such as user click a link?
			expect($("#name").text()).toBe("Adam")
			expect($("#mobile").text()).toBe("123")
	

		
	



