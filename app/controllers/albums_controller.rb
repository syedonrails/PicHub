class AlbumsController < ApplicationController
	before_action :authenticate_user!
  before_action :set_user, :except => [:delete_photo, :sort_photo]
  before_action :get_album, :only => [:show, :destroy, :edit, :upload_photo]

  def index
    @albums = @user.albums.all
  end

  def show
    @photos = @album.photos.order(:position)
  end

  def new
    @album = @user.albums.new
  end


  def edit
  end

  def create
    @album = @user.albums.new(album_params)

    respond_to do |format|
      if @album.save
        format.html { redirect_to user_albums_path, notice: 'Album was successfully created.' }
        #format.json { render :show, status: :created, location: @office }
      else
        format.html { render :new }
        #format.json { render json: @office.errors, status: :unprocessable_entity }
      end
    end
  end

=begin
  def update
    respond_to do |format|
      if @office.update(office_params)
        format.html { redirect_to @office, notice: 'Office was successfully updated.' }
        format.json { render :show, status: :ok, location: @office }
      else
        format.html { render :edit }
        format.json { render json: @office.errors, status: :unprocessable_entity }
      end
    end
  end
=end

  def destroy
    @album.destroy
    respond_to do |format|
      format.html { redirect_to user_albums_path, notice: 'Album was successfully destroyed.' }
      format.json { render status: :success }
    end
  end

  def upload_photo
    data = []

    params["files"].each do |file|
      pic = @album.photos.new(avatar: file)
      pic.save
      info = {}
      info.merge!(url: pic.avatar.url, thumbnailUrl: pic.avatar.url(:thumb), name: pic.avatar_file_name, size: pic.avatar_file_size)
      info.merge!(type: pic.avatar_content_type, deleteUrl: "/delete_photo?pic_id=#{pic.id}", deleteType: "DELETE")
      data << info
    end

    result = { :files => data}
    respond_to do |format|
      format.json { render json: result, status: :ok }
    end
  end

  def sort_photo
    params["p"].each_with_index do |p, i|
      Photo.find(p).update(:position => i+1 )
    end
    respond_to do |format|
      format.json { render json: "OK", status: :ok }
    end
  end

  def delete_photo
    pic = Photo.find(params[:pic_id])
    pic.destroy
    respond_to do |format|
      format.json { render json: {pic.id => true}, status: :ok }
    end
  end

  private
    def set_user
      @user = User.find(params[:user_id])
    end

    def get_album
      @album = @user.albums.where(id: params[:id]).first
    end

    def album_params
      params.require(:album).permit(:name, :description, :user_id)
    end
end
