@Contacts = new Mongo.Collection("contacts")

Contacts.allow
	insert: (userId, doc) ->
		userId and Roles.userIsInRole(userId, "normal") 
	remove: (userId, doc) ->
		userId and doc.owner is Meteor.userId()

class @Contact
	constructor: (@_id, @name, @mobile, @owner) ->
	save: (callback) ->
		throw new Meteor.Error("Name is not define!") unless @name

		that = @
		if @_id
			throw new Meteor.Error("Wrong owner!") if @owner != Meteor.userId()
			Contacts.update @_id, 
				$set:
					name: @name
					mobile: @mobile
		else
			doc = {name: @name, mobile: @mobile, owner: Meteor.userId()}
			Contacts.insert doc, (error, result) ->
				that._id = result
				callback.call(that, error, result) if callback
	delete: ->
		if @owner is Meteor.userId() or Roles.userIsInRole(Meteor.userId(), ['admin'])
			Contacts.remove(@_id) 
		else
			throw new Meteor.Error("Wrong owner!")
	star: ->
		if Meteor.userId()
			Contacts.update @_id,
				$addToSet: {stars: Meteor.userId()}

	all: ->
		Contacts.find({}, {sort: {name: 1}})
	search: (term) ->
		Contacts.find({name: term}, {sort: {name: 1}})
	isEmpty: ->
		Contacts.find().count() == 0
	generateTestContacts: (userId) ->
		myContacts = [
			{name: "Adam"}
			{name: "Esther"}
			{name: "Jessica"}
			{name: "Peter"} 
			{name: "Brian"} 
		]
		for contact in myContacts
			Contacts.insert(name: contact.name, owner: userId)

			