import 'package:flutter/material.dart';

// 這是一個可重複使用的 StatelessWidget，它接收一個自定義 Widget 作為子元件。
class DefaultContainerWithCustomWidget extends StatelessWidget {
  // 透過建構子傳入自定義的 Widget
  const DefaultContainerWithCustomWidget(this.customWidget, {Key? key})
      : super(key: key);
  // 自定義的 Widget
  final Widget customWidget;

  // 重寫 build 方法，根據自定義的 customWidget 生成 Widget 樹
  @override
  Widget build(BuildContext context) {
    // 返回一個 Container 元件，其中包含一些樣式設定和 customWidget
    return Container(
      // 設定 Container 的邊距為 8.0
      margin: const EdgeInsets.all(8.0),
      // 設定 Container 的填充為 8.0
      padding: const EdgeInsets.all(8.0),
      // 將 customWidget 置中
      alignment: Alignment.center,
      // 設定 Container 的高度為 200
      height: 200,
      // 使用 BoxDecoration 來設定 Container 的樣式
      decoration: BoxDecoration(
          // 設定背景色為白色
          color: Colors.white,
          // 設定邊角半徑為 20
          borderRadius: BorderRadius.circular(20),
          // 設定陰影效果
          boxShadow: [
            // 設定陰影的顏色、擴散範圍、模糊程度以及偏移量
            BoxShadow(
                color: Colors.black.withOpacity(0.15),
                spreadRadius: 6,
                blurRadius: 6,
                offset: Offset.fromDirection(5, -5))
          ]),
      // 將 customWidget 作為子元件
      child: customWidget,
    );
  }
}
