namespace :tweet_collect do 
  desc "Retrieve Tweets for ConnectingSexes"
  
  task :start => :environment do
    require 'twitter'
    
    TweetData.delete_all
    
    Twitter.user('connectingsexes')
    @user_timeline = Twitter.user_timeline('connectingsexes', :include_rts => true)
    @search = Twitter.search('connectingsexes')

    tweets = (@search + @user_timeline).compact
    
    @tweets = tweets.inject([]) do |result, item|
      result << item unless result.map(&:id).include?(item.id)
      result
    end
    
    @tweets = @tweets.sort! {|a,b| Time.parse(b.created_at).to_i <=> Time.parse(a.created_at).to_i}
    
    @tweets.each do |tweet|
      TweetData.create(:tdata => tweet)      
    end
        
  end  
end