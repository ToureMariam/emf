import joblib
import os

BASE_DIR = r"C:\Users\Admin\StudioProjects\emf\Backend"
MODEL_PATH = os.path.join(BASE_DIR, "best_model_Random_Forest_20260819_232556.pkl")

def test_prediction(distance):
    if not os.path.exists(MODEL_PATH):
        print("Model not found")
        return

    model = joblib.load(MODEL_PATH)

    # Trying the OLD feature mapping: [distance, height, load, 1.0, 1.0]
    # distance, 1.5 (height), 1 (average peak), 1.0, 1.0
    features = [[
        distance,
        1.5,
        1,
        1.0,
        1.0
    ]]

    prediction = model.predict(features)

    b_field = prediction[0][0]
    e_field = prediction[0][1]

    print(f"Distance: {distance}m")
    print(f"Predicted B-Field: {b_field:.6f} uT")
    print(f"Predicted E-Field: {e_field:.6f} V/m")
    print(f"Compliant: {(b_field <= 0.4 and e_field <= 5000)}")
    print("-" * 30)

if __name__ == "__main__":
    print("Testing Predictions WITHOUT SCALER (Old Logic):")
    test_prediction(5)
    test_prediction(20)
    test_prediction(50)
    test_prediction(100)
