import joblib
import os
import pandas as pd
import numpy as np

model_path = r"C:/Users/Admin/StudioProjects/EMF/Backend/best_model_Random_Forest_20260819_232556.pkl"
model = joblib.load(model_path)

print("Model Type:", type(model))
if hasattr(model, 'n_features_in_'):
    print("Features In:", model.n_features_in_)

# If it's a RandomForest, we can look at feature importances
if hasattr(model, 'feature_importances_'):
    print("Feature Importances:", model.feature_importances_)

# Let's try to find any attributes that might indicate feature names
for attr in dir(model):
    if 'feature' in attr.lower():
        try:
            val = getattr(model, attr)
            print(f"{attr}: {val}")
        except:
            pass

# Try to find what it was trained on by looking at the estimator's trees if possible
# or if there's a pipeline
if hasattr(model, 'estimators_'):
    print("Number of estimators:", len(model.estimators_))
    # We can't easily get feature names from trees if they weren't named in the first place.

# Test a wide range of distances to see if it ever goes below 0.4
print("\nScanning distances for B <= 0.4 (Height=1.0, Load=0, V=161, F=50)")
for d in range(0, 500, 10):
    feat = np.array([[float(d), 1.0, 0, 161.0, 50.0]])
    pred = model.predict(feat)
    b = pred[0][0]
    if b <= 0.4:
        print(f"B <= 0.4 reached at {d}m: B={b:.4f}")
        break
else:
    print("B never reached 0.4 in 0-500m scan with Dist as first feature.")

print("\nScanning distances with Dist as FOURTH feature (just in case)")
# Maybe [Volt, Height, Load, Dist, Freq] ?
for d in range(0, 500, 10):
    feat = np.array([[161.0, 1.0, 0, float(d), 50.0]])
    pred = model.predict(feat)
    b = pred[0][0]
    if b <= 0.4:
        print(f"B <= 0.4 reached at {d}m: B={b:.4f}")
        break

print("\nScanning distances with Dist as FIFTH feature")
for d in range(0, 500, 10):
    feat = np.array([[161.0, 1.0, 0, 50.0, float(d)]])
    pred = model.predict(feat)
    b = pred[0][0]
    if b <= 0.4:
        print(f"B <= 0.4 reached at {d}m: B={b:.4f}")
        break
