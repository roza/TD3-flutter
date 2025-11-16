import 'package:flutter/material.dart';
import 'package:td3/api/myapi.dart';
import 'package:td3/UI/detail.dart';

class Ecran2 extends StatelessWidget {
  final MyAPI myAPI = MyAPI();

  Ecran2({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: myAPI.getTasks(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        }
        if (snapshot.data != null) {
          return ListView.builder(
            itemCount: snapshot.data?.length ?? 0,
            itemBuilder: (BuildContext context, index) {
              return Card(
                color: Theme.of(context).cardColor,
                elevation: 7,
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: const Color.fromARGB(255, 49, 41, 87),
                    child: Text(snapshot.data?[index].id.toString() ?? ""),
                  ),
                  title: Text(snapshot.data?[index].title ?? ""),
                  subtitle: Text(snapshot.data?[index].tags.join(" ") ?? ""),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              Detail(task: snapshot.data![index]),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        }
        return Container();
      },
    );
  }
}
