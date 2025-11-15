import 'package:ecommercefrontend/app/presentation/widgets/appbar/custom_appbar/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../core/routes/named_routes.dart';
import '../../widgets/appbar/drawer/custom_drawer.dart';
import '../../widgets/custom_carrousel/custom_carrousel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Color primaryBlue = const Color(0xFF1976D2);
  final Color accentOrange = const Color(0xFFFF6D00);

  int activeIndex = 0;

  final List<String> banners = [
    "https://picsum.photos/id/1003/900/350",
    "https://picsum.photos/id/1040/900/350",
    "https://picsum.photos/id/1025/900/350",
  ];

  String? selectedOrder = "Preço: menor → maior";

  final List<String> orderOptions = [
    "Preço: menor → maior",
    "Preço: maior → menor",
    "Nome: A → Z",
    "Nome: Z → A",
  ];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.grey[100],

        drawer: CustomDrawer(),

        // DRAWER FUNCIONANDO
        // drawer: Drawer(
        //   child: ListView(
        //     padding: EdgeInsets.zero,
        //     children: const [
        //       DrawerHeader(
        //         decoration: BoxDecoration(color: Colors.blue),
        //         child: Text(
        //           "Menu",
        //           style: TextStyle(color: Colors.white, fontSize: 22),
        //         ),
        //       ),
        //       ListTile(leading: Icon(Icons.home), title: Text("Home")),
        //       ListTile(
        //         leading: Icon(Icons.shopping_cart),
        //         title: Text("Carrinho"),
        //       ),
        //     ],
        //   ),
        // ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: accentOrange,
          tooltip: "FILTROS",
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return const AlertDialog(
                  title: Text("Filtros"),
                  content: Text("Filtros avançados"),
                );
              },
            );
          },
          child: const Icon(Icons.filter_alt, color: Colors.white),
        ),
        appBar: CustomMainAppBar(),
        // ------------------------------------------------------------
        // APPBAR MODERNO COM MENU
        // ------------------------------------------------------------
        // appBar: PreferredSize(
        //   preferredSize: const Size.fromHeight(110),
        //   child: Container(
        //     padding: const EdgeInsets.symmetric(horizontal: 20),
        //     decoration: BoxDecoration(
        //       color: Colors.white,
        //       border: Border(
        //         bottom: BorderSide(color: Colors.grey.shade300, width: 2),
        //       ),
        //       boxShadow: [
        //         BoxShadow(
        //           color: Colors.black.withOpacity(0.06),
        //           blurRadius: 8,
        //           offset: const Offset(0, 4),
        //         ),
        //       ],
        //     ),
        //     child: Row(
        //       children: [
        //         // BOTÃO DO DRAWER CORRETAMENTE
        //         Builder(
        //           builder: (context) {
        //             return IconButton(
        //               icon: Icon(Icons.menu, color: primaryBlue, size: 32),
        //               onPressed: () => Scaffold.of(context).openDrawer(),
        //             );
        //           },
        //         ),

        //         const SizedBox(width: 12),

        //         // LOGO
        //         Image.network(
        //           "https://upload.wikimedia.org/wikipedia/commons/4/44/Google-flutter-logo.svg",
        //           width: 60,
        //         ),

        //         const Spacer(),

        //         // BARRA DE BUSCA
        //         SizedBox(
        //           width: 420,
        //           child: TextField(
        //             decoration: InputDecoration(
        //               filled: true,
        //               fillColor: Colors.grey[200],
        //               hintText: "Buscar produtos...",
        //               hintStyle: const TextStyle(fontSize: 16),
        //               suffixIcon: Icon(Icons.search, color: primaryBlue),
        //               contentPadding: const EdgeInsets.symmetric(
        //                 horizontal: 20,
        //                 vertical: 14,
        //               ),
        //               border: OutlineInputBorder(
        //                 borderRadius: BorderRadius.circular(30),
        //                 borderSide: BorderSide.none,
        //               ),
        //             ),
        //           ),
        //         ),

        //         const Spacer(),

        //         // CONTA
        //         IconButton(
        //           tooltip: "Minha Conta",
        //           onPressed: () {},
        //           icon: Icon(
        //             Icons.person_outline,
        //             size: 34,
        //             color: primaryBlue,
        //           ),
        //         ),

        //         // CARRINHO
        //         IconButton(
        //           tooltip: "Carrinho",
        //           onPressed: () => context.goNamed(NamedRoute.checkoutPage),
        //           icon: Icon(
        //             Icons.shopping_cart_outlined,
        //             size: 34,
        //             color: accentOrange,
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),

        // ------------------------------------------------------------
        // CORPO: CARROSSEL + DROPDOWN + GRID
        // ------------------------------------------------------------
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),

              // --- BANNER CARROSSEL ---
              // CarouselSlider.builder(
              //   itemCount: banners.length,
              //   itemBuilder: (context, index, realIndex) {
              //     return ClipRRect(
              //       borderRadius: BorderRadius.circular(18),
              //       child: Image.network(
              //         banners[index],
              //         width: double.infinity,
              //         fit: BoxFit.cover,
              //       ),
              //     );
              //   },
              //   options: CarouselOptions(
              //     height: 280,
              //     autoPlay: true,
              //     enlargeCenterPage: true,
              //     viewportFraction: 0.9,
              //     onPageChanged: (i, reason) {
              //       setState(() => activeIndex = i);
              //     },
              //   ),
              // ),
              HomeCarousel(),

              const SizedBox(height: 12),

              // AnimatedSmoothIndicator(
              //   activeIndex: activeIndex,
              //   count: banners.length,
              //   effect: ExpandingDotsEffect(
              //     activeDotColor: primaryBlue,
              //     dotHeight: 8,
              //     dotWidth: 8,
              //   ),
              // ),
              const SizedBox(height: 20),

              // --- DROPDOWN DE ORDENAÇÃO ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: 300,
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        value: selectedOrder,
                        items: orderOptions
                            .map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() => selectedOrder = value);
                          // Aqui você chamaria o Cubit
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // --- GRID DE PRODUTOS ---
              Padding(
                padding: const EdgeInsets.all(30),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    const itemWidth = 260.0;
                    final crossAxisCount = (constraints.maxWidth / itemWidth)
                        .floor();

                    return GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 24,
                        mainAxisSpacing: 24,
                        childAspectRatio: 3 / 4,
                      ),
                      itemCount: 20,
                      itemBuilder: (_, index) {
                        return _buildProductCard();
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // CARD DO PRODUTO
  Widget _buildProductCard() {
    return Card(
      elevation: 5,
      shadowColor: Colors.black.withOpacity(0.15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.network(
                    "https://picsum.photos/seed/product/400/400",
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                "Produto Gamer",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Text(
                    "R\$ 2999",
                    style: TextStyle(
                      decoration: TextDecoration.lineThrough,
                      color: Colors.red[400],
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    "R\$ 1999",
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.bottomRight,
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.add_shopping_cart),
                  color: const Color(0xFFFF6D00),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';

// import '../../../core/routes/named_routes.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return PopScope(
//       canPop: false,
//       child: Scaffold(
//         floatingActionButton: FloatingActionButton(
//           tooltip: "FILTROS",
//           onPressed: () {
//             print("object");
//             showDialog(
//               context: context,
//               builder: (context) {
//                 return AlertDialog(title: Text("data"), content: Text("data"));
//               },
//             );
//           },
//           child: Icon(Icons.filter_alt),
//         ),
//         appBar: AppBar(
//           shape: const Border(
//             bottom: BorderSide(
//               color: Colors.black12, // Customize border color
//               width: 3, // Customize border width
//             ),
//           ),
//           toolbarHeight: 150,
//           centerTitle: true,
//           shadowColor: Colors.black,
//           elevation: 3,
//           backgroundColor: Colors.transparent,
//           forceMaterialTransparency: true,
//           title: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             //mainAxisSize: MainAxisSize.min,
//             children: [
//               Image.network(
//                 "https://blog.geekhunter.com.br/wp-content/uploads/2020/11/flutter.png.webp",
//                 fit: BoxFit.cover,
//                 width: 300,

//                 height: 100,
//               ),
//               SearchBar(
//                 constraints: BoxConstraints(minWidth: 100, maxWidth: 500),
//                 trailing: [
//                   IconButton(onPressed: () {}, icon: Icon(Icons.search)),
//                 ],
//                 // leading: IconButton(onPressed: null, icon: Icon(Icons.search)),
//               ),
//               IconButton(
//                 onPressed: null,
//                 icon: Icon(Icons.account_circle),
//                 tooltip: "MINHA CONTA",
//               ),
//               IconButton(
//                 onPressed: () {
//                   context.goNamed(NamedRoute.checkoutPage);
//                 },
//                 icon: Icon(Icons.shopping_cart),
//                 tooltip: "CARRINHO",
//               ),
//             ],
//           ),
//           // actions: [
//           //   SizedBox(
//           //     width: 500,
//           //     child: SearchBar(
//           //       constraints: BoxConstraints(minWidth: 20, maxWidth: 50),
//           //       trailing: [
//           //         IconButton(onPressed: () {}, icon: Icon(Icons.search)),
//           //       ],
//           //       // leading: IconButton(onPressed: null, icon: Icon(Icons.search)),
//           //     ),
//           //   ),
//           //   IconButton(onPressed: null, icon: Icon(Icons.shopping_cart)),
//           // ],
//         ),
//         body: Padding(
//           padding: const EdgeInsets.all(24),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             //spacing: 100,
//             children: [
//               SizedBox(height: 10),
//               Expanded(
//                 child: LayoutBuilder(
//                   builder: (context, constraints) {
//                     const itemWidth = 250.0; // tamanho fixo desejado
//                     final crossAxisCount = (constraints.maxWidth / itemWidth)
//                         .floor();
//                     return GridView.builder(
//                       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                         crossAxisCount: crossAxisCount,
//                         childAspectRatio: 3 / 4,
//                         //mainAxisExtent: 100,
//                         mainAxisSpacing: 20,
//                         crossAxisSpacing: 20,
//                       ),
//                       itemCount: 50,

//                       itemBuilder: (context, index) {
//                         return SizedBox(
//                           width: 220,
//                           height: 340,
//                           child: Card(
//                             elevation: 5,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(16),
//                             ),
//                             shadowColor: Colors.black12,
//                             child: InkWell(
//                               borderRadius: BorderRadius.circular(16),
//                               onTap: () {
//                                 // Ex: abrir detalhes do produto
//                               },
//                               child: Padding(
//                                 padding: const EdgeInsets.all(12),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     // 🖼️ Imagem do produto
//                                     Expanded(
//                                       child: ClipRRect(
//                                         borderRadius: BorderRadius.circular(12),
//                                         child: Image.network(
//                                           "https://upload.wikimedia.org/wikipedia/commons/4/44/Google-flutter-logo.svg",
//                                           fit: BoxFit.cover,
//                                           width: double.infinity,
//                                           errorBuilder: (_, __, ___) =>
//                                               const Icon(
//                                                 Icons.image,
//                                                 size: 60,
//                                                 color: Colors.grey,
//                                               ),
//                                         ),
//                                       ),
//                                     ),

//                                     const SizedBox(height: 12),

//                                     // 🏷️ Nome do produto
//                                     Text(
//                                       "name",
//                                       maxLines: 2,
//                                       overflow: TextOverflow.ellipsis,
//                                       style: Theme.of(context)
//                                           .textTheme
//                                           .titleMedium
//                                           ?.copyWith(
//                                             fontWeight: FontWeight.bold,
//                                             color: Colors.grey[900],
//                                           ),
//                                     ),

//                                     const SizedBox(height: 6),

//                                     // 💰 Preço anterior e atual
//                                     Row(
//                                       children: [
//                                         Text(
//                                           "R\$ ${0}",
//                                           //"R\$ ${oldPrice.toStringAsFixed(2)}",
//                                           style: const TextStyle(
//                                             decoration:
//                                                 TextDecoration.lineThrough,
//                                             color: Colors.redAccent,
//                                             fontSize: 14,
//                                             fontWeight: FontWeight.w500,
//                                           ),
//                                         ),
//                                         const SizedBox(width: 8),
//                                         Text(
//                                           "R\$ ${0}",
//                                           //"R\$ ${price.toStringAsFixed(2)}",
//                                           style: const TextStyle(
//                                             color: Colors.green,
//                                             fontSize: 16,
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                       ],
//                                     ),

//                                     const SizedBox(height: 10),
//                                     Divider(
//                                       height: 2,
//                                       color: Colors.black12,
//                                       thickness: 1,
//                                     ),

//                                     // ➕➖ Botões de quantidade
//                                     Row(
//                                       mainAxisAlignment: MainAxisAlignment.end,
//                                       children: [
//                                         // // ⭐ Avaliação (opcional)
//                                         // Row(
//                                         //   children: List.generate(
//                                         //     5,
//                                         //     (index) => const Icon(
//                                         //       Icons.star,
//                                         //       size: 14,
//                                         //       color: Colors.amber,
//                                         //     ),
//                                         //   ),
//                                         // ),

//                                         // Botões de ação
//                                         Row(
//                                           children: [
//                                             IconButton(
//                                               onPressed: () {},
//                                               icon: const Icon(
//                                                 Icons.remove_circle_outline,
//                                               ),
//                                               color: Colors.grey[700],
//                                             ),
//                                             IconButton(
//                                               onPressed: () {},
//                                               icon: const Icon(
//                                                 Icons.add_circle_outline,
//                                               ),
//                                               color: Colors.blueAccent,
//                                             ),
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                         );
//                         // return SizedBox(
//                         //   width: 20,
//                         //   height: 20,
//                         //   child: Card(
//                         //     child: Column(
//                         //       spacing: 8,
//                         //       children: [
//                         //         Expanded(
//                         //           child: Padding(
//                         //             padding: const EdgeInsets.all(8.0),
//                         //             child: Image.network(
//                         //               "https://www.google.com/imgres?q=avatar&imgurl=https%3A%2F%2Fimg.freepik.com%2Fvetores-gratis%2Filustracao-do-jovem-sorridente_1308-174669.jpg%3Fsemt%3Dais_incoming%26w%3D740%26q%3D80&imgrefurl=https%3A%2F%2Fbr.freepik.com%2Ffotos-vetores-gratis%2Favatar&docid=p6PhUVAUuKavQM&tbnid=mlHmviLrZRI6FM&vet=12ahUKEwiDnMyh6O-QAxV7ppUCHRSEFMQQM3oECBsQAA..i&w=740&h=855&hcb=2&ved=2ahUKEwiDnMyh6O-QAxV7ppUCHRSEFMQQM3oECBsQAA",
//                         //             ),
//                         //           ),
//                         //         ),
//                         //         Text("nome"),
//                         //         Text(
//                         //           "R\$ 00,00",
//                         //           style: TextStyle(
//                         //             decoration: TextDecoration.lineThrough,
//                         //             color: Colors.black,
//                         //             decorationColor: Colors.redAccent,
//                         //             decorationThickness: 4,
//                         //           ),
//                         //         ),
//                         //         Text("R\$ 00,00"),
//                         //         Row(
//                         //           spacing: 4,
//                         //           mainAxisAlignment: MainAxisAlignment.end,
//                         //           children: [
//                         //             IconButton(
//                         //               onPressed: () {},
//                         //               icon: Icon(Icons.add_circle_outlined),
//                         //             ),
//                         //             IconButton(
//                         //               onPressed: () {},
//                         //               icon: Icon(Icons.remove_circle_outlined),
//                         //             ),
//                         //           ],
//                         //         ),
//                         //       ],
//                         //     ),
//                         //   ),
//                         // );
//                       },
//                     );
//                   },
//                 ),
//               ),
//               // SizedBox(height: 40),
//               // InkWell(
//               //   onTap: () {
//               //     print("object");
//               //   },
//               //   child: Container(
//               //     height: 20,
//               //     width: double.infinity,
//               //     decoration: BoxDecoration(
//               //       color: Colors.amber,
//               //       borderRadius: BorderRadius.all(Radius.circular(10)),
//               //     ),
//               //   ),
//               // ),
//               //ElevatedButton(onPressed: () {}, child: Text("data")),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
