import 'dart:async';
import 'dart:convert';

import 'package:enavatek_mobile/auth/shared_preference_helper.dart';
import 'package:enavatek_mobile/services/remote_service.dart';
import 'package:enavatek_mobile/value/constant_colors.dart';
import 'package:enavatek_mobile/widget/footer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class MQTTWaitingScreen extends StatefulWidget {
  final String deviceName;
  const MQTTWaitingScreen({Key? key, required this.deviceName})
      : super(key: key);

  @override
  MQTTWaitingScreenState createState() => MQTTWaitingScreenState();
}

class MQTTWaitingScreenState extends State<MQTTWaitingScreen> {
  // ---------- CONFIG ----------
  static const Duration pollInterval = Duration(seconds: 5);
  static const Duration timeout = Duration(minutes: 3);
  static const Duration successHold = Duration(milliseconds: 1200);
  static const Duration failureHold = Duration(milliseconds: 1500);

  Timer? _progressTimer;
  Timer? _pollTimer;
  DateTime _start = DateTime.now();
  int _elapsedMs = 0;

  String _msg = 'Waiting for server confirmation';
  _Phase _phase = _Phase.waiting;
  bool _done = false;
  bool _successTriggered = false; // ADD THIS FLAG

  double get _progress => (_elapsedMs / timeout.inMilliseconds).clamp(0.0, 1.0);

  int get _remainingSec => ((_elapsedMs >= timeout.inMilliseconds)
          ? 0
          : (timeout.inMilliseconds - _elapsedMs) / 1000)
      .ceil();

  @override
  void initState() {
    super.initState();
    _start = DateTime.now();

    // Smooth progress bar
    _progressTimer = Timer.periodic(const Duration(milliseconds: 120), (_) {
      if (!mounted) return;
      setState(
          () => _elapsedMs = DateTime.now().difference(_start).inMilliseconds);
      if (_elapsedMs >= timeout.inMilliseconds && !_done) {
        _onTimeout();
      }
    });

    // First poll immediately, then interval
    _pollOnce();
    _pollTimer = Timer.periodic(pollInterval, (_) => _pollOnce());
  }

  @override
  void dispose() {
    _progressTimer?.cancel();
    _pollTimer?.cancel();
    super.dispose();
  }

  Future<void> _pollOnce() async {
    if (_done || _successTriggered) return; // ADD CHECK HERE

    try {
      setState(() => _msg = 'Waiting for server confirmation');

      final token = await SharedPreferencesHelper.instance.getAuthToken();
      final userId = await SharedPreferencesHelper.instance.getUserID();
      if (token == null || userId == null) {
        setState(() => _msg = 'Missing auth. Retrying…');
        return;
      }

      final resp = await _checkMqttStatus(token, widget.deviceName);

      dynamic data;
      try {
        data = jsonDecode(resp.body);
      } catch (_) {
        data = null;
      }

      if (_isSuccess(resp, data)) {
        _onSuccess();
      } else {
        if (mounted) setState(() => _msg = 'Waiting for server confirmation');
      }
    } catch (e) {
      if (mounted) setState(() => _msg = 'Connection failed… retrying.');
    }
  }

  Future<Response> _checkMqttStatus(String authToken, String deviceName) async {
    try {
      Response response =
          await RemoteServices.checkMqttStaus(authToken, deviceName);
      return response;
    } catch (e) {
      return Response('{"error": "$e"}', 500);
    }
  }

