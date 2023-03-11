enum APIPath {
  getStationStamp,
  getStationStampNotGet,
}

extension APIPathExtension on APIPath {
  String? get value {
    switch (this) {
      case APIPath.getStationStamp:
        return 'getStationStamp';
      case APIPath.getStationStampNotGet:
        return 'getStationStampNotGet';
    }
  }
}
