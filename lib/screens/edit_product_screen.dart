import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products_provider.dart';
import '../providers/product_provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final TextEditingController _imageController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': ''
  };
  var _changedValues = {
    'title': false,
    'description': false,
    'price': false,
    'imageUrl': false
  };
  var _isInit = true;
  var _editedProduct =
      Product(id: null, title: '', description: '', imageUrl: '', price: 0.0);
  var _isLoading = false;

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments;
      if (productId != null) {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          'imageUrl': ''
        };
        _imageController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if ((!_imageController.text.startsWith('http') &&
              !_imageController.text.startsWith('www')) ||
          (!_imageController.text.endsWith('.png') &&
              !_imageController.text.endsWith('.jpg') &&
              !_imageController.text.endsWith('.jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  @override
  void dispose() {
    _imageController.dispose();
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    final isValid = _formKey.currentState.validate();
    if (isValid) {
      _formKey.currentState.save();
      setState(() {
        _isLoading = true;
      });
      if (_editedProduct.id != null) {
        await Provider.of<Products>(context, listen: false)
            .updateProduct(_editedProduct.id, _editedProduct);
      } else {
        try {
          await Provider.of<Products>(context, listen: false)
              .addProduct(_editedProduct);
        } catch (error) {
          await showDialog<Null>(
              context: context,
              builder: (ctx) {
                return AlertDialog(
                  title: Text('An error occurred'),
                  content:
                      Text('Something went wrong,the item could not be added'),
                  actions: [
                    TextButton(
                        child: Text(
                          'Close',
                          style: TextStyle(color: Theme.of(context).errorColor),
                        ),
                        onPressed: () {
                          Navigator.of(ctx).pop();
                        })
                  ],
                );
              });
        }
      }
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [IconButton(onPressed: _saveForm, icon: Icon(Icons.save))],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Title',
                        ),
                        initialValue: _initValues['title'],
                        style: TextStyle(
                            color: _changedValues['title'] && _editedProduct.id != null
                                ? Colors.green
                                : Colors.black,
                        ),
                        onChanged: (_) {
                          setState(() {
                            _changedValues['title'] = true;
                          });
                        },
                        textInputAction: TextInputAction.next,
                        maxLines: 1,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please provide a value';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                              isFavorite: _editedProduct.isFavorite,
                              id: _editedProduct.id,
                              title: value,
                              price: _editedProduct.price,
                              imageUrl: _editedProduct.imageUrl,
                              description: _editedProduct.description);
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Price'),
                        style: TextStyle(
                            color: _changedValues['price'] && _editedProduct.id != null
                                ? Colors.green
                                : Colors.black),
                        onChanged: (_) {
                          setState(() {
                            _changedValues['price'] = true;
                          });
                        },
                        initialValue: _initValues['price'],
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter a price';
                          } else if (double.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          } else if (double.parse(value) < 0) {
                            return 'Please enter a number greater than zero';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                              isFavorite: _editedProduct.isFavorite,
                              id: _editedProduct.id,
                              title: _editedProduct.title,
                              price: double.parse(value),
                              imageUrl: _editedProduct.imageUrl,
                              description: _editedProduct.description);
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Description'),
                        keyboardType: TextInputType.multiline,
                        style: TextStyle(
                            color: _changedValues['description'] && _editedProduct.id != null
                                ? Colors.green
                                : Colors.black),
                        onChanged: (_) {
                          setState(() {
                            _changedValues['description'] = true;
                          });
                        },
                        initialValue: _initValues['description'],
                        maxLines: 3,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please provide a description';
                          } else if (value.length < 10) {
                            return 'Please add more details';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                              isFavorite: _editedProduct.isFavorite,
                              id: _editedProduct.id,
                              title: _editedProduct.title,
                              price: _editedProduct.price,
                              imageUrl: _editedProduct.imageUrl,
                              description: value);
                        },
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                decoration:
                                    InputDecoration(labelText: 'Image Url'),
                                style: TextStyle(
                                    color: _changedValues['imageUrl'] && _editedProduct.id != null
                                        ? Colors.green
                                        : Colors.black),
                                onChanged: (_) {
                                  setState(() {
                                    _changedValues['imageUrl'] = true;
                                  });
                                },
                                textInputAction: TextInputAction.done,
                                keyboardType: TextInputType.url,
                                controller: _imageController,
                                focusNode: _imageUrlFocusNode,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please provide a value';
                                  } else if (!value.startsWith('http') &&
                                      !value.startsWith('www') &&
                                      !value.endsWith('.png') &&
                                      !value.endsWith('.jpg') &&
                                      !value.endsWith('.jpeg')) {
                                    return 'Please enter a valid URL';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _editedProduct = Product(
                                      isFavorite: _editedProduct.isFavorite,
                                      id: _editedProduct.id,
                                      title: _editedProduct.title,
                                      price: _editedProduct.price,
                                      imageUrl: value,
                                      description: _editedProduct.description);
                                },
                                onFieldSubmitted: (value) {
                                  _saveForm();
                                },
                              ),
                            ),
                          ),
                          Container(
                              padding: const EdgeInsets.all(8.0),
                              margin: const EdgeInsets.all(8.0),
                              height: 100,
                              width: 100,
                              child: Container(
                                child: _imageController.text.isEmpty
                                    ? Text('Enter Url')
                                    : FittedBox(
                                        fit: BoxFit.contain,
                                        child: Image.network(
                                            _imageController.text),
                                      ),
                              ),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.grey, width: 1))),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
