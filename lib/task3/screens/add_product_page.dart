import 'package:flutter/material.dart';

import '../data/categories.dart';
import '../data/market_store.dart';
import '../models/product.dart';

/// One form handles both creating a new product and editing an existing one.
class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key, this.product});

  final Product? product;

  bool get isEditing => product != null;

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _priceController;
  late final TextEditingController _descriptionController;

  late String _category;

  @override
  void initState() {
    super.initState();
    final product = widget.product;

    // Controllers are initialized from the product when this screen is used
    // for editing, otherwise the form starts with empty/default values.
    _titleController = TextEditingController(text: product?.title ?? '');
    _priceController = TextEditingController(
      text: product == null ? '' : product.price.toString(),
    );
    _descriptionController = TextEditingController(
      text: product?.description ?? '',
    );
    _category = product?.category ?? categories.first;
  }

  @override
  void dispose() {
    // TextEditingController owns resources, so it should be disposed when
    // this StatefulWidget is removed from the widget tree.
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _save() {
    // FormState.validate() runs every validator before we save anything.
    if (!_formKey.currentState!.validate()) return;

    final product = Product(
      id: widget.product?.id ?? MarketStore.newProductId(),
      title: _titleController.text.trim(),
      price: double.parse(_priceController.text.trim()),
      category: _category,
      description: _descriptionController.text.trim(),
    );

    if (widget.isEditing) {
      MarketStore.updateProduct(product);
    } else {
      MarketStore.addProduct(product);
    }

    // pop() returns to the previous screen. The HomeScreen awaits this route
    // and then calls setState() so the changed product list is displayed.
    Navigator.pop(context, product);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(
          widget.isEditing ? 'Edit product' : 'Add product',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(26, 22, 26, 24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Title', style: TextStyle(fontSize: 18, color: Colors.grey)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  hintText: 'Desk lamp',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Enter a title'
                    : null,
              ),
              const SizedBox(height: 22),
              const Text('Price', style: TextStyle(fontSize: 18, color: Colors.grey)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _priceController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  hintText: '0',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  final price = double.tryParse(value?.trim() ?? '');
                  if (price == null || price < 0) return 'Enter a valid price';
                  return null;
                },
              ),
              const SizedBox(height: 22),
              const Text('Category', style: TextStyle(fontSize: 18, color: Colors.grey)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: _category,
                decoration: const InputDecoration(border: OutlineInputBorder()),
                items: categories
                    .map((category) => DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value == null) return;
                  setState(() => _category = value);
                },
              ),
              const SizedBox(height: 22),
              const Text('Description', style: TextStyle(fontSize: 18, color: Colors.grey)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'Short description',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Enter a description'
                    : null,
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                  onPressed: _save,
                  child: Text(
                    widget.isEditing ? 'Update product' : 'Save product',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
