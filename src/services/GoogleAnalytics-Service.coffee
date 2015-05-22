nodeAnalytics    = null
gaCode           = null
gaSite           = null
Config           = null
piwikAnalytics   = null
piwik            = null
class GoogleAnalytics_Service

  dependencies:()->
    nodeAnalytics  = require 'nodealytics'
    Config         = require('../misc/Config')
    piwikAnalytics = require 'piwik-tracker'

  setup:() =>
    piwik = new piwikAnalytics(1, @.trackerUrl)

  constructor:(req, res)->
    @.dependencies()
    @.req        = req
    @.res        = res
    @.config     = new Config()
    @.trackerUrl = 'http://michaelhidalgo.piwikpro.com/piwik.php'
    @.siteId     =  1
    @.baseUrl    = 'http://tmdev01-beta.teammentor.net'
    @.setup()

  trackUrl: (url) ->
    fullUrl = 'http://tmdev01-beta.teammentor.net'+url
    console.log(fullUrl)
    piwik.track (fullUrl)

  track : (req,res) ->
    url = req.protocol + '://' + req.get('host') + req.originalUrl
    socket = req.socket
    console.log ("Remote Ip is" + req.header('x-forwarded-for'))
    console.log (url)
    piwik.track({
      url: url,
      action_name: req.url,
      _id:req.sessionID.add_5_Random_Letters()
      ua: req.header('User-Agent'),
      lang: req.header('Accept-Language'),
      token_auth:'4ec97f159ebf614038b91a6ac0316040',
      cip:req.header('x-forwarded-for'),
      cvar: JSON.stringify({
        '1': ['API version', 'v1'],
        '2': ['HTTP method', req.method]
      })
    });

  trackPage:(pageTitle, url) ->
    nodeAnalytics.trackPage pageTitle,url,(err,res)->
      if(err? and res?.statusCode? != 200)
        return "Error tracking Page on Google Analytics #{err.message}"


  trackEvent: (eventCategory,eventAction,eventLabel,eventValue) ->
    nodeAnalytics.trackEvent eventCategory, eventAction,eventLabel,eventValue, (err,res) ->
      if(err? and res?.statusCode? != 200)
        return "Error tracking Event on Google Analytics #{err.message}"

  module.exports =GoogleAnalytics_Service
