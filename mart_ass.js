const chatBox = document.getElementById("chatBox");

// Simulated Database
const data = {
    brands: ["Van Huesen", "Levi", "Nike", "Adidas"],
    colors: ["Red", "Blue", "Black", "White"],
    sizes: ["XS", "S", "M", "L", "XL"],
    discounts: [
        { id: 1, discount: 10 },
        { id: 2, discount: 15 },
        { id: 3, discount: 20 },
        { id: 4, discount: 5 },
        { id: 5, discount: 25 },
        { id: 6, discount: 10 },
        { id: 7, discount: 30 },
        { id: 8, discount: 35 },
        { id: 9, discount: 40 },
        { id: 10, discount: 45 }
    ]
};

function sendMessage() {
    const input = document.getElementById("userInput");
    const userText = input.value.trim();
    if (!userText) return;

    addMessage(userText, "user-message");
    input.value = "";

    setTimeout(() => {
        const reply = getBotReply(userText.toLowerCase());
        addMessage(reply, "bot-message");
    }, 500);
}

function addMessage(text, className) {
    const div = document.createElement("div");
    div.className = className;
    div.innerText = text;
    chatBox.appendChild(div);
    chatBox.scrollTop = chatBox.scrollHeight;
}

function getBotReply(text) {

    if (text.includes("brand")) {
        return "Available brands are: " + data.brands.join(", ");
    }

    if (text.includes("color")) {
        return "Available colors are: " + data.colors.join(", ");
    }

    if (text.includes("size")) {
        return "Available sizes are: " + data.sizes.join(", ");
    }

    if (text.includes("discount")) {
        const max = Math.max(...data.discounts.map(d => d.discount));
        return `Discounts range from 5% to ${max}%. Highest discount is ${max}%.`;
    }

    if (text.includes("nike")) {
        return "Nike T-shirts are available in multiple colors and sizes.";
    }

    if (text.includes("adidas")) {
        return "Adidas T-shirts are available with discounts up to 45%.";
    }

    if (text.includes("stock")) {
        return "Each T-shirt has stock between 10 and 100 units.";
    }

    return "Sorry, I didn't understand. Try asking about brands, colors, sizes, discounts, or stock.";
}
