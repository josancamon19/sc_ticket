import 'package:flutter/material.dart';
import 'package:sc_ticket/models/ticket.dart';
import 'package:sc_ticket/ui/ticket_details.dart';

class TicketView extends StatefulWidget {
  final Ticket ticket;

  const TicketView({Key key, this.ticket}) : super(key: key);

  @override
  _TicketViewState createState() => _TicketViewState();
}

class _TicketViewState extends State<TicketView> {
  @override
  Widget build(BuildContext context) {
    Ticket ticket = widget.ticket;
    Color color;
    switch (ticket.state) {
      case 'Open':
        color = Colors.blue.shade100;
        break;
      case 'In Progress':
        color = Colors.yellow.shade100;
        break;
      case 'Closed':
        color = Colors.greenAccent.shade100;
        break;
      case 'Re-open':
        color = Colors.blue.shade50;
        break;
    }
    return Material(
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => TicketDetails(
                        ticket: ticket,
                      )));
        },
        child: Card(
          color: color,
          elevation: 0.0,
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(vertical: 16.0),
                child: ListTile(
                  title: Text(
                    ticket.title,
                    style: TextStyle(fontSize: 20.0),
                  ),
                  subtitle: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              ticket.type,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Colors.black87, fontSize: 16.0),
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                'Time: ${ticket.time.substring(0, 5)}\nDate: ${ticket.date}',
                                style: TextStyle(fontSize: 16.0),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 16.0,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              ticket.description.length > 200
                                  ? '${ticket.description.substring(0, 196)} ..'
                                  : ticket.description,
                              style: TextStyle(
                                  fontSize: 16.0, color: Colors.black87),
                            ),
                          ),
                          SizedBox(
                            height: 16.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                '${ticket.username}',
                                style: TextStyle(fontSize: 20.0),
                              ),
                              Icon(
                                Icons.navigate_next,
                                size: 36.0,
                                color: Colors.green,
                              )
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Divider(
                height: 3.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
