from flask import Flask

app = Flask(__name__)

@app.route('/')
def home():
    return """
    <html>
    <head><title>DevSecOps App</title></head>
    <body style="font-family: Arial; text-align: center; padding: 50px;">
        <h1>🚀 Hello from DevSecOps App!</h1>
        <p>Deployed using Docker + Jenkins + Terraform + AWS</p>
        <p style="color: green;">✅ Application is running successfully</p>
    </body>
    </html>
    """

@app.route('/health')
def health():
    return {"status": "healthy"}, 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
