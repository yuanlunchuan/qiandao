$(document).ready(function(){
  var map = new BMap.Map("mapArea");          // 创建地图实例  
  var point = new BMap.Point(121.45008, 31.208252);  // 创建点坐标  
  map.centerAndZoom(point, 15);                 // 初始化地图，设置中心点坐标和地图级别

  var marker = new BMap.Marker(point);        // 创建标注    
  map.addOverlay(marker);                     // 将标注添加到地图中

  //添加控制控件
  var opts = {anchor:BMAP_ANCHOR_TOP_RIGHT,type:BMAP_NAVIGATION_CONTROL_ZOOM}    
  map.addControl(new BMap.NavigationControl(opts));
})