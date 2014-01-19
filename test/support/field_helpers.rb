module Test
  module FieldHelpers

    def setup_multi_select_fields
      @first_field = a_saved Marina::Db::FieldDefinition, name: 'first', label: 'First', kind: 'multi_select', options: ['this', 'that', 'the other']
      @second_field = a_saved Marina::Db::FieldDefinition, name: 'second', label: 'Second', kind: 'multi_select', options: ['punk', 'rock', 'house']
    end

    def setup_drop_down_fields
      @first_field = a_saved Marina::Db::FieldDefinition, name: 'first', label: 'First', kind: 'drop_down', options: ['this', 'that', 'the other']
      @second_field = a_saved Marina::Db::FieldDefinition, name: 'second', label: 'Second', kind: 'drop_down', options: ['punk', 'rock', 'house']
    end

    def setup_text_fields
      @first_field = a_saved Marina::Db::FieldDefinition, name: 'first', label: 'First', kind: 'short_text'
      @second_field = a_saved Marina::Db::FieldDefinition, name: 'second', label: 'Second', kind: 'long_text'
    end

    def setup_checkbox_fields
      @first_field = a_saved Marina::Db::FieldDefinition, name: 'first', label: 'First', kind: 'checkbox'
      @second_field = a_saved Marina::Db::FieldDefinition, name: 'second', label: 'Second', kind: 'checkbox'
    end
  end
end