  bool _isSuccess(Response resp, dynamic data) {
    print('Status Code: ${resp.statusCode}');
    print('Response Body: ${resp.body}');

    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      if (data is Map<String, dynamic>) {
        // Check if the response contains actual device data (not just connection status)
        final hasDeviceData = data.containsKey('device_id') &&
            data.containsKey('ac_voltage') &&
            data.containsKey('dc_voltage');

        // If it has device data, it means the device is actually sending data
        if (hasDeviceData) {
          return true;
        }

        final status =
            (data['status'] ?? data['state'] ?? data['message'] ?? '')
                .toString()
                .toLowerCase();
        final isConnected = data['connected'] ?? data['isConnected'] ?? false;

        return status == 'success' ||
            status == 'ready' ||
            status == 'connected' ||
            status == 'active' ||
            data['ok'] == true ||
            isConnected == true;
      }
      return true;
    }
    return false;
  }

  void _onSuccess() {
    if (_done || _successTriggered) return; // PREVENT MULTIPLE TRIGGERS
    _successTriggered = true; // SET THIS FLAG
    _done = true;
    _progressTimer?.cancel();
    _pollTimer?.cancel();
    if (!mounted) return;

    setState(() {
      _phase = _Phase.success;
      _msg = 'Device started sending data to the server successfully';
    });

    Future.delayed(successHold, () {
      if (!mounted) return;
      _showSuccessDialog();
    });
  }

  void _onTimeout() {
    if (_done) return;
    _done = true;
    _progressTimer?.cancel();
    _pollTimer?.cancel();
    if (!mounted) return;

    setState(() {
      _phase = _Phase.timeout;
      _msg =
          'Device not sending data to server, check the connectivity or Time frequency configured';
    });

    Future.delayed(failureHold, () {
      if (!mounted) return;
      _showFailureDialog();
    });
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 60,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Success!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Device started sending data to the server successfully',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close dialog
                    Navigator.of(context).pop(); // Navigate back
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    'OK',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showFailureDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 60,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Connection Failed',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Device not sending data to server, check the connectivity or Time frequency configured',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close dialog
                    Navigator.of(context).pop(); // Navigate back
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    'OK',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Block back button (no user actions while waiting)
  Future<bool> _onWillPop() async => false;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final bool isTablet = screenWidth >= 600;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: ConstantColors.backgroundColor,
        bottomNavigationBar: const Footer(),
        body: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              isTablet ? 0.05 * screenWidth : 0.05 * screenWidth,
              isTablet ? 0.05 * screenHeight : 0.05 * screenHeight,
              isTablet ? 0.05 * screenWidth : 0.05 * screenWidth,
              isTablet ? 0.02 * screenHeight : 0.05 * screenHeight,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    _phase == _Phase.success
                        ? 'Ready'
                        : _phase == _Phase.timeout
                            ? 'Timeout'
                            : 'Please wait',
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 16),

                  // Horizontal progress bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      minHeight: 10,
                      value: _phase == _Phase.waiting ? _progress : 1.0,
                      backgroundColor: Colors.grey.shade300,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _phase == _Phase.success
                            ? Colors.green
                            : _phase == _Phase.timeout
                                ? Colors.red
                                : Colors.blue,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Loading icon with message
                  if (_phase == _Phase.waiting) ...[
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.blue.shade700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  Text(
                    _phase == _Phase.waiting
                        ? '$_msg  •  ${_formatTime(_remainingSec)} remaining'
                        : _msg,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _phase == _Phase.waiting
                          ? Colors.grey.shade700
                          : _phase == _Phase.success
                              ? Colors.green.shade700
                              : Colors.red.shade700,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 12),
                  if (_phase == _Phase.success)
                    _chip('✓ Success', Colors.green),
                  if (_phase == _Phase.timeout) _chip('✗ Timeout', Colors.red),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatTime(int totalSec) {
    final m = (totalSec ~/ 60).toString().padLeft(2, '0');
    final s = (totalSec % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  Widget _chip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(.1),
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: color.withOpacity(.6)),
      ),
      child: Text(text,
          style: TextStyle(color: color, fontWeight: FontWeight.w600)),
    );
  }
}

enum _Phase { waiting, success, timeout }

// import 'dart:async';
// import 'dart:convert';

// import 'package:enavatek_mobile/auth/shared_preference_helper.dart';
// import 'package:enavatek_mobile/services/remote_service.dart';
// import 'package:enavatek_mobile/value/constant_colors.dart';
// import 'package:enavatek_mobile/widget/footer.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart';

// class MQTTWaitingScreen extends StatefulWidget {
//   final String deviceName;
//   const MQTTWaitingScreen({Key? key, required this.deviceName})
//       : super(key: key);

//   @override
//   MQTTWaitingScreenState createState() => MQTTWaitingScreenState();
// }

// class MQTTWaitingScreenState extends State<MQTTWaitingScreen> {
//   // ---------- CONFIG ----------
//   static const Duration pollInterval = Duration(seconds: 5);
//   static const Duration timeout = Duration(minutes: 2);
//   static const Duration successHold = Duration(milliseconds: 1200);
//   static const Duration failureHold = Duration(milliseconds: 1500);

//   Timer? _progressTimer;
//   Timer? _pollTimer;
//   DateTime _start = DateTime.now();
//   int _elapsedMs = 0;

//   String _msg = 'Waiting for server confirmation';
//   _Phase _phase = _Phase.waiting;
//   bool _done = false;

//   double get _progress => (_elapsedMs / timeout.inMilliseconds).clamp(0.0, 1.0);

//   int get _remainingSec => ((_elapsedMs >= timeout.inMilliseconds)
//           ? 0
//           : (timeout.inMilliseconds - _elapsedMs) / 1000)
//       .ceil();

//   @override
//   void initState() {
//     super.initState();
//     _start = DateTime.now();

