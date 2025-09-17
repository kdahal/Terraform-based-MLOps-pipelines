import os
from langchain_community.vectorstores import FAISS
from langchain_openai import OpenAIEmbeddings
from langchain.text_splitter import CharacterTextSplitter
from langchain_openai import ChatOpenAI
from langchain.chains import RetrievalQA
from langchain.document_loaders import TextLoader

# Sample documents (replace with your corpus)
documents = [
    "AI/ML is transforming industries. RAG improves LLM accuracy by retrieving relevant info.",
    "Terraform automates MLOps pipelines for scalable ML deployments."
]

# Load and split docs
text_splitter = CharacterTextSplitter(chunk_size=1000, chunk_overlap=0)
texts = text_splitter.create_documents([doc for doc in documents])

# Embeddings and vector store
embeddings = OpenAIEmbeddings(openai_api_key=os.getenv("OPENAI_API_KEY"))
vectorstore = FAISS.from_documents(texts, embeddings)

# LLM and QA chain
llm = ChatOpenAI(model="gpt-3.5-turbo", temperature=0)
qa_chain = RetrievalQA.from_chain_type(
    llm=llm,
    chain_type="stuff",
    retriever=vectorstore.as_retriever(search_kwargs={"k": 2})
)

# Query
query = "What is RAG?"
result = qa_chain.run(query)
print(result)
# Output: Something like "RAG improves LLM accuracy by retrieving relevant info."