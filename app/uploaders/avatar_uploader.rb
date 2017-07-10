class AvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick
  include CarrierWave::Processing::RMagick
  storage :file

  version :middle do
    process resize_to_fill: [96, 96]
  end

  def default_url
    ActionController::Base.helpers.asset_path('fallback/' + [version_name, 'default.jpg'].compact.join('_'))
  end

end