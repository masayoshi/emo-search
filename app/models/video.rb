# -*- encoding: utf-8 -*
require 'open-uri'

class Video < ActiveRecord::Base
  attr_accessible :comment_num, :description, :first_retrieve, :length, :mylist_counter, :nicovideo_id, :nicovideo_user_id, :thumbnail_url, :title, :view_counter, :watch_url
  attr_accessible :nicovideo_tag_list
  acts_as_taggable_on :nicovideo_tags

  validates :nicovideo_id, presence: true, uniqueness: true
  validates :first_retrieve, presence: true
  validates :thumbnail_url, format: {with: URI::regexp(%w(http https))}
  validates :watch_url, format: {with: URI::regexp(%w(http https))}

  default_scope order: 'first_retrieve DESC'

  # apply nico video attributes when create
  before_validation :apply_attributes, on: :create

  THUMBINFO_BASE_URL = 'http://ext.nicovideo.jp/api/getthumbinfo/'

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
      self.nicovideo_tag_list = xml.xpath('//tags[contains(@domain, "jp")]//tag').map{|tag| tag.text }.join(",")
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
