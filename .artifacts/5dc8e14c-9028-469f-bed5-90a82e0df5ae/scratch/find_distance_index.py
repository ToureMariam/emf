import joblib
import os

MODEL_PATH = r"C:\Users\Admin\StudioProjects\emf\Backend\best_model_Random_Forest_20260819_232556.pkl"

def test_permutations():
    model = joblib.load(MODEL_PATH)

    for i in range(5):
        # Set all to 1.0, but vary the i-th feature
        f_close = [1.0] * 5
        f_close[i] = 1.0

        f_far = [1.0] * 5
        f_far[i] = 100.0

        p_close = model.predict([f_close])[0][0]
        p_far = model.predict([f_far])[0][0]

        diff = abs(p_close - p_far)
        print(f"Feature {i} variation (1.0 vs 100.0) => Diff: {diff:.6f}")

if __name__ == "__main__":
    test_permutations()
