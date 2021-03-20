class ZCL_FLP_PWA_EXAMPLE definition
  public
  final
  create public .

public section.

  interfaces IF_BADI_INTERFACE .
  interfaces ZIF_EX_FLP_PWA .

  class-methods TEMPLATE_WEB_APP_MANIFEST
    importing
      !NAME type CSEQUENCE
      !NAME_SHORT type CSEQUENCE
      !THEME_COLOR type CSEQUENCE
      !BACKGROUND_COLOR type CSEQUENCE
      !DISPLAY type CSEQUENCE default `standalone`
      !SCOPE type CSEQUENCE default `/`
      !START_URL type CSEQUENCE default `/sap/bc/ui2/flp`
    returning
      value(R_WEBMANIFEST) type STRING .
protected section.
private section.

  constants SW_SCOPE type STRING value `/` ##NO_TEXT.
ENDCLASS.



CLASS ZCL_FLP_PWA_EXAMPLE IMPLEMENTATION.


  method TEMPLATE_WEB_APP_MANIFEST.

  r_webmanifest = |\{ |
    && |"name": "{ name }", |
    && |"short_name": "{ name_short }", |
    && |"icons": [ |
    && |\{ "src": "/sap/public/zflp_pwa_res/img_icon192.png", "sizes": "192x192", "type": "image/png" \}, |
    && |\{ "src": "/sap/public/zflp_pwa_res/img_icon512.png", "sizes": "512x512", "type": "image/png" \} |
    && |], |
    && |"theme_color": "{ theme_color }", |
    && |"background_color": "{ background_color }", |
    && |"display": "{ display }", |
    && |"scope": "{ scope }", |
    && |"start_url": "{ start_url }" |
    && |\}|.

  endmethod.


  method zif_ex_flp_pwa~image_resource.
    " This example uses base64 encoded blank images, but you shouldn't do that on your own implementation.
    data strcont type string.
    case path.
      when `/img_icon192.png`.
        strcont = |iVBORw0KGgoAAAANSUhEUgAAAMAAAADACAQAAAD41aSMAAABFklEQVR42u3RQREAAAzCsOHf9A4VfFIJTU7TYgEAAAIAQAAACAAAAQAgAAAEAIAAABAAAAIAQAAACAAAAQAgAAAEAIA|
               && |AABAAAAIAQAAACAAAAQAgAAAEAIAAABAAAAIAQAAACAAAAQAgAAAEAIAAAAAgAAAEAIAAABAAAAIAQAAACAAAAQAgAAAEAIAAABAAAAIAQAAACAAAAQAgAAAEAIAAABAAAAIAQAAACA|
               && |AAAQAgAAAEAIAAABAAAAIAQAAACAAAAQAAQAAACAAAAQAgAAAEAIAAABAAAAIAQAAACAAAAQAgAAAEAIAAABAAAAIAQAAACAAAAQAgAAAEAIAAABAAAAIAQAAACAAAAQAgAAAEAIAAA|
               && |FB7/4MAwRNRY2IAAAAASUVORK5CYII=|.

      when `/img_icon512.png`.
        strcont = |iVBORw0KGgoAAAANSUhEUgAAAgAAAAIACAQAAABecRxxAAAEmElEQVR42u3UMQEAAAzCsOHf9CQggERCj+aAWZEADAAwAMAAAAMADAAwAMAAAAMADAAwAMAAAAMADAAwAMAAAAMADAA|
               && |wAMAAAAMADAAwAMAAAAMADAAwAMAAAAMADAAwAMAAAAMADAAwAMAAAAMAAwAMADAAwAAAAwAMADAAwAAAAwAMADAAwAAAAwAMADAAwAAAAwAMADAAwAAAAwAMADAAwAAAAwAMADAAwA|
               && |AAAwAMADAAwAAAAwAMADAAwAAAAwADAAwAMADAAAADAAwAMADAAAADAAwAMADAAAADAAwAMADAAAADAAwAMADAAAADAAwAMADAAAADAAwAMADAAAADAAwAMADAAAADAAwAMADAAAADA|
               && |AMADAAwAMAAAAMADAAwAMAAAAMADAAwAMAAAAMADAAwAMAAAAMADAAwAMAAAAMADAAwAMAAAAMADAAwAMAAAAMADAAwAMAAAAMADAAwAMAAAAMAAwAMADAAwAAAAwAMADAAwAAAAwAM|
               && |ADAAwAAAAwAMADAAwAAAAwAMADAAwAAAAwAMADAAwAAAAwAMADAAwAAAAwAMADAAwAAAAwAMADAAwAAAAwADAAwAMADAAAADAAwAMADAAAADAAwAMADAAAADAAwAMADAAAADAAwAMAD|
               && |AAAADAAwAMADAAAADAAwAMADAAAADAAwAMADAAAADAAwAMADAAAADAAMADAAwAMAAAAMADAAwAMAAAAMADAAwAMAAAAMADAAwAMAAAAMADAAwAMAAAAMADAAwAMAAAAMADAAwAMAAAA|
               && |MADAAwAMAAAAMADAAwAMAAwAAkAAMADAAwAMAAAAMADAAwAMAAAAMADAAwAMAAAAMADAAwAMAAAAMADAAwAMAAAAMADAAwAMAAAAMADAAwAMAAAAMADAAwAMAAAAMADAAwAMAAwAAAA|
               && |wAMADAAwAAAAwAMADAAwAAAAwAMADAAwAAAAwAMADAAwAAAAwAMADAAwAAAAwAMADAAwAAAAwAMADAAwAAAAwAMADAAwAAAAwAMADAAwADAAAADAAwAMADAAAADAAwAMADAAAADAAwA|
               && |MADAAAADAAwAMADAAAADAAwAMADAAAADAAwAMADAAAADAAwAMADAAAADAAwAMADAAAADAAwAMADAAMAAAAMADAAwAMAAAAMADAAwAMAAAAMADAAwAMAAAAMADAAwAMAAAAMADAAwAMA|
               && |AAAMADAAwAMAAAAMADAAwAMAAAAMADAAwAMAAAAMADAAwAMAAwAAAAwAMADAAwAAAAwAMADAAwAAAAwAMADAAwAAAAwAMADAAwAAAAwAMADAAwAAAAwAMADAAwAAAAwAMADAAwAAAAw|
               && |AMADAAwAAAAwAMADAAwADAAAADAAwAMADAAAADAAwAMADAAAADAAwAMADAAAADAAwAMADAAAADAAwAMADAAAADAAwAMADAAAADAAwAMADAAAADAAwAMADAAAADAAwAMADAAMAAAAMAD|
               && |AAwAMAAAAMADAAwAMAAAAMADAAwAMAAAAMADAAwAMAAAAMADAAwAMAAAAMADAAwAMAAAAMADAAwAMAAAAMADADoHnvSAgHwhtNTAAAAAElFTkSuQmCC|.
      when others.
        return.
    endcase.
    content = cl_http_utility=>decode_x_base64( strcont ).
    content_type = `image/png`.
  endmethod.


  method ZIF_EX_FLP_PWA~SERVICE_WORKER_JS.
    r_srv_worker = `self.addEventListener('fetch', function(e) {});`.
  endmethod.


  method ZIF_EX_FLP_PWA~SERVICE_WORKER_REGISTRATION_JS.
    r_reg = |if('serviceWorker' in navigator) \{ navigator.serviceWorker.register('/sap/public/zflp_pwa_res/sw.js', \{scope: '{ sw_scope }'\})| &&
                 |.then(function(registration) \{ console.log('Service Worker Registered with scope:',  registration.scope); \}); \}|.
  endmethod.


  method ZIF_EX_FLP_PWA~SERVICE_WORKER_SCOPE.
    r_scope = sw_scope.
  endmethod.


  method zif_ex_flp_pwa~web_app_manifest.
    r_manifest = template_web_app_manifest(
        name             = `Example FLP PWA Implementation`
        name_short       = `Example FLP PWA`
        theme_color      = `#FFDF00`
        background_color = `#002776` ).
  endmethod.
ENDCLASS.
