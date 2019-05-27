import 'package:finewallet/Blocs/transaction_bloc.dart';
import 'package:finewallet/Models/transaction_model.dart';
import 'package:finewallet/Resources/internal_data.dart';
import 'package:flutter/material.dart';


class HistoryPage extends StatefulWidget {

  HistoryPage(this.title, {Key key}) : super(key: key);

  final String title;

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final _txBloc = TransactionBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffd8e7ff),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Text(widget.title, style: TextStyle(color: Colors.white),),
      ),
      body: StreamBuilder<List<TransactionModel>>(
        stream: _txBloc.transactions,
        builder: (BuildContext context, AsyncSnapshot<List<TransactionModel>> snapshot){
          if(snapshot.hasData){
            
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index){
                TransactionModel item = snapshot.data[index];
                // print(item.category);
                // print(icons.length);
                return ListTile(
                  title: Column(children: <Widget>[
                    Text(item.amount.toString()),
                    Text(item.subcategoryName),
                    Icon(icons[item.category-1])
                  ],),
                  leading: Text(item.id.toString()),
                  trailing: InkWell(
                    child: Icon(Icons.delete_outline),
                    onTap: () {
                      _txBloc.delete(item.id);
                    },
                  )
                );
              },
            );
          }else{
            return Container();
          }
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          TransactionModel tx = new TransactionModel(subcategory: 30, amount: 3.23, date: dayInMillis(DateTime.now()), isExpense: 1);
          _txBloc.add(tx);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}


// FutureBuilder(
//         future: DBProvider.db.getAllTransactions(),
//         builder: (ctxt, snapshot){
//           if(snapshot.hasData){
//             return ListView.builder(
//               itemCount: snapshot.data.length,
//               itemBuilder: (context, index){
//                 TransactionModel item = snapshot.data[index];
//                 return ListTile(
//                   title: Text(item.amount.toString()),
//                   leading: Text(item.id.toString()),
//                   trailing: InkWell(
//                     child: Icon(Icons.delete_outline),
//                     onTap: () {
//                       DBProvider.db.deleteTransaction(item.id);
//                       setState(() {});
//                       },
//                   )
//                 );
//               },
//             );
//           }else{
//             return Container();
//           }
//         },
//       ),