import 'package:addtocart/cart_model.dart';
import 'package:addtocart/cart_provider.dart';
import 'package:addtocart/cart_screen.dart';
import 'package:addtocart/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {

  ///////List//////////
  // Lists of fruits, weight measures, prices, and image links
  List<String> productName = [
    "Mango",
    "Orange",
    "Grapes",
    "Banana",
    "Cherry",
    "Peach",
    "Pineapple",
  ];

  List<String> productUnit = [
    "grams",
    "KG",
    "Dozens",
    "KG",
    "grams",
    "KG",
    "grams",
  ];

  List<double> productPrice = [
    5,   // Price of Apple in USD
    3,   // Price of Banana in USD
    4,   // Price of Orange in USD
    6,   // Price of Grapes in USD
    5,   // Price of Strawberry in USD
    8,   // Price of Mango in USD
    2,   // Price of Pineapple in USD
  ];

  List<String> productImage = [
    'https://image.shutterstock.com/image-photo/mango-isolated-on-white-background-600w-610892249.jpg' ,
    'https://image.shutterstock.com/image-photo/orange-fruit-slices-leaves-isolated-600w-1386912362.jpg' ,
    'https://image.shutterstock.com/image-photo/green-grape-leaves-isolated-on-600w-533487490.jpg' ,
    'https://media.istockphoto.com/photos/banana-picture-id1184345169?s=612x612' ,
    'https://media.istockphoto.com/photos/cherry-trio-with-stem-and-leaf-picture-id157428769?s=612x612' ,
    'https://media.istockphoto.com/photos/single-whole-peach-fruit-with-leaf-and-slice-isolated-on-white-picture-id1151868959?s=612x612' ,
    'https://media.istockphoto.com/photos/fruit-background-picture-id529664572?s=612x612' ,
  ] ;

  ////initialize the db
  DBHelper? dbHelper = DBHelper();

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Product List'),
        centerTitle: true,
        actions: [

          InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>CartScreen()));
            },
            child: Center(
              child: Badge(
                label: Consumer<CartProvider>(
                  builder: (context , value , child){
                    return Text(
                      value.getCounter().toString(),
                      style: TextStyle(
                          fontSize: 15
                      ),
                    );
                  },


                ),
                child: Icon(
                  Icons.shopping_bag_outlined,
                  size: 30,
                ),
              ),
            ),
          ),

          SizedBox(width: 20,),

        ],
      ),

      body: Column(

        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: productName.length,
                itemBuilder: (context , index){
                return Card(

                    child : Column(

                      children: <Widget>[
                        Row(
                          children: <Widget>[

                            Image(

                                image: NetworkImage(productImage[index].toString()),
                              width: 100,
                              height: 100,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(productName[index].toString(), style: TextStyle(fontSize: 20 , fontWeight: FontWeight.bold) ,),
                                  Text(productUnit[index].toString() + " " + r'$' + productPrice[index].toString()),

                                ],
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                                child: ElevatedButton(
                                    onPressed: (){
                                      dbHelper!.insert(
                                        Cart(id: index,
                                            productId: index.toString(),
                                            productName: productName[index].toString(),
                                            initialPrice: productPrice[index].toInt(),
                                            productPrice: productPrice[index].toInt(),
                                            quantity: 1,
                                            unitTag: productUnit[index].toString(),
                                            image: productImage[index].toString())
                                      ).then((value){
                                        print('Products added successfully');
                                        cart.addTotalPrice(double.parse(productPrice[index].toString()));
                                        cart.addCounter();
                                      }).onError((error, stackTrace){
                                        print(error.toString());
                                      });
                                    },
                                    child: Text("Add to Cart")
                                )
                            )
                          ],
                        )
                      ],
                    ),

                );

                }
            ),
          )
        ],
      ),
    );
  }
}
