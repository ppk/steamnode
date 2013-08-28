# GET home page.
$ = require('jquery')
http = require('http')
request = require('request')

module.exports.index = (req, res) ->
	userGames = null
	allGames = {}
	userid = '76561197970525212' # dortimus
	renderPage = ->
		promise = $.getJSON(ownedGamesUrl, (data) =>
			userGames = data.response.games
		)
		.done( =>
			res.render('index', { title: username, userid: userid, games: userGames, allGames: allGames })
		)

	storeGameInfo = (games) ->
		promise = null

	getAllGames = ->
		allGamesUrl = 'http://api.steampowered.com/ISteamApps/GetAppList/v0001/?format=json'
		$.getJSON(allGamesUrl, (data) =>
			for game in data.applist.apps.app
				allGames[game['appid']] = game['name']
			renderPage()
		)

	username = req.params.user || 'dortimus'
	console.log('user is ' + username)
	userurl = "http://steamcommunity.com/id/#{username}/?xml=1";
	if req.params.user 
		request( userurl, (err, response, body) ->
			if(err && response.statusCode != 200)
				console.log('Request error.')
			else
				userid = body.substring(body.indexOf('<steamID64>') + 11, body.indexOf('</steamID64>'))
				console.log("id is " + userid)
		)

	apiKey = '3B18402FDDF1F6EFB7C00A2DE4A21C1E'

	ownedGamesUrl = "http://api.steampowered.com/IPlayerService/GetOwnedGames/v0001/?key=#{apiKey}&steamid=#{userid}&format=json"

	getAllGames()
	
	
