class ChosenInput < SimpleForm::Inputs::CollectionSelectInput

  def input_html_classes
    super.push('select2')
  end

end
