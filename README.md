# Crop & Plant Disease Recognition App

A mobile app (Android and iOS) that identifies the **crop** in a photo and detects **plant diseases**, so a farmer can check a plant from a phone camera or the gallery.

## How it works

1. **Model:** a convolutional neural network built with transfer learning on **MobileNetV2** (pre-trained on ImageNet), fine-tuned on a dataset of labelled crop and disease images.
2. **Mobile-ready:** the trained TensorFlow model is converted to **TensorFlow Lite**, so predictions run on the phone without a server.
3. **App:** built with **Flutter**. The user takes or picks a photo, and the app shows the predicted crop and any detected disease.

## Tech stack

| Area | Tools |
|---|---|
| Modeling | Python, TensorFlow / Keras, MobileNetV2 (transfer learning) |
| Deployment | TensorFlow Lite |
| App | Flutter (Dart), Android & iOS |

## Repository contents

| Path | What it is |
|---|---|
| `AI-Based-Crop-and-disease-Recognition-Mobile-App-master/` | Flutter app source code |

## Run it locally

```bash
cd AI-Based-Crop-and-disease-Recognition-Mobile-App-master
flutter pub get
flutter run
```

## What I learned

- Transfer learning gets strong results from a small, domain-specific image dataset.
- Model size and speed matter as much as accuracy when the model has to run on a phone.

---
**Sussma Senthil Kumar** · [Portfolio](https://sussmasenthilkumar.com) · [LinkedIn](https://www.linkedin.com/in/sussma-senthilkumar/)
