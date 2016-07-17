class DatabaseCleaner
  def self.clean
    models.each do |model|
      model.all.each(&:delete)
    end
  end

  def self.models
    if @models.to_a == []
      Rails.application.eager_load!
      @models = Mongoid.models
      @models.delete(TagSystem)
      @models.delete(Tag)
    end
    @models
  end
end
