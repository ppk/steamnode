# GET home page.
$ = require('jquery')
http = require('http')
request = require('request')

module.exports.index = (req, res) ->
	userGames = null
	allGames = {}
	allGamesRaw = {}
	username = 'everybody'
	userid = '' #'76561197970525212' # dortimus
	apiKey = '3B18402FDDF1F6EFB7C00A2DE4A21C1E'
	ownedGamesUrl = ''
	renderPage = ->
		if ownedGamesUrl != ''
			promise = $.getJSON(ownedGamesUrl, (data) =>
				userGames = data.response.games
			)
			.done( =>
				res.render('index', { title: "Games for " + username + " - #" + userid, user: username, games: userGames, allGames: allGames })
			)
		else
			userGames = allGamesRaw
			res.render('index', { title: "All Steam Games", user: username, games: userGames, allGames: allGames })

	storeGameInfo = (games) ->
		promise = null

	getAllGames = ->
		allGamesUrl = 'http://api.steampowered.com/ISteamApps/GetAppList/v0001/?format=json'
		$.getJSON(allGamesUrl, (data) =>
			allGamesRaw = data.applist.apps.app
			for game in allGamesRaw
					allGames[game['appid']] = game['name']
			renderPage()
		)

	username = req.params.user
	userurl = "http://steamcommunity.com/id/#{username}/?xml=1";
	if req.params.user 
		request( userurl, (err, response, body) ->
			if(err && response.statusCode != 200)
				console.log('Request error.')
			else
				userid = body.substring(body.indexOf('<steamID64>') + 11, body.indexOf('</steamID64>'))
				
				console.log("id is " + userid)
				ownedGamesUrl = "http://api.steampowered.com/IPlayerService/GetOwnedGames/v0001/?key=#{apiKey}&steamid=#{userid}&format=json"
				getAllGames()
		)
	else
		getAllGames()
	
	
