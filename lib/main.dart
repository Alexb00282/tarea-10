import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Catálogo de Hardware',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF6F8FC),
      ),
      home: const MyHomePage(),
    );
  }
}

class HardwareComponent {
  HardwareComponent({
    required this.name,
    required this.category,
    required this.description,
    required this.price,
    required this.stock,
  });

  final String name;
  final String category;
  final String description;
  final double price;
  final int stock;
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const List<String> _categories = [
    'Todos',
    'Procesadores',
    'Tarjetas gráficas',
    'Memorias RAM',
    'Almacenamiento',
    'Periféricos',
    'Monitores',
    'Red',
  ];

  final List<HardwareComponent> _components = [
    HardwareComponent(
      name: 'Ryzen 9 7900X',
      category: 'Procesadores',
      description: 'Procesador de alto rendimiento para juegos y edición profesional.',
      price: 489.99,
      stock: 12,
    ),
    HardwareComponent(
      name: 'RTX 4070 Super',
      category: 'Tarjetas gráficas',
      description: 'GPU de gama alta con excelente rendimiento en render y videojuegos.',
      price: 789.0,
      stock: 7,
    ),
    HardwareComponent(
      name: 'Corsair Vengeance 32GB',
      category: 'Memorias RAM',
      description: 'Kit DDR5 de 32 GB para multitarea y carga intensiva de aplicaciones.',
      price: 249.5,
      stock: 18,
    ),
    HardwareComponent(
      name: 'SSD NVMe 2TB',
      category: 'Almacenamiento',
      description: 'Disco sólido ultrarrápido para sistemas operativos y juegos.',
      price: 179.9,
      stock: 25,
    ),
    HardwareComponent(
      name: 'Teclado mecánico RGB',
      category: 'Periféricos',
      description: 'Teclado con switches mecánicos y retroiluminación programable.',
      price: 129.0,
      stock: 30,
    ),
    HardwareComponent(
      name: 'Monitor 27" 144Hz',
      category: 'Monitores',
      description: 'Pantalla IPS de alta tasa de refresco para gaming y productividad.',
      price: 399.99,
      stock: 9,
    ),
  ];

  String _selectedCategory = 'Todos';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  List<HardwareComponent> get _filteredComponents {
    final query = _searchQuery.trim().toLowerCase();

    return _components.where((component) {
      final matchesCategory =
          _selectedCategory == 'Todos' || component.category == _selectedCategory;
      final haystack = '${component.name} ${component.description}'.toLowerCase();
      final matchesQuery = query.isEmpty || haystack.contains(query);
      return matchesCategory && matchesQuery;
    }).toList();
  }

  void _openDetail(HardwareComponent component) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => HardwareDetailPage(component: component),
      ),
    );
  }

  void _showAddDialog() {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    final priceController = TextEditingController();
    final stockController = TextEditingController();
    String? selectedCategory = _categories.skip(1).first;

    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Registrar componente'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nombre del producto',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        (value == null || value.trim().isEmpty)
                            ? 'Ingresa un nombre válido'
                            : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: descriptionController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Descripción',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        (value == null || value.trim().isEmpty)
                            ? 'Ingresa la descripción del componente'
                            : null,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: selectedCategory,
                    decoration: const InputDecoration(
                      labelText: 'Categoría',
                      border: OutlineInputBorder(),
                    ),
                    items: _categories
                        .skip(1)
                        .map(
                          (category) => DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          ),
                        )
                        .toList(),
                    onChanged: (value) => selectedCategory = value,
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Selecciona una categoría' : null,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: priceController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          decoration: const InputDecoration(
                            labelText: 'Precio',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Ingresa el precio';
                            }
                            final parsed = double.tryParse(value);
                            if (parsed == null || parsed <= 0) {
                              return 'El precio debe ser mayor que 0';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: stockController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Stock',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Ingresa el stock';
                            }
                            final parsed = int.tryParse(value);
                            if (parsed == null || parsed < 0) {
                              return 'El stock no puede ser negativo';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final newComponent = HardwareComponent(
                    name: nameController.text.trim(),
                    category: selectedCategory!,
                    description: descriptionController.text.trim(),
                    price: double.parse(priceController.text),
                    stock: int.parse(stockController.text),
                  );

                  setState(() {
                    _components.add(newComponent);
                    _selectedCategory = 'Todos';
                  });

                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Componente agregado al catálogo.'),
                    ),
                  );
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredComponents = _filteredComponents;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo de Hardware'),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: _showAddDialog,
            icon: const Icon(Icons.add_circle_outline),
            tooltip: 'Agregar componente',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SearchBar(
              controller: _searchController,
              hintText: 'Buscar por nombre o descripción',
              leading: const Icon(Icons.search),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 52,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  final isSelected = category == _selectedCategory;
                  return ChoiceChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (_) {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: filteredComponents.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.search_off_rounded,
                            size: 64,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Sin resultados',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'No se encontraron componentes con esos filtros.',
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          FilledButton.tonal(
                            onPressed: () {
                              setState(() {
                                _searchController.clear();
                                _searchQuery = '';
                                _selectedCategory = 'Todos';
                              });
                            },
                            child: const Text('Limpiar filtros'),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      itemCount: filteredComponents.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final component = filteredComponents[index];
                        return Card(
                          elevation: 2,
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            leading: CircleAvatar(
                              radius: 28,
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                              child: Icon(
                                Icons.computer_outlined,
                                color: Theme.of(context).colorScheme.onPrimaryContainer,
                              ),
                            ),
                            title: Text(
                              component.name,
                              style: const TextStyle(fontWeight: FontWeight.w700),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    component.category,
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    component.description,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'S/. ${component.price.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  '${component.stock} disponibles',
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                            onTap: () => _openDetail(component),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class HardwareDetailPage extends StatelessWidget {
  const HardwareDetailPage({super.key, required this.component});

  final HardwareComponent component;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(component.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.memory_outlined,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            component.name,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Chip(label: Text(component.category)),
                    const SizedBox(height: 16),
                    Text(
                      'S/. ${component.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${component.stock} unidades disponibles',
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Descripción',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              component.description,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
