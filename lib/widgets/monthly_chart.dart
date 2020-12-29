import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:charts_flutter/flutter.dart' as charts;

final formatter = new NumberFormat.simpleCurrency(locale: 'eu', decimalDigits: 0);

class MonthlyChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  MonthlyChart(this.seriesList, {this.animate});

  factory MonthlyChart.withData(goalData, istData, kundenData, projektData,
      {showProjekt: true}) {
    return new MonthlyChart(
      createData(goalData, istData, kundenData, projektData, showProjekt),
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
      goalData, istData, kundenData, projektData, bool showProjekt) {
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
      new OrdinalSales('Januar', kundenData['m1']),
      new OrdinalSales('Februar', kundenData['m2']),
      new OrdinalSales('März', kundenData['m3']),
      new OrdinalSales('April', kundenData['m4']),
      new OrdinalSales('Mai', kundenData['m5']),
      new OrdinalSales('Juni', kundenData['m6']),
      new OrdinalSales('Juli', kundenData['m7']),
      new OrdinalSales('August', kundenData['m8']),
      new OrdinalSales('September', kundenData['m9']),
      new OrdinalSales('Oktober', kundenData['m10']),
      new OrdinalSales('November', kundenData['m11']),
      new OrdinalSales('Dezember', kundenData['m12']),
    ];

    final projektforecastDataB = [
      new OrdinalSales('Januar', projektData['m1']),
      new OrdinalSales('Februar', projektData['m2']),
      new OrdinalSales('März', projektData['m3']),
      new OrdinalSales('April', projektData['m4']),
      new OrdinalSales('Mai', projektData['m5']),
      new OrdinalSales('Juni', projektData['m6']),
      new OrdinalSales('Juli', projektData['m7']),
      new OrdinalSales('August', projektData['m8']),
      new OrdinalSales('September', projektData['m9']),
      new OrdinalSales('Oktober', projektData['m10']),
      new OrdinalSales('November', projektData['m11']),
      new OrdinalSales('Dezember', projektData['m12']),
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

    List<charts.Series<OrdinalSales, String>>  chartList = [
      new charts.Series<OrdinalSales, String>(
        id: 'Goal',
        seriesCategory: 'A',
        domainFn: (OrdinalSales sales, _) => sales.month,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: zielData,
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(Color.fromRGBO(226, 6, 68, 1)),
      ),
      new charts.Series<OrdinalSales, String>(
        id: 'Kundenforecast',
        seriesCategory: 'B',
        domainFn: (OrdinalSales sales, _) => sales.month,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: kundenforecastDataB,
        colorFn: (_, __) =>
            charts.ColorUtil.fromDartColor(Color.fromRGBO(32, 162, 250, 1)),
      ),
      new charts.Series<OrdinalSales, String>(
        id: 'IST Stichtag',
        seriesCategory: 'B',
        domainFn: (OrdinalSales sales, _) => sales.month,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: stichtagDataB,
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(Color.fromRGBO(90, 90, 90, 1)),
      ),
    ];

    if (showProjekt) {
      chartList.insert(1, new charts.Series<OrdinalSales, String>(
        id: 'Projektforecast',
        seriesCategory: 'B',
        domainFn: (OrdinalSales sales, _) => sales.month,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: projektforecastDataB,
        colorFn: (_, __) =>
            charts.ColorUtil.fromDartColor(Color.fromRGBO(98, 206, 255, 1)),
      ));
    }

    return chartList;
  }
}

/// sales data type.
class OrdinalSales {
  final String month;
  final double sales;

  OrdinalSales(this.month, this.sales);
}
