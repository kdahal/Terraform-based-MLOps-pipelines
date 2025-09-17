# Builds on basic_rag.py; adds streaming and basic eval
import os
from langchain_core.output_parsers import StrOutputParser
from langchain_core.runnables import RunnablePassthrough
from langchain_openai import ChatOpenAI
from langchain_community.vectorstores import FAISS
from langchain_openai import OpenAIEmbeddings
from langchain.text_splitter import RecursiveCharacterTextSplitter
from rouge_score import rouge_scorer  # pip install rouge-score for eval

# Assume same docs and embeddings as basic_rag.py
documents = [...]  # Same as above
splitter = RecursiveCharacterTextSplitter(chunk_size=500, chunk_overlap=50)
texts = splitter.create_documents([doc for doc in documents])
embeddings = OpenAIEmbeddings(openai_api_key=os.getenv("OPENAI_API_KEY"))
vectorstore = FAISS.from_documents(texts, embeddings)

# RAG chain with streaming
llm = ChatOpenAI(model="gpt-3.5-turbo", streaming=True)
retriever = vectorstore.as_retriever()

def format_docs(docs):
    return "\n\n".join(doc.page_content for doc in docs)

rag_chain = (
    {"context": retriever | format_docs, "question": RunnablePassthrough()}
    | ChatPromptTemplate.from_template(
        "Answer based on context: {context}\nQuestion: {question}"
    )  # Define ChatPromptTemplate properly
    | llm
    | StrOutputParser()
)

# Streaming query
query = "How does Terraform fit into MLOps?"
for chunk in rag_chain.stream(query):
    print(chunk, end="", flush=True)

# Basic eval (ROUGE score against ground truth)
ground_truth = "Terraform automates infrastructure for ML pipelines."
scorer = rouge_scorer.RougeScorer(['rouge1'], use_stemmer=True)
result = rag_chain.invoke(query)
score = scorer.score(ground_truth, result)
print(f"\nROUGE Score: {score}")