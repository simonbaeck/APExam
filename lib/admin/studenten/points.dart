checkCorrection(String answer, String correction) {
  correction = correction.trim();
  correction = correction.toUpperCase();
  correction = correction.replaceAll(" ", "");

  if (answer == correction) {
    return true;
  }
}
