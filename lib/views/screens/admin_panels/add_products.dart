import 'dart:io';
import 'package:flower/firebase/product_fb_controller.dart';
import 'package:flower/model/product_model.dart';

import 'package:flower/helper/snackbar.dart';
import 'package:flower/shared_preferences/shared_preferences.dart';
import 'package:flower/views/widgets/my_button.dart';
import 'package:flower/views/widgets/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../constant/colors.dart';

class AddProducts extends StatefulWidget {
  final ProductModel? product;

  const AddProducts({
    required this.product,
    Key? key,
  }) : super(key: key);

  @override
  State<AddProducts> createState() => _AddProductsState();
}

class _AddProductsState extends State<AddProducts> with SnackBarHelper {
  late TextEditingController priceEditingController;
  late TextEditingController titleEditingController;

  late TextEditingController stateEditingController;

  late TextEditingController locationEditingController;

  late TextEditingController descriptionEditingController;

  @override
  void initState() {
    priceEditingController = TextEditingController(text: widget.product != null ? widget.product!.price.toString() : '');
    titleEditingController = TextEditingController(text: widget.product != null ? widget.product!.title : '');
    stateEditingController = TextEditingController();
    locationEditingController = TextEditingController(text: widget.product != null ? widget.product!.location : '');
    descriptionEditingController = TextEditingController(text: widget.product != null ? widget.product!.description : '');
    super.initState();
  }

  @override
  void dispose() {
    priceEditingController.dispose();
    titleEditingController.dispose();
    stateEditingController.dispose();
    locationEditingController.dispose();
    descriptionEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: green,
        title: Text(widget.product == null ? "Add Product" : "Update Product"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(8)),
                      child: Center(
                          child: (imgPath == null)
                              ? const Text("No img selected")
                              : Image.file(imgPath!)),
                    ),
                    PositionedDirectional(
                      bottom: 0,
                      start: 0,
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(30)),
                        child: InkWell(
                          onTap: () async {
                            await uploadImage();
                          },
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.black,
                            size: 25,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                MyTextField(
                    hintText: 'Title',
                    controller: titleEditingController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                   ),
                const SizedBox(height: 16),
                MyTextField(
                    hintText: 'Price',
                    controller: priceEditingController,
                   ),
                const SizedBox(height: 16),
                MyTextField(
                    hintText: 'location',
                    controller: locationEditingController,
                  ),
                const SizedBox(height: 16),
                MyTextField(
                    hintText: 'description',
                    controller: descriptionEditingController,
                   ),
                const SizedBox(height: 24),
                MyButton(
                    title: widget.product == null ? 'Add Product' : 'Update Product',
                    backgroundColor: Colors.white,
                    isLoading: loading,
                    onPressed: () async {
                      await addProduct();
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool loading = false;
  File? imgPath;

  uploadImage() async {
    final pickedImg = await ImagePicker().pickImage(source: ImageSource.camera);
    try {
      if (pickedImg != null) {
        setState(() {
          imgPath = File(pickedImg.path);
        });
        // String imgName = basename(pickedImg.path);
        // print(imgPath);
        // print(imgName);
      } else {
        showSnackBar(context, message: "NO img selected", error: true);
      }
    } catch (e) {
      showSnackBar(context, message: "Error => $e", error: true);
    }
  }

  Future<void> addProduct() async {
    setState(() {
      loading = true;
    });
    try {
      if(widget.product == null) {
        await ProductFbController().createProduct(getProduct);
      } else {
        await ProductFbController().updateProduct(getProduct);
      }
      showSnackBar(context, message: widget.product == null ? "Product Added" : "Product Updated", error: false,);
      Navigator.pop(context);
    } catch(e){
      showSnackBar(context, message: widget.product == null ? "Failed Adding" : "Failed Updating", error: true,);
    }
    setState(() {
      loading = false;
    });
  }

  ProductModel get getProduct {
    ProductModel productModel = ProductModel();
    productModel.id = widget.product == null ? DateTime.now().toString() : widget.product!.id;
    productModel.title = titleEditingController.text;
    productModel.price = num.parse(priceEditingController.text);
    productModel.location = locationEditingController.text;
    productModel.description = descriptionEditingController.text;
    productModel.sellerId = SharedPreferencesController().getUId;
    productModel.imagePath = 'assets/images/8.jpg';
    return productModel;
  }
}