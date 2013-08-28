# GET home page.
$ = require('jquery')
http = require('http')

module.exports.index = (req, res) ->
	userGames = null
	allGames = {}
	renderPage = ->
		promise = $.getJSON(ownedGamesUrl, (data) =>
			userGames = data.response.games
		)
		.done( =>
			res.render('index', { title: username, games: userGames, allGames: allGames })
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

	apiKey = '3B18402FDDF1F6EFB7C00A2DE4A21C1E'
	userid = '76561197960435530' #data.substring(data.indexOf('<steamID64>'), data.indexOf('</steamID64>'))

	#"http://api.steampowered.com/IPlayerService/GetOwnedGames/v0001/?key=3B18402FDDF1F6EFB7C00A2DE4A21C1E&steamid=76561197960435530&format=json"
	ownedGamesUrl = "http://api.steampowered.com/IPlayerService/GetOwnedGames/v0001/?key=#{apiKey}&steamid=#{userid}&format=json"

	getAllGames()
	
	
