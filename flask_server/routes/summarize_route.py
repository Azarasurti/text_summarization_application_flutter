from flask import Blueprint, request, jsonify
from models.langchain_model import llm_model
from utils.pdf_utils import extract_text_from_pdf, summarize_text
from langchain.chains.summarize import load_summarize_chain

summarize_blueprint = Blueprint('summarize', __name__)

@summarize_blueprint.route('/summarize', methods=['POST'])
def summarize():
    try:
        file = request.files['file']
        text = extract_text_from_pdf(file)
        if not text:
            return jsonify({'error': 'Could not extract text from PDF.'}), 400
        else:
            summary = summarize_text(text)
            return jsonify({'summary': summary}), 200
    except Exception as e:
        return jsonify({'error': f"Error processing PDF: {str(e)}"}), 500