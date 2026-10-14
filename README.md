# Crop & Plant Disease Recognition App

A mobile app (Android and iOS) that identifies the **crop** in a photo and detects **plant diseases**. The user takes a photo with the camera or picks one from the gallery.

## How it works

1. **Training:** [`crop_identification.ipynb`](crop_identification.ipynb), run in Google Colab
   - Dataset of crop field images in **10 classes**: bitter gourd, coffee, cotton, jute, maize, rice, soybean, sugarcane, tea, wheat (795 training images, 73 validation images).
   - **Transfer learning:** a pre-trained **MobileNetV2** feature extractor (TensorFlow Hub) with a new classification layer, trained for 30 epochs with the Adam optimizer.
   - Reached **92% validation accuracy**.
2. **Export:** the trained model is converted to **TensorFlow Lite** and tested with the TFLite interpreter, so predictions run on the phone without a server.
3. **App:** [`crop_identification_final/`](crop_identification_final), built with **Flutter**, bundles two TFLite models:
   - `model.tflite` identifies the crop (10 classes).
   - `diseasemodel.tflite` recognizes diseases: cotton angular spot, maize common rust, maize gray leaf spot, maize northern leaf blight and pepper bacterial spot.

## Tech stack

| Area | Tools |
|---|---|
| Modeling | Python, TensorFlow / Keras, TensorFlow Hub (MobileNetV2), Google Colab |
| Deployment | TensorFlow Lite |
| App | Flutter (Dart), Android & iOS |

## Repository contents

| Path | What it is |
|---|---|
| `crop_identification.ipynb` | Data prep, transfer learning, training and TFLite export |
| `crop_identification_final/lib/` | Flutter app screens: choose image, predict, show result |
| `crop_identification_final/assets/` | TFLite models and label files |

## Run the app

```bash
cd crop_identification_final
flutter pub get
flutter run
```

---
**Sussma Senthil Kumar** · [Portfolio](https://sussmasenthilkumar.com) · [LinkedIn](https://www.linkedin.com/in/sussma-senthilkumar/)
