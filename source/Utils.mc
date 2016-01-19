using Toybox.Math as Math;

function isPointInBox(point, box) {
  if (point[0] >= box["x"][0] && point[0] <= box["x"][1] &&
      point[1] >= box["y"][0] && point[1] <= box["y"][1]) {
    return true;
  }
  return false;
}

function arrayIndexOf(array, elem) {
  for (var i = 0; i < array.size(); i++) {
    if (array[i] == elem) {
      return i;
    }
  }
  return null;
}
