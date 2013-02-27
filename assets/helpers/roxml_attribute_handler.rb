class RoxmlAttributeHandler < YARD::Handlers::Ruby::AttributeHandler

  ID_DESC = <<FOO
An identifier is a string compatible with common ID types
as in, for instance, XML Schema.
identifier fields must be unique throughout a corpus document
(or a corpus object tree).
FOO

  handles method_call(:xml_accessor)
  namespace_only

  def process
    # push_state(:scope => :class) { super }

    name = statement.parameters.first.jump(:tstring_content, :ident).source
    object = YARD::CodeObjects::MethodObject.new(namespace, name)
    register(object)

    setter_string = nil
    current_object_type = nil

    if object.docstring.to_s.strip =~ /identifier/
      current_object_type = "String"
      object.dynamic = true
      object.docstring = "Gets the identifier of this object. #{ID_DESC}"
      object.docstring.add_tag(YARD::Tags::Tag.new("return","", current_object_type))
      setter_string = "Sets the identifier for this object. #{ID_DESC}"
    end

    if object.docstring.to_s.strip =~ /.*type\s+(.*)/
      current_object_type = $1
      object.dynamic = true
      object.docstring = "XML-bound getter method for the #{name} field."
      object.docstring.add_tag(YARD::Tags::Tag.new("return","", current_object_type))
      setter_string = "XML-bound setter method for the #{name} field."
    end

    if object.docstring.to_s.strip =~ /.*collection of\s+(.*)/
      object.dynamic = true
      object.docstring = "XML-bound getter method for the #{name} collection of #{$1} objects."
      current_object_type = "[#{$1}]"
      object.docstring.add_tag(YARD::Tags::Tag.new("return","", current_object_type))
      setter_string = "XML-bound setter method for the #{name} collection of #{$1} objects."
    end

    setter_object = YARD::CodeObjects::MethodObject.new(namespace, "#{name}=")
    register(setter_object)
    setter_object.dynamic = true
    setter_object.parameters= [ ['new_value', nil] ]
    setter_object.docstring = setter_string || "Sets the XML-bound field '#{name}'."
    setter_object.docstring.add_tag(YARD::Tags::Tag.new("return", "", "void"))
    setter_object.docstring.add_tag(YARD::Tags::Tag.new(:param, "The new value to be set", current_object_type, 'new_value'))

  end

end