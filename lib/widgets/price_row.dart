import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PriceRow extends StatelessWidget {
  final String label;
  final String price;
  final IconData? icon; // ✅ Optional icon

  const PriceRow({
    super.key,
    required this.label,
    required this.price,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: Colors.teal, size: 20),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            price,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