//     // Smooth progress bar
//     _progressTimer = Timer.periodic(const Duration(milliseconds: 120), (_) {
//       if (!mounted) return;
//       setState(
//           () => _elapsedMs = DateTime.now().difference(_start).inMilliseconds);
//       if (_elapsedMs >= timeout.inMilliseconds && !_done) {
//         _onTimeout();
//       }
//     });

//     // First poll immediately, then interval
//     _pollOnce();
//     _pollTimer = Timer.periodic(pollInterval, (_) => _pollOnce());
//   }

//   @override
//   void dispose() {
//     _progressTimer?.cancel();
//     _pollTimer?.cancel();
//     super.dispose();
//   }

//   Future<void> _pollOnce() async {
//     if (_done) return;

//     try {
//       setState(() => _msg = 'Waiting for server confirmation');

//       final token = await SharedPreferencesHelper.instance.getAuthToken();
//       final userId = await SharedPreferencesHelper.instance.getUserID();
//       if (token == null || userId == null) {
//         setState(() => _msg = 'Missing auth. Retrying…');
//         return;
//       }

//       // Fixed: Properly call the method and get response
//       final resp = await _checkMqttStatus(token, widget.deviceName);

//       dynamic data;
//       try {
//         data = jsonDecode(resp.body);
//       } catch (_) {
//         data = null;
//       }

//       if (_isSuccess(resp, data)) {
//         _onSuccess();
//       } else {
//         if (mounted) setState(() => _msg = 'Waiting for server confirmation');
//       }
//     } catch (e) {
//       if (mounted) setState(() => _msg = 'Connection failed… retrying.');
//     }
//   }

//   Future<Response> _checkMqttStatus(String authToken, String deviceName) async {
//     try {
//       Response response =
//           await RemoteServices.checkMqttStaus(authToken, deviceName);
//       return response;
//     } catch (e) {
//       return Response('{"error": "$e"}', 500);
//     }
//   }

//   bool _isSuccess(Response resp, dynamic data) {
//     print('Status Code: ${resp.statusCode}'); // Debug log
//     print('Response Body: ${resp.body}'); // Debug log

//     if (resp.statusCode >= 200 && resp.statusCode < 300) {
//       if (data is Map<String, dynamic>) {
//         final status =
//             (data['status'] ?? data['state'] ?? data['message'] ?? '')
//                 .toString()
//                 .toLowerCase();
//         final isConnected = data['connected'] ?? data['isConnected'] ?? false;

//         // Enhanced success conditions
//         return status == 'success' ||
//             status == 'ready' ||
//             status == 'connected' ||
//             status == 'active' ||
//             data['ok'] == true ||
//             isConnected == true;
//       }
//       // Any 2xx with no body → treat as success
//       return true;
//     }
//     return false;
//   }

//   void _onSuccess() {
//     if (_done) return;
//     _done = true;
//     _progressTimer?.cancel();
//     _pollTimer?.cancel();
//     if (!mounted) return;

//     setState(() {
//       _phase = _Phase.success;
//       _msg = 'Device started sending data to the server successfully';
//     });

//     Future.delayed(successHold, () {
//       if (!mounted) return;
//       _showSuccessDialog();
//     });
//   }

//   void _onTimeout() {
//     if (_done) return;
//     _done = true;
//     _progressTimer?.cancel();
//     _pollTimer?.cancel();
//     if (!mounted) return;

//     setState(() {
//       _phase = _Phase.timeout;
//       _msg =
//           'Device not sending data to server, check the connectivity or Time frequency configured';
//     });

//     Future.delayed(failureHold, () {
//       if (!mounted) return;
//       _showFailureDialog();
//     });
//   }

