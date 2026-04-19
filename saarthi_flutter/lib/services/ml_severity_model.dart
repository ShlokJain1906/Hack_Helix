// GENERATED CODE - DO NOT MODIFY BY HAND
// This file contains a purely offline Random Forest model for Severity Classification.
// Generated from Python scikit-learn.

class MLModelData {
  static const List<String> vocabulary = ["accident", "active", "ankle", "arm", "arrest", "attack", "badly", "big", "bit", "bleeding", "blood", "blue", "bone", "breathing", "building", "car", "got", "having", "head", "heart", "heavily", "hurt", "hurts", "injuries", "kitchen", "leg", "losing", "lot", "major", "minor", "mother", "need", "okay", "pains", "paracetamol", "people", "pulse", "really", "scratch", "shooter", "showing", "small", "smoke", "sprained", "stabbed", "stairs", "stopped", "stubbed", "sweating", "think"];

  static int predictSeverity(List<double> features) {
    int vote0 = 0;
    int vote1 = 0;
    int vote2 = 0;
    int vote3 = 0;

    int tree0() {
      if (features[7] <= 0.5) {
        if (features[24] <= 0.5) {
          if (features[34] <= 0.5) {
            if (features[35] <= 0.5) {
              if (features[1] <= 0.5) {
                return 3;
              } else {
                return 3;
              }
            } else {
              return 2;
            }
          } else {
            return 0;
          }
        } else {
          return 2;
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
      if (features[31] <= 0.5) {
        if (features[24] <= 0.5) {
          if (features[38] <= 0.5) {
            if (features[43] <= 0.5) {
              if (features[3] <= 0.5) {
                return 1;
              } else {
                return 2;
              }
            } else {
              return 1;
            }
          } else {
            return 0;
          }
        } else {
          return 2;
        }
      } else {
        return 3;
      }
    }
    switch (tree1()) {
      case 0: vote0++; break;
      case 1: vote1++; break;
      case 2: vote2++; break;
      case 3: vote3++; break;
    }

    int tree2() {
      if (features[28] <= 0.5) {
        if (features[40] <= 0.5) {
          if (features[29] <= 0.5) {
            if (features[41] <= 0.5) {
              if (features[6] <= 0.5) {
                return 3;
              } else {
                return 1;
              }
            } else {
              return 0;
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
    }
    switch (tree2()) {
      case 0: vote0++; break;
      case 1: vote1++; break;
      case 2: vote2++; break;
      case 3: vote3++; break;
    }

    int tree3() {
      if (features[47] <= 0.5) {
        if (features[9] <= 0.5) {
          if (features[32] <= 0.5) {
            if (features[34] <= 0.5) {
              if (features[1] <= 0.5) {
                return 3;
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
          if (features[20] <= 0.5) {
            return 1;
          } else {
            return 2;
          }
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
      if (features[37] <= 0.5) {
        if (features[41] <= 0.5) {
          if (features[25] <= 0.5) {
            if (features[0] <= 0.5) {
              if (features[9] <= 0.5) {
                return 3;
              } else {
                return 2;
              }
            } else {
              return 2;
            }
          } else {
            return 1;
          }
        } else {
          return 0;
        }
      } else {
        return 1;
      }
    }
    switch (tree4()) {
      case 0: vote0++; break;
      case 1: vote1++; break;
      case 2: vote2++; break;
      case 3: vote3++; break;
    }

    int tree5() {
      if (features[29] <= 0.5) {
        if (features[0] <= 0.5) {
          if (features[18] <= 0.5) {
            if (features[46] <= 0.5) {
              if (features[49] <= 0.5) {
                return 3;
              } else {
                return 2;
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
        if (features[15] <= 0.5) {
          return 0;
        } else {
          return 1;
        }
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
        if (features[32] <= 0.5) {
          if (features[18] <= 0.5) {
            if (features[14] <= 0.5) {
              if (features[16] <= 0.5) {
                return 2;
              } else {
                return 0;
              }
            } else {
              return 3;
            }
          } else {
            return 2;
          }
        } else {
          return 0;
        }
      } else {
        return 2;
      }
    }
    switch (tree6()) {
      case 0: vote0++; break;
      case 1: vote1++; break;
      case 2: vote2++; break;
      case 3: vote3++; break;
    }

    int tree7() {
      if (features[40] <= 0.5) {
        if (features[8] <= 0.5) {
          if (features[9] <= 0.5) {
            if (features[31] <= 0.5) {
              if (features[14] <= 0.5) {
                return 3;
              } else {
                return 3;
              }
            } else {
              return 0;
            }
          } else {
            if (features[20] <= 0.5) {
              return 1;
            } else {
              return 2;
            }
          }
        } else {
          return 0;
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
      if (features[11] <= 0.5) {
        if (features[26] <= 0.5) {
          if (features[16] <= 0.5) {
            if (features[31] <= 0.5) {
              if (features[43] <= 0.5) {
                return 2;
              } else {
                return 1;
              }
            } else {
              if (features[34] <= 0.5) {
                return 3;
              } else {
                return 0;
              }
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
      if (features[48] <= 0.5) {
        if (features[43] <= 0.5) {
          if (features[14] <= 0.5) {
            if (features[28] <= 0.5) {
              if (features[9] <= 0.5) {
                return 1;
              } else {
                return 1;
              }
            } else {
              return 2;
            }
          } else {
            if (features[39] <= 0.5) {
              return 2;
            } else {
              return 3;
            }
          }
        } else {
          return 1;
        }
      } else {
        return 3;
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
