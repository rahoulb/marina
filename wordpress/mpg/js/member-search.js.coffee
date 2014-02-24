window.$ = jQuery

class MemberSearchViewModel extends ViewModel
  constructor: ->
    super
    @membersDb = new MembersDb this

  deselectLetters: ->
    jQuery('.membersearch-alpha a').removeClass 'alpha-active'

class MembersDb extends Db
  constructor: (viewModel)->
    super viewModel, 'member', "/api/members_directory/members_search.json"

    @lastName = ko.observable ''
    @lastName.subscribe (value)=>
      @viewModel.deselectLetters()

    @acceptsInterns = ko.observable false

  doSearch: =>
    baseUrl = "/api/members_directory/members_search.json?z=z"
    baseUrl = baseUrl + "&last_name=#{@lastName()}"

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

window.viewModel = new MemberSearchViewModel

jQuery(document).ready ->
  ko.applyBindings viewModel
  jQuery('.membersearch-alpha a').on 'click', (event)->
    viewModel.membersDb.lastName jQuery(this).html()
    jQuery(this).addClass 'alpha-active'
