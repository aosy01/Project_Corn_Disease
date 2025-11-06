import torch
import torchvision.transforms as transforms
from PIL import Image
from flask import Flask, request, jsonify

print("Loading model...")
model_data = torch.load("best_model.pth", map_location=torch.device('cpu'))

model = model_data['model'] if 'model' in model_data else None
if model is None:
    from torchvision.models import mobilenet_v3_large
    model = mobilenet_v3_large(weights=None)
    model.classifier[3] = torch.nn.Linear(model.classifier[3].in_features, 5)
    model.load_state_dict(model_data["model_state_dict"])

model.eval()
print("Model loaded ✅")

app = Flask(__name__)

transform = transforms.Compose([
    transforms.Resize(256),
    transforms.CenterCrop(224),
    transforms.ToTensor(),
    transforms.Normalize(mean=[0.485, 0.456, 0.406], std=[0.229, 0.224, 0.225])
])

class_names = ["Bercak Daun", "Bulai", "Daun Sehat", "Hawar Daun", "Karat Daun"]

# ===== Informasi Penanganan Penyakit =====
treatment_info = {
    "Bercak Daun": (
        "1. Gunakan benih jagung tahan penyakit.\n"
        "2. Hindari kelembapan tinggi dengan jarak tanam yang cukup.\n"
        "3. Buang daun yang terinfeksi dan semprotkan fungisida berbahan aktif mancozeb atau chlorothalonil."
    ),
    "Bulai": (
        "1. Gunakan varietas jagung tahan bulai.\n"
        "2. Lakukan pergiliran tanaman (rotasi) dengan non-jagung.\n"
        "3. Rendam benih dengan fungisida metalaksil sebelum tanam.\n"
        "4. Cabut tanaman yang terserang berat."
    ),
    "Daun Sehat": (
        "Tanaman dalam kondisi sehat 🌿\n"
        "Pertahankan perawatan rutin: penyiraman cukup, pemupukan seimbang, kontrol gulma."
    ),
    "Hawar Daun": (
        "1. Gunakan varietas tahan hawar daun.\n"
        "2. Hindari penanaman terus-menerus di lahan sama.\n"
        "3. Semprot fungisida sistemik seperti azoxystrobin atau propiconazole jika perlu."
    ),
    "Karat Daun": (
        "1. Gunakan varietas tahan karat.\n"
        "2. Pangkas daun bawah yang terinfeksi.\n"
        "3. Gunakan fungisida berbasis strobilurin atau triazol.\n"
        "4. Rotasi tanaman untuk mencegah penyebaran spora."
    )
}

@app.route("/")
def home():
    return "Flask Corn Disease API is running ✅"

@app.route("/predict", methods=["POST"])
def predict():
    if "file" not in request.files:
        return jsonify({"error": "No file uploaded"}), 400

    img = Image.open(request.files["file"]).convert("RGB")
    img_tensor = transform(img).unsqueeze(0)

    with torch.no_grad():
        output = model(img_tensor)
        probabilities = torch.softmax(output, dim=1)
        confidence = probabilities.max().item()
        _, pred = torch.max(output, 1)
        label = class_names[pred.item()]

    return jsonify({
        "class": label,
        "confidence": confidence,
        "treatment": treatment_info[label]
    })

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
