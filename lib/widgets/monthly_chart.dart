import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:charts_flutter/flutter.dart' as charts;

final formatter = new NumberFormat.currency(locale: 'eu', decimalDigits: 0);

class MonthlyChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  MonthlyChart(this.seriesList, {this.animate});

  factory MonthlyChart.withData(goalData, istData, kundenData, projektData) {
    return new MonthlyChart(
      createData(goalData, istData, kundenData, projektData),
      // Disable animations for image tests.
      animate: true,
    );
  }


  @override
  Widget build(BuildContext context) {
    return new charts.BarChart(
      seriesList,
      animate: animate,
      barGroupingType: charts.BarGroupingType.groupedStacked,
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
  static List<charts.Series<OrdinalSales, String>> createData(goalData, istData, kundenData, projektData) {
    final zielData = [
      new OrdinalSales('Januar', goalData['m1']),
      new OrdinalSales('Februar', goalData['m2']),
      new OrdinalSales('März', goalData['m3']),
      new OrdinalSales('April', goalData['m4']),
      new OrdinalSales('Mai', goalData['m5']),
      new OrdinalSales('Juni', goalData['m6']),
      new OrdinalSales('Juli', goalData['m7']),
      new OrdinalSales('August', goalData['m8']),
      new OrdinalSales('September', goalData['m9']),
      new OrdinalSales('Oktober', goalData['m10']),
      new OrdinalSales('November', goalData['m11']),
      new OrdinalSales('Dezember', goalData['m12']),
    ];

    final kundenforecastDataB = [
      new OrdinalSales('Januar', 200),
      new OrdinalSales('Februar', 200),
      new OrdinalSales('März', 200),
      new OrdinalSales('April', 200),
      new OrdinalSales('Mai', 200),
      new OrdinalSales('Juni', 200),
      new OrdinalSales('Juli', 200),
      new OrdinalSales('August', 200),
      new OrdinalSales('September', 200),
      new OrdinalSales('Oktober', 200),
      new OrdinalSales('November', 200),
      new OrdinalSales('Dezember', 200),
    ];

    final projektforecastDataB = [
      new OrdinalSales('Januar', 200),
      new OrdinalSales('Februar', 200),
      new OrdinalSales('März', 200),
      new OrdinalSales('April', 200),
      new OrdinalSales('Mai', 200),
      new OrdinalSales('Juni', 200),
      new OrdinalSales('Juli', 200),
      new OrdinalSales('August', 200),
      new OrdinalSales('September', 200),
      new OrdinalSales('Oktober', 200),
      new OrdinalSales('November', 200),
      new OrdinalSales('Dezember', 200),
    ];

    final stichtagDataB = [
      new OrdinalSales('Januar', istData['m1']),
      new OrdinalSales('Februar', istData['m2']),
      new OrdinalSales('März', istData['m3']),
      new OrdinalSales('April', istData['m4']),
      new OrdinalSales('Mai', istData['m5']),
      new OrdinalSales('Juni', istData['m6']),
      new OrdinalSales('Juli', istData['m7']),
      new OrdinalSales('August', istData['m8']),
      new OrdinalSales('September', istData['m9']),
      new OrdinalSales('Oktober', istData['m10']),
      new OrdinalSales('November', istData['m11']),
      new OrdinalSales('Dezember', istData['m12']),
    ];

    return [
      new charts.Series<OrdinalSales, String>(
        id: 'Ziel',
        seriesCategory: 'A',
        domainFn: (OrdinalSales sales, _) => sales.month,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: zielData,
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(Color(0xff007cba)),
      ),
      new charts.Series<OrdinalSales, String>(
        id: 'Kundenforecast',
        seriesCategory: 'B',
        domainFn: (OrdinalSales sales, _) => sales.month,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: kundenforecastDataB,
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(Color.fromRGBO(226, 6, 68, 0.3)),
      ),
      new charts.Series<OrdinalSales, String>(
        id: 'Projektforecast',
        seriesCategory: 'B',
        domainFn: (OrdinalSales sales, _) => sales.month,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: projektforecastDataB,
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(Color.fromRGBO(226, 6, 68, 0.6)),
      ),
      new charts.Series<OrdinalSales, String>(
        id: 'Ist Stichtag',
        seriesCategory: 'B',
        domainFn: (OrdinalSales sales, _) => sales.month,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: stichtagDataB,
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(Color(0xffe20644)),
      ),
    ];
  }
}

/// sales data type.
class OrdinalSales {
  final String month;
  final double sales;

  OrdinalSales(this.month, this.sales);
}