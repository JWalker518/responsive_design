import 'package:flutter/material.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Responsive Design'),
      ),
      body: Center(
        child: Container(
          color: const Color.fromARGB(95, 138, 218, 255),
          padding: const EdgeInsets.all(20),
          constraints: const BoxConstraints(maxWidth: 800),

          child: LayoutBuilder(
            builder: (context, constraints) {
              // If the screen is wide enough, make it a row
              if (constraints.maxWidth > 600) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildAvatar(),
                    SizedBox(width: 20,),
                    Expanded(child: _buildContent())
                    
                  ],
                );
              }
              // Else, make the info a column
              else {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [_buildAvatar(), SizedBox(height: 20), _buildContent()],
                );
              }
            }
          ),
        ),
      ),
    );
  }
}

// function that returns a widget

Widget _buildAvatar() {
  return Container(
    width: 100,
    height: 100,
    decoration: BoxDecoration(
      color: const Color.fromARGB(186, 101, 185, 253),
      shape: BoxShape.circle,
    ),
    child: Icon(
      Icons.person,
      size: 50,
      color: const Color.fromARGB(255, 255, 255, 255),
    ),
  );
}

// Content Widget for Profile
Widget _buildContent() {
  return Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start, // left justifies
    children: [
      Text(
        'Sir Jameson Ritz',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      Text('Major: Business and Finance'),
      Text('Favorite Class: Concierge 101'),
      SizedBox(height: 20),
      ElevatedButton(onPressed: () {}, child: Text('Log in'))
    ],
  );
}
