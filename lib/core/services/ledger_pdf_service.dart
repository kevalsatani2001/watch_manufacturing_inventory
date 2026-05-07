import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:watch_manufacturing_inventory_app/core/constants/app_colors.dart';
import 'package:watch_manufacturing_inventory_app/core/constants/app_sizes.dart';
import 'package:watch_manufacturing_inventory_app/core/constants/app_strings.dart';
import 'package:watch_manufacturing_inventory_app/core/models/stock_ledger_entry.dart';

class LedgerPdfService {
  const LedgerPdfService();

  Future<String> exportLedgerPdf({
    required List<StockLedgerEntry> entries,
    required String filterSummary,
  }) async {
    final document = pw.Document();
    final regular = await PdfGoogleFonts.nunitoRegular();
    final bold = await PdfGoogleFonts.nunitoBold();

    document.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          margin: const pw.EdgeInsets.all(AppSizes.xl),
          theme: pw.ThemeData.withFont(base: regular, bold: bold),
          buildBackground: (context) => pw.FullPage(
            ignoreMargins: true,
            child: pw.Container(
              color: _toPdfColor(AppColors.obsidianMidnight),
            ),
          ),
        ),
        header: (context) => _buildPageHeader(filterSummary, bold),
        footer: (context) => _buildFooter(context, regular),
        build: (context) => <pw.Widget>[
          _buildTable(entries, bold, regular),
        ],
      ),
    );

    final bytes = await document.save();
    final directory = await getApplicationDocumentsDirectory();
    final stamp = DateTime.now().millisecondsSinceEpoch;
    final file = File('${directory.path}/ledger_report_$stamp.pdf');
    await file.writeAsBytes(bytes, flush: true);
    await OpenFile.open(file.path);
    return file.path;
  }

  pw.Widget _buildPageHeader(String filterSummary, pw.Font bold) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: <pw.Widget>[
        _buildHeaderCard(filterSummary, bold),
        pw.SizedBox(height: AppSizes.sm),
        _buildTableSectionStrip(bold),
        pw.SizedBox(height: AppSizes.md),
      ],
    );
  }

  pw.Widget _buildHeaderCard(String filterSummary, pw.Font bold) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(AppSizes.md),
      decoration: pw.BoxDecoration(
        color: _toPdfColor(AppColors.obsidianMidnight),
        borderRadius: pw.BorderRadius.circular(AppSizes.sm),
        border: pw.Border.all(color: _toPdfColor(AppColors.borderGlass)),
      ),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: <pw.Widget>[
          pw.Container(
            width: AppSizes.xl + AppSizes.lg,
            height: AppSizes.xl + AppSizes.lg,
            decoration: pw.BoxDecoration(
              color: _toPdfColor(AppColors.cardLuxury),
              borderRadius: pw.BorderRadius.circular(AppSizes.sm),
              border: pw.Border.all(color: _toPdfColor(AppColors.champagneGold)),
            ),
            alignment: pw.Alignment.center,
            child: pw.Text(
              'WF',
              style: pw.TextStyle(
                font: bold,
                fontSize: AppSizes.md,
                color: _toPdfColor(AppColors.champagneGold),
              ),
            ),
          ),
          pw.SizedBox(width: AppSizes.sm + AppSizes.xs),
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: <pw.Widget>[
                pw.Text(
                  AppStrings.ledgerReportTitle,
                  style: pw.TextStyle(
                    font: bold,
                    fontSize: AppSizes.lg,
                    color: _toPdfColor(AppColors.textPrimary),
                  ),
                ),
                pw.SizedBox(height: AppSizes.xs),
                pw.Text(
                  '${AppStrings.filterSummaryLabel}: $filterSummary',
                  style: pw.TextStyle(
                    fontSize: AppSizes.sm + 2,
                    color: _toPdfColor(AppColors.textSecondary),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildTableSectionStrip(pw.Font bold) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.symmetric(horizontal: AppSizes.md, vertical: AppSizes.sm),
      decoration: pw.BoxDecoration(
        color: _toPdfColor(AppColors.cardGlass),
        borderRadius: pw.BorderRadius.circular(AppSizes.sm),
        border: pw.Border.all(color: _toPdfColor(AppColors.borderGold10)),
      ),
      child: pw.Text(
        AppStrings.latestTenEntries,
        style: pw.TextStyle(
          font: bold,
          fontSize: AppSizes.md,
          color: _toPdfColor(AppColors.champagneGold),
        ),
      ),
    );
  }

  pw.Widget _buildTable(List<StockLedgerEntry> entries, pw.Font bold, pw.Font regular) {
    final headers = <String>[
      AppStrings.reportColumnDate,
      AppStrings.reportColumnItem,
      AppStrings.reportColumnType,
      AppStrings.reportColumnQty,
      AppStrings.reportColumnReason,
      AppStrings.reportColumnStatus,
    ];

    final rows = entries.asMap().entries.map((row) {
      final e = row.value;
      return <String>[
        _dateTimeLabel(e.createdAt),
        e.itemName,
        e.transactionType,
        e.quantity.toString(),
        e.reason,
        e.transactionType == AppStrings.statusIn ? AppStrings.statusStockIn : AppStrings.statusStockOut,
      ];
    }).toList();

    return pw.TableHelper.fromTextArray(
      headers: headers,
      data: rows,
      headerCount: 1,
      border: pw.TableBorder.all(color: _toPdfColor(AppColors.borderGlass), width: 0.5),
      headerStyle: pw.TextStyle(
        font: bold,
        fontSize: AppSizes.sm + 2,
        color: _toPdfColor(AppColors.champagneGold),
      ),
      headerDecoration: pw.BoxDecoration(color: _toPdfColor(AppColors.cardLuxury)),
      headerPadding: const pw.EdgeInsets.symmetric(
        horizontal: AppSizes.sm,
        vertical: AppSizes.sm,
      ),
      cellPadding: const pw.EdgeInsets.symmetric(
        horizontal: AppSizes.sm,
        vertical: AppSizes.xs,
      ),
      cellStyle: pw.TextStyle(
        font: regular,
        fontSize: AppSizes.sm + 1,
        color: _toPdfColor(AppColors.textPrimary),
      ),
      rowDecoration: pw.BoxDecoration(color: _toPdfColor(AppColors.surfaceElevated)),
      oddRowDecoration: pw.BoxDecoration(
        color: _toPdfColor(AppColors.cardLuxury.withValues(alpha: 0.82)),
      ),
      cellAlignments: <int, pw.Alignment>{
        3: pw.Alignment.centerRight,
      },
      columnWidths: <int, pw.TableColumnWidth>{
        0: const pw.FlexColumnWidth(2.2),
        1: const pw.FlexColumnWidth(1.8),
        2: const pw.FlexColumnWidth(1),
        3: const pw.FlexColumnWidth(0.8),
        4: const pw.FlexColumnWidth(2.4),
        5: const pw.FlexColumnWidth(1),
      },
    );
  }

  pw.Widget _buildFooter(pw.Context context, pw.Font regular) {
    final now = DateTime.now();
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: <pw.Widget>[
        pw.Text(
          '${AppStrings.generatedOn}: ${_dateTimeLabel(now)}',
          style: pw.TextStyle(font: regular, fontSize: AppSizes.sm + 1, color: _toPdfColor(AppColors.textSecondary)),
        ),
        pw.Text(
          'Page ${context.pageNumber}/${context.pagesCount}',
          style: pw.TextStyle(font: regular, fontSize: AppSizes.sm + 1, color: _toPdfColor(AppColors.textSecondary)),
        ),
      ],
    );
  }

  String _dateTimeLabel(DateTime dt) {
    String two(int value) => value < 10 ? '0$value' : '$value';
    return '${two(dt.day)}/${two(dt.month)}/${dt.year} ${two(dt.hour)}:${two(dt.minute)}';
  }

  PdfColor _toPdfColor(Color color) {
    return PdfColor(
      color.r,
      color.g,
      color.b,
      color.a,
    );
  }
}
