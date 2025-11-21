import torch
import torch.nn as nn
import torchvision.models as models
import torchvision.transforms as transforms
from PIL import Image
from flask import Flask, request, jsonify
import os

print("Loading model...")

# ====================== LOAD MODEL ======================
model_path = "best_model.pth"

# Pastikan file ada
if not os.path.exists(model_path):
    raise FileNotFoundError(f"Model tidak ditemukan: {model_path}")

# Buat arsitektur model (sama persis seperti training)
model = models.mobilenet_v3_large(weights=None)

# Ubah classifier jadi 5 kelas
in_features = model.classifier[3].in_features
model.classifier = nn.Sequential(
    model.classifier[0],
    model.classifier[1],
    nn.Dropout(p=0.2),           # sesuaikan dengan dropout terbaik dari Optuna (misal 0.2-0.5)
    nn.Linear(in_features, 5)    # 5 kelas: Bercak, Bulai, Sehat, Hawar, Karat
)

# Load state_dict langsung
state_dict = torch.load(model_path, map_location=torch.device('cpu'))
model.load_state_dict(state_dict)
model.eval()

print("Model loaded successfully ✅")

# ====================== TRANSFORMS ======================
transform = transforms.Compose([
    transforms.Resize(256),
    transforms.CenterCrop(224),
    transforms.ToTensor(),
    transforms.Normalize(mean=[0.485, 0.456, 0.406],
                         std=[0.229, 0.224, 0.225])
])

# ====================== KELAS & TREATMENT ======================
class_names = ["Bercak Daun", "Bulai", "Daun Sehat", "Hawar Daun", "Karat Daun"]

treatment_info = {
    "Bercak Daun": "1. Gunakan benih tahan.\n2. Jarak tanam cukup.\n3. Semprot fungisida mancozeb/chlorothalonil.",
    "Bulai": "1. Varietas tahan bulai.\n2. Rotasi tanaman.\n3. Rendam benih dengan metalaksil.\n4. Cabut tanaman sakit parah.",
    "Daun Sehat": "Tanaman sehat! 🌿\nLanjutkan perawatan rutin: penyiraman, pemupukan, dan pengendalian gulma.",
    "Hawar Daun": "1. Varietas tahan hawar.\n2. Rotasi lahan.\n3. Semprot azoxystrobin/propiconazole jika diperlukan.",
    "Karat Daun": "1. Varietas tahan karat.\n2. Pangkas daun bawah.\n3. Semprot fungisida strobilurin/triazol."
}

# ====================== FLASK APP ======================
app = Flask(__name__)

@app.route("/")
def home():
    return "Corn Disease Detection API - Running ✅"

@app.route("/predict", methods=["POST"])
def predict():
    if "file" not in request.files:
        return jsonify({"error": "No file uploaded"}), 400

    file = request.files["file"]
    if not file or file.filename == "":
        return jsonify({"error": "No file selected"}), 400

    try:
        img = Image.open(file.stream).convert("RGB")
        img_tensor = transform(img).unsqueeze(0)

        with torch.no_grad():
            output = model(img_tensor)
            probs = torch.softmax(output, dim=1)[0].cpu().numpy()   # jadi array numpy

        pred_idx = probs.argmax()
        predicted_class = class_names[pred_idx]
        confidence = float(probs[pred_idx])

        # Top-3 prediksi
        top3_idx = probs.argsort()[-3:][::-1]
        top3 = [
            {"class": class_names[i], "confidence": round(float(probs[i]), 4)}
            for i in top3_idx
        ]

        return jsonify({
            "predicted_class": predicted_class,
            "confidence": round(confidence, 4),
            "treatment": treatment_info[predicted_class],
            "all_predictions": top3
        })

    except Exception as e:
        return jsonify({"error": "Prediction failed", "details": str(e)}), 500

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=False)