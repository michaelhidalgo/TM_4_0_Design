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
    url = 'http://tmdev01-beta.teammentor.net' + req.url
    console.log ('Url ' + url)
    ipAddr = req.headers["x-forwarded-for"]
    if (ipAddr)
      console.log ("x-forwarded-for value " + req.headers['x-forwarded-for'])
      ipAddr = req.headers['x-forwarded-for'].split(',')[0]
      console.log("Remote ip value is  " +ipAddr)
    else
      ipAddr = req.connection.remoteAddress

    piwik.track({
      url: url,
      action_name: req.url,
      _id:req.sessionID.add_5_Random_Letters()
      ua: req.header('User-Agent'),
      lang: req.header('Accept-Language'),
      token_auth:'4ec97f159ebf614038b91a6ac0316040',
      cip:ipAddr,
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
