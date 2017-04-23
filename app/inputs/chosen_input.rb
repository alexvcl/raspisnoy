class ChosenInput < SimpleForm::Inputs::CollectionSelectInput

  def input(wrapper_options)
    input_html_classes << 'chosen-select'
    super
  end

end
