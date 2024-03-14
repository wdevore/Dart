import 'package:vector_math/vector_math.dart';

class GlobalIllumination {
  double kd = 0.6; // diffuse
  double ia = 0.3; // ambient
  double ks = 1000.0; // specular
  double kdIa = 0.0; // background diffuse + ambient

  GlobalIllumination() {
    kdIa = kd * ia;
  }

  // calc Partial Lambert Intensity
  double calcPartialLI(double angle, double ip) {
    double I = kd * ip * angle; // partial lambert Lambert equation.
    return I;
  }

  // calc Partial Lambert Intensity
  double calcPartialLIByNormal(Vector3 normal, Vector3 lightRay, double ip) {
    double nl = normal.dot(lightRay);
    if (nl < 0.0) nl = 0.0; // is face not facing light?
    return calcPartialLI(nl, ip);
  }

  double calcIntensity(double partialIntensity) {
    double i = kdIa + partialIntensity;
    // clamp intensity to 1.0f
    if (i > 1.0) i = 1.0;
    return i;
  }
}
