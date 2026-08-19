import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_colors.dart';

class StatusBadgeWidget extends StatelessWidget {
  final String status;

  const StatusBadgeWidget({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;
    IconData icon;
    final statusLower = status.toLowerCase();

    if (statusLower.contains('disetujui') ||
        statusLower.contains('diperiksa') ||
        statusLower.contains('setuju')) {
      bgColor = AppColors.statusApprovedBg;
      textColor = AppColors.statusApprovedText;
      icon = Icons.check;
    } else if (statusLower.contains('ditolak') ||
        statusLower.contains('tolak')) {
      bgColor = AppColors.statusRejectedBg;
      textColor = AppColors.statusRejectedText;
      icon = Icons.close;
    } else if (statusLower.contains('belum') ||
        statusLower.contains('proses') ||
        statusLower.contains('diproses') ||
        statusLower.contains('berjalan')) {
      bgColor = AppColors.statusPendingBg;
      textColor = AppColors.statusPendingText;
      icon = Icons.access_time_rounded;
    } else {
      bgColor = AppColors.statusDefaultBg;
      textColor = AppColors.statusDefaultText;
      icon = Icons.remove_done;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: textColor, size: 14),
          const SizedBox(width: 4),
          Text(
            status.isEmpty ? 'Unknown' : status,
            style: GoogleFonts.inter(
              color: textColor,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
