import 'package:dating/constants/dating_app_user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';



class CitySearchPage extends StatefulWidget {
  @override
  _CitySearchPageState createState() => _CitySearchPageState();
}

class _CitySearchPageState extends State<CitySearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Place> _suggestions = [];
  List<Place> _recentCities = [];
  bool _isLoading = false;
  Timer? _debounce;
  String? _selectedCity;

  @override
  void initState() {
    super.initState();
    _loadRecentCities();
  }

  void _loadRecentCities() {
    // Simulating recent cities - in a real app, you'd load from SharedPreferences
    _recentCities = [
      Place(name: "Bengaluru Urban, Ka, India", placeId: "1", types: ["administrative_area_level_2"]),
      Place(name: "Mumbai, Mh, India", placeId: "2", types: ["locality"]),
      Place(name: "Gurugram, Hr, India", placeId: "3", types: ["locality"]),
      Place(name: "Pune, Mh, India", placeId: "4", types: ["locality"]),
      Place(name: "Ahmedabad, Gj, India", placeId: "5", types: ["locality"]),
      Place(name: "Hyderabad, Tg, India", placeId: "6", types: ["locality"]),
      Place(name: "Chennai, Tn, India", placeId: "7", types: ["locality"]),
      Place(name: "Jaipur, Rj, India", placeId: "8", types: ["locality"]),
      Place(name: "Kolkata, Wb, India", placeId: "9", types: ["locality"]),
      Place(name: "Noida, Up, India", placeId: "10", types: ["locality"]),
      Place(name: "North Twenty Four Parganas, Wb, India", placeId: "11", types: ["administrative_area_level_2"]),
      Place(name: "Thane, Mh, India", placeId: "12", types: ["administrative_area_level_2"]),
      Place(name: "Kochi, Kl, India", placeId: "13", types: ["locality"]),
      Place(name: "Navi Mumbai, Mh, India", placeId: "14", types: ["locality"]),
      Place(name: "Lucknow, Up, India", placeId: "15", types: ["locality"]),
      Place(name: "Indore, Mp, India", placeId: "16", types: ["locality"]),
      Place(name: "Ghaziabad, Up, India", placeId: "17", types: ["locality"]),
      Place(name: "Bhopal, Mp, India", placeId: "18", types: ["locality"]),
      Place(name: "Surat, Gj, India", placeId: "19", types: ["locality"]),
      Place(name: "Vadodara, Gj, India", placeId: "20", types: ["locality"]),
    ];
  }

  Future<List<Place>> fetchCitySuggestions(String query) async {
    if (query.isEmpty) return [];
    
    try {
      final String apiKey = "AIzaSyB_7QtF9EUbVs_5mVFxZWS-NdzYwV9dbU0"; 
      
      // Modified URL to search for all administrative areas including districts
      final url =
          'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=${Uri.encodeComponent(query)}&components=country:IN&types=administrative_area_level_1|administrative_area_level_2|administrative_area_level_3|locality|sublocality&key=$apiKey';

      print('API URL: $url'); // Debug print
      
      final response = await http.get(Uri.parse(url));
      
      print('Response Status: ${response.statusCode}'); // Debug print
      print('Response Body: ${response.body}'); // Debug print
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['status'] == 'OK') {
          final predictions = data['predictions'] as List;
          print('Found ${predictions.length} predictions'); // Debug print
          
          return List<Place>.from(
            predictions.map((p) => Place(
              name: p['description'],
              placeId: p['place_id'],
              types: List<String>.from(p['types'] ?? []),
            )),
          );
        } else {
          print('API Error: ${data['status']}');
          if (data['error_message'] != null) {
            print('Error Message: ${data['error_message']}');
          }
          
          // Check for specific quota/billing errors
          if (data['status'] == 'REQUEST_DENIED') {
            _showErrorDialog('API Key Error', 'Please check your Google Places API key and ensure billing is enabled.');
          } else if (data['status'] == 'OVER_QUERY_LIMIT') {
            _showErrorDialog('Quota Exceeded', 'You have exceeded your API quota limit.');
          }
          
          return [];
        }
      } else {
        print('HTTP Error: ${response.statusCode}');
        _showErrorDialog('Network Error', 'Failed to connect to the API. Status: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching suggestions: $e');
      _showErrorDialog('Error', 'An error occurred while searching: $e');
      return [];
    }
  }

  void _showErrorDialog(String title, String message) {
    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (value.isEmpty) {
        setState(() {
          _suggestions = [];
          _isLoading = false;
        });
        return;
      }

      setState(() {
        _isLoading = true;
      });

      final newSuggestions = await fetchCitySuggestions(value);
      
      if (mounted) {
        setState(() {
          _suggestions = newSuggestions;
          _isLoading = false;
        });
      }
    });
  }

  void _selectCity(String cityName) {
    setState(() {
      _selectedCity = cityName;
      _searchController.text = cityName;
      _suggestions = [];
    });
    
      // Add to recent cities if not already present
      final existingIndex = _recentCities.indexWhere((city) => city.name == cityName);
      if (existingIndex == -1) {
        setState(() {
          _recentCities.insert(0, Place(
            name: cityName, 
            placeId: DateTime.now().millisecondsSinceEpoch.toString(),
            types: [],
          ));
          if (_recentCities.length > 20) {
            _recentCities.removeLast();
          }
        });
      } else {
        // Move to top if already exists
        final city = _recentCities.removeAt(existingIndex);
        setState(() {
          _recentCities.insert(0, city);
        });
      }
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Selected: $cityName"),
        backgroundColor: DatingColors.darkGreen,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _suggestions = [];
      _selectedCity = null;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Find Your Current City'),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: EdgeInsets.all(16.0),
            color: Colors.blue,
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              style: TextStyle(color: DatingColors.white),
              decoration: InputDecoration(
                hintText: 'Search for your city',
                hintStyle: TextStyle(color: DatingColors.white),
                prefixIcon: Icon(Icons.search, color: DatingColors.white),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear, color: DatingColors.white),
                        onPressed: _clearSearch,
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: DatingColors.white),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: DatingColors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: DatingColors.white, width: 2),
                ),
              ),
            ),
          ),
          
          // Content Area
          Expanded(
            child: _isLoading
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Searching cities...'),
                      ],
                    ),
                  )
                : _suggestions.isNotEmpty
                    ? _buildSuggestionsList()
                    : _buildRecentCitiesList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionsList() {
    return ListView.separated(
      itemCount: _suggestions.length,
      separatorBuilder: (context, index) => Divider(height: 1),
      itemBuilder: (context, index) {
        final place = _suggestions[index];
        
        // Determine icon based on place type
        IconData iconData = Icons.location_city;
        if (place.types.contains('administrative_area_level_2')) {
          iconData = Icons.location_on; // District
        } else if (place.types.contains('locality')) {
          iconData = Icons.location_city; // City
        } else if (place.types.contains('sublocality')) {
          iconData = Icons.place; // Sublocality
        }
        
        return ListTile(
          leading: Icon(iconData, color: DatingColors.lightgrey),
          title: Text(
            place.name,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: place.types.isNotEmpty 
              ? Text(
                  place.types.join(', '),
                  style: TextStyle(fontSize: 12, color: DatingColors.lightgrey),
                )
              : null,
          onTap: () => _selectCity(place.name),
        );
      },
    );
  }

  Widget _buildRecentCitiesList() {
    if (_recentCities.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.location_city, size: 64, color: DatingColors.lightgrey),
            SizedBox(height: 16),
            Text(
              'No recent cities',
              style: TextStyle(
                fontSize: 16,
                color: DatingColors.lightgrey,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Start typing to search for cities',
              style: TextStyle(
                fontSize: 14,
                color: DatingColors.lightgrey,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      itemCount: _recentCities.length,
      separatorBuilder: (context, index) => Divider(height: 1),
      itemBuilder: (context, index) {
        final place = _recentCities[index];
        return ListTile(
          leading: Icon(Icons.location_city, color: DatingColors.lightgrey),
          title: Text(
            place.name,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing: Icon(Icons.arrow_forward_ios, size: 16, color: DatingColors.lightgrey),
          onTap: () => _selectCity(place.name),
        );
      },
    );
  }
}

class Place {
  final String name;
  final String placeId;
  final List<String> types;

  Place({
    required this.name, 
    required this.placeId,
    this.types = const [],
  });
}