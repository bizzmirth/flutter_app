// function to convert [3 star, 4 star, 5 star] to [3,4,5]
List<String> convertStarsToNumbers(List<String> selectedStars) {
  return selectedStars.map((star) {
    switch (star) {
      case '3 Star':
        return '3';
      case '4 Star':
        return '4';
      case '5 Star':
        return '5';
      case 'Villa':
        return 'Villa'; // Keep Villa as is, or change to a number if needed
      default:
        return star;
    }
  }).toList();
}

// function to get min duration and max duration from values like "4N - 7N"
Map<String, String> getTripDurationValues(String? selectedDuration) {
  switch (selectedDuration) {
    case "Upto 3N":
      return {"minDuration": "0", "maxDuration": "3", "tripDuration": ""};
    case "4N - 7N":
      return {"minDuration": "4", "maxDuration": "7", "tripDuration": ""};
    case "7N - 11N":
      return {"minDuration": "7", "maxDuration": "11", "tripDuration": ""};
    case "11N - 15N":
      return {"minDuration": "11", "maxDuration": "15", "tripDuration": ""};
    case "Above 15N":
      return {
        "minDuration": "15",
        "maxDuration": "999", // or whatever max value you want
        "tripDuration": ""
      };
    default:
      return {"minDuration": "0", "maxDuration": "999", "tripDuration": ""};
  }
}
