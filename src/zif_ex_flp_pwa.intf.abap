interface ZIF_EX_FLP_PWA
  public .


  interfaces IF_BADI_INTERFACE .

  methods SERVICE_WORKER_REGISTRATION_JS
    returning
      value(R_REG) type STRING .
  methods SERVICE_WORKER_JS
    returning
      value(R_SRV_WORKER) type STRING .
  methods SERVICE_WORKER_SCOPE
    returning
      value(R_SCOPE) type STRING .
  methods WEB_APP_MANIFEST
    returning
      value(R_MANIFEST) type STRING .
  methods IMAGE_RESOURCE
    importing
      !PATH type STRING
    exporting
      !CONTENT type XSTRING
      !CONTENT_TYPE type STRING .
endinterface.
