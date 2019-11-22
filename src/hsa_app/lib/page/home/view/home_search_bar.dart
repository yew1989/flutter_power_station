// import 'package:flutter/material.dart';
// import 'package:hsa_app/page/search/search_page.dart';

// class HomeSearchBar extends StatefulWidget {

//   final double searchBarHeight;
//   final List<Station> rawStations;

//   const HomeSearchBar({Key key, this.searchBarHeight, this.rawStations}) : super(key: key);

//   @override
//   _HomeSearchBarState createState() => _HomeSearchBarState();
// }

// class _HomeSearchBarState extends State<HomeSearchBar> {
  
//   @override
//   Widget build(BuildContext context) {
//     var h = widget.searchBarHeight ?? 50;
//     return Container(
//       height: h,
//       width: double.infinity,
//       child: GestureDetector(
//         onTap: (){
//           Navigator.of(context).push(
//             MaterialPageRoute(builder: (BuildContext context) => SearchPage(rawStations: widget.rawStations)));
//         },
//         child: Container(
//           margin: EdgeInsets.only(left: 16,right: 16,top: 2,bottom: 8),
//           decoration: BoxDecoration(
//           color: Colors.black,
//           border: Border.all(
//             color: Colors.grey,
//             width: 1,
//           ),
//           borderRadius: BorderRadius.circular(h/2),
//         ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: <Widget>[
//               Text(
//                 '请输入电站名或拼音',
//                 style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 16,
//                     color: Colors.grey),
//               ),
//               SizedBox(width: 10),
//               Icon(
//                 Icons.search,
//                 color: Colors.grey,
//                 size: 20,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }