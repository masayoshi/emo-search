class VideosController < ApplicationController
  before_filter :authenticate_user!, except: [:index, :show]

  def index
    @videos = Video.refine_search(params).paginate(page: params[:page])
    @tags = Video.refine_search(params).tag_counts_on(:nicovideo_tags)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @videos }
    end
  end

  def show
    @video = Video.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @video }
    end
  end

  # POST /videos
  # POST /videos.json
  def create
    @video = Video.new(nicovideo_id: params[:nicovideo_id])

    respond_to do |format|
      if @video.save
        format.html { redirect_to @video, notice: 'Video was successfully created.' }
        format.json { render json: @video, status: :created, location: @video }
      else
        format.html { redirect_to videos_path , alert: 'Video was not successfully created.' }
        format.json { render json: @video.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /videos/1
  # PUT /videos/1.json
  def update
    @video = Video.find(params[:id])
    @video.update_attributes

    respond_to do |format|
      if @video.save
        format.html { redirect_to @video, notice: 'Video was successfully updated.' }
        format.json { render json: @video, status: :created, location: @video }
      else
        format.html { redirect_to videos_path , alert: 'Video was not successfully updated.' }
        format.json { render json: @video.errors, status: :unprocessable_entity }
      end
    end
  end
end
