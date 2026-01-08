///
/// visitor_demo.dart
/// VisitorDemoPage
///
/// Created by Adam Chen on 2025/12/29
/// Copyright © 2025 Abb company. All rights reserved
///
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'view_model/shape_view_model.dart';
import 'visitor_history_page.dart';
import 'widgets/info_banner.dart';
import 'widgets/control_panel.dart';
import 'widgets/result_list.dart';

class VisitorDemoPage extends StatelessWidget {

  const VisitorDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ShapeViewModel(),
      child: const VisitorDemoView(),
    );
  }

}

class VisitorDemoView extends StatelessWidget {
  const VisitorDemoView();

  @override
  Widget build(BuildContext context) {
    return Consumer<ShapeViewModel>(
      builder: (context, vm, child) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final msg = vm.lastToast;
          if (msg != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(msg), duration: const Duration(seconds: 2)),
            );
            vm.lastToast = null;
          }
        });

        return Scaffold(
          appBar: AppBar(
            title: const Text('Visitor Demo'),
            actions: [
              // 右上角跳轉至結果清單頁面
              IconButton(
                icon: Badge(
                  label: Text('${vm.logs.length}'),
                  child: const Icon(Icons.history),
                ),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChangeNotifierProvider.value(
                      value: vm,
                      child: const VisitorHistoryPage(),
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. 說明區 (佔 1 份空間，獨立捲動)
                Expanded(
                  flex: 1,
                  child: _buildScrollableCard(
                    context: context,
                    widgets: [_buildBorderedSection(child: const InfoBanner())],
                  ),
                ),

                // 2. 控制區 (佔 3 份空間，獨立捲動)
                Expanded(
                  flex: 3,
                  child: _buildScrollableCard(
                    context: context,
                    widgets: [_buildBorderedSection(child: const ControlPanel())],
                  ),
                ),

                // 3. 結果清單 (固定高度，獨立捲動)
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Text('系統執行結果', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
                    child: _buildBorderedSection(child: const ResultList()),
                  ),
                )
              ],
            ),
          ),
        );
      }
    );
  }


  Widget _buildScrollableCard({required BuildContext context, required List<Widget> widgets}) {
    return Card(
      margin: const EdgeInsets.all(12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Theme.of(context).dividerColor.withValues(alpha: 0.1)),
      ),
      // 讓 Card 撐滿 Expanded 分配給它的空間
      child: SizedBox.expand(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: widgets,
          ),
        ),
      ),
    );
  }



  Widget _buildBorderedSection({required Widget child}) {
    return Container(
      width: double.infinity, // 確保寬度一致撐滿
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.withValues(alpha: 0.3), // 明顯的邊框顏色
          width: 1.5,
        ),
      ),
      child: child, // 這裡的 child 就是原有的 InfoBanner, ControlPanel 等
    );
  }
}