import joblib
import os

MODEL_PATH = r"C:\Users\Admin\StudioProjects\EMF\Backend\best_model_Random_Forest_20260819_232556.pkl"

if os.path.exists(MODEL_PATH):
    model = joblib.load(MODEL_PATH)
    print(f"Model type: {type(model)}")
    if hasattr(model, "n_features_in_"):
        print(f"Number of features expected: {model.n_features_in_}")
    if hasattr(model, "feature_names_in_"):
        print(f"Feature names: {model.feature_names_in_}")

    # Try a dummy prediction with 3 features
    try:
        dummy_3 = [[20.0, 1.5, 1]]
        res = model.predict(dummy_3)
        print(f"Prediction with 3 features: {res}")
    except Exception as e:
        print(f"Prediction with 3 features failed: {e}")

    # Try a dummy prediction with 5 features
    try:
        dummy_5 = [[20.0, 1.5, 1, 0.5, 0.2]]
        res = model.predict(dummy_5)
        print(f"Prediction with 5 features: {res}")
    except Exception as e:
        print(f"Prediction with 5 features failed: {e}")
else:
    print("Model not found")
