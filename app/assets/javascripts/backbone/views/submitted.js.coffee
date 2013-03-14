class App.Views.Submitted extends App.Views.Request
#  el: 'section.submission-list ul'

  tagName: 'li'

  className: 'hidden'

  template: HandlebarsTemplates['backbone/templates/submitted']

  events:
    'click .like.can-vote'  : 'like'
    'click .like.cant-vote'  : 'do_nothing'
    'click .comments-count' : 'show_comments'
    'click .add_comment'    : 'comment_on_click'
    'keyup .new_comment'    : 'comment_on_enter'

  initialize: ->
    @$el.addClass("submission-#{@model.id}")
    @$el.attr('id', "request-#{@model.id}")
    @can_vote = @model.get('can_vote')
    @model.on 'change:votes', @updateVotes, @
    @model.on 'promoted', @promoteRequest, @
    @model.on 'remove', @remove, @
    @model.on 'commented', @addComment, @

  render: ->
    json = @model.toJSON()
    @formatCommentsTime(json.comments)
    time = moment(json.created_at).add('day', 7).fromNow()
    _.extend json, { created_at: time, can_vote: @can_vote }
    @$el.html(@template(json))
    @$el.fadeIn()
    @renderComments()
    @

  like: (e)->
    e.preventDefault()
    @model.like() unless @liked

  updateVotes: (model)->
    @can_vote = false
    @$el.find('.votes span:first-child').html(model.get('votes'))
    @$el.find('.like').removeClass('can-vote').addClass('cant-vote')

  promoteRequest: ->
    @model.collection.remove(@model)
    @model.set('state', 'promoted')
    App.promoted_list.add @model, { silent: true }
    App.promoted_list.trigger('add-new', @model)

  remove: ->
    @$el.css('background', '#C7DEA9').fadeOut(1600)
    @stopListening()

  comment_on_enter: (e)->
    e.preventDefault()
    if e.keyCode is 13
      @comment(e.target.value)
    else
      @$el.find('.char-counter').text(140 - @$el.find('.new_comment').val().length)

  comment_on_click: (e)->
    e.preventDefault()
    value = @$el.find('.new_comment').val()
    @comment(value)

  do_nothing: (e)->
    e.preventDefault()




