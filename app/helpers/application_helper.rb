# -*- encoding: utf-8 -*
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

  def additional_tag_path(additional_tag)
    if params[:tags].present?
      tags_param = params[:tags] + "+" + additional_tag
    else
      tags_param = additional_tag
    end
    videos_path(tags: tags_param, sort: params[:sort], range: params[:range])
  end

  def remove_tag_path(remove_tag)
    tags_params = params[:tags].split("+")
    tags_params.delete(remove_tag)
    tags = tags_params.join("+") if tags_params.present?
    videos_path(tags: tags, sort: params[:sort], range: params[:range])
  end

  def tagged_videos_path(tag)
    videos_path(tags: tag, sort: params[:sort], range: params[:range])
  end

  def sort_videos_path(sort)
    videos_path(tags: params[:tags], sort: sort, range: params[:range])
  end

  def remove_sort_videos_path
    videos_path(tags: params[:tags], range: params[:range])
  end

  def readable_sort_condition(sort)
    case sort
    when "fd"
      "登録日時が新しい順"
    when "fa"
      "登録日時が古い順"
    when "vd"
      "再生数が多い順"
    when "va"
      "再生数が少ない順"
    when "cd"
      "コメント数が多い順"
    when "ca"
      "コメント数が少ない順"
    when "md"
      "マイリスト数が多い順"
    when "ma"
      "マイリスト数が少ない順"
    else
      "登録日時が新しい順"
    end
  end

  def range_scoped_videos_path(range)
    videos_path(tags: params[:tags], sort: params[:sort], range: range)
  end

  def remove_range_videos_path
    videos_path(tags: params[:tags], sort: params[:sort])
  end

  def readable_range_condition(range)
    case range
    when "day"
      "24時間以内に投稿"
    when "week"
      "1週間以内に投稿"
    when "month"
      "1ヶ月以内に投稿"
    else
      "期間指定なし"
    end
  end
end
