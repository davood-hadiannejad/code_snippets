import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class MonthlyChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  MonthlyChart(this.seriesList, {this.animate});

  factory MonthlyChart.withSampleData() {
    return new MonthlyChart(
      createSampleData(),
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
          showMeasures: false,
          // Optionally provide a measure formatter to format the measure value.
          // If none is specified the value is formatted as a decimal.
          measureFormatter: (num value) {
            return value == null ? '-' : '${value}k';
          },
        ),
      ],
    );
  }

  /// Create series list with multiple series
  static List<charts.Series<OrdinalSales, String>> createSampleData() {
    final zielData = [
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
      new OrdinalSales('Januar', 45),
      new OrdinalSales('Februar', 54),
      new OrdinalSales('März', 55),
      new OrdinalSales('April', 68),
      new OrdinalSales('Mai', 41),
      new OrdinalSales('Juni', 25),
      new OrdinalSales('Juli', 88),
      new OrdinalSales('August', 54),
      new OrdinalSales('September', 31),
      new OrdinalSales('Oktober', 12),
      new OrdinalSales('November', 78),
      new OrdinalSales('Dezember', 88),
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
  final int sales;

  OrdinalSales(this.year, this.sales);
}