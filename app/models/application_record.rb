class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def translate_enum(enum)
    I18n.t("#{self.class.name.underscore}.#{enum.to_s.pluralize}.#{self.send(enum).to_s}")
  end

end