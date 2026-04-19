// GENERATED CODE - DO NOT MODIFY BY HAND
// This file contains a purely offline Random Forest model for Severity Classification.
// Generated from Python scikit-learn.

class MLModelData {
  static const List<String> vocabulary = ["accident", "active", "ankle", "arm", "badly", "big", "bit", "bleeding", "blood", "blue", "breathing", "building", "bumper", "car", "chest", "choking", "collapsed", "coming", "crash", "got", "headache", "heart", "heavily", "hurt", "hurts", "injuries", "kitchen", "leg", "losing", "lot", "major", "minor", "mother", "need", "okay", "pains", "paracetamol", "people", "pulse", "really", "scratch", "shooter", "small", "smoke", "sprained", "stabbed", "stairs", "stopped", "stubbed", "sweating"];

  static int predictSeverity(List<double> features) {
    int vote0 = 0;
    int vote1 = 0;
    int vote2 = 0;
    int vote3 = 0;

    int tree0() {
      if (features[31] <= 0.5) {
        if (features[19] <= 0.5) {
          if (features[34] <= 0.5) {
            if (features[21] <= 0.5) {
              if (features[41] <= 0.5) {
                return 2;
              } else {
                return 3;
              }
            } else {
              return 3;
            }
          } else {
            return 0;
          }
        } else {
          return 3;
        }
      } else {
        return 1;
      }
    }
    switch (tree0()) {
      case 0: vote0++; break;
      case 1: vote1++; break;
      case 2: vote2++; break;
      case 3: vote3++; break;
    }

    int tree1() {
      if (features[44] <= 0.5) {
        if (features[42] <= 0.5) {
          if (features[47] <= 0.5) {
            if (features[43] <= 0.5) {
              if (features[5] <= 0.5) {
                return 2;
              } else {
                return 1;
              }
            } else {
              return 2;
            }
          } else {
            return 3;
          }
        } else {
          return 0;
        }
      } else {
        return 1;
      }
    }
    switch (tree1()) {
      case 0: vote0++; break;
      case 1: vote1++; break;
      case 2: vote2++; break;
      case 3: vote3++; break;
    }

    int tree2() {
      if (features[39] <= 0.5) {
        if (features[32] <= 0.5) {
          if (features[23] <= 0.5) {
            if (features[27] <= 0.5) {
              if (features[29] <= 0.5) {
                return 0;
              } else {
                return 3;
              }
            } else {
              return 1;
            }
          } else {
            return 2;
          }
        } else {
          return 3;
        }
      } else {
        return 1;
      }
    }
    switch (tree2()) {
      case 0: vote0++; break;
      case 1: vote1++; break;
      case 2: vote2++; break;
      case 3: vote3++; break;
    }

    int tree3() {
      if (features[48] <= 0.5) {
        if (features[26] <= 0.5) {
          if (features[22] <= 0.5) {
            if (features[36] <= 0.5) {
              if (features[21] <= 0.5) {
                return 3;
              } else {
                return 3;
              }
            } else {
              return 0;
            }
          } else {
            return 2;
          }
        } else {
          return 2;
        }
      } else {
        return 0;
      }
    }
    switch (tree3()) {
      case 0: vote0++; break;
      case 1: vote1++; break;
      case 2: vote2++; break;
      case 3: vote3++; break;
    }

    int tree4() {
      if (features[35] <= 0.5) {
        if (features[3] <= 0.5) {
          if (features[16] <= 0.5) {
            if (features[24] <= 0.5) {
              if (features[15] <= 0.5) {
                return 2;
              } else {
                return 3;
              }
            } else {
              return 1;
            }
          } else {
            return 3;
          }
        } else {
          return 0;
        }
      } else {
        return 2;
      }
    }
    switch (tree4()) {
      case 0: vote0++; break;
      case 1: vote1++; break;
      case 2: vote2++; break;
      case 3: vote3++; break;
    }

    int tree5() {
      if (features[35] <= 0.5) {
        if (features[11] <= 0.5) {
          if (features[12] <= 0.5) {
            if (features[31] <= 0.5) {
              if (features[42] <= 0.5) {
                return 3;
              } else {
                return 0;
              }
            } else {
              return 0;
            }
          } else {
            return 1;
          }
        } else {
          if (features[17] <= 0.5) {
            return 3;
          } else {
            return 2;
          }
        }
      } else {
        return 2;
      }
    }
    switch (tree5()) {
      case 0: vote0++; break;
      case 1: vote1++; break;
      case 2: vote2++; break;
      case 3: vote3++; break;
    }

    int tree6() {
      if (features[42] <= 0.5) {
        if (features[41] <= 0.5) {
          if (features[34] <= 0.5) {
            if (features[49] <= 0.5) {
              if (features[31] <= 0.5) {
                return 2;
              } else {
                return 0;
              }
            } else {
              return 2;
            }
          } else {
            return 0;
          }
        } else {
          return 3;
        }
      } else {
        return 0;
      }
    }
    switch (tree6()) {
      case 0: vote0++; break;
      case 1: vote1++; break;
      case 2: vote2++; break;
      case 3: vote3++; break;
    }

    int tree7() {
      if (features[30] <= 0.5) {
        if (features[14] <= 0.5) {
          if (features[18] <= 0.5) {
            if (features[15] <= 0.5) {
              if (features[33] <= 0.5) {
                return 0;
              } else {
                return 0;
              }
            } else {
              return 3;
            }
          } else {
            return 1;
          }
        } else {
          return 2;
        }
      } else {
        return 2;
      }
    }
    switch (tree7()) {
      case 0: vote0++; break;
      case 1: vote1++; break;
      case 2: vote2++; break;
      case 3: vote3++; break;
    }

    int tree8() {
      if (features[9] <= 0.5) {
        if (features[29] <= 0.5) {
          if (features[36] <= 0.5) {
            if (features[3] <= 0.5) {
              if (features[47] <= 0.5) {
                return 2;
              } else {
                return 3;
              }
            } else {
              return 0;
            }
          } else {
            return 0;
          }
        } else {
          return 3;
        }
      } else {
        return 3;
      }
    }
    switch (tree8()) {
      case 0: vote0++; break;
      case 1: vote1++; break;
      case 2: vote2++; break;
      case 3: vote3++; break;
    }

    int tree9() {
      if (features[44] <= 0.5) {
        if (features[43] <= 0.5) {
          if (features[30] <= 0.5) {
            if (features[11] <= 0.5) {
              if (features[12] <= 0.5) {
                return 1;
              } else {
                return 1;
              }
            } else {
              return 3;
            }
          } else {
            return 2;
          }
        } else {
          return 2;
        }
      } else {
        return 1;
      }
    }
    switch (tree9()) {
      case 0: vote0++; break;
      case 1: vote1++; break;
      case 2: vote2++; break;
      case 3: vote3++; break;
    }

    // Find majority vote
    int maxVotes = vote0;
    int prediction = 0;
    
    if (vote1 > maxVotes) { maxVotes = vote1; prediction = 1; }
    if (vote2 > maxVotes) { maxVotes = vote2; prediction = 2; }
    if (vote3 > maxVotes) { maxVotes = vote3; prediction = 3; }
    
    return prediction;
  }
}
