from flask import Flask
app = Flask(__name__)

@app.route("/")
def home():
    return "Hello from Project 8 – Flask on EKS with GitOps 🚀"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)

