from flask import Flask
from routes.summarize_route import summarize_blueprint

app = Flask(__name__)
app.register_blueprint(summarize_blueprint)

if __name__ == '__main__':
    app.run(debug=True)