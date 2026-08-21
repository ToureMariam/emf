import joblib
import os

SCALER_PATH = r"C:\Users\Admin\StudioProjects\emf\Backend\scaler.pkl"

def inspect():
    scaler = joblib.load(SCALER_PATH)
    print("Scaler Mean:", scaler.mean_)
    print("Scaler Scale:", scaler.scale_)
    print("Feature names:", getattr(scaler, 'feature_names_in_', 'N/A'))

if __name__ == "__main__":
    inspect()
