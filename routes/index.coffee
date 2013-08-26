# GET home page.
$ = require('jquery');

module.exports.index = (req, res) ->

	ownedGamesUrl = ''
	renderPage = () ->
		$.getJSON(ownedGamesUrl, (data) ->
			games = []
			for game in data.response.games
				games.push game
			res.render('index', { title: username, games: games })
		)

	username = req.params.user || 'dortimus'
	console.log('user is ' + username)
	userurl = "http://steamcommunity.com/id/#{username}/?xml=1";

	apiKey = '3B18402FDDF1F6EFB7C00A2DE4A21C1E'

	#$.get( userurl, (data) ->
	userid = '76561197960435530' #data.substring(data.indexOf('<steamID64>'), data.indexOf('</steamID64>'))

	ownedGamesUrl = "http://api.steampowered.com/IPlayerService/GetOwnedGames/v0001/?key=#{apiKey}&steamid=#{userid}&format=json"

	renderPage()
	#)
