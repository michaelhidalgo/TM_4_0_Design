require('fluentnode')
fs       = require('fs')
#levelup    = require("levelup")
#levelup    = require("level"        )
#levelgraph      = require('levelgraph'   )
GitHub_Service  = require('./GitHub-Service')

class GraphService

  constructor: ->
    @dataFile   = './src/article-data.json'
    @data       = null
    @server     = 'http://localhost:1332'

  dataFromGitHub: (callback)=>
    user   = "TMContent"
    repo   = "TM_Test_GraphData"
    path   = 'GraphData/article_Data.json'
    new GitHub_Service().file user, repo, path, (data)-> callback(JSON.parse(data))

  graphDataFromGraphDB: (queryId, filters, callback)=>

    if not queryId or queryId.trim() is ''
      callback {}
      return

    if filters
      graphDataUrl = "#{@server}/data/query_tree_filtered/#{queryId}/#{filters}"
    else
      graphDataUrl = "#{@server}/data/query_tree/#{queryId}"

    graphDataUrl.GET_Json (json)->
      callback json || {}

  resolve_To_Ids: (values, callback)=>
    url = "#{@server}/convert/to_ids/#{values}"
    url.GET_Json (json)->
      callback json || {}

  root_Queries: (callback)=>
    url_root_queries = "#{@server}/data/root_queries"              # need to call this first to create the root_query mapping
    url_query_Tree = "#{@server}/data/query_tree/Root-Queries"
    url_root_queries.GET (root_queries)->
      url_query_Tree.GET_Json (json)->
        callback json || {}

  query_From_Text_Search: (text, callback)=>
    if not text
      callback null
      return


    url_Convert = "#{@server}/convert/to_ids/#{text}"
    url_Search = "#{@server}/search/query_from_text_search/#{text}"

    url_Convert.GET_Json (json)->

      mapping = json[json.keys().first()]
      if mapping.id
        callback mapping.id
      else
        url_Search.GET (search_Id)->
          callback search_Id

  article_Html: (article_Id, callback)=>
    if not article_Id
      callback ''
      return

    url_Article_Html = "#{@server}/data/article_Html/#{article_Id}"

    url_Article_Html.GET_Json (json)->
      callback json || ''

  node_Data: (id, callback)=>
    if not id
      callback ''
      return

    url_Node_Data = "#{@server}/data/id/#{id}"

    url_Node_Data.GET_Json (json)->
      if json and json.values()
        callback json.values().first()
      else
        callback {}


module.exports = GraphService