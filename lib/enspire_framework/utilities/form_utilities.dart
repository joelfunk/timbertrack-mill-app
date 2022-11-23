import 'package:form_validator/form_validator.dart';

String? buildFormValidation(List<String>? validators, String? value) {

  if(validators != null) {
    
    for(final type in validators) {
      
      if(type == 'email') {
        final validator =  ValidationBuilder().email('Please enter a valid email').build();
        return validator(value);
      }

      if(type == 'numeric') {
        final validator = ValidationBuilder().required('Field is required!').build();
        return validator(value);
      }
    }

    final validator = ValidationBuilder().required('Field is Required!').build();
    return validator(value);

  } else {

    return null;
  }
}