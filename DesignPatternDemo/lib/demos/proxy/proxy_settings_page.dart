///
/// proxy_settings_page.dart
/// ProxySettingsPage
///
/// Created by Adam Chen on 2026/01/06
/// Copyright © 2025 Abb company. All rights reserved
///
import 'package:design_pattern_demo/demos/proxy/pattern/proxy_context.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pattern/proxy_service.dart';
import 'util/proxy_util.dart';
import 'view_model/proxy_view_model.dart';

class ProxySettingsPage extends StatelessWidget {

  const ProxySettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProxyViewModel>();
    return Scaffold(
      appBar: AppBar(title: const Text('代理行為設定')),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('1. 代理模式組合', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    _buildProxyKindSelector(vm), // 這裡可以用 Wrap 解決橫向寬度不足

                    const SizedBox(height: 24),
                    const Text('2. 當前存取角色', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    _buildRoleSelector(vm),

                    const SizedBox(height: 24),
                    const Text('3. 請求資源 Key', style: TextStyle(fontWeight: FontWeight.bold)),
                    _buildRequestResource(vm),
                  ],
                ),
              ),
            ),
            // 底部動作
            _buildActionFooter(context, vm),
          ],
        ),
      ),
    );
  }

  Widget _buildProxyKindSelector(ProxyViewModel vm) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: ProxyKind.values.map((kind) {
        final isSelected = vm.selectedKind == kind;
        return ChoiceChip(
          label: Text(ProxyUtil.getProxyName(kind)),
          selected: isSelected,
          selectedColor: Colors.blue.shade100,
          onSelected: (bool selected) {
            if (selected) {
              vm.selectKind(kind);
            }
          },
        );
      }).toList(),
    );
  }

  Widget _buildRoleSelector(ProxyViewModel vm) {
    return Wrap(
      spacing: 12,
      children: AccessRole.values.map((role) {
        final isSelected = vm.role == role;
        return ChoiceChip(
          avatar: Icon(
            role == AccessRole.admin ? Icons.admin_panel_settings : Icons.person,
            size: 16,
          ),
          label: Text(_getRoleName(role)),
          selected: isSelected,
          onSelected: (bool selected) {
            if (selected) vm.setRole(role);
          },
        );
      }).toList(),
    );

  }

  Widget _buildRequestResource(ProxyViewModel vm) {
    return TextField(
      controller: TextEditingController(text: vm.lastKey),
      decoration: const InputDecoration(
        labelText: 'Key',
        hintText: 'e.g., article-100',
      ),
      onChanged: vm.setKey,
    );
  }

  Widget _buildActionFooter(BuildContext context, ProxyViewModel vm) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton(onPressed: () => Navigator.pop(context), child: const Text('取消')),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: FilledButton.icon(
                  onPressed: () { vm.fetchOnce(); Navigator.pop(context); },
                  icon: const Icon(Icons.send),
                  label: const Text('執行請求'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12), // 加上間距
          // execute batch
          SizedBox(
            width: double.infinity, // 讓按鈕橫向撐滿
            child: FilledButton.icon(
              onPressed: () { vm.fetchBatch(5); Navigator.pop(context); },
              icon: const Icon(Icons.send),
              label: const Text('執行批次請求'),
            ),
          ),
        ],
      ),
    );
  }

  String _getRoleName(AccessRole role) {
    switch (role) {
      case AccessRole.guest: return '訪客';
      case AccessRole.user: return '使用者';
      case AccessRole.admin: return '管理員';
    }
  }

}