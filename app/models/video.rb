# -*- encoding: utf-8 -*
# == Schema Information
#
# Table name: videos
#
#  id                :integer          not null, primary key
#  nicovideo_id      :string(255)      not null
#  title             :string(255)      not null
#  description       :text             not null
#  thumbnail_url     :string(255)      not null
#  first_retrieve    :datetime         not null
#  length            :string(255)      not null
#  view_counter      :integer          not null
#  comment_num       :integer          not null
#  mylist_counter    :integer          not null
#  watch_url         :string(255)      not null
#  nicovideo_user_id :string(255)      not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

require 'open-uri'

class Video < ActiveRecord::Base
  attr_accessible :comment_num, :description, :first_retrieve, :length, :mylist_counter, :nicovideo_id, :nicovideo_user_id, :thumbnail_url, :title, :view_counter, :watch_url
  attr_accessible :nicovideo_tag_list
  acts_as_taggable_on :nicovideo_tags

  validates :nicovideo_id, presence: true, uniqueness: true
  validates :first_retrieve, presence: true
  validates :thumbnail_url, format: {with: URI::regexp(%w(http https))}
  validates :watch_url, format: {with: URI::regexp(%w(http https))}

  #default_scope order: 'first_retrieve DESC'

  scope :refine_search, lambda { |params|
    composed_scope = self.scoped

    if params[:tags].present?
      params[:tags].split("+").each do |tag|
        composed_scope = composed_scope.tagged_with(tag)
      end
    end

    if params[:range].present?
      case params[:range]
      when "day"
        range = 1.day.ago
      when "week"
        range = 1.week.ago
      when "month"
        range = 1.month.ago
      else
        range = "invalid"
      end
      composed_scope = composed_scope.where("first_retrieve >= ?", range) unless range == "invalid"
    end

    if params[:sort].present?
      case params[:sort]
      when "fd"
        sort_option = "first_retrieve DESC"
      when "fa"
        sort_option = "first_retrieve ASC"
      when "vd"
        sort_option = "view_counter DESC"
      when "va"
        sort_option = "view_counter ASC"
      when "cd"
        sort_option = "comment_num DESC"
      when "ca"
        sort_option = "comment_num ASC"
      when "md"
        sort_option = "mylist_counter DESC"
      when "ma"
        sort_option = "mylist_counter ASC"
      else
        sort_option = "first_retrieve DESC"
      end

      composed_scope = composed_scope.order(sort_option)
    end

    return composed_scope
  }

  # apply nico video attributes when create
  before_validation :apply_attributes, on: :create

  THUMBINFO_BASE_URL = 'http://ext.nicovideo.jp/api/getthumbinfo/'

  def update_attributes
    xml = Nokogiri::XML(open(THUMBINFO_BASE_URL + self.nicovideo_id))
    if nicovideo_api_response_is_valid?(xml) && validate_video_category?(xml)
      self.description = xml.xpath('//description').inner_text
      self.view_counter = xml.xpath('//view_counter').inner_text.to_i
      self.comment_num = xml.xpath('//comment_num').inner_text.to_i
      self.mylist_counter = xml.xpath('//mylist_counter').inner_text.to_i
      # replace "+" to "＋" for tag refine search separater
      self.nicovideo_tag_list = xml.xpath('//tags[contains(@domain, "jp")]//tag').map{|tag| tag.text.gsub("+", "＋") }.join(",")
    else
      return false
    end
  end

  private

  def apply_attributes
    xml = Nokogiri::XML(open(THUMBINFO_BASE_URL + self.nicovideo_id))
    if nicovideo_api_response_is_valid?(xml) && validate_video_category?(xml)
      self.title = xml.xpath('//title').inner_text
      self.description = xml.xpath('//description').inner_text
      self.thumbnail_url = xml.xpath('//thumbnail_url').inner_text
      self.first_retrieve = Time.parse(xml.xpath('//first_retrieve').inner_text)
      self.length = xml.xpath('//length').inner_text
      self.view_counter = xml.xpath('//view_counter').inner_text.to_i
      self.comment_num = xml.xpath('//comment_num').inner_text.to_i
      self.mylist_counter = xml.xpath('//mylist_counter').inner_text.to_i
      self.watch_url = xml.xpath('//watch_url').inner_text
      self.nicovideo_user_id = xml.xpath('//user_id').inner_text
      # replace "+" to "＋" for tag refine search separater
      self.nicovideo_tag_list = xml.xpath('//tags[contains(@domain, "jp")]//tag').map{|tag| tag.text.gsub("+", "＋") }.join(",")
    else
      return false
    end
  end

  def nicovideo_api_response_is_valid?(response_xml)
    if response_xml.at_css('nicovideo_thumb_response')["status"] == "ok"
      return true
    else
      return false
    end
  end

  def validate_video_category?(response_xml)
    tag_list = response_xml.xpath('//tags[contains(@domain, "jp")]//tag').map{|tag| tag.text }.join(",")
    if tag_list.include?("VOCALOID") || tag_list.include?("ニコニコインディーズ")
      return true
    else
      return false
    end
  end
end
