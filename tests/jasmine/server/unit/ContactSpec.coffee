describe "Contact", ->
  describe "save", ->
    it "should create contact", ->
      spyOn(Contacts, "insert").and.callFake (doc, callback) ->
        # simulate async return of id = "1"
        callback(null, "1")
      contact = new Contact(null, "Contact 1", "12345678")
      expect(contact.name).toBe("Contact 1")
      expect(contact.mobile).toBe("12345678")
      contact.save()
      # id should be defined
      expect(contact._id).toEqual("1")
      expect(Contacts.insert).toHaveBeenCalled()
    it "should update contact by owner if id already exists", ->
      spyOn(Contacts, "update")
      spyOn(Meteor, "userId").and.returnValue(2)
      contact = new Contact(1, "Contact 1", "12345678", 2)
      contact.name = "Contact 2"
      contact.mobile = "87654321"
      contact.save()
      expect(Contacts.update).toHaveBeenCalled()
      expect(Contacts.update.calls.mostRecent().args[0]).toEqual(1)
      expect(Contacts.update.calls.mostRecent().args[1]).toEqual({$set: {name: "Contact 2", mobile: "87654321"}})
    it "should not save contact without name", ->
      contact = new Contact(null, "", "12345678")
      expect( -> contact.save()).toThrow()
    it "should update contact by owner only", ->
      # set owner 
      spyOn(Meteor, "userId").and.returnValue(1)
      contact = new Contact(1, "Contact 1", "12345678", 2)
      expect( -> contact.save()).toThrow()
  describe "delete", ->
    it "should delete contact by owner only", ->
      spyOn(Contacts, "remove")
      spyOn(Meteor, "userId").and.returnValue(2)
      contact = new Contact(1, "Contact 1", "12345678", 2)
      contact.delete()
      expect(Contacts.remove).toHaveBeenCalled()
      expect(Contacts.remove.calls.mostRecent().args[0]).toEqual(1)
      contact = new Contact(1, "Contact 1", "12345678", 1)
      expect( -> contact.delete()).toThrow()
    it "should delete contact by admin", ->
      spyOn(Contacts, "remove")
      # set admin but not owner
      spyOn(Meteor, "userId").and.returnValue(1)
      spyOn(Roles, "userIsInRole").and.returnValue(true)
      contact = new Contact(1, "Contact 1", "12345678", 2)
      contact.delete()
      expect(Contacts.remove).toHaveBeenCalled()
      expect(Contacts.remove.calls.mostRecent().args[0]).toEqual(1)

  describe "star", ->
    it "should add user id to the star list of the contact", ->
      spyOn(Contacts, "update")
      spyOn(Meteor, "userId").and.returnValue(1)
      contact = new Contact(1, "Contact 1", "12345678", 2)
      contact.star()
      expect(Contacts.update).toHaveBeenCalled()
      expect(Contacts.update.calls.argsFor(0)).toEqual([1, {$addToSet: {stars: 1}}])

  describe "all", ->
    it "should get all contacts order by name", ->
      spyOn(Contacts, "find")
      contact = new Contact()
      contact.all()
      expect(Contacts.find.calls.argsFor(0)).toEqual([{}, {sort: {name: 1}}])
  describe "search", ->
    it "should search contacts by name", ->
      name = "test"
      spyOn(Contacts, "find")
      contact = new Contact()
      contact.search(name)
      expect(Contacts.find.calls.argsFor(0)).toEqual([{name: "test"}, {sort: {name: 1}}])






        




