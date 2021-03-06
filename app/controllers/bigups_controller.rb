class BigupsController < ApplicationController
  def create
    @spool = Spool.find(params[:spool_id])
    @bigup = @spool.bigups.build(params[:bigup])
    if @bigup.save
      @spool.updated_at = Time.now
      if @spool.save
        flash[:success] = "thread bumped!"
      else
        flash_error
      end
    else
      flash_error
    end
    redirect_to root_path
  end

  def destroy
    @bigup = Bigup.find(params[:id])
    @spool = Spool.find(@bigup.spool_id)

    if @spool.bigups.count <= 1
      if @spool.destroy
        flash[:success] = "thread removed"
      else
        flash_error
      end

    elsif @bigup.destroy
      flash[:success] = "post removed"
    else
      flash_error
    end

    redirect_to request.env['HTTP_REFERER']
  end

  def show
    @bigup = Bigup.find(params[:id])

    if !(@bigup.title.blank?)
      @title = Sanitize.clean(@bigup.title)
    elsif !(@bigup.content.blank?)
      @title = Sanitize.clean(@bigup.content)
    elsif !(@bigup.name.blank?)
      @title = "comment #{@bigup.id} by #{Sanitize.clean(@bigup.name)}"
    else
      @title = "untitled"
    end

    @spool = Spool.find(@bigup.spool_id)
  end

end
