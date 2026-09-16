# Task 3 — Mini Market

This task implements the Mini Market screens shown in the supplied reference images and applies the navigation concepts from the Routes and Navigation lecture.

## Screens

1. **Home** — product grid, cart button, and add button.
2. **Product details** — product information, quantity controls, edit/delete, and Add to cart.
3. **Add/Edit product** — validated form for title, price, category, and description.
4. **Your cart** — cart items, quantities, total, remove, and checkout.

## Navigation concepts used

The lecture explains that Flutter's imperative navigation uses a stack: `push()` adds a route and `pop()` removes it. This implementation uses `Navigator.push()` to open screens and `Navigator.pop()` to return. It also passes the selected product id through the `ProductDetailsPage` constructor, matching the lecture's constructor-based data passing example.

The delete confirmation demonstrates returning a value from a dialog: the dialog calls `Navigator.pop(context, true/false)` and the calling code checks the returned result.

## Run Task 3

The original `main.dart` for Task 1 is intentionally preserved. Task 3 has its own entry point:

```bash
flutter run -t lib/task3/main.dart
```

No external package is required for Task 3.
