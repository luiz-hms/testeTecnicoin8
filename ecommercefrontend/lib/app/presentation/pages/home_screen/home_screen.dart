import 'package:ecommercefrontend/app/presentation/widgets/appbar/custom_appbar/custom_appbar.dart';
import 'package:ecommercefrontend/app/presentation/cubits/theme/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../widgets/appbar/drawer/custom_drawer.dart';
import '../../widgets/custom_carrousel/custom_carrousel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int activeIndex = 0;

  final List<String> orderOptions = [
    "Preço: menor → maior",
    "Preço: maior → menor",
    "Nome: A → Z",
    "Nome: Z → A",
  ];

  String? selectedOrder = "Preço: menor → maior";

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final accentColor = (state is ThemeLoaded)
            ? state.theme.accentColor
            : const Color(0xFFFF6D00);

        return PopScope(
          canPop: false,
          child: Scaffold(
            backgroundColor: Colors.grey[100],
            drawer: CustomDrawer(),
            floatingActionButton: FloatingActionButton(
              backgroundColor: accentColor,
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
            body: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  HomeCarousel(),
                  const SizedBox(height: 12),
                  const SizedBox(height: 20),
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
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e),
                                  ),
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
                        final crossAxisCount =
                            (constraints.maxWidth / itemWidth).floor();

                        return GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                crossAxisSpacing: 24,
                                mainAxisSpacing: 24,
                                childAspectRatio: 3 / 4,
                              ),
                          itemCount: 20,
                          itemBuilder: (_, index) {
                            return _buildProductCard(accentColor);
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
      },
    );
  }

  // CARD DO PRODUTO
  Widget _buildProductCard(Color accentColor) {
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
                  color: accentColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
