enum Routers {
  dashboard('/', '/'),
  // Home related pages
  milkLog('/milkLog', 'milkLog'),
  addMilk('addMilk', 'addMilk'),
  updateMilk('update/:id', 'updateMilk'),
  volumeChart('/volumeChart', 'volumeChart'),
  feedingCount('/feedingCount', 'feedingCount'),
  feedingHistory('/feedingHistory', 'feedingHistory');

  final String routerPath;  // Path to navigate to
  final String routerName;  // Human - readable name used internally for identification

  const Routers(this.routerPath, this.routerName);
}