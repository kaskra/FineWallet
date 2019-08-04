/*
 * Developed by Lukas Krauch 10.6.2019.
 * Copyright (c) 2019. All rights reserved.
 *
 */

enum ChartType { LINE, BAR }

ChartType fromIntToChartType(int value) {
  switch (value) {
    case 1:
      return ChartType.LINE;
      break;
    case 2:
      return ChartType.BAR;
      break;
  }
  return ChartType.LINE;
}

int fromChartTypeToInt(ChartType type) {
  switch (type) {
    case ChartType.LINE:
      return 1;
      break;
    case ChartType.BAR:
      return 2;
      break;
  }
  return 1;
}