//   void _showSuccessDialog() {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 width: 80,
//                 height: 80,
//                 decoration: BoxDecoration(
//                   color: Colors.green.withOpacity(0.1),
//                   shape: BoxShape.circle,
//                 ),
//                 child: const Icon(
//                   Icons.check_circle,
//                   color: Colors.green,
//                   size: 60,
//                 ),
//               ),
//               const SizedBox(height: 20),
//               const Text(
//                 'Success!',
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.green,
//                 ),
//               ),
//               const SizedBox(height: 10),
//               const Text(
//                 'Device started sending data to the server successfully',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: Colors.black87,
//                 ),
//               ),
//               const SizedBox(height: 20),
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     Navigator.of(context).pop(); // Close dialog
//                     Navigator.of(context).pop(); // Navigate back
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.green,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     padding: const EdgeInsets.symmetric(vertical: 12),
//                   ),
//                   child: const Text(
//                     'OK',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   void _showFailureDialog() {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 width: 80,
//                 height: 80,
//                 decoration: BoxDecoration(
//                   color: Colors.red.withOpacity(0.1),
//                   shape: BoxShape.circle,
//                 ),
//                 child: const Icon(
//                   Icons.error_outline,
//                   color: Colors.red,
//                   size: 60,
//                 ),
//               ),
//               const SizedBox(height: 20),
//               const Text(
//                 'Connection Failed',
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.red,
//                 ),
//               ),
//               const SizedBox(height: 10),
//               const Text(
//                 'Device not sending data to server, check the connectivity or Time frequency configured',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: Colors.black87,
//                 ),
//               ),
//               const SizedBox(height: 20),
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     Navigator.of(context).pop(); // Close dialog
//                     Navigator.of(context).pop(); // Navigate back
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.red,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     padding: const EdgeInsets.symmetric(vertical: 12),
//                   ),
//                   child: const Text(
//                     'OK',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   // Block back button (no user actions while waiting)
//   Future<bool> _onWillPop() async => false;

//   @override
//   Widget build(BuildContext context) {
//     final double screenWidth = MediaQuery.of(context).size.width;
//     final double screenHeight = MediaQuery.of(context).size.height;
//     final bool isTablet = screenWidth >= 600;

//     return WillPopScope(
//       onWillPop: _onWillPop,
//       child: Scaffold(
//         backgroundColor: ConstantColors.backgroundColor,
//         bottomNavigationBar: const Footer(),
//         body: Center(
//           child: SingleChildScrollView(
//             padding: EdgeInsets.fromLTRB(
//               isTablet ? 0.05 * screenWidth : 0.05 * screenWidth,
//               isTablet ? 0.05 * screenHeight : 0.05 * screenHeight,
//               isTablet ? 0.05 * screenWidth : 0.05 * screenWidth,
//               isTablet ? 0.02 * screenHeight : 0.05 * screenHeight,
//             ),
//             child: ConstrainedBox(
//               constraints: const BoxConstraints(maxWidth: 560),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   const SizedBox(height: 4),
//                   Text(
//                     _phase == _Phase.success
//                         ? 'Ready'
//                         : _phase == _Phase.timeout
//                             ? 'Timeout'
//                             : 'Please wait',
//                     style: const TextStyle(
//                         fontSize: 22, fontWeight: FontWeight.w700),
//                   ),
//                   const SizedBox(height: 16),

//                   // Horizontal progress bar
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(8),
//                     child: LinearProgressIndicator(
//                       minHeight: 10,
//                       value: _phase == _Phase.waiting ? _progress : 1.0,
//                       backgroundColor: Colors.grey.shade300,
//                       valueColor: AlwaysStoppedAnimation<Color>(
//                         _phase == _Phase.success
//                             ? Colors.green
//                             : _phase == _Phase.timeout
//                                 ? Colors.red
//                                 : Colors.blue,
//                       ),
//                     ),
//                   ),

//                   const SizedBox(height: 20),

//                   // Loading icon with message
//                   if (_phase == _Phase.waiting) ...[
//                     SizedBox(
//                       width: 40,
//                       height: 40,
//                       child: CircularProgressIndicator(
//                         strokeWidth: 3,
//                         valueColor: AlwaysStoppedAnimation<Color>(
//                           Colors.blue.shade700,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                   ],

//                   Text(
//                     _phase == _Phase.waiting
//                         ? '$_msg  •  ${_formatTime(_remainingSec)} remaining'
//                         : _msg,
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       color: _phase == _Phase.waiting
//                           ? Colors.grey.shade700
//                           : _phase == _Phase.success
//                               ? Colors.green.shade700
//                               : Colors.red.shade700,
//                       fontSize: 14,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),

//                   const SizedBox(height: 12),
//                   if (_phase == _Phase.success)
//                     _chip('✓ Success', Colors.green),
//                   if (_phase == _Phase.timeout) _chip('✗ Timeout', Colors.red),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   String _formatTime(int totalSec) {
//     final m = (totalSec ~/ 60).toString().padLeft(2, '0');
//     final s = (totalSec % 60).toString().padLeft(2, '0');
//     return '$m:$s';
//   }

//   Widget _chip(String text, Color color) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//       decoration: BoxDecoration(
//         color: color.withOpacity(.1),
//         borderRadius: BorderRadius.circular(99),
//         border: Border.all(color: color.withOpacity(.6)),
//       ),
//       child: Text(text,
//           style: TextStyle(color: color, fontWeight: FontWeight.w600)),
//     );
//   }
// }

// enum _Phase { waiting, success, timeout }
