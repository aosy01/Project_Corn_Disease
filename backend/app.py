from flask import Flask, request, jsonify
from PIL import Image
import torch
import torch.nn as nn
from torchvision import transforms
from torchvision.models import mobilenet_v3_large, MobileNet_V3_Large_Weights

app = Flask(__name__)

# ===== Load Model =====
num_classes = 5
device = torch.device("cpu")

model = mobilenet_v3_large(weights=MobileNet_V3_Large_Weights.IMAGENET1K_V2)
for param in model.parameters():
    param.requires_grad = False
model.classifier[3] = nn.Linear(model.classifier[3].in_features, num_classes)

model.load_state_dict(torch.load("mobilenetv3_leaf_disease.pth", map_location=device))
model.eval()

# ===== Transformasi Gambar =====
transform = transforms.Compose([
    transforms.Resize((224, 224)),
    transforms.ToTensor(),
    transforms.Normalize([0.485, 0.456, 0.406], [0.229, 0.224, 0.225])
])

# ===== API Endpoint =====
@app.route('/predict', methods=['POST'])
def predict():
    file = request.files['file']
    image = Image.open(file.stream).convert('RGB')
    img_t = transform(image).unsqueeze(0)

    with torch.no_grad():
        output = model(img_t)
        probs = torch.nn.functional.softmax(output, dim=1)
        confidence, predicted = torch.max(probs, 1)

    labels = ["Bercak Daun", "Bulai", "Daun Sehat", "Hawar Daun", "Karat Daun"]
    result = labels[predicted.item()]

    return jsonify({
        "class": result,
        "confidence": confidence.item()
    })


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
