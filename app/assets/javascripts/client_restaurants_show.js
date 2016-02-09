$(document).ready(function(){
  var map = new BMap.Map("mapArea");          // 创建地图实例  
  var point = new BMap.Point(121.45008, 31.208252);  // 创建点坐标  
  map.centerAndZoom(point, 16);                 // 初始化地图，设置中心点坐标和地图级别  
})