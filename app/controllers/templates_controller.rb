class TemplatesController < ApplicationController
  include SessionsHelper

  before_action :force_admin

  def pre_lesson_template
    @template = Template.where(pre: true).first
    @template ||= Template.new
  end

  def create_pre_lesson_template

  end

  def post_lesson_template

  end

  def create_post_lesson_template

  end
end
