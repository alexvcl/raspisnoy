class MultiSelectInput < SimpleForm::Inputs::CollectionSelectInput

  def input_html_options
    super.merge(multiple: '')
  end

  def input_html_classes
    super.push('select2')
  end

end
