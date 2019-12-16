/*
 * Project: FineWallet
 * Last Modified: Tuesday, 10th September 2019 11:19:47 am
 * Modified By: Lukas (luke.krauch@gmail.com>)
 * -----
 * Copyright 2019 - 2019 Sylu, Sylu
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
