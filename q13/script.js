const dbName = "ComputerComponentsDB";
let db;

const request = indexedDB.open(dbName, 1);

request.onupgradeneeded = (event) => {
  db = event.target.result;
  const store = db.createObjectStore("components", { keyPath: ["name", "manufacturer"] });
  store.createIndex("name", "name", { unique: false });
  store.createIndex("manufacturer", "manufacturer", { unique: false });
  console.log("Database setup complete");
};

request.onsuccess = (event) => {
  db = event.target.result;
  console.log("Database opened successfully");
};

request.onerror = (event) => {
  console.error("Database error:", event.target.error);
};

// Dialog box and inputs
const dialog = document.getElementById("dialog");
const nameInput = document.getElementById("name");
const manufacturerInput = document.getElementById("manufacturer");
const priceInput = document.getElementById("price");
const saveBtn = document.getElementById("saveBtn");
const closeBtn = document.getElementById("closeBtn");
const componentList = document.getElementById("componentList");

// Show dialog box
document.getElementById("addBtn").addEventListener("click", () => {
  dialog.style.display = "block";
});

// Close dialog box
closeBtn.addEventListener("click", () => {
  dialog.style.display = "none";
  clearInputs();
});

// Add component
saveBtn.addEventListener("click", () => {
  const name = nameInput.value;
  const manufacturer = manufacturerInput.value;
  const price = parseFloat(priceInput.value);

  if (!name || !manufacturer || isNaN(price)) {
    alert("All fields are required!");
    return;
  }

  const transaction = db.transaction(["components"], "readwrite");
  const store = transaction.objectStore("components");

  store.add({ name, manufacturer, price });

  transaction.oncomplete = () => {
    alert("Component added successfully");
    dialog.style.display = "none";
    clearInputs();
  };

  transaction.onerror = () => {
    alert("Error adding component (may already exist)");
  };
});

// Show all components
document.getElementById("showBtn").addEventListener("click", () => {
  const transaction = db.transaction(["components"], "readonly");
  const store = transaction.objectStore("components");

  componentList.innerHTML = ""; // Clear the list
  store.openCursor().onsuccess = (event) => {
    const cursor = event.target.result;
    if (cursor) {
      const { name, manufacturer, price } = cursor.value;
      const li = document.createElement("li");
      li.textContent = `Name: ${name}, Manufacturer: ${manufacturer}, Price: ${price}`;
      componentList.appendChild(li);
      cursor.continue();
    } else if (!componentList.hasChildNodes()) {
      componentList.textContent = "No components found";
    }
  };
});

// Update component
document.getElementById("updateBtn").addEventListener("click", () => {
  const name = prompt("Enter the name of the component to update:");
  const manufacturer = prompt("Enter the manufacturer of the component:");

  if (!name || !manufacturer) {
    alert("Both name and manufacturer are required!");
    return;
  }

  const newPrice = parseFloat(prompt("Enter the new price:"));
  if (isNaN(newPrice)) {
    alert("Invalid price!");
    return;
  }

  const transaction = db.transaction(["components"], "readwrite");
  const store = transaction.objectStore("components");

  store.get([name, manufacturer]).onsuccess = (event) => {
    const data = event.target.result;

    if (data) {
      data.price = newPrice;
      store.put(data);
      alert("Component updated successfully");
    } else {
      alert("Component not found!");
    }
  };
});

// Delete component
document.getElementById("deleteBtn").addEventListener("click", () => {
  const name = prompt("Enter the name of the component to delete:");
  const manufacturer = prompt("Enter the manufacturer of the component:");

  if (!name || !manufacturer) {
    alert("Both name and manufacturer are required!");
    return;
  }

  const transaction = db.transaction(["components"], "readwrite");
  const store = transaction.objectStore("components");

  store.delete([name, manufacturer]).onsuccess = () => {
    alert("Component deleted successfully");
  };

  transaction.onerror = () => {
    alert("Error deleting component");
  };
});

// Utility function to clear inputs
function clearInputs() {
  nameInput.value = "";
  manufacturerInput.value = "";
  priceInput.value = "";
}
