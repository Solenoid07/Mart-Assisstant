# 🛍️ Mart Assistant – Natural Language to SQL LLM Assistant 🤖

![Mart Assistant UI](assets/mart_assistant_ui.png)

**Mart Assistant** is an end-to-end **LLM-powered system** built using **Google Gemini + LangChain** that allows users to interact with a **MySQL shoes inventory database using plain English**.

The system understands user questions, converts them into **MySQL queries**, executes them on the database, and returns **clear answers** — without the user needing to know SQL.

---

## 🚀 Use Case

**Mart Assistant** is a shoe retail store that manages its **inventory, pricing, and discounts** in a MySQL database.

Store managers often ask analytics or inventory-related questions like:

| Example Question | What the System Does |
|------------------|---------------------|
| *How many white Nike shoes of size 9 are left in stock?* | Generates a `SELECT COUNT()` query and returns the exact stock |
| *Which brand has the highest inventory?* | Aggregates stock using SQL |
| *List all shoes with discounts greater than 30%* | Uses JOIN between shoes & discounts |
| *What is the average price of Adidas shoes?* | Uses SQL aggregation |

All queries are handled automatically using **natural language**.

---

## 🧠 How It Works

1. User asks a question in **plain English**
2. **Google Gemini (LLM)** understands intent
3. **LangChain** converts the question into SQL
4. SQL runs on the **MySQL Mart Assistant database**
5. The final answer is returned in readable form

---

## 🧠 Tech Stack

| Component | Technology |
|---------|-----------|
| LLM | Google Gemini (`gemini-3-flash-preview`) |
| Framework | LangChain + LangChain Experimental |
| Database | MySQL |
| Embeddings (optional) | HuggingFace Sentence Transformers |
| Vector Store (optional) | ChromaDB |
| Environment Handling | python-dotenv |
| UI | Streamlit (Chat Interface) |

---

## 📦 Installation

```bash
git clone <your-repo-url>
cd mart-assistant
pip install -r requirements.txt
