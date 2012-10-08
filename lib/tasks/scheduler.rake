require 'feedzirra'

RSS_URL_VOCALOID = "http://www.nicovideo.jp/tag/VOCALOID?sort=f&rss=2.0&lang=ja-jp"
RSS_URL_INDIES = "http://www.nicovideo.jp/tag/%E3%83%8B%E3%82%B3%E3%83%8B%E3%82%B3%E3%82%A4%E3%83%B3%E3%83%87%E3%82%A3%E3%83%BC%E3%82%BA?sort=f&rss=2.0&lang=ja-jp"

desc "This task is called by the Heroku scheduler add-on"
task fetch_feeds: :environment do
  puts "Updating Nicovideo Feeds..."
  fetch_new_videos
  puts "done."
end

private

def fetch_new_videos
  feeds = []
  return unless feeds << Feedzirra::Feed.fetch_and_parse(RSS_URL_VOCALOID)
  return unless feeds << Feedzirra::Feed.fetch_and_parse(RSS_URL_INDIES)

  feeds.each do |feed|
    puts "Entries num : " + feed.entries.count.to_s
    feed.entries.each do |entry|
      puts "Entry url : " + entry.url
      nicovideo_id = entry.url.scan(/\w*$/)
      Video.where(nicovideo_id: nicovideo_id[0]).first_or_create!
    end
  end
end
