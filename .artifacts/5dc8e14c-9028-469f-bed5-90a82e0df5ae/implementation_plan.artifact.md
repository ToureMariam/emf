# Implementation Plan - High-Sensitivity ML Mapping

Redefine the feature mapping to better utilize the model's trained range, ensuring that high-load and low-height scenarios correctly trigger non-compliance even at distances > 5m.

## User Review Required

> [!WARNING]
> **Increased Sensitivity**: The app will now be much more sensitive to "Load Condition" and "Height." You will see "NON-COMPLIANT" results at greater distances (up to 35m+) when the load is set to Maximum, as per the model's training.

## Proposed Changes

### [Backend Enhancements]

#### [MODIFY] [main.py](file:///C:/Users/Admin/StudioProjects/emf/Backend/main.py)
- **Expanded Load Mapping**: Mappings for Load will be increased (X-component from `0.1-0.3` to `0.1-0.6`) and distributed across all vector components (X, Y, Z) to trigger the model's high-exposure logic.
- **Height Calibration**: Adjust `rf_strength` to use the full standard deviation range of the model (m to cm conversion).
- **Neutral Data Refinement**: Use scaler means more precisely for unused features.

## Verification Plan

### Manual Verification
1.  **Distance Sensitivity**:
    - Verify **35m + Maximum-Peak** = **NON-COMPLIANT**.
    - Verify **35m + Off-Peak** = **COMPLIANT**.
2.  **Safe Zone Update**: Check that the "Recommended Setback" on the Safe Zone screen now correctly jumps to a higher number (e.g., 35m) when Max Load is selected.
