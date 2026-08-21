import joblib
import os
import numpy as np
from itertools import permutations

model_path = r"C:/Users/Admin/StudioProjects/EMF/Backend/best_model_Random_Forest_20260819_232556.pkl"
model = joblib.load(model_path)

# Potential features
dist_range = [0, 5, 10, 20, 50, 100]
height_range = [1.0, 1.5, 1.8]
load_range = [0, 1, 2]
v = 161.0
f = 50.0

param_names = ['Dist', 'Height', 'Load', 'Volt', 'Freq']

print("Searching for feature order that allows compliance (B <= 0.4)...")

found_any = False
for p in permutations(range(5)):
    # Create a test matrix for this permutation
    # features[p[0]] = Dist, features[p[1]] = Height, etc.

    def get_feat(d, h, l):
        feat = [0]*5
        feat[p[0]] = d
        feat[p[1]] = h
        feat[p[2]] = l
        feat[p[3]] = v
        feat[p[4]] = f
        return feat

    # Test extreme cases: Max distance, min height, min load
    feat_safe = get_feat(100.0, 1.0, 0)
    pred_safe = model.predict([feat_safe])[0]
    b_safe = pred_safe[0]

    if b_safe <= 0.4:
        order = [param_names[p.index(i)] for i in range(5)]
        print(f"\nPotential Order Found: {order}")
        print(f"  Max Safety Case (100m, 1m, Off-Peak) -> B: {b_safe:.4f}")

        # Check for decay (B at 0m > B at 100m)
        feat_near = get_feat(0.0, 1.0, 0)
        b_near = model.predict([feat_near])[0][0]
        print(f"  Decay Check: 0m -> {b_near:.4f}, 100m -> {b_safe:.4f}")

        if b_near > b_safe:
            print("  [MATCH] This order shows proper distance decay and compliance.")
            found_any = True

if not found_any:
    print("\nNo feature order produced B <= 0.4 within 100m using V=161, F=50.")
    print("Checking if B <= 0.4 is possible with ANY input at all...")

    # Random sampling to see if 0.4 is even in the output range
    # The model is a RF, so its output is bounded by training data.
    all_preds = []
    for _ in range(1000):
        feat = np.random.uniform(0, 200, 5) # Random inputs
        all_preds.append(model.predict([feat])[0][0])

    print(f"Min B found in random sample: {min(all_preds):.4f}")
    print(f"Max B found in random sample: {max(all_preds):.4f}")
