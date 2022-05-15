checkCorrection(String answer, String correction) {
  correction = correction.trim();
  correction = correction.toUpperCase();
  correction = correction.replaceAll(" ", "");
  print(correction);

  if (answer == correction) {
    return true;
  }
}
