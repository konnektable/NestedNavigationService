# Just a simple service to assist with Nested Navigation in Flutter...

Ever tried to implement nested navigation in Flutter and found it a bit confusing and/or time-consuming for smaller projects? This package aims to solve just that. It creates an abstraction layer to be used when doing simple Nested Navigation. 

Developed by Kyriakos Giannakis (Technical Manager, Konnektable Technologies)

License: MIT

## Package Requirements:
- Dart >= 2.12
- A way to inject the service in the widget tree. I personally use [Flutter Bloc](https://pub.dev/packages/flutter_bloc), which in turn uses Provider but you can also use [Provider](https://pub.dev/packages/provider) directly if you don't use Bloc in your project.

## Installation/Implementation:

- Step 1: Copy and paste the `nested_navigation_service.dart` file into your project.
- Step 2: Initialize and inject it in your widget tree:

```dart
RepositoryProvider<NestedNavigationService>(
  create: (context) => NestedNavigationService(
    routes: {
      "/subscreen-1": (context) => SubScreen1(),
      "/subscreen-2": (context) => AnotherSubscreen()
    }
  ),
  child: ...,
);
```
- Step 3: At the place where you want to place the Navigator, just use the `.navigator` getter function. Make sure to use it only when the service has been initialized and is above the current widget, in the tree:

```dart
return Scaffold( 
  // Use WillPopScope to stop the back button from popping the
  // parent screen. Customize as needed...
  body: WillPopScope(
    onWillPop: () async => false,
    child: NestedNavigatorService.getNearest(context).navigator
  ),
)
```

In the example above, the `getNearest` function is used to get the nearest service instance from the tree.

## Usage:

### Push:

If you want to push a route to the nested stack, call the `push` method from the service:

```dart
NestedNavigatorService.getNearest(context).push(
  route: "/subscreen-2"
)
```

You can also receive a result when `pop` is called (see below):

```dart
Future<String> result = NestedNavigatorService.getNearest(context).push<String>(
  route: "/subscreen-2"
)
```

You can also add some arguments, should you wish:

```dart
final args = Map<String, dynamic>{
  "arg1": "Hello",
  "arg2": 2
}
NestedNavigatorService.getNearest(context).push(
  route: "/subscreen-2", 
  arguments: args
)
```

### Pop:

Same goes for `pop`ping from the stack:

```dart
NestedNavigatorService.getNearest(context).pop()
```

If you want to also send back a result:

```dart
NestedNavigatorService.getNearest(context).pop<String>("This is a result")
```

### Replace:

`replace` combines `push` and `pop`, to replace your existing route:

```dart
NestedNavigatorService.getNearest(context).replace(route: "/subscreen-2")
```

And with a result:

```dart
Future<String> nextResult = NestedNavigatorService.getNearest(context).replace<String>(
  route: "/subscreen-2", 
  result: "Hello"
  // This calls pop to the previous route and sends back this result.
  // Do not confuse it with nextResult.
)
```