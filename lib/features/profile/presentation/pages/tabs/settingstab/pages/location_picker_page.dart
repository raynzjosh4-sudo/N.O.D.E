import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:node_app/core/utils/responsive_size.dart';

class LocationPickerPage extends StatefulWidget {
  const LocationPickerPage({super.key});

  static Future<String?> show(BuildContext context) {
    return Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (context) => const LocationPickerPage()),
    );
  }

  @override
  State<LocationPickerPage> createState() => _LocationPickerPageState();
}

class _LocationPickerPageState extends State<LocationPickerPage> {
  final MapController _mapController = MapController();
  LatLng _selectedLocation = const LatLng(0.3476, 32.5825); // Kampala Center

  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  bool _isSearching = false;
  List<dynamic> _searchResults = [];

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    if (query.trim().isEmpty) {
      setState(() {
        _searchResults.clear();
        _isSearching = false;
      });
      return;
    }

    setState(() => _isSearching = true);
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      try {
        final url = Uri.parse(
          'https://nominatim.openstreetmap.org/search?q=${Uri.encodeComponent(query)}&format=json&limit=5',
        );
        final response = await http.get(url);
        if (response.statusCode == 200) {
          final data = json.decode(response.body) as List<dynamic>;
          if (mounted) {
            setState(() {
              _searchResults = data;
              _isSearching = false;
            });
          }
        } else {
          if (mounted) setState(() => _isSearching = false);
        }
      } catch (e) {
        if (mounted) setState(() => _isSearching = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    final primary = theme.primaryColor;

    return Scaffold(
      body: Stack(
        children: [
          // ── The Map ─────────────────────────────────────────────────────
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _selectedLocation,
              initialZoom: 15.0,
              onPositionChanged: (position, hasGesture) {
                if (hasGesture) {
                  setState(() {
                    _selectedLocation = position.center;
                  });
                }
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.node.app',
              ),
            ],
          ),

          // ── Centered Pin (Fixed) ────────────────────────────────────────
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.location_on_rounded,
                  size: 40.w,
                  color: primary,
                ),
                SizedBox(height: 40.h), // Offset for the pin tip
              ],
            ),
          ),

          // ── Top Header Actions & Search ─────────────────────────────────
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(16.0.w),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        child: IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(Icons.chevron_left_rounded, color: Colors.black),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Container(
                          height: 48.h,
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.search_rounded, size: 18.w, color: Colors.grey[400]),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: TextField(
                                  controller: _searchController,
                                  decoration: InputDecoration(
                                    hintText: 'Search District or Street...',
                                    hintStyle: GoogleFonts.plusJakartaSans(
                                      fontSize: 13.sp,
                                      color: Colors.grey[400],
                                    ),
                                    border: InputBorder.none,
                                    isDense: true,
                                  ),
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 14.sp,
                                    color: Colors.black87,
                                  ),
                                  onChanged: _onSearchChanged,
                                ),
                              ),
                              if (_isSearching)
                                SizedBox(
                                  width: 16.w,
                                  height: 16.h,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: primary),
                                )
                              else if (_searchController.text.isNotEmpty)
                                GestureDetector(
                                  onTap: () {
                                    _searchController.clear();
                                    setState(() {
                                      _searchResults.clear();
                                    });
                                  },
                                  child: Icon(Icons.close_rounded, size: 18.w, color: Colors.grey[400]),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  // ── Search Results Dropdown ───────────────────────────────
                  if (_searchResults.isNotEmpty)
                    Container(
                      margin: EdgeInsets.only(top: 8.h, left: 50.w),
                      constraints: BoxConstraints(maxHeight: 250.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ListView.separated(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        itemCount: _searchResults.length,
                        separatorBuilder: (context, index) => Divider(height: 1, color: Colors.grey[200]),
                        itemBuilder: (context, index) {
                          final result = _searchResults[index];
                          return ListTile(
                            dense: true,
                            leading: Icon(Icons.location_on_outlined, color: Colors.grey[400], size: 18.w),
                            title: Text(
                              result['display_name'] ?? '',
                              style: GoogleFonts.plusJakartaSans(fontSize: 12.sp, color: Colors.black87),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            onTap: () {
                              final lat = double.tryParse(result['lat']) ?? 0;
                              final lon = double.tryParse(result['lon']) ?? 0;
                              
                              if (lat != 0 && lon != 0) {
                                final loc = LatLng(lat, lon);
                                _mapController.move(loc, 16.0);
                                setState(() {
                                  _selectedLocation = loc;
                                  _searchResults.clear();
                                });
                                FocusScope.of(context).unfocus();
                              }
                            },
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),

          // ── Bottom Selection Panel ──────────────────────────────────────
          Positioned(
            bottom: 32.h,
            left: 16.w,
            right: 16.w,
            child: Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Row(
                    children: [
                      Icon(Icons.map_rounded, size: 18.w, color: primary),
                      SizedBox(width: 12.w),
                      Text(
                        'Confirm Location',
                        style: GoogleFonts.outfit(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w800,
                          color: primary,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'Precision Point',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w700,
                      color: onSurface.withOpacity(0.5),
                    ),
                  ),
                  Text(
                    '${_selectedLocation.latitude.toStringAsFixed(6)}, ${_selectedLocation.longitude.toStringAsFixed(6)}',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w800,
                      color: onSurface,
                    ),
                  ),
                  Text(
                    'Set this as your primary distribution hub.',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: onSurface.withOpacity(0.4),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  SizedBox(
                    width: double.infinity,
                    height: 54.h,
                    child: ElevatedButton(
                      onPressed: () {
                        // In a real app, we'd reverse geocode here.
                        // For now, return a mock address based on lat/lng
                        Navigator.pop(context, "Loc: ${_selectedLocation.latitude.toStringAsFixed(3)}, ${_selectedLocation.longitude.toStringAsFixed(3)} (Kampala)");
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                      ),
                      child: Text(
                        'SET DISTRIBUTION POINT',
                        style: GoogleFonts.outfit(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
