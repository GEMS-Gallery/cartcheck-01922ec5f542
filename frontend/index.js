import { backend } from 'declarations/backend';

document.addEventListener('DOMContentLoaded', async () => {
    const shoppingList = document.getElementById('shopping-list');
    const addItemForm = document.getElementById('add-item-form');
    const newItemInput = document.getElementById('new-item');

    // Function to render the shopping list
    async function renderShoppingList() {
        const items = await backend.getItems();
        shoppingList.innerHTML = '';
        items.forEach(item => {
            const li = document.createElement('li');
            li.innerHTML = `
                <span>${item.text}</span>
                <div class="item-actions">
                    <i class="fas fa-check-circle" data-id="${item.id}"></i>
                    <i class="fas fa-trash-alt" data-id="${item.id}"></i>
                </div>
            `;
            if (item.completed) {
                li.classList.add('completed');
            }
            shoppingList.appendChild(li);
        });
    }

    // Add new item
    addItemForm.addEventListener('submit', async (e) => {
        e.preventDefault();
        const text = newItemInput.value.trim();
        if (text) {
            await backend.addItem(text);
            newItemInput.value = '';
            await renderShoppingList();
        }
    });

    // Toggle item completion
    shoppingList.addEventListener('click', async (e) => {
        if (e.target.classList.contains('fa-check-circle')) {
            const id = Number(e.target.getAttribute('data-id'));
            await backend.toggleItem(id);
            await renderShoppingList();
        }
    });

    // Delete item
    shoppingList.addEventListener('click', async (e) => {
        if (e.target.classList.contains('fa-trash-alt')) {
            const id = Number(e.target.getAttribute('data-id'));
            await backend.deleteItem(id);
            await renderShoppingList();
        }
    });

    // Initial render
    await renderShoppingList();
});
