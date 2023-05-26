import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart';

void main() {
  runApp(const HoldUp());
}

class HoldUp extends StatelessWidget {
  const HoldUp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hold Up',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurpleAccent),
        useMaterial3: true,
      ),
      // home: const MyHomePage(title: 'Hold Up'),
      home: const HomeScreen(title: 'Apps'),
    );
  }
}

class HomeScreen extends StatefulWidget {

  const HomeScreen({super.key, required this.title});

  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Future<List<Application>> _apps = DeviceApps.getInstalledApplications(includeAppIcons: true, onlyAppsWithLaunchIntent: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: FutureBuilder(
        future: _apps,
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.done) {
            if(snapshot.hasError) {
              return Center(child: Text(snapshot.error as String));
            }
            return AppList(apps: snapshot.data!);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        }
      )
    );
  }
}

class AppList extends StatelessWidget {
  const AppList({super.key, required this.apps});

  final List<Application> apps;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.only(top: 10),
      addAutomaticKeepAlives: false,
      itemCount: apps.length,
      itemBuilder: (_, index) => AppTile(app: apps[index] as ApplicationWithIcon),
      separatorBuilder: (_, __) => const Divider(),
    );
  }
}

class AppTile extends StatefulWidget {
  const AppTile({super.key, required this.app});

  final ApplicationWithIcon app;

  @override
  State<StatefulWidget> createState() => _AppTile();
}

class _AppTile extends State<AppTile> {
  bool checked = false;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.memory(widget.app.icon),
      title: Text(widget.app.appName),
      // onTap: () =>  /
      trailing: Icon(checked ? Icons.check_box : Icons.check_box_outline_blank),
      onTap: () => setState(() { checked = !checked; }),
    );
  }
}
