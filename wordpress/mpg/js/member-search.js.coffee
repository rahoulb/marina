window.$ = jQuery

class MemberSearchViewModel extends ViewModel
  constructor: ->
    super
    @membersDb = new MembersDb this
    @latestMembersDb = new LatestMembersDb this
    @latestMembersDb.load false
    @fieldDefinitionsDb = new FieldDefinitionsDb this
    @fieldDefinitionsDb.load false, =>
      @fieldDefinitionsDb.setupSearchOptions()

  deselectLetters: ->
    jQuery('.membersearch-alpha a').removeClass 'alpha-active'

class FieldDefinitionsDb extends Db
  constructor: (viewModel)->
    super viewModel, 'fieldDefinition', "/api/field_definitions.json"
    @roles = ko.observableArray []
    @genres = ko.observableArray []
    @facilities = ko.observableArray []
    @instruments = ko.observableArray []

  newItem: (id)->
    new FieldDefinition id, this

  itemDataFrom: (data)->
    data.fieldDefinitions

  setupSearchOptions: ->
    field = @fieldCalled 'roles'
    @roles field.options() if field?
    field = @fieldCalled 'genres'
    @genres field.options() if field?
    field = @fieldCalled 'instruments'
    @instruments field.options() if field?
    field = @fieldCalled 'facilities'
    @facilities field.options() if field?

  fieldCalled: (name)->
    for field in @items()
      return field if field.name() == name
    return null

class LatestMembersDb extends Db
  constructor: (viewModel)->
    super viewModel, 'latestMember', "/api/members_directory/latest_members/6.json"

  newItem: (id)->
    new Member id, this

  itemDataFrom: (data)->
    data.members

class MembersDb extends Db
  constructor: (viewModel)->
    super viewModel, 'member', "/api/members_directory/members_search.json"

    @lastName = ko.observable ''
    @lastName.subscribe (value)=>
      @viewModel.deselectLetters()

    @acceptsInterns = ko.observable false
    @roles = ko.observableArray []
    @genres = ko.observableArray []
    @instruments = ko.observableArray []
    @facilities = ko.observableArray []

  doSearch: =>
    baseUrl = "/api/members_directory/members_search.json?z=z"
    baseUrl = baseUrl + "&last_name=#{@lastName()}" if @lastName() != ''
    baseUrl = baseUrl + "&accepts_interns=true" if @acceptsInterns()

    @url baseUrl
    @items.removeAll()
    @load false

  newItem: (id)->
    new Member id, this

  itemDataFrom: (data)->
    data.members

class Member extends Model
  constructor: (id, db)->
    super id, db
    @firstName = ko.observable ''
    @lastName = ko.observable ''
    @name = ko.observable ''
    @email = ko.observable ''
    @skype = ko.observable ''
    @facebook = ko.observable ''
    @twitter = ko.observable ''
    @webAddress = ko.observable ''
    @subscriptionPlan = ko.observable ''
    @biography = ko.observable ''
    @createdAt = ko.observable null
    @managementName = ko.observable ''
    @managementCompany = ko.observable ''
    @managementEmail = ko.observable ''

  updateAttributes: (data)->
    @firstName data.firstName
    @lastName data.lastName
    @name data.name
    @email data.email
    @skype data.skype
    @facebook data.facebook
    @twitter data.twitter
    @webAddress data.webAddress
    @subscriptionPlan data.subscriptionPlan
    @biography data.biography
    @createdAt data.createdAt
    @managementName data.managementName
    @managementCompany data.managementCompany
    @managementEmail data.managementEmail

class FieldDefinition extends Model
  constructor: (id, db)->
    super id, db
    @name = ko.observable ''
    @label = ko.observable ''
    @kind = ko.observable ''
    @options = ko.observableArray []

  updateAttributes: (data)->
    @name data.name
    @label data.label
    @kind data.kind
    @options data.options

window.viewModel = new MemberSearchViewModel

jQuery(document).ready ->
  ko.applyBindings viewModel
  jQuery('.membersearch-alpha a').on 'click', (event)->
    viewModel.membersDb.lastName jQuery(this).html()
    jQuery(this).addClass 'alpha-active'
