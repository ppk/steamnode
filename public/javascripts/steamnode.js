$( function() {
	var gameIds = []
	$.each($('.games tr'), function() {
		gameIds.unshift($(this).attr('class').slice(5))
	});
	var self = this;
	getGameAchievements = function() {
		gameId = gameIds.pop();
		$.getJSON('/api/global_achievements/' + gameId, function(data) {

			var cheevos = data.achievementpercentages.achievements;
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
			getGameAchievements();
		});
	};
	setTimeout(getGameAchievements, 2000);
})