from PyPDF2 import PdfReader
from io import BytesIO
from langchain_core.prompts import PromptTemplate
from langchain.docstore.document import Document
from models.langchain_model import llm_model
from langchain.chains.summarize import load_summarize_chain

def extract_text_from_pdf(file):
    pdf_reader = PdfReader(BytesIO(file.read()))
    text = ''
    for page in pdf_reader.pages:
        content = page.extract_text()
        if content:
            text += content + '\n'
    return text

def summarize_text(text):
    try:
        template = PromptTemplate(
            input_variables=['text'],
            template='''Write a concise and short summary of the following document.
                        Document: `{text}`
                        '''
        )
        chain = load_summarize_chain(
            llm_model,
            chain_type='stuff',  # Adjust this according to your model setup
            prompt=template,
            verbose=False
        )
        docs = [Document(page_content=text)]
        output_summary = chain.run(docs)
        return output_summary
    except Exception as e:
        return str(e)