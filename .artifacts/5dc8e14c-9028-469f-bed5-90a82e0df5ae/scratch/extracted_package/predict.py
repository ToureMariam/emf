
# ============================================================
# DEPLOYMENT SCRIPT
# ============================================================
import joblib
import numpy as np

# Load the model and scaler
model = joblib.load('model.pkl')
scaler = joblib.load('scaler.pkl')

def predict_emf(distance, rf_strength, x_component, y_component, z_component):
    """
    Make predictions for magnetic and electric fields.
    
    Args:
        distance: Distance in meters
        rf_strength: RF strength
        x_component: X component value
        y_component: Y component value
        z_component: Z component value
    
    Returns:
        dict: Predicted magnetic_field and electric_field
    """
    # Prepare input features
    features = np.array([[distance, rf_strength, x_component, 
                          y_component, z_component]])
    
    # Scale features
    features_scaled = scaler.transform(features)
    
    # Make prediction
    prediction = model.predict(features_scaled)
    
    return {
        'magnetic_field': prediction[0][0],
        'electric_field': prediction[0][1]
    }

# Example usage
if __name__ == "__main__":
    # Test with sample values
    result = predict_emf(
        distance=5.0,
        rf_strength=0.8,
        x_component=0.5,
        y_component=0.3,
        z_component=0.2
    )
    print("Prediction:", result)
    print(f"Magnetic Field: {result['magnetic_field']:.4f}")
    print(f"Electric Field: {result['electric_field']:.4f}")
