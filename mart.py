# ==============================
# 1. Gemini Client (Direct SDK)
# ==============================
import os
from google import genai

# Set API Key
os.environ["GEMINI_API_KEY"] = "YOUR_API_KEY_HERE"

# Test Gemini connection (optional but good)
client = genai.Client()

test_response = client.models.generate_content(
    model="gemini-3-flash-preview",
    contents="Say OK"
)
print("Gemini Test:", test_response.text)


# ==============================
# 2. LangChain Gemini LLM
# ==============================
from langchain_google_genai import ChatGoogleGenerativeAI

llm = ChatGoogleGenerativeAI(
    model="gemini-3-flash-preview",
    temperature=0
)


# ==============================
# 3. MySQL Database Connection
# ==============================
from urllib.parse import quote_plus
from langchain_community.utilities import SQLDatabase

db_user = "root"
db_password = quote_plus("vinit@07062004")  # URL-encoded
db_host = "localhost"
db_name = "mart_assistant"

db = SQLDatabase.from_uri(
    f"mysql+pymysql://{db_user}:{db_password}@{db_host}/{db_name}",
    sample_rows_in_table_info=3
)

print("\nConnected Tables:\n")
print(db.table_info)


# ==============================
# 4. SQLDatabaseChain (NL → SQL)
# ==============================
from langchain_experimental.sql import SQLDatabaseChain

db_chain = SQLDatabaseChain.from_llm(
    llm=llm,
    db=db,
    verbose=True
)


# ==============================
# 5. Ask Questions (User Input)
# ==============================
print("\nAsk questions about the Mart Assistant database.")
print("Type 'exit' to stop.\n")

while True:
    question = input("🧠 Question: ")
    if question.lower() == "exit":
        break

    try:
        answer = db_chain.run(question)
        print("✅ Answer:", answer, "\n")
    except Exception as e:
        print("❌ Error:", e, "\n")
