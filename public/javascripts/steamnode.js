var stopProcessing = false;

$( function() {
	var gameIds = []
	$.each($('.games tr'), function() {
		gameIds.unshift($(this).attr('class').slice(5))
	});
	var self = this;
	getGameAchievements = function() {
		gameId = gameIds.pop();
		getLocalGameAchievements(gameId, function(data) {
			var cheevos = data.achievementpercentages.achievements;

			storeGameAchievementsLocally(gameId, cheevos);
			if(cheevos.length == 0) {
				// remove irrelevant element
				$('.games tr.game_' + gameId).remove();
				return;
			}

			var minpercent = 100.0;
			for (var i = 0; i < cheevos.length; ++i) {
				minpercent = Math.min(minpercent, cheevos[i].percent);
			}

			$($('.games tr.game_' + gameId + ' td')[2]).text(minpercent.toString().toString().substr(0, 9));
		}).fail(function(){
			console.log('fail')
		}).always(function(){
			if(!stopProcessing) {
				getGameAchievements();
			}
		});
	};

	getLocalGameAchievements = function(gameId, fn) {
		if(haveLocalGameAchievements(gameId))
		{
			cheevos = JSON.parse(localStorage["game_" + gameId]);
			// fake promise
			pr = {};
			pr.fail = function() { return pr};
			pr.always = function(fn) {fn(); return pr};
			fn({achievementpercentages: {achievements: cheevos}});
			return pr;
		}
		else {
			return $.getJSON('/api/global_achievements/' + gameId, fn);
		}
	}

	haveLocalGameAchievements = function(gameId) {
		if(typeof(Storage)!=="undefined")
		{
			return localStorage["game_" + gameId + "_valid"] == "t";
		}
		else {
			return false;
		}
	}

	storeGameAchievementsLocally = function(gameId, achievements) {
		if(typeof(Storage)!=="undefined")
		{
			localStorage["game_" + gameId + "_valid"] = "t";
			localStorage["game_" + gameId] = JSON.stringify(achievements);
		}
	}

	setTimeout(getGameAchievements, 200);
	$('.stop_processing').click(function() {
		stopProcessing = !stopProcessing;

		if(!stopProcessing) {
			$(this).text("Stop Processing");
			setTimeout(getGameAchievements, 200);
		}
		else {
			$(this).text("Start Processing");
		}

	});
})