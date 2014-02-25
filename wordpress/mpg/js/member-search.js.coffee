window.$ = jQuery

class MemberSearchViewModel extends ViewModel
  constructor: ->
    super
    @membersDb = new MembersDb this
    @latestMembersDb = new LatestMembersDb this
    @latestMembersDb.load true

  deselectLetters: ->
    jQuery('.membersearch-alpha a').removeClass 'alpha-active'

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

  doSearch: =>
    baseUrl = "/api/members_directory/members_search.json?z=z"
    baseUrl = baseUrl + "&last_name=#{@lastName()}" if @lastName() != ''
    baseUrl = baseUrl + "&accepts_interns=true" if @acceptsInters()

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

window.viewModel = new MemberSearchViewModel

jQuery(document).ready ->
  ko.applyBindings viewModel
  jQuery('.membersearch-alpha a').on 'click', (event)->
    viewModel.membersDb.lastName jQuery(this).html()
    jQuery(this).addClass 'alpha-active'
