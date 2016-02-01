class TemplatesController < ApplicationController
  def show
    logger.info "---------params: #{params}"
  end
end
