Session.setDefault 'contactId', null
Template.contact.helpers
	contact: ->
		Contacts.findOne Session.get('contactId')