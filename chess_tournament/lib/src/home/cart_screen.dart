import 'package:chess_tournament/src/base_screen.dart';
import 'package:flutter/material.dart';

class CartScreen extends BasePageScreen {
  const CartScreen({super.key});

  @override
  CartScreenState createState() => CartScreenState();
}

class CartScreenState extends BasePageScreenState<CartScreen> with BaseScreen {
  @override
  void initState() {
    isCartButton(false);
    super.initState();
  }

  @override
  void isCartButton(bool isCart) {
    super.isCartButton(isCart);
  }

  @override
  String appBarTitle() {
    return "Cart";
  }

  @override
  Widget body() {
    return const Center(
      child: Text("CART SCREEN BODY"),
    );
  }

  @override
  void onClickBackButton() {
    print("BACK BUTTON CLICKED FROM CART");
    Navigator.of(context).pop();
  }

  @override
  void onClickCart() {
    print("CART BUTTON CLICKED");
  }
}
