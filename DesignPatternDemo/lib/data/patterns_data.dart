///
/// patterns_data.dart
/// DesignPatternDemo
///
/// Created by Adam Chen on 2025/12/10.
/// Copyright © 2025 Abb company. All rights reserved.
///
import 'package:design_pattern_demo/demos/singleton/singleton_demo.dart';

import '../demos/Bridge/bridge_demo.dart';
import '../demos/Interpreter/interpreter_demo.dart';
import '../demos/abstract_factory/absfactory_demo.dart';
import '../demos/adapter/adapter_demo.dart';
import '../demos/builder/builder_demo.dart';
import '../demos/chain_of_responsibility/cor_demo.dart';
import '../demos/command/command_demo.dart';
import '../demos/composite/composite_demo.dart';
import '../demos/decorator/decorator_demo.dart';
import '../demos/facade/facade_demo.dart';
import '../demos/factory_method/factory_demo.dart';
import '../demos/flyweight/flyweight_demo.dart';
import '../demos/iterator/iterator_demo.dart';
import '../demos/mediator/mediator_demo.dart';
import '../demos/memento/memento_demo.dart';
import '../demos/observer/observer_demo.dart';
import '../demos/prototype/prototype_demo.dart';
import '../demos/proxy/proxy_demo.dart';
import '../demos/state/state_demo.dart';
import '../demos/strategy/strategy_demo.dart';
import '../demos/template/template_demo.dart';
import '../demos/visitor/visitor_demo.dart';
import '../models/design_pattern.dart';

const _descTBD = 'Demo not implemented yet.';

final List<DesignPattern> patterns = [
// 建立型模式 (Creational)
  DesignPattern(name: '單例模式 (Singleton)', category: '建立型', description: _descTBD, widget: const SingletonDemoPage()),
  DesignPattern(name: '工廠方法 (Factory Method)', category: '建立型', description: _descTBD, widget: const FactoryDemoPage()),
  DesignPattern(name: '抽象工廠 (Abstract Factory)', category: '建立型', description: _descTBD, widget: const AbstractFactoryDemoPage()),
  DesignPattern(name: '生成器 (Builder)', category: '建立型', description: _descTBD, widget: const BuilderDemoPage()),
  DesignPattern(name: '原型模式 (Prototype)', category: '建立型', description: _descTBD, widget: const PrototypeDemoPage()),

// 結構型模式 (Structural)
  DesignPattern(name: '適配器 (Adapter)', category: '結構型', description: _descTBD, widget: const AdapterDemoPage()),
  DesignPattern(name: '橋接模式 (Bridge)', category: '結構型', description: _descTBD, widget: const BridgeDemoPage()),
  DesignPattern(name: '組合模式 (Composite)', category: '結構型', description: _descTBD, widget: const CompositeDemoPage()),
  DesignPattern(name: '裝飾模式 (Decorator)', category: '結構型', description: _descTBD, widget: const DecoratorDemoPage()),
  DesignPattern(name: '外觀模式 (Facade)', category: '結構型', description: _descTBD, widget: const FacadeDemoPage()),
  DesignPattern(name: '享元模式 (Flyweight)', category: '結構型', description: _descTBD, widget: const FlyweightDemoPage()),
  DesignPattern(name: '代理模式 (Proxy)', category: '結構型', description: _descTBD, widget: const ProxyDemoPage()),

// 行為型模式 (Behavioral)
  DesignPattern(name: '責任鏈 (Chain of Responsibility)', category: '行為型', description: _descTBD, widget: const CoRDemoPage()),
  DesignPattern(name: '命令模式 (Command)', category: '行為型', description: _descTBD, widget: const CommandDemoPage()),
  DesignPattern(name: '解釋器 (Interpreter)', category: '行為型', description: _descTBD, widget: const InterpreterDemoPage()),
  DesignPattern(name: '迭代器 (Iterator)', category: '行為型', description: _descTBD, widget: const IteratorDemoPage()),
  DesignPattern(name: '中介者 (Mediator)', category: '行為型', description: _descTBD, widget: const MediatorDemoPage()),
  DesignPattern(name: '備忘錄 (Memento)', category: '行為型', description: _descTBD, widget: const MementoDemoPage()),
  DesignPattern(name: '觀察者 (Observer)', category: '行為型', description: _descTBD, widget: const ObserverDemoPage()),
  DesignPattern(name: '狀態模式 (State)', category: '行為型', description: _descTBD, widget: const StateDemoPage()),
  DesignPattern(name: '策略模式 (Strategy)', category: '行為型', description: _descTBD, widget: const StrategyDemoPage()),
  DesignPattern(name: '模板方法 (Template Method)', category: '行為型', description: _descTBD, widget: const TemplateDemoPage()),
  DesignPattern(name: '訪問者 (Visitor)', category: '行為型', description: _descTBD, widget: const VisitorDemoPage()),
];
