# encoding: utf-8

class AvatarUploader < CarrierWave::Uploader::Base
  storage :fog
end
