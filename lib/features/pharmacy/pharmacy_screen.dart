import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/theme/app_colors.dart';

class PharmacyScreen extends StatefulWidget {
  const PharmacyScreen({super.key});

  @override
  State<PharmacyScreen> createState() => _PharmacyScreenState();
}

class _PharmacyScreenState extends State<PharmacyScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // سلة المشتريات المحفوظة
  final List<Map<String, dynamic>> _cartItems = [];

  final List<Map<String, dynamic>> _pharmacies = [
    {
      'name': 'صيدلية العالمية النموذجية',
      'location': 'صنعاء - شارع الزبيري (أمام المستشفى الجمهوري)',
      'distance': '1.2 كم',
      'status': 'مفتوح 24 ساعة',
      'medicines': [
        {'name': 'بندول إكسترا (Panadol Extra)', 'price': 1500, 'category': 'مسكن آلام'},
        {'name': 'أوغمنتين 1جرام (Augmentin)', 'price': 6800, 'category': 'مضاد حيوي'},
        {'name': 'فيتامين سي فوار (Vitamin C)', 'price': 2200, 'category': 'فيتامينات'},
        {'name': 'بخاخ فنتولين للربو (Ventolin)', 'price': 3500, 'category': 'أدوية تنفسية'},
      ],
    },
    {
      'name': 'صيدلية العزاني الطبية',
      'location': 'صنعاء - شارع حدة (مقابل الكميم)',
      'distance': '2.5 كم',
      'status': 'مفتوح الآن',
      'medicines': [
        {'name': 'بروفين 400ملجم (Brufen)', 'price': 1200, 'category': 'مسكن ومضاد التهاب'},
        {'name': 'شراب كوفبان للسعال (Cofpan)', 'price': 2500, 'category': 'شراب أطفال'},
        {'name': 'أومبريزول 20ملجم (Omeprazole)', 'price': 3000, 'category': 'أدوية معدة'},
        {'name': 'قطرة عيون مرطبة (Refresh)', 'price': 2800, 'category': 'قطرات عيون'},
      ],
    },
    {
      'name': 'صيدلية النضيد المركزية',
      'location': 'صنعاء - شارع الرباط (جوار جامعة الرازي)',
      'distance': '0.5 كم',
      'status': 'مفتوح 24 ساعة',
      'medicines': [
        {'name': 'بندول نايت (Panadol Night)', 'price': 1800, 'category': 'مسكن ومنظم نوم'},
        {'name': 'كمامات طبية (علبة 50 حبة)', 'price': 1000, 'category': 'مستلزمات طبية'},
        {'name': 'ميزان حرارة إلكتروني', 'price': 4500, 'category': 'أجهزة طبية'},
        {'name': 'مرهم فيوسيدين (Fucidin)', 'price': 2100, 'category': 'مضاد جلدي'},
      ],
    },
    {
      'name': 'صيدلية الحديثة التخصصية',
      'location': 'صنعاء - شارع الستين الغربي',
      'distance': '3.1 كم',
      'status': 'مفتوح الآن',
      'medicines': [
        {'name': 'فيتامين د3 (Vitamin D3 50000)', 'price': 5500, 'category': 'مكملات غذائية'},
        {'name': 'شراب أدول للأطفال (Adol)', 'price': 1400, 'category': 'خافض حرارة'},
        {'name': 'حبوب منظم السكر (Glucophage 500)', 'price': 2900, 'category': 'أدوية مزمنة'},
      ],
    },
  ];

  void _addToCart(Map<String, dynamic> medicine, String pharmacyName) {
    setState(() {
      _cartItems.add({
        ...medicine,
        'pharmacy': pharmacyName,
      });
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تمت إضافة ${medicine['name']} لسلة المشتريات!'),
        backgroundColor: AppColors.primary,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  int get _totalAmount {
    return _cartItems.fold(0, (sum, item) => sum + (item['price'] as int));
  }

  @override
  Widget build(BuildContext context) {
    final filteredPharmacies = _pharmacies.where((pharmacy) {
      final pName = pharmacy['name'].toString().contains(_searchQuery);
      final pLoc = pharmacy['location'].toString().contains(_searchQuery);
      final medicines = (pharmacy['medicines'] as List).any(
            (m) => m['name'].toString().contains(_searchQuery),
      );
      return pName || pLoc || medicines;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('دليل صيدليات صنعاء الموسع'),
        centerTitle: true,
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(LucideIcons.shoppingBag, color: AppColors.primary),
                onPressed: () => _showCartBottomSheet(context),
              ),
              if (_cartItems.isNotEmpty)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Color(0xFF10B981),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${_cartItems.length}',
                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(
                hintText: 'ابحث عن صيدلية، شارع، أو علاج...',
                prefixIcon: const Icon(LucideIcons.search, color: AppColors.primaryLight),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: filteredPharmacies.length,
                itemBuilder: (context, index) {
                  final pharmacy = filteredPharmacies[index];
                  final List medicines = pharmacy['medicines'];

                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    elevation: 2,
                    child: ExpansionTile(
                      leading: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight.withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(LucideIcons.building2, color: AppColors.primary),
                      ),
                      title: Text(pharmacy['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      subtitle: Text('${pharmacy['location']} • ${pharmacy['distance']}', style: const TextStyle(fontSize: 12)),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          pharmacy['status'],
                          style: const TextStyle(fontSize: 10, color: Color(0xFF10B981), fontWeight: FontWeight.bold),
                        ),
                      ),
                      children: [
                        const Divider(),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              'الأدوية والعلاجات المتوفرة لطلب والتوصيل:',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.blueGrey[800]),
                            ),
                          ),
                        ),
                        ...medicines.map((med) {
                          return ListTile(
                            dense: true,
                            leading: const Icon(LucideIcons.pill, color: AppColors.secondary, size: 20),
                            title: Text(med['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                            subtitle: Text('${med['category']} • ${med['price']} ر.ي'),
                            trailing: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              onPressed: () => _addToCart(med, pharmacy['name']),
                              icon: const Icon(LucideIcons.plus, size: 14),
                              label: const Text('إضافة للسلة', style: TextStyle(fontSize: 11)),
                            ),
                          );
                        }).toList(),
                      ],
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

  // نافذة السلة واختيار الخدمة للتسديد الإلكتروني
  void _showCartBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('سلة الطلبات - التسديد الإلكتروني 🛒', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const Divider(),
                  if (_cartItems.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 30),
                      child: Center(
                        child: Text('السلة فارغة حالياً، أضف علاجاً من إحدى الصيدليات.', style: TextStyle(color: Colors.grey)),
                      ),
                    )
                  else ...[
                    SizedBox(
                      height: 120,
                      child: ListView.builder(
                        itemCount: _cartItems.length,
                        itemBuilder: (context, index) {
                          final item = _cartItems[index];
                          return ListTile(
                            dense: true,
                            title: Text(item['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                            subtitle: Text('من: ${item['pharmacy']}'),
                            trailing: Text('${item['price']} ر.ي', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
                          );
                        },
                      ),
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('الإجمالي المطلوب:', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('$_totalAmount ر.ي', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF10B981))),
                      ],
                    ),
                    const SizedBox(height: 14),
                    const Text('اختر محفظة التسديد الإلكتروني:', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),

                    // خيارات التسديد الإلكتروني (الكريمي، جيب، ون كاش، جوال باي)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildPaymentOption(context, 'حاسب الكريمي', LucideIcons.building2, const Color(0xFF1E3A8A)),
                        _buildPaymentOption(context, 'محفظة جيب', LucideIcons.wallet, const Color(0xFF10B981)),
                        _buildPaymentOption(context, 'ون كاش', LucideIcons.qrCode, const Color(0xFFD97706)),
                        _buildPaymentOption(context, 'جوال باي', LucideIcons.smartphone, const Color(0xFF0284C7)),
                      ],
                    ),
                  ],
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ودجت خيارات الدفع
  Widget _buildPaymentOption(BuildContext context, String name, IconData icon, Color color) {
    return InkWell(
      onTap: () {
        final int currentTotal = _totalAmount;
        Navigator.pop(context); // إغلاق السلة
        setState(() => _cartItems.clear()); // تفريغ السلة

        // إظهار الرسالة التأكيدية في وسط الشاشة
        _showSuccessTransferDialog(context, name, currentTotal);
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(name, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
      ),
    );
  }

  // رسالة نجاح العملية الحقيقية بوسط الشاشة
  void _showSuccessTransferDialog(BuildContext context, String method, int total) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          elevation: 10,
          child: Padding(
            padding: const EdgeInsets.all(22.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // أيقونة النجاح المضيئة
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(LucideIcons.checkCircle2, color: Color(0xFF10B981), size: 55),
                ),
                const SizedBox(height: 14),
                const Text(
                  'تمت عملية الحوالة والتسديد بنجاح!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                ),
                const SizedBox(height: 8),
                const Text(
                  'إشعار إيداع وخصم إلكتروني',
                  style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 16),

                // تفاصيل الحوالة
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('طريقة التسديد:', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                          Text(method, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('المبلغ المحول:', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                          Text('$total ر.ي', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF10B981))),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('رقم العملية الترخيصية:', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                          Text('#YEM-994821', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'تم إرسال إشعار الدفع للصيدلية وجاري توصيل طلبك لموقعك بصنعاء.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                ),
                const SizedBox(height: 20),

                // زر الإغلاق
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text('موافق، تم الاستلام', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}