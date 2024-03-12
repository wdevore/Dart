enum EdgeStates {
  perminent, // Visibilty can't be changed
  nonPerminent,
  visible,
  invisible,
  noFace,
  frontFace,
  backFace,
}

class TriangleEdge {
  EdgeStates perminence = EdgeStates.nonPerminent;
  EdgeStates _visibility = EdgeStates.invisible;
  EdgeStates face = EdgeStates.noFace;

  EdgeStates get isVisible => _visibility;

  // An edge that has been determined(processed)
  // to be visible overrides an edge that has been
  // determined to be invisible.
  //
  // An edge that is invisible can be forced to visible.
  // But an edge that has been determined to be visible can
  // not be forced to be invisible.
  set visibility(EdgeStates visible) {
    if (perminence == EdgeStates.perminent) {
      return; // visibility can't be changed}
    }
    _visibility = visible;
  }
}
