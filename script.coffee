class TwitterSpeechSearch
	constructor: (@input, @tweetsWrap) -> 
		@input.on 'webkitspeechchange', @search
	search: (e) =>
		query = @input.val()
		
		# Input was cleared
		if !query
			return
		
		$.getJSON "http://search.twitter.com/search.json?callback=?&q=#{encodeURI(query)}", @validate
	validate: (result) =>
		if result.results.length < 1
			alert "Nothing matched your query '#{@input.val()}'. Try again."
			return

		console.log result.results[0]

		@tweets = $.map result.results, (tweet) ->
			id: tweet.id_str,
			text: tweet.text, 
			avatar: tweet.profile_image_url, 
			user: tweet.from_user
			img: tweet.profile_image_url
			timestamp: tweet.created_at
			

		@renderTweets()
	renderTweets: ->
		html = '<ul class="tweets">'
		for tweet in @tweets
			html += "
				<li class='tweet'>
					<section class='content'>
						<div class='user'>
							<div class='avatar'>
								<img src='#{tweet.img}' width='35' height='35'>
							</div>
						</div>

						<div class='drop-shadow lifted'>
							#{tweet.text}
						</div>
					</section>

					<footer>
						<a href='http://twitter.com/#{tweet.user}/status/#{tweet.id}' title='View tweet on Twitter.com' target='_blank'>@#{tweet.user}</a>
						<p class='timestamp'>#{@formatTimestamp(tweet.timestamp)}</p>
					</footer>
				</li>
			"
		html += '</ul>'

		@tweetsWrap.empty().append $(html)
	formatTimestamp: (timestamp) ->
		timestamp.replace /(\s[0-9][0-9]:.+$)/g, ''

new TwitterSpeechSearch $('#talktome'), $('#tweets')