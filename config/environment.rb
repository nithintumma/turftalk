# Load the rails application
require File.expand_path('../application', __FILE__)

ActiveSupport::Inflector.inflections do |inflection| inflection.irregular "turf", "turfs"
end

# Initialize the rails application
Cs50::Application.initialize!
