import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InfoRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String text;

  const InfoRow({
    super.key,
    required this.icon,
    this.iconColor = Colors.teal,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.black87,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
