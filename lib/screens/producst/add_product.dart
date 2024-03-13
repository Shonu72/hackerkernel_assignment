import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  File? _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _productNameController,
                decoration: InputDecoration(
                  hintText: "Enter product name",
                  prefixIcon: const Icon(Icons.dataset),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter product name';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(
                  hintText: "Enter product price",
                  prefixIcon: const Icon(Icons.currency_rupee),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter price';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              _buildImagePicker(),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue),
                    minimumSize:
                        MaterialStateProperty.all<Size>(const Size(200, 50)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    )),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _addProduct();
                    }
                  },
                  child: const Text(
                    'Save Product',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // const Text('Product Image',
        //     style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400)),
        // const SizedBox(height: 8),
        _image != null
            ? Image.file(
                _image!,
                height: 200,
                width: double.maxFinite,
                fit: BoxFit.cover,
              )
            : Container(
                height: 200,
                width: double.maxFinite,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.camera_alt,
                            size: 30,
                            color: Colors.grey,
                          ),
                        )),
                    Padding(
                      padding: const EdgeInsets.only(left: 0.0),
                      child: TextButton(
                        onPressed: _pickImage,
                        child: const Text(
                          'Pick Image',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w300),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ],
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  void _addProduct() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List products = (prefs.getStringList('products') ?? [])
        .map((productJson) => jsonDecode(productJson))
        .toList();
    String newProduct = _productNameController.text;
    if (products.any((product) => product['name'] == newProduct)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Product already exists!'),
      ));
    } else {
      // Add new product
      Map<String, dynamic> newProductData = {
        'name': _productNameController.text,
        'price': double.parse(_priceController.text),
        'image':
            _image != null ? base64Encode(_image!.readAsBytesSync()) : null,
      };
      setState(() {
        products.add(newProductData);
        prefs.setStringList('products',
            products.map((product) => jsonEncode(product)).toList());
      });
      Navigator.pop(context);
    }
  }
}
