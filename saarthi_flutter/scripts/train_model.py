import json
import os
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.ensemble import RandomForestClassifier

# 1. Synthetic Dataset - EXPANDED for better differentiation
data = [
    # Low Severity (0)
    ("I stubbed my toe", 0),
    ("I have a minor headache", 0),
    ("Feeling a bit dizzy but okay", 0),
    ("Got a small scratch on my arm", 0),
    ("Need some paracetamol", 0),
    ("I have a headache and stomach ache", 0),
    ("Just a minor scratch or papercut", 0),
    ("My stomach is hurting", 0),
    ("minor cut on finger", 0),
    ("feeling okay now", 0),
    ("small papercut", 0),
    ("mild headache", 0),
    ("minor scratch", 0),
    ("it is just a scratch", 0),
    ("small bruise", 0),
    ("tiny cut", 0),
    
    # Medium Severity (1)
    ("I cut my finger and it's bleeding", 1),
    ("I fell down the stairs and my leg hurts", 1),
    ("Someone fainted but they are breathing", 1),
    ("I sprained my ankle really badly", 1),
    ("Minor car bumper crash, no big injuries", 1),
    ("Severe headache and blurred vision", 1),
    ("Major papercut and bleeding", 1),
    ("badly sprained wrist", 1),
    ("pain is getting worse", 1),
    ("difficulty walking", 1),
    
    # High Severity (2)
    ("There is a fire in the kitchen", 2),
    ("Someone is bleeding heavily from their head", 2),
    ("I see smoke coming from the building", 2),
    ("Major car accident, people are hurt", 2),
    ("I think I broke my arm bone is showing", 2),
    ("Fell down and snapped my bone, severe fracture", 2),
    ("It's so hot, fainted outside in the sun, heat dehydrated", 2),
    ("Heatstroke, very hot and dehydrated", 2),
    ("Dog bite, rabid animal", 2),
    ("I have a broken bone and fracture", 2),
    ("Major scratch bleeding heavily", 2),
    ("Deep scratch and losing a lot of blood", 2),
    ("severe bleeding from arm", 2),
    ("car crash injuries", 2),

    # Critical Severity (3)
    ("My mother collapsed and is not breathing", 3),
    ("Someone is choking and turning blue", 3),
    ("Active shooter in the building", 3),
    ("My friend got stabbed and is losing a lot of blood", 3),
    ("No pulse, heart stopped, need CPR", 3),
    ("My dad is having chest pains and sweating, think it's a heart attack", 3),
    ("Cardiac arrest, they are not breathing", 3),
    ("Having a stroke, face drooping, slurred speech", 3),
    ("Body is numb and face paralyzed, stroke", 3),
    ("Having a seizure, shaking, convulsing, epilepsy", 3),
    ("They are fitting and shaking violently", 3),
    ("Swallowed poison, pills, chemicals, overdose", 3),
    ("Drank chemicals and poison", 3),
    ("Severe allergic reaction, throat closing", 3),
    ("Bee sting, peanuts, swelling allergic", 3),
    ("Drowning in the water pool", 3),
    ("Submerged in ocean drowning", 3),
    ("Snake bite, venom rabid animal", 3),
    ("not breathing and unconscious", 3),
    ("stopped breathing", 3),
]

texts = [d[0] for d in data]
labels = [d[1] for d in data]

# 2. Vectorization (Bag of Words for simplicity in Dart)
vectorizer = CountVectorizer(lowercase=True, stop_words='english', max_features=150)
X = vectorizer.fit_transform(texts).toarray()

# 3. Train Random Forest (Increase trees to 20, depth to 10 for more nuance)
rf = RandomForestClassifier(n_estimators=20, max_depth=10, random_state=42)
rf.fit(X, labels)

# 4. Export to Dart
vocab = vectorizer.get_feature_names_out().tolist()

def export_tree_to_dart(tree, node=0, indent="    "):
    left = tree.children_left[node]
    right = tree.children_right[node]
    
    if left == -1 and right == -1: # Leaf node
        # Get the class with highest probability/count
        values = tree.value[node][0]
        predicted_class = values.argmax()
        return f"{indent}return {predicted_class};\n"
    
    feature_idx = tree.feature[node]
    threshold = tree.threshold[node]
    
    code = f"{indent}if (features[{feature_idx}] <= {threshold}) {{\n"
    code += export_tree_to_dart(tree, left, indent + "  ")
    code += f"{indent}}} else {{\n"
    code += export_tree_to_dart(tree, right, indent + "  ")
    code += f"{indent}}}\n"
    
    return code

dart_code = f"""// GENERATED CODE - DO NOT MODIFY BY HAND
// This file contains a purely offline Random Forest model for Severity Classification.
// Generated from Python scikit-learn.

class MLModelData {{
  static const List<String> vocabulary = {json.dumps(vocab)};

  static int predictSeverity(List<double> features) {{
    int vote0 = 0;
    int vote1 = 0;
    int vote2 = 0;
    int vote3 = 0;

"""

for i, estimator in enumerate(rf.estimators_):
    dart_code += f"    int tree{i}() {{\n"
    dart_code += export_tree_to_dart(estimator.tree_, indent="      ")
    dart_code += f"    }}\n"
    
    dart_code += f"    switch (tree{i}()) {{\n"
    dart_code += f"      case 0: vote0++; break;\n"
    dart_code += f"      case 1: vote1++; break;\n"
    dart_code += f"      case 2: vote2++; break;\n"
    dart_code += f"      case 3: vote3++; break;\n"
    dart_code += f"    }}\n\n"

dart_code += """    // Find majority vote
    int maxVotes = vote0;
    int prediction = 0;
    
    if (vote1 > maxVotes) { maxVotes = vote1; prediction = 1; }
    if (vote2 > maxVotes) { maxVotes = vote2; prediction = 2; }
    if (vote3 > maxVotes) { maxVotes = vote3; prediction = 3; }
    
    return prediction;
  }
}
"""

out_path = os.path.join(os.path.dirname(os.path.dirname(__file__)), 'lib', 'services', 'ml_severity_model.dart')
with open(out_path, 'w') as f:
    f.write(dart_code)

print(f"Model successfully exported to {out_path}")
print(f"Vocabulary size: {len(vocab)}")
print(f"Number of trees: {len(rf.estimators_)}")
