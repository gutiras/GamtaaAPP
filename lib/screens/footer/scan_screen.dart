import 'package:flutter/material.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'dart:io';
import '../base_scaffold.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String? scannedData;
  bool _isFlashOn = false;
  bool _isScanning = true;

  // For hot reload (important for Android camera)
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    }
    controller?.resumeCamera();
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() => this.controller = controller);
    controller.scannedDataStream.listen((scanData) {
      if (!_isScanning) return;
      
      setState(() {
        scannedData = scanData.code;
        _isScanning = false;
      });
      
      if (scannedData != null) {
        controller.pauseCamera();
        _showPaymentDialog(scannedData!);
      }
    });
  }

  void _showPaymentDialog(String qrData) {
    // Parse QR data for amount and merchant info
    double amount = _parseAmountFromQR(qrData);
    String merchant = _parseMerchantFromQR(qrData);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Row(
            children: [
              Icon(Icons.qr_code, color: Color(0xFF00ADEF)),
              SizedBox(width: 8),
              Text('Payment Request'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('QR Data: ${qrData.length > 30 ? '${qrData.substring(0, 30)}...' : qrData}'),
              const SizedBox(height: 16),
              Text('Amount: ETB ${amount.toStringAsFixed(2)}', 
                   style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('Merchant: $merchant'),
              const SizedBox(height: 8),
              const Text('From: Gutu Rarie'),
              const SizedBox(height: 8),
              const Text('Account: •••• 6789'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _resumeScanning();
              },
              child: const Text('CANCEL'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _processPayment(qrData, amount, merchant);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00ADEF),
              ),
              child: const Text('PAY NOW'),
            ),
          ],
        );
      },
    );
  }

  double _parseAmountFromQR(String qrData) {
    // Simple parsing logic - you can enhance this based on your QR format
    if (qrData.contains('amount=')) {
      try {
        final amountStr = qrData.split('amount=')[1].split('&')[0];
        return double.parse(amountStr);
      } catch (e) {
        return 150.00; // Default amount
      }
    }
    return 150.00; // Default amount
  }

  String _parseMerchantFromQR(String qrData) {
    // Simple parsing logic - you can enhance this based on your QR format
    if (qrData.contains('merchant=')) {
      try {
        return qrData.split('merchant=')[1].split('&')[0];
      } catch (e) {
        return 'Coop Merchant';
      }
    }
    return 'Coop Merchant'; // Default merchant
  }

  void _processPayment(String qrData, double amount, String merchant) {
    // Show processing dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(color: Color(0xFF00ADEF)),
                const SizedBox(height: 20),
                const Text(
                  'Processing Payment...',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'ETB ${amount.toStringAsFixed(2)} to $merchant',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        );
      },
    );

    // Simulate payment processing
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context); // Close processing dialog
      _showPaymentSuccess(amount, merchant);
    });
  }

  void _showPaymentSuccess(double amount, String merchant) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 28),
              SizedBox(width: 8),
              Text('Payment Successful', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('ETB ${amount.toStringAsFixed(2)}', 
                   style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green)),
              const SizedBox(height: 12),
              _buildDetailRow('Paid to:', merchant),
              _buildDetailRow('Transaction ID:', 'TXN${DateTime.now().millisecondsSinceEpoch}'),
              _buildDetailRow('Date:', '${DateTime.now().toString().split(' ')[0]}'),
              _buildDetailRow('Time:', '${TimeOfDay.now().format(context)}'),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.security, color: Colors.green, size: 16),
                    SizedBox(width: 4),
                    Text('Transaction Secured', style: TextStyle(color: Colors.green, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _resumeScanning();
              },
              child: const Text('SCAN AGAIN'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _resumeScanning();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00ADEF),
              ),
              child: const Text('VIEW RECEIPT'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 12))),
        ],
      ),
    );
  }

  void _resumeScanning() {
    setState(() {
      scannedData = null;
      _isScanning = true;
    });
    controller?.resumeCamera();
  }

  void _toggleFlash() async {
    await controller?.toggleFlash();
    setState(() => _isFlashOn = !_isFlashOn);
  }

  void _pickFromGallery() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Gallery QR scanning feature coming soon!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: 'Scan QR Code',
      userName: 'Gutu Rarie',
      notificationCount: 0,
      showBackButton: false,
      initialTabIndex: 2, // Scan tab index
      body: Column(
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Real Scanner
                _isScanning ? _buildRealScanner() : _buildScanCompleteState(),
                
                // Scanner Overlay
                if (_isScanning) _buildScannerOverlay(),

                // Flash Button
                if (_isScanning)
                  Positioned(
                    top: 50,
                    right: 20,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(
                          _isFlashOn ? Icons.flash_on : Icons.flash_off,
                          color: Colors.white,
                          size: 28,
                        ),
                        onPressed: _toggleFlash,
                      ),
                    ),
                  ),

                // Instructions
                if (_isScanning)
                  Positioned(
                    bottom: 120,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: const Text(
                        'Align QR code within frame',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Bottom Controls
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              children: [
                if (!_isScanning && scannedData != null)
                  Column(
                    children: [
                      Text(
                        'Scanned: ${scannedData!.length > 40 ? '${scannedData!.substring(0, 40)}...' : scannedData!}',
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _pickFromGallery,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF00ADEF),
                          side: const BorderSide(color: Color(0xFF00ADEF)),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.photo_library),
                        label: const Text('Gallery'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _isScanning ? null : _resumeScanning,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isScanning ? Colors.grey : const Color(0xFF00ADEF),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: Icon(_isScanning ? Icons.qr_code_scanner : Icons.refresh),
                        label: Text(_isScanning ? 'Scanning...' : 'Scan Again'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  'Scan CoopBank QR codes for instant payments',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRealScanner() {
    return QRView(
      key: qrKey,
      overlay: QrScannerOverlayShape(
        borderColor: const Color(0xFF00ADEF),
        borderRadius: 10,
        borderLength: 30,
        borderWidth: 6,
        cutOutSize: 250,
      ),
      onQRViewCreated: _onQRViewCreated,
    );
  }

  Widget _buildScanCompleteState() {
    return Container(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, size: 60, color: Colors.green),
            const SizedBox(height: 16),
            const Text(
              'QR Code Scanned',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 8),
            if (scannedData != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  scannedData!.length > 40 
                      ? '${scannedData!.substring(0, 40)}...' 
                      : scannedData!,
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildScannerOverlay() {
    return IgnorePointer(
      child: Container(
        width: 300,
        height: 300,
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color(0xFF00ADEF).withOpacity(0.5),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: CustomPaint(
          painter: ScannerCornerPainter(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}

class ScannerCornerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF00ADEF)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    const cornerLength = 20.0;

    // Top left corner
    canvas.drawLine(Offset.zero, const Offset(cornerLength, 0), paint);
    canvas.drawLine(Offset.zero, const Offset(0, cornerLength), paint);

    // Top right corner
    canvas.drawLine(Offset(size.width, 0), Offset(size.width - cornerLength, 0), paint);
    canvas.drawLine(Offset(size.width, 0), Offset(size.width, cornerLength), paint);

    // Bottom left corner
    canvas.drawLine(Offset(0, size.height), Offset(0, size.height - cornerLength), paint);
    canvas.drawLine(Offset(0, size.height), Offset(cornerLength, size.height), paint);

    // Bottom right corner
    canvas.drawLine(Offset(size.width, size.height), Offset(size.width, size.height - cornerLength), paint);
    canvas.drawLine(Offset(size.width, size.height), Offset(size.width - cornerLength, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}