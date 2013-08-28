# GET home page.
$ = require('jquery')
http = require('http')

module.exports.global_achievements = (req, res) ->

	gameid = parseInt(req.params.game)
	apiKey = '3B18402FDDF1F6EFB7C00A2DE4A21C1E'
	unless gameid
		res.send({error: "game id not specified"});
		return

	#"http://api.steampowered.com/IPlayerService/GetOwnedGames/v0001/?key=3B18402FDDF1F6EFB7C00A2DE4A21C1E&steamid=76561197960435530&format=json"
	url = "http://api.steampowered.com/ISteamUserStats/GetGlobalAchievementPercentagesForApp/v0002/?gameid=#{gameid}&format=json"

	$.getJSON(url, (data) =>
		res.send(data);
	)	
	
	
