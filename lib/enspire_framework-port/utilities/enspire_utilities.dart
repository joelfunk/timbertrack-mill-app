String getCustomerType({required Map<String, dynamic> globalSettings, required String customerTypeId}) {
  if (customerTypeId.isEmpty) return '';

  for (var item in globalSettings['customerTypes']) {
    if (item['id'] == customerTypeId) return item['name'];
  }
  return '';
}

List<String> getInitials(String? displayName) {
  if (displayName == null) return [];
  List<String> nameArray = displayName.split(' ');
  String address = '';
  String initials = '';
  int i = 0;
  int x = 0;

  if (isNumeric(nameArray[0])) {
    address = nameArray[0];
    i++;
    x = 1;
  }

  if (nameArray.length == (2 + x)) {
    initials = nameArray[i][0] + nameArray[i + 1][0];
  } else if (nameArray.length >= (3 + x)) {
    initials = nameArray[i][0] + nameArray[i + 1][0] + nameArray[i + 2][0];
  } else {
    initials = displayName.substring(i, 3);
  }

  return [address, initials];
}

bool isNumeric(String? s) {
  if (s == null) {
    return false;
  }
  return double.tryParse(s) != null;
}
