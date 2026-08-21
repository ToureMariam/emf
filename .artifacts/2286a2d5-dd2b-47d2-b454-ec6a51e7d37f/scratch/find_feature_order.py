import joblib
import os
import numpy as np
from itertools import permutations

model_path = r"C:/Users/Admin/StudioProjects/EMF/Backend/best_model_Random_Forest_20260819_232556.pkl"
model = joblib.load(model_path)

# Known parameters for a test case
d1, d2 = 0, 50
h = 1.5
l = 1
v = 161
f = 50

params = [d1, h, l, v, f]
param_names = ['Dist', 'Height', 'Load', 'Volt', 'Freq']

print("Searching for feature order that shows distance decay...")

for p in permutations(range(5)):
    # Try distance d1 and d2 in the position p[0]
    # Height in p[1], Load in p[2], Volt in p[3], Freq in p[4]

    def get_features(dist):
        feat = [0]*5
        feat[p[0]] = dist
        feat[p[1]] = h
        feat[p[2]] = l
        feat[p[3]] = v
        feat[p[4]] = f
        return feat

    pred1 = model.predict([get_features(d1)])[0]
    pred2 = model.predict([get_features(d2)])[0]

    # B field is index 0, E field is index 1 (usually B is smaller than E in these units)
    b1, e1 = pred1[0], pred1[1]
    b2, e2 = pred2[0], pred2[1]

    # We expect b1 > b2 and e1 > e2 (decay with distance)
    if b1 > b2 and e1 > e2:
        order = [param_names[p.index(i)] for i in range(5)]
        print(f"Candidate Order: {order}")
        print(f"  0m -> B: {b1:.4f}, E: {e1:.4f}")
        print(f"  50m -> B: {b2:.4f}, E: {e2:.4f}")
        print(f"  Ratio B: {b1/b2:.2f}, Ratio E: {e1/e2:.2f}")

print("\nDone.")
