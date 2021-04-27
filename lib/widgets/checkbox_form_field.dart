import 'package:flutter/material.dart';


class CheckboxFormField extends FormField<bool>{

    CheckboxFormField({
        Widget ? title,
        bool initialValue = false,
        FormFieldSetter<bool> ? onSaved,
        FormFieldValidator<bool> ? validator
        }) : super(
            initialValue: false,
            validator: validator,
            onSaved: onSaved,
            builder: (field) {

                    return CheckboxListTile(
                        title: title,
                        subtitle: field.hasError ? Text(field.errorText ?? '',
                                                        style: TextStyle(color: Colors.red)) : null,
                        value: field.value,
                        dense: field.hasError,
                        onChanged: field.didChange,
                    );
            }
        );

}
