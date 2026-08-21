import joblib
import os

MODEL_PATH = r"C:\Users\Admin\StudioProjects\emf\Backend\best_model_Random_Forest_20260819_232556.pkl"

def test(d):
    model = joblib.load(MODEL_PATH)
    # Mapping distance to Index 4
    features = [[1.0, 1.0, 1.0, 1.0, d]]
    p = model.predict(features)[0][0]
    print(f"Dist (at idx 4)={d} => B={p:.4f}")

if __name__ == "__main__":
    test(1)
    test(10)
    test(50)
    test(100)
