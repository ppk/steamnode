# GET home page.

exports.index = (req, res) ->
	$ = require('jquery');

	apiKey = '3B18402FDDF1F6EFB7C00A2DE4A21C1E'
	ownedGamesUrl = 'http://api.steampowered.com/IPlayerService/GetOwnedGames/v0001/?key=3B18402FDDF1F6EFB7C00A2DE4A21C1E&steamid=76561197960434622&format=json'

	$.getJSON(ownedGamesUrl, (data) ->
		games = []
		for game in data.response.games
			games.push game
		res.render('index', { title: 'Express', games: games })
	)

