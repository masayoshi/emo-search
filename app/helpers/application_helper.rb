module ApplicationHelper
  # Returns the full title on a per-page basis.
  def full_title page_title
    base_title = "emo-search"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

  def nico_video_player(video)
    return "<script type='text/javascript' src='http://ext.nicovideo.jp/thumb_watch/#{video.nicovideo_id}?w=490&h=307'></script><noscript><a href='http://www.nicovideo.jp/watch/#{video.nicovideo_id}'>#{video.title}</a></noscript>".html_safe
  end
end
