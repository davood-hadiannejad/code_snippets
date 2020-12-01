import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:charts_flutter/flutter.dart' as charts;

final formatter = new NumberFormat.simpleCurrency(locale: 'eu', decimalDigits: 0);

class DashboardChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  DashboardChart(this.seriesList, {this.animate});

  factory DashboardChart.withData(summaryData) {
    return new DashboardChart(
      createData(summaryData),
      // Disable animations for image tests.
      animate: false,
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
  static List<charts.Series<OrdinalSales, String>> createData(summaryData) {
    final zielData = [
      new OrdinalSales('2020', summaryData.goal['goal']),
    ];

    final kundenforecastDataB = [
      new OrdinalSales('2020', summaryData.forecast['kunde']),
    ];

    final projektforecastDataB = [
      new OrdinalSales('2020', summaryData.forecast['projekt']),
    ];

    final stichtagDataB = [
      new OrdinalSales('2020', summaryData.stichtag['ist']),
    ];

    return [
      new charts.Series<OrdinalSales, String>(
        id: 'Ziel',
        seriesCategory: 'A',
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: zielData,
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(Color(0xff007cba)),
      ),
      new charts.Series<OrdinalSales, String>(
        id: 'Kundenforecast',
        seriesCategory: 'B',
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: kundenforecastDataB,
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(Color.fromRGBO(226, 6, 68, 0.3)),
      ),
      new charts.Series<OrdinalSales, String>(
        id: 'Projektforecast',
        seriesCategory: 'B',
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: projektforecastDataB,
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(Color.fromRGBO(226, 6, 68, 0.6)),
      ),
      new charts.Series<OrdinalSales, String>(
        id: 'Ist Stichtag',
        seriesCategory: 'B',
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: stichtagDataB,
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(Color(0xffe20644)),
      ),
    ];
  }
}

/// Sample ordinal data type.
class OrdinalSales {
  final String year;
  final double sales;

  OrdinalSales(this.year, this.sales);
}