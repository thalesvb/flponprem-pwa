class ZCL_FLP_PWA_RESOURCES_HANDLER definition
  public
  final
  create public .

public section.

  interfaces IF_HTTP_EXTENSION .
protected section.
private section.
ENDCLASS.



CLASS ZCL_FLP_PWA_RESOURCES_HANDLER IMPLEMENTATION.


method if_http_extension~handle_request.
  " https://web.dev/install-criteria/
  " https://www.chromium.org/Home/chromium-security/deprecating-powerful-features-on-insecure-origins
  " https://medium.com/@subodhgarg/web-app-manifest-file-make-your-web-app-installable-b5fcdb2919b9
  " 2478325 - No authorization to change/delete virtual host/system service
*  data resource type string.
*  data content_type type string.
*
*  check server->request->get_method( ) eq 'GET'.
*  data(path) = server->request->get_header_field( if_http_header_fields_sap=>path_info ).
*
*  case path.
*    when `/app.js`.
*      resource = `if('serviceWorker' in navigator) { navigator.serviceWorker.register('/sap/public/zflp_pwa_res/sw.js', {scope: '/'})` &&
*                 `.then(function(registration) { console.log('Service Worker Registered with scope:',  registration.scope); }); }`.
*      server->response->set_content_type( `text/javascript` ).
*    when `/manifest.webmanifest`.
*      resource = `{ "name": "Trophaeum Locus Logistics", "short_name": "Trololo", "icons": [{ "src": "./icon192.png", "sizes": "192x192", "type": "image/png" }, { "src": "./icon512.png", "sizes": "512x512", "type": "image/png" }],` &&
*                 `"theme_color": "#ffffff", "background_color": "#000000", "display": "standalone", "scope": "/", "start_url": "/flp_pwa" }`.
*    when `/sw.js`.
*      resource = `self.addEventListener('install', function(e) {});` &&
*                 `self.addEventListener('fetch', function(e) { fetch(e.request).then(function(response) { return response; })});`.
*      server->response->set_content_type( `text/javascript` ).
*      server->response->set_header_field( name = `service-worker-allowed` value = `/` ).
*
*    when `/icon192.png` or `/icon512.png`.
*      data(mime_api) = cl_mime_repository_api=>get_api( ).
*      mime_api->get(
*        exporting
*          i_url = |/SAP/PUBLIC/ZFLP_PWA_MIME{ path }|
*          i_check_authority = abap_false " No-user user, no authorizations assigned.
*        importing
*          e_content = data(icon)
*          e_mime_type = content_type
*        exceptions
*          others = 0 ).
*      server->response->set_data( icon ).
*      server->response->set_content_type( content_type ).
*  endcase.
*  if resource is not initial.
*    server->response->set_cdata( resource ).
*  endif.

  """""""""""""""""""""""""
  " Protocode for blog "
  """""""""""""""""""""""""method if_http_extension~handle_request.
  data content type xstring.
  data content_clike type string.
  data content_type type string.
  data flp_pwa type ref to zflp_pwa.

  check server->request->get_method( ) eq IF_HTTP_REQUEST=>CO_REQUEST_METHOD_GET.
  data(path) = server->request->get_header_field( if_http_header_fields_sap=>path_info ).
  try.
      get badi flp_pwa.
      case path.
        when `/manifest.webmanifest`.
          content_type = `application/manifest+json`.
          call badi flp_pwa->web_app_manifest
            receiving r_manifest = content_clike.
            content = `Jassa`.
        when `/app.js`.
          content_type = `text/javascript`.
          call badi flp_pwa->service_worker_registration_js
            receiving r_reg = content_clike.
        when `/sw.js`.
          content_type = `text/javascript`.
          call badi flp_pwa->service_worker_js
            receiving r_srv_worker = content_clike.
          call badi flp_pwa->service_worker_scope
            receiving r_scope = data(sw_scope).
          server->response->set_header_field( name = `Service-Worker-Allowed` value = sw_scope ).
        when others.
          if path np `/img*`.
            " Someone meddling with service. Mock them!
            server->response->set_cdata( `Ah ah ah! You didn't say the magic word!` ).
            " Wait a Minute, I'm being mocked. Why should I need to
            server->response->set_status( code = 400 reason = if_http_status=>reason_400 ).
            return.
          endif.

          call badi flp_pwa->image_resource
            exporting path = path
            importing content = content
                      content_type = content_type.
      endcase.
      if content_clike is not initial.
        server->response->set_cdata( content_clike ).
      else.
        server->response->set_data( content ).
      endif.
      server->response->set_content_type( content_type ).
    catch cx_badi_not_implemented.
  endtry.

endmethod.
ENDCLASS.
