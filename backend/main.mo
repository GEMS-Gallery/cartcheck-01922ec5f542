import Bool "mo:base/Bool";
import List "mo:base/List";

import Array "mo:base/Array";
import Text "mo:base/Text";
import Nat "mo:base/Nat";
import Option "mo:base/Option";

actor {
  // Define the ShoppingItem type
  type ShoppingItem = {
    id: Nat;
    text: Text;
    completed: Bool;
  };

  // Initialize a stable variable to store the shopping list
  stable var shoppingList: [ShoppingItem] = [];
  stable var nextId: Nat = 0;

  // Add a new item to the shopping list
  public func addItem(text: Text) : async Nat {
    let id = nextId;
    nextId += 1;
    let newItem: ShoppingItem = {
      id = id;
      text = text;
      completed = false;
    };
    shoppingList := Array.append(shoppingList, [newItem]);
    id
  };

  // Get all items in the shopping list
  public query func getItems() : async [ShoppingItem] {
    shoppingList
  };

  // Toggle the completed status of an item
  public func toggleItem(id: Nat) : async Bool {
    let index = Array.indexOf<ShoppingItem>({ id = id; text = ""; completed = false }, shoppingList, func(a, b) { a.id == b.id });
    switch (index) {
      case null { false };
      case (?i) {
        let item = shoppingList[i];
        let updatedItem = {
          id = item.id;
          text = item.text;
          completed = not item.completed;
        };
        shoppingList := Array.tabulate(shoppingList.size(), func (j: Nat) : ShoppingItem {
          if (j == i) { updatedItem } else { shoppingList[j] }
        });
        true
      };
    }
  };

  // Delete an item from the shopping list
  public func deleteItem(id: Nat) : async Bool {
    let newList = Array.filter(shoppingList, func(item: ShoppingItem) : Bool { item.id != id });
    if (newList.size() < shoppingList.size()) {
      shoppingList := newList;
      true
    } else {
      false
    }
  };
}
