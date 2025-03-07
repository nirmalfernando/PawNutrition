class NavigationService {
  int currentTabIndex = 0;

  final List<Function(int)> _listeners = [];

  void setCurrentTab(int index) {
    currentTabIndex = index;
    for (var listener in _listeners) {
      listener(index);
    }
  }

  void addListener(Function(int) listener) {
    _listeners.add(listener);
  }

  void removeListener(Function(int) listener) {
    _listeners.remove(listener);
  }
}
