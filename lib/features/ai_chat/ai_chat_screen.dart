// import 'package:flutter/material.dart';
// import 'package:google_generative_ai/google_generative_ai.dart';
// import 'package:lucide_icons/lucide_icons.dart';
// import '../../core/theme/app_colors.dart';
//
// class AiChatScreen extends StatefulWidget {
//   const AiChatScreen({super.key});
//
//   @override
//   State<AiChatScreen> createState() => _AiChatScreenState();
// }
//
// class _AiChatScreenState extends State<AiChatScreen> {
//   final TextEditingController _messageController =
//   TextEditingController();
//
//   final List<Map<String, dynamic>> _messages = [
//     {
//       'sender': 'ai',
//       'text':
//       'أهلاً بك يا سامي! أنا مساعدك الطبي الذكي مدعوم بـ Gemini AI. كيف يمكنني مساعدتك اليوم؟',
//       'time': 'الآن',
//     },
//   ];
//
//   bool _isLoading = false;
//
//   late final GenerativeModel _model;
//
//
//   // static const String _apiKey = '';
//
//   @override
//   void initState() {
//     super.initState();
//
//   //   _model = GenerativeModel(
//   //     model: 'gemini-3.5-flash',
//   //     // apiKey: _apiKey,
//   //   );
//   // }
//
//   Future<void> _sendMessage() async {
//     final userText = _messageController.text.trim();
//
//     if (userText.isEmpty || _isLoading) {
//       return;
//     }
//
//     setState(() {
//       _messages.add({
//         'sender': 'user',
//         'text': userText,
//         'time': 'الآن',
//       });
//
//       _isLoading = true;
//     });
//
//     _messageController.clear();
//
//     try {
//       final prompt = '''
// أنت مساعد طبي ذكي داخل تطبيق "طبيبك".
//
// أجب باللغة العربية وبشكل واضح ومختصر.
//
// مهم:
// - لا تقدم تشخيصًا قطعيًا.
// - لا تعتبر نفسك بديلًا عن الطبيب.
// - إذا كانت الحالة تبدو طارئة، انصح المستخدم بطلب رعاية طبية عاجلة.
// - لا تعطِ جرعات دوائية خطيرة أو وصفات طبية شخصية.
// - إذا كان السؤال عامًا، أجب عليه بشكل مباشر.
//
// سؤال المستخدم:
// $userText
// ''';
//
//       final response = await _model.generateContent(
//         [
//           Content.text(prompt),
//         ],
//       );
//
//       final responseText = response.text?.trim();
//
//       if (!mounted) return;
//
//       if (responseText != null && responseText.isNotEmpty) {
//         setState(() {
//           _messages.add({
//             'sender': 'ai',
//             'text': responseText,
//             'time': 'الآن',
//           });
//         });
//       } else {
//         _addErrorMessage(
//           'Gemini لم يُرجع إجابة.\n'
//               'حاول إرسال السؤال مرة أخرى.',
//         );
//       }
//     } catch (e, stackTrace) {
//       // إظهار الخطأ الحقيقي في Android Studio
//       debugPrint('');
//       debugPrint('==========================================');
//       debugPrint('           GEMINI API ERROR');
//       debugPrint('==========================================');
//       debugPrint('ERROR:');
//       debugPrint(e.toString());
//       debugPrint('');
//       debugPrint('STACK TRACE:');
//       debugPrint(stackTrace.toString());
//       debugPrint('==========================================');
//       debugPrint('');
//
//       if (!mounted) return;
//
//       // نعرض الخطأ الحقيقي مؤقتًا داخل التطبيق
//       _addErrorMessage(
//         'حدث خطأ أثناء الاتصال بـ Gemini:\n\n'
//             '${e.toString()}',
//       );
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     }
//   }
//
//   void _addErrorMessage(String message) {
//     setState(() {
//       _messages.add({
//         'sender': 'ai',
//         'text': message,
//         'time': 'الآن',
//       });
//     });
//   }
//
//   @override
//   void dispose() {
//     _messageController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(
//               LucideIcons.bot,
//               color: AppColors.secondary,
//               size: 22,
//             ),
//             SizedBox(width: 8),
//             Text('المساعد الطبي الذكي'),
//           ],
//         ),
//       ),
//
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               padding: const EdgeInsets.all(16),
//               itemCount: _messages.length,
//               itemBuilder: (context, index) {
//                 final message = _messages[index];
//
//                 final bool isUser =
//                     message['sender'] == 'user';
//
//                 return Align(
//                   alignment: isUser
//                       ? Alignment.centerRight
//                       : Alignment.centerLeft,
//
//                   child: Container(
//                     margin: const EdgeInsets.symmetric(
//                       vertical: 6,
//                     ),
//
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 16,
//                       vertical: 12,
//                     ),
//
//                     constraints: BoxConstraints(
//                       maxWidth:
//                       MediaQuery.of(context).size.width *
//                           0.78,
//                     ),
//
//                     decoration: BoxDecoration(
//                       color: isUser
//                           ? AppColors.primary
//                           : Theme.of(context)
//                           .colorScheme
//                           .surface,
//
//                       borderRadius: BorderRadius.only(
//                         topLeft:
//                         const Radius.circular(16),
//                         topRight:
//                         const Radius.circular(16),
//
//                         bottomLeft: Radius.circular(
//                           isUser ? 16 : 0,
//                         ),
//
//                         bottomRight: Radius.circular(
//                           isUser ? 0 : 16,
//                         ),
//                       ),
//                     ),
//
//                     child: Text(
//                       message['text'],
//                       style: TextStyle(
//                         fontSize: 14,
//                         height: 1.5,
//
//                         color: isUser
//                             ? Colors.white
//                             : Theme.of(context)
//                             .textTheme
//                             .bodyLarge
//                             ?.color,
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//
//           if (_isLoading)
//             const Padding(
//               padding: EdgeInsets.symmetric(
//                 vertical: 8,
//               ),
//
//               child: Row(
//                 mainAxisAlignment:
//                 MainAxisAlignment.center,
//
//                 children: [
//                   SizedBox(
//                     width: 16,
//                     height: 16,
//
//                     child: CircularProgressIndicator(
//                       strokeWidth: 2,
//                     ),
//                   ),
//
//                   SizedBox(width: 10),
//
//                   Text(
//                     'جاري الاتصال بـ Gemini...',
//                     style: TextStyle(
//                       fontSize: 12,
//                       color:
//                       AppColors.textSecondary,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//           Container(
//             padding: const EdgeInsets.symmetric(
//               horizontal: 16,
//               vertical: 12,
//             ),
//
//             decoration: BoxDecoration(
//               color:
//               Theme.of(context)
//                   .colorScheme
//                   .surface,
//             ),
//
//             child: SafeArea(
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       controller:
//                       _messageController,
//
//                       onSubmitted: (_) =>
//                           _sendMessage(),
//
//                       textInputAction:
//                       TextInputAction.send,
//
//                       decoration:
//                       const InputDecoration(
//                         hintText:
//                         'اسأل عن أي عرض أو دواء...',
//                         border:
//                         InputBorder.none,
//                         enabledBorder:
//                         InputBorder.none,
//                         focusedBorder:
//                         InputBorder.none,
//                         filled: false,
//                       ),
//                     ),
//                   ),
//
//                   const SizedBox(width: 8),
//
//                   Container(
//                     decoration:
//                     const BoxDecoration(
//                       gradient:
//                       AppColors.vibrantGradient,
//                       shape: BoxShape.circle,
//                     ),
//
//                     child: IconButton(
//                       icon: const Icon(
//                         LucideIcons.send,
//                         color: Colors.white,
//                         size: 20,
//                       ),
//
//                       onPressed: _isLoading
//                           ? null
//                           : _sendMessage,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }