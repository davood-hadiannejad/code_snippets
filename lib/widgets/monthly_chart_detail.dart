import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:charts_flutter/flutter.dart' as charts;

final formatter =
    new NumberFormat.simpleCurrency(locale: 'eu', decimalDigits: 0);

List<String> detailTVKind = ['ATV', 'Trade', 'SoWeFo', 'DRTV', 'Klassisch'];
List<Color> detailTVColor = [
  Color.fromRGBO(176, 133, 246, 1),
  Color.fromRGBO(32, 162, 255, 1),
  Color.fromRGBO(98, 206, 255, 1),
  Color.fromRGBO(86, 87, 249, 1),
  Color.fromRGBO(24, 0, 203, 1)
];
List<String> detailOnlineKind = ['3rd-Party', 'Klassisch'];
List<Color> detailOnlineColor = [
  Color.fromRGBO(145, 145, 145, 1),
  Color.fromRGBO(90, 90, 90, 1)
];

class MonthlyChartDetail extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  MonthlyChartDetail(this.seriesList, {this.animate});

  factory MonthlyChartDetail.withData(tv, online) {
    return new MonthlyChartDetail(
      createData(tv, online),
      // Disable animations for image tests.
      animate: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final simpleCurrencyFormatter =
    new charts.BasicNumericTickFormatterSpec.fromNumberFormat(formatter);

    return new charts.BarChart(
      seriesList,
      animate: animate,
      barGroupingType: charts.BarGroupingType.groupedStacked,
      primaryMeasureAxis: new charts.NumericAxisSpec(
          tickFormatterSpec: simpleCurrencyFormatter),
      behaviors: [
        new charts.SeriesLegend(
          // Positions for "start" and "end" will be left and right respectively
          // for widgets with a build context that has directionality ltr.
          // For rtl, "start" and "end" will be right and left respectively.
          // Since this example has directionality of ltr, the legend is
          // positioned on the right side of the chart.
          position: charts.BehaviorPosition.end,
          // By default, if the position of the chart is on the left or right of
          // the chart, [horizontalFirst] is set to false. This means that the
          // legend entries will grow as new rows first instead of a new column.
          horizontalFirst: false,
          // This defines the padding around each legend entry.
          cellPadding: new EdgeInsets.only(right: 4.0, bottom: 4.0),
          // Set show measures to true to display measures in series legend,
          // when the datum is selected.
          showMeasures: true,
          // Optionally provide a measure formatter to format the measure value.
          // If none is specified the value is formatted as a decimal.
          measureFormatter: (num value) {
            return value == null ? '-' : formatter.format(value);
          },
        ),
      ],
    );
  }

  /// Create series list with multiple series
  static List<charts.Series<OrdinalSales, String>> createData(
      List tv, List online) {
    List<charts.Series<OrdinalSales, String>> chartList = [
      ...detailTVKind
          .map((value) {
            final e = tv.firstWhere((tvEntry) => (tvEntry['name'] == value));
            final color = detailTVColor[detailTVKind.indexOf(value)];
            return new charts.Series<OrdinalSales, String>(
                id: e['name'],
                seriesCategory: 'A',
                domainFn: (OrdinalSales sales, _) => sales.month,
                measureFn: (OrdinalSales sales, _) => sales.sales,
                data: [
                  new OrdinalSales('Januar', e['m1']),
                  new OrdinalSales('Februar', e['m2']),
                  new OrdinalSales('März', e['m3']),
                  new OrdinalSales('April', e['m4']),
                  new OrdinalSales('Mai', e['m5']),
                  new OrdinalSales('Juni', e['m6']),
                  new OrdinalSales('Juli', e['m7']),
                  new OrdinalSales('August', e['m8']),
                  new OrdinalSales('September', e['m9']),
                  new OrdinalSales('Oktober', e['m10']),
                  new OrdinalSales('November', e['m11']),
                  new OrdinalSales('Dezember', e['m12']),
                ],
                colorFn: (_, __) =>
                    charts.ColorUtil.fromDartColor(color),
              );})
          .toList(),
      ...detailOnlineKind
          .map((value) {
        final e = online.firstWhere((onlineEntry) => (onlineEntry['name'] == value));
        final color = detailOnlineColor[detailOnlineKind.indexOf(value)];
        return new charts.Series<OrdinalSales, String>(
          id: e['name'],
          seriesCategory: 'B',
          domainFn: (OrdinalSales sales, _) => sales.month,
          measureFn: (OrdinalSales sales, _) => sales.sales,
          data: [
            new OrdinalSales('Januar', e['m1']),
            new OrdinalSales('Februar', e['m2']),
            new OrdinalSales('März', e['m3']),
            new OrdinalSales('April', e['m4']),
            new OrdinalSales('Mai', e['m5']),
            new OrdinalSales('Juni', e['m6']),
            new OrdinalSales('Juli', e['m7']),
            new OrdinalSales('August', e['m8']),
            new OrdinalSales('September', e['m9']),
            new OrdinalSales('Oktober', e['m10']),
            new OrdinalSales('November', e['m11']),
            new OrdinalSales('Dezember', e['m12']),
          ],
          colorFn: (_, __) =>
              charts.ColorUtil.fromDartColor(color),
        );})
          .toList(),
    ];

    return chartList;
  }
}

/// sales data type.
class OrdinalSales {
  final String month;
  final double sales;

  OrdinalSales(this.month, this.sales);
}
