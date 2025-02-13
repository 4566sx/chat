import 'package:flutter/material.dart';

class AppColors {
  // 主色调
  static const navy = Color(0xFF1B365D);
  static const warmBeige = Color(0xFFF5F5F7);
  static const gold = Color(0xFFD4AF37);
  static const lightGold = Color(0xFFE6D5A7);
  static const lightBlue = Color(0xFFEDF3F9);
  
  // 文本颜色
  static const textPrimary = Color(0xFF2D3748);
  static const textSecondary = Color(0xFF718096);
  
  // 背景颜色
  static const backgroundPrimary = warmBeige;
  static const backgroundSecondary = Colors.white;
  static final backgroundElevated = Colors.white.withOpacity(0.7);
  
  // 消息气泡颜色
  static final userMessageBg = navy.withOpacity(0.9);
  static final botMessageBg = Colors.white.withOpacity(0.8);
  
  // 强调色
  static const accent = gold;
  
  // 分割线颜色
  static const divider = Color(0xFFE2E8F0);
  
  // 阴影颜色
  static final shadow = Colors.black.withOpacity(0.08);
  
  // 玻璃拟态效果颜色
  static final glassBorder = Colors.white.withOpacity(0.2);
  static final glassBackground = Colors.white.withOpacity(0.1);
} 