///
/// patterns_data.dart
/// DesignPatternDemo
///
/// Created by Adam Chen on 2025/12/10.
/// Copyright © 2025 Abb company. All rights reserved.
///
import 'package:design_pattern_demo/demos/singleton/singleton_demo.dart';

import '../demos/Bridge/bridge_demo.dart';
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
import '../demos/prototype/prototype_demo.dart';
import '../demos/proxy/proxy_demo.dart';
import '../models/design_pattern.dart';

const _descTBD = 'Demo not implemented yet.';

final List<DesignPattern> patterns = [
DesignPattern(name: 'Singleton', category: 'Creational', description: _descTBD, widget: const SingletonDemoPage()),
DesignPattern(name: 'Factory Method', category: 'Creational', description: _descTBD, widget: const FactoryDemoPage()),
DesignPattern(name: 'Abstract Factory', category: 'Creational', description: _descTBD, widget: const AbstractFactoryDemoPage()),
DesignPattern(name: 'Builder', category: 'Creational', description: _descTBD, widget: const BuilderDemoPage()),
DesignPattern(name: 'Prototype', category: 'Creational', description: _descTBD, widget: const PrototypeDemoPage()),
DesignPattern(name: 'Adapter', category: 'Structural', description: _descTBD, widget: const AdapterDemoPage()),
DesignPattern(name: 'Bridge', category: 'Structural', description: _descTBD, widget: const BridgeDemoPage()),
DesignPattern(name: 'Composite', category: 'Structural', description: _descTBD, widget: const CompositeDemoPage()),
DesignPattern(name: 'Decorator', category: 'Structural', description: _descTBD, widget: const DecoratorDemoPage()),
DesignPattern(name: 'Facade', category: 'Structural', description: _descTBD, widget: const FacadeDemoPage()),
DesignPattern(name: 'Flyweight', category: 'Structural', description: _descTBD, widget: const FlyweightDemoPage()),
DesignPattern(name: 'Proxy', category: 'Structural', description: _descTBD, widget: const ProxyDemoPage()),
DesignPattern(name: 'Chain of Responsibility', category: 'Behavioral', description: _descTBD, widget: const CoRDemoPage()),
DesignPattern(name: 'Command', category: 'Behavioral', description: _descTBD, widget: const CommandDemoPage()),
DesignPattern(name: 'Interpreter', category: 'Behavioral', description: _descTBD),
DesignPattern(name: 'Iterator', category: 'Behavioral', description: _descTBD),
DesignPattern(name: 'Mediator', category: 'Behavioral', description: _descTBD),
DesignPattern(name: 'Memento', category: 'Behavioral', description: _descTBD),
DesignPattern(name: 'Observer', category: 'Behavioral', description: _descTBD),
DesignPattern(name: 'State', category: 'Behavioral', description: _descTBD),
DesignPattern(name: 'Strategy', category: 'Behavioral', description: _descTBD),
DesignPattern(name: 'Template Method', category: 'Behavioral', description: _descTBD),
DesignPattern(name: 'Visitor', category: 'Behavioral', description: _descTBD),
];
