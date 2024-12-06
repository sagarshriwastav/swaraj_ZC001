CLASS ycl_test_adobe DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
    CLASS-DATA : access_token TYPE string .
    CLASS-DATA : xml_file TYPE string .
    TYPES :
      BEGIN OF struct,
        xdp_template TYPE string,
        xml_data     TYPE string,
        form_type    TYPE string,
        form_locale  TYPE string,
        tagged_pdf   TYPE string,
        embed_font   TYPE string,
      END OF struct.
    CLASS-DATA: lc_ads_render    TYPE string VALUE '/ads.restapi/v1/adsRender/pdf',
                lv1_url          TYPE string .

    CLASS-METHODS create_client
      IMPORTING url           TYPE string
      RETURNING VALUE(result) TYPE REF TO if_web_http_client
      RAISING   cx_static_check.

    CLASS-METHODS generate_token
      RETURNING VALUE(result) TYPE string.

    CLASS-METHODS getpdf
      IMPORTING VALUE(template) TYPE string
                VALUE(xmldata)  TYPE string
      RETURNING VALUE(result)   TYPE string.

    CLASS-METHODS getxdp
      IMPORTING VALUE(form)     TYPE string OPTIONAL
                VALUE(template) TYPE string OPTIONAL
      RETURNING VALUE(result)   TYPE string.

    CLASS-METHODS Get_Pdf_From_Saved_template
      IMPORTING VALUE(xmldata_1)  TYPE string OPTIONAL
                VALUE(template_1) TYPE string OPTIONAL
      RETURNING VALUE(result)     TYPE string.

    CLASS-METHODS Format_xml
      IMPORTING VALUE(xmldata)    TYPE string OPTIONAL
      RETURNING VALUE(result_xml) TYPE string .
     CLASS-METHODS BTP_DATA
       EXPORTING  VALUE(CLIENT_SECRET)  TYPE STRING
                  VALUE(CLIENT_ID)  TYPE STRING
                  VALUE(AUTH_URL)   TYPE STRING
                  value(uri)        type string
         RETURNING VALUE(result_xml) TYPE string  .

ENDCLASS.



CLASS YCL_TEST_ADOBE IMPLEMENTATION.


  METHOD BTP_DATA.
    FIELD-SYMBOLS <data>                TYPE data.
    FIELD-SYMBOLS <field>               TYPE any.
    FIELD-SYMBOLS <field_clientid>      TYPE any.
    FIELD-SYMBOLS <field_clientsecret>  TYPE any.
    FIELD-SYMBOLS <field_uri>  TYPE any.
    FIELD-SYMBOLS <field_url>  TYPE any.
    FIELD-SYMBOLS <pdf_based64_encoded> TYPE any.
    SELECT SINGLE * FROM ztemplate_store
      WHERE formtemplate = 'BTP'
      INTO @DATA(tab11).
 DATA(response_final) = xco_cp=>xstring( TAB11-attachment
      )->as_string( xco_cp_character=>code_page->utf_8
      )->value .
  REPLACE ALL OCCURRENCES OF '\n' IN   response_final WITH ''  .
  DATA(lr_d1) = /ui2/cl_json=>generate( json = response_final ).
    IF lr_d1 IS  BOUND.
    ASSIGN lr_d1->* TO <data>.
    ASSIGN COMPONENT `uri` OF STRUCTURE <data> TO <field_uri>.
    ASSIGN <field_uri>->* TO <field_uri>.
    uri  = <field_uri> .
    UNASSIGN <field_uri>.
    ASSIGN COMPONENT `uaa` OF STRUCTURE <data> TO <field>.
    IF sy-subrc = 0.
      ASSIGN <field>->* TO <pdf_based64_encoded>.
      IF <pdf_based64_encoded> IS ASSIGNED.
        ASSIGN COMPONENT `clientid` OF STRUCTURE <pdf_based64_encoded> TO <field_clientid>.
        ASSIGN COMPONENT `clientsecret` OF STRUCTURE <pdf_based64_encoded> TO <field_clientsecret>.
        ASSIGN COMPONENT `url` OF STRUCTURE <pdf_based64_encoded> TO <field_url>.
        ASSIGN <field_clientid>->* TO <field_clientid>.
        ASSIGN <field_clientsecret>->* TO <field_clientsecret>.
        ASSIGN <field_url>->* TO <field_url>.
        client_secret = <field_clientsecret>.
        CONDENSE client_secret.
        client_id = <field_clientid>.
        CONDENSE client_id.
        auth_url = <field_url>.
        CONDENSE auth_url.
      ENDIF.
    ELSE.
    ENDIF.
     ENDIF.

  ENDMETHOD.


  METHOD create_client.
    DATA(dest) = cl_http_destination_provider=>create_by_url( url ).
    result = cl_web_http_client_manager=>create_by_http_destination( dest ).
  ENDMETHOD.


  METHOD FORMAT_XML.
    REPLACE ALL OCCURRENCES OF '\t' IN xmldata WITH '&#9;'.
    REPLACE ALL OCCURRENCES OF '\n' IN xmldata WITH '&#10;'.
    REPLACE ALL OCCURRENCES OF '\r' IN xmldata WITH '&#13;'.
    REPLACE ALL OCCURRENCES OF '!' IN xmldata WITH '&#33;'.
*    REPLACE ALL OCCURRENCES OF '"' IN xmldata WITH '&#34;'.
*    REPLACE ALL OCCURRENCES OF '#' IN xmldata WITH '&#35;'.
    REPLACE ALL OCCURRENCES OF '$' IN xmldata WITH '&#36;'.
*        REPLACE ALL OCCURRENCES OF '%' IN xmldata WITH '&#37;'.
    REPLACE ALL OCCURRENCES OF '&' IN xmldata WITH '&#38;'.
*    REPLACE ALL OCCURRENCES OF |'| IN xmldata WITH '&#39;'.
    REPLACE ALL OCCURRENCES OF '(' IN xmldata WITH '&#40;'.
    REPLACE ALL OCCURRENCES OF ')' IN xmldata WITH '&#41;'.
    REPLACE ALL OCCURRENCES OF '*' IN xmldata WITH '&#42;'.
    REPLACE ALL OCCURRENCES OF '+' IN xmldata WITH '&#43;'.
*    REPLACE ALL OCCURRENCES OF ',' IN xmldata WITH '&#44;'.
*    REPLACE ALL OCCURRENCES OF '-' IN xmldata WITH '&#45;'.
*    REPLACE ALL OCCURRENCES OF '.' IN xmldata WITH '&#46;'.
*    REPLACE ALL OCCURRENCES OF '/' IN xmldata WITH '&#47;'.
    REPLACE ALL OCCURRENCES OF ':' IN xmldata WITH '&#58;'.
*    REPLACE ALL OCCURRENCES OF ';' IN xmldata WITH '&#59;'.
*    REPLACE ALL OCCURRENCES OF '<' IN xmldata WITH '&#60;'.
    REPLACE ALL OCCURRENCES OF '=' IN xmldata WITH '&#61;'.
*    REPLACE ALL OCCURRENCES OF '>' IN xmldata WITH '&#62;'.
    REPLACE ALL OCCURRENCES OF '?' IN xmldata WITH '&#63;'.
    REPLACE ALL OCCURRENCES OF '@' IN xmldata WITH '&#64;'.
    REPLACE ALL OCCURRENCES OF '[' IN xmldata WITH '&#91;'.
*    REPLACE ALL OCCURRENCES OF '\' IN xmldata WITH '&#92;'.
    REPLACE ALL OCCURRENCES OF ']' IN xmldata WITH '&#93;'.
    REPLACE ALL OCCURRENCES OF '^' IN xmldata WITH '&#94;'.
*    REPLACE ALL OCCURRENCES OF '_' IN xmldata WITH '&#95;'.
    REPLACE ALL OCCURRENCES OF '`' IN xmldata WITH '&#96;'.
    REPLACE ALL OCCURRENCES OF '{' IN xmldata WITH '&#123;'.
    REPLACE ALL OCCURRENCES OF '|' IN xmldata WITH '&#124;'.
    REPLACE ALL OCCURRENCES OF '}' IN xmldata WITH '&#125;'.
    REPLACE ALL OCCURRENCES OF '~' IN xmldata WITH '&#126;'.
    REPLACE ALL OCCURRENCES OF '€' IN xmldata WITH '&#128;'.
    REPLACE ALL OCCURRENCES OF '‚' IN xmldata WITH '&#130;'.
    REPLACE ALL OCCURRENCES OF 'ƒ' IN xmldata WITH '&#131;'.
    REPLACE ALL OCCURRENCES OF '„' IN xmldata WITH '&#132;'.
    REPLACE ALL OCCURRENCES OF '…' IN xmldata WITH '&#133;'.
    REPLACE ALL OCCURRENCES OF '†' IN xmldata WITH '&#134;'.
    REPLACE ALL OCCURRENCES OF '‡' IN xmldata WITH '&#135;'.
    REPLACE ALL OCCURRENCES OF 'ˆ' IN xmldata WITH '&#136;'.
    REPLACE ALL OCCURRENCES OF '‰' IN xmldata WITH '&#137;'.
    REPLACE ALL OCCURRENCES OF 'Š' IN xmldata WITH '&#138;'.
    REPLACE ALL OCCURRENCES OF '‹' IN xmldata WITH '&#139;'.
    REPLACE ALL OCCURRENCES OF 'Œ' IN xmldata WITH '&#140;'.
    REPLACE ALL OCCURRENCES OF 'Ž' IN xmldata WITH '&#142;'.
    REPLACE ALL OCCURRENCES OF '‘' IN xmldata WITH '&#145;'.
    REPLACE ALL OCCURRENCES OF '’' IN xmldata WITH '&#146;'.
    REPLACE ALL OCCURRENCES OF '“' IN xmldata WITH '&#147;'.
    REPLACE ALL OCCURRENCES OF '”' IN xmldata WITH '&#148;'.
    REPLACE ALL OCCURRENCES OF '•' IN xmldata WITH '&#149;'.
    REPLACE ALL OCCURRENCES OF '–' IN xmldata WITH '&#150;'.
    REPLACE ALL OCCURRENCES OF '—' IN xmldata WITH '&#151;'.
    REPLACE ALL OCCURRENCES OF '˜' IN xmldata WITH '&#152;'.
    REPLACE ALL OCCURRENCES OF '™' IN xmldata WITH '&#153;'.
    REPLACE ALL OCCURRENCES OF 'š' IN xmldata WITH '&#154;'.
    REPLACE ALL OCCURRENCES OF '›' IN xmldata WITH '&#155;'.
    REPLACE ALL OCCURRENCES OF 'œ' IN xmldata WITH '&#156;'.
    REPLACE ALL OCCURRENCES OF 'ž' IN xmldata WITH '&#158;'.
    REPLACE ALL OCCURRENCES OF 'Ÿ' IN xmldata WITH '&#159;'.
    REPLACE ALL OCCURRENCES OF '¡' IN xmldata WITH '&#161;'.
    REPLACE ALL OCCURRENCES OF '¢' IN xmldata WITH '&#162;'.
    REPLACE ALL OCCURRENCES OF '£' IN xmldata WITH '&#163;'.
    REPLACE ALL OCCURRENCES OF '¤' IN xmldata WITH '&#164;'.
    REPLACE ALL OCCURRENCES OF '¥' IN xmldata WITH '&#165;'.
    REPLACE ALL OCCURRENCES OF '¦' IN xmldata WITH '&#166;'.
    REPLACE ALL OCCURRENCES OF '§' IN xmldata WITH '&#167;'.
    REPLACE ALL OCCURRENCES OF '¨' IN xmldata WITH '&#168;'.
    REPLACE ALL OCCURRENCES OF '©' IN xmldata WITH '&#169;'.
    REPLACE ALL OCCURRENCES OF 'ª' IN xmldata WITH '&#170;'.
    REPLACE ALL OCCURRENCES OF '«' IN xmldata WITH '&#171;'.
    REPLACE ALL OCCURRENCES OF '¬' IN xmldata WITH '&#172;'.
    REPLACE ALL OCCURRENCES OF '®' IN xmldata WITH '&#174;'.
    REPLACE ALL OCCURRENCES OF '¯' IN xmldata WITH '&#175;'.
    REPLACE ALL OCCURRENCES OF '°' IN xmldata WITH '&#176;'.
    REPLACE ALL OCCURRENCES OF '±' IN xmldata WITH '&#177;'.
    REPLACE ALL OCCURRENCES OF '²' IN xmldata WITH '&#178;'.
    REPLACE ALL OCCURRENCES OF '³' IN xmldata WITH '&#179;'.
    REPLACE ALL OCCURRENCES OF '´' IN xmldata WITH '&#180;'.
    REPLACE ALL OCCURRENCES OF 'µ' IN xmldata WITH '&#181;'.
    REPLACE ALL OCCURRENCES OF '¶' IN xmldata WITH '&#182;'.
    REPLACE ALL OCCURRENCES OF '·' IN xmldata WITH '&#183;'.
    REPLACE ALL OCCURRENCES OF '¸' IN xmldata WITH '&#184;'.
    REPLACE ALL OCCURRENCES OF '¹' IN xmldata WITH '&#185;'.
    REPLACE ALL OCCURRENCES OF 'º' IN xmldata WITH '&#186;'.
    REPLACE ALL OCCURRENCES OF '»' IN xmldata WITH '&#187;'.
    REPLACE ALL OCCURRENCES OF '¼' IN xmldata WITH '&#188;'.
    REPLACE ALL OCCURRENCES OF '½' IN xmldata WITH '&#189;'.
    REPLACE ALL OCCURRENCES OF '¾' IN xmldata WITH '&#190;'.
    REPLACE ALL OCCURRENCES OF '¿' IN xmldata WITH '&#191;'.
    REPLACE ALL OCCURRENCES OF 'À' IN xmldata WITH '&#192;'.
    REPLACE ALL OCCURRENCES OF 'Á' IN xmldata WITH '&#193;'.
    REPLACE ALL OCCURRENCES OF 'Â' IN xmldata WITH '&#194;'.
    REPLACE ALL OCCURRENCES OF 'Ã' IN xmldata WITH '&#195;'.
    REPLACE ALL OCCURRENCES OF 'Ä' IN xmldata WITH '&#196;'.
    REPLACE ALL OCCURRENCES OF 'Å' IN xmldata WITH '&#197;'.
    REPLACE ALL OCCURRENCES OF 'Æ' IN xmldata WITH '&#198;'.
    REPLACE ALL OCCURRENCES OF 'Ç' IN xmldata WITH '&#199;'.
    REPLACE ALL OCCURRENCES OF 'È' IN xmldata WITH '&#200;'.
    REPLACE ALL OCCURRENCES OF 'É' IN xmldata WITH '&#201;'.
    REPLACE ALL OCCURRENCES OF 'Ê' IN xmldata WITH '&#202;'.
    REPLACE ALL OCCURRENCES OF 'Ë' IN xmldata WITH '&#203;'.
    REPLACE ALL OCCURRENCES OF 'Ì' IN xmldata WITH '&#204;'.
    REPLACE ALL OCCURRENCES OF 'Í' IN xmldata WITH '&#205;'.
    REPLACE ALL OCCURRENCES OF 'Î' IN xmldata WITH '&#206;'.
    REPLACE ALL OCCURRENCES OF 'Ï' IN xmldata WITH '&#207;'.
    REPLACE ALL OCCURRENCES OF 'Ð' IN xmldata WITH '&#208;'.
    REPLACE ALL OCCURRENCES OF 'Ñ' IN xmldata WITH '&#209;'.
    REPLACE ALL OCCURRENCES OF 'Ò' IN xmldata WITH '&#210;'.
    REPLACE ALL OCCURRENCES OF 'Ó' IN xmldata WITH '&#211;'.
    REPLACE ALL OCCURRENCES OF 'Ô' IN xmldata WITH '&#212;'.
    REPLACE ALL OCCURRENCES OF 'Õ' IN xmldata WITH '&#213;'.
    REPLACE ALL OCCURRENCES OF 'Ö' IN xmldata WITH '&#214;'.
    REPLACE ALL OCCURRENCES OF '×' IN xmldata WITH '&#215;'.
    REPLACE ALL OCCURRENCES OF 'Ø' IN xmldata WITH '&#216;'.
    REPLACE ALL OCCURRENCES OF 'Ù' IN xmldata WITH '&#217;'.
    REPLACE ALL OCCURRENCES OF 'Ú' IN xmldata WITH '&#218;'.
    REPLACE ALL OCCURRENCES OF 'Û' IN xmldata WITH '&#219;'.
    REPLACE ALL OCCURRENCES OF 'Ü' IN xmldata WITH '&#220;'.
    REPLACE ALL OCCURRENCES OF 'Ý' IN xmldata WITH '&#221;'.
    REPLACE ALL OCCURRENCES OF 'Þ' IN xmldata WITH '&#222;'.
    REPLACE ALL OCCURRENCES OF 'ß' IN xmldata WITH '&#223;'.
    REPLACE ALL OCCURRENCES OF 'à' IN xmldata WITH '&#224;'.
    REPLACE ALL OCCURRENCES OF 'á' IN xmldata WITH '&#225;'.
    REPLACE ALL OCCURRENCES OF 'â' IN xmldata WITH '&#226;'.
    REPLACE ALL OCCURRENCES OF 'ã' IN xmldata WITH '&#227;'.
    REPLACE ALL OCCURRENCES OF 'ä' IN xmldata WITH '&#228;'.
    REPLACE ALL OCCURRENCES OF 'å' IN xmldata WITH '&#229;'.
    REPLACE ALL OCCURRENCES OF 'æ' IN xmldata WITH '&#230;'.
    REPLACE ALL OCCURRENCES OF 'ç' IN xmldata WITH '&#231;'.
    REPLACE ALL OCCURRENCES OF 'è' IN xmldata WITH '&#232;'.
    REPLACE ALL OCCURRENCES OF 'é' IN xmldata WITH '&#233;'.
    REPLACE ALL OCCURRENCES OF 'ê' IN xmldata WITH '&#234;'.
    REPLACE ALL OCCURRENCES OF 'ë' IN xmldata WITH '&#235;'.
    REPLACE ALL OCCURRENCES OF 'ì' IN xmldata WITH '&#236;'.
    REPLACE ALL OCCURRENCES OF 'í' IN xmldata WITH '&#237;'.
    REPLACE ALL OCCURRENCES OF 'î' IN xmldata WITH '&#238;'.
    REPLACE ALL OCCURRENCES OF 'ï' IN xmldata WITH '&#239;'.
    REPLACE ALL OCCURRENCES OF 'ð' IN xmldata WITH '&#240;'.
    REPLACE ALL OCCURRENCES OF 'ñ' IN xmldata WITH '&#241;'.
    REPLACE ALL OCCURRENCES OF 'ò' IN xmldata WITH '&#242;'.
    REPLACE ALL OCCURRENCES OF 'ó' IN xmldata WITH '&#243;'.
    REPLACE ALL OCCURRENCES OF 'ô' IN xmldata WITH '&#244;'.
    REPLACE ALL OCCURRENCES OF 'õ' IN xmldata WITH '&#245;'.
    REPLACE ALL OCCURRENCES OF 'ö' IN xmldata WITH '&#246;'.
    REPLACE ALL OCCURRENCES OF '÷' IN xmldata WITH '&#247;'.
    REPLACE ALL OCCURRENCES OF 'ø' IN xmldata WITH '&#248;'.
    REPLACE ALL OCCURRENCES OF 'ù' IN xmldata WITH '&#249;'.
    REPLACE ALL OCCURRENCES OF 'ú' IN xmldata WITH '&#250;'.
    REPLACE ALL OCCURRENCES OF 'û' IN xmldata WITH '&#251;'.
    REPLACE ALL OCCURRENCES OF 'ü' IN xmldata WITH '&#252;'.
    REPLACE ALL OCCURRENCES OF '✓' IN xmldata WITH 'a'.
    REPLACE ALL OCCURRENCES OF 'ý' IN xmldata WITH '&#253;'.
*    REPLACE ALL OCCURRENCES OF '&#40;' IN xmldata WITH ''.
*    REPLACE ALL OCCURRENCES OF '&#41;' IN xmldata WITH ''.
*    REPLACE ALL OCCURRENCES OF '&#58;' IN xmldata WITH ''.
*    REPLACE ALL OCCURRENCES OF '&#91;' IN xmldata WITH ''.
*    REPLACE ALL OCCURRENCES OF '&#93;' IN xmldata WITH ''.

   result_xml = xmldata .
  ENDMETHOD.


  METHOD GENERATE_TOKEN.

    DATA url             TYPE string.
      DATA client_id       TYPE string.
      DATA client_password TYPE string.
      btp_data( IMPORTING client_secret = client_password
                          client_id     = client_id
                          auth_url      = url  ).

    TRY.
        DATA(client) = create_client( |{ url }/oauth/token| ).
      CATCH cx_static_check.
        "handle exception
    ENDTRY.
    DATA(req) = client->get_http_request(  ).

    req->set_authorization_basic(
    i_username = client_id
    i_password = client_password )  .
    req->set_content_type( 'application/x-www-form-urlencoded'  ).
    req->set_form_field( EXPORTING i_name  = 'grant_type'
                                   i_value = 'client_credentials' ) .
    TRY.
        DATA(response) = client->execute( if_web_http_client=>post )->get_text(  ).
      CATCH cx_web_http_client_error cx_web_message_error.
        "handle exception
    ENDTRY.
    REPLACE ALL OCCURRENCES OF '{"access_token":"' IN response WITH ''.
    SPLIT response AT '","token_type' INTO DATA(v1) DATA(v2) .
    result = v1 .
    TRY.
        client->close(  ).
        CATCH cx_web_http_client_error.
        "handle exception
    ENDTRY.

  ENDMETHOD.


  METHOD getpdf.

     btp_data( IMPORTING  uri      = lv1_url  ).



    xmldata = Format_xml( xmldata = xmldata ).
    result  = get_pdf_from_saved_template( template_1 = template
                                           xmldata_1  = xmldata ).
IF RESULT IS INITIAL .

      access_token = generate_token( ).
      DATA url TYPE string.
      DATA(gv) = |{ lv1_url }/adsRender/pdf?templateSource=storageName&TraceLevel=2|.
      DATA(ls_data_xml) = cl_web_http_utility=>encode_base64( xmldata ).
      url = |{ gv }|.
    TRY.
        DATA(client) = create_client( URL ).
      CATCH cx_static_check.
        "handle exception
    ENDTRY.
    DATA(req) = client->get_http_request(  ).
    req->set_authorization_bearer( access_token ) .

    DATA(ls_body) = VALUE struct( xdp_template = template
                                     xml_data = ls_data_xml
                                      form_type = 'print'
*                                     form_type = 'interactive'
                                     form_locale = 'en_US'
                                     tagged_pdf = '0'
                                     embed_font = '0' ).
    DATA(lv_json) = /ui2/cl_json=>serialize( data = ls_body compress = abap_true pretty_name = /ui2/cl_json=>pretty_mode-camel_case ).
    req->append_text(
              EXPORTING
                data   = lv_json
            ).
    req->set_content_type( 'application/json' ).
    DATA: url_response TYPE string.
    TRY.
        url_response = client->execute( if_web_http_client=>post )->get_text( ).
      CATCH cx_web_http_client_error cx_web_message_error.
        "handle exception
    ENDTRY.
    result = url_response .
    FIELD-SYMBOLS:
      <data>                TYPE data,
      <field>               TYPE any,
      <pdf_based64_encoded> TYPE any.
    DATA : lr_d TYPE string .
    DATA(lr_d1) = /ui2/cl_json=>generate( json = url_response ).
    IF lr_d1 IS BOUND.
      ASSIGN lr_d1->* TO <data>.
      ASSIGN COMPONENT `fileContent` OF STRUCTURE <data> TO <field>.
      IF sy-subrc EQ 0.
        ASSIGN <field>->* TO <pdf_based64_encoded>.
        result = <pdf_based64_encoded> .
**            out->write( <pdf_based64_encoded> ).
      else.
        result = 'ERROR'.
      ENDIF.
    ENDIF.
    ENDIF .
  ENDMETHOD.


  METHOD GETXDP.
    DATA(url) = |{ lv1_url }/v1/forms/{ FORM }/templates/{ template }|.
    TRY.
        DATA(client) = create_client( url ).
      CATCH cx_static_check.
        " handle exception
    ENDTRY.
    DATA(req) = client->get_http_request( ).
    req->set_authorization_bearer( generate_token( ) ).
    TRY.
        DATA(url_response) = client->execute( if_web_http_client=>get )->get_text( ).
      CATCH cx_web_http_client_error cx_web_message_error.
        " handle exception
    ENDTRY.


    DATA result11 TYPE string.
    FIELD-SYMBOLS <data>                TYPE data.
    FIELD-SYMBOLS <field>               TYPE any.
    FIELD-SYMBOLS <pdf_based64_encoded> TYPE any.
    DATA(lr_d1) = /ui2/cl_json=>generate( json = url_response ).
    IF lr_d1 IS BOUND.
      ASSIGN lr_d1->* TO <data>.
      ASSIGN COMPONENT `xdpTemplate` OF STRUCTURE <data> TO <field>.
      IF sy-subrc = 0.
        ASSIGN <field>->* TO <pdf_based64_encoded>.
        result = <pdf_based64_encoded>.
      ELSE.
        result = 'ERROR'.
      ENDIF.
    ENDIF.



  ENDMETHOD.


  METHOD GET_PDF_FROM_SAVED_TEMPLATE.
 select single * from ztemplate_store
         where formtemplate = @template_1
         into @data(tab1) .

  IF SY-SUBRC <> 0  .
      DATA ev_pdf          TYPE xstring.
      DATA ev_pages        TYPE int4.
      DATA ev_trace_string TYPE string.
      DATA iv_xml_data     TYPE xstring.
      DATA iv_xdp_layout   TYPE xstring.
      DATA iv_locale       TYPE string.
      DATA is_options      TYPE cl_fp_ads_util=>ty_gs_options_pdf.
      DATA lv_data         TYPE TABLE OF ztemplate_store.
      SPLIT template_1 AT '/' INTO DATA(form) DATA(template1).
      DATA(xdp) =    getxdp( form     = form
                             template = template1 ).

    iv_xdp_layout = xco_cp=>string( xdp )->as_xstring( xco_cp_binary=>text_encoding->base64 )->value.

    lv_data = VALUE #(  (  formtemplate = template_1
                         comments     = 'Uploaded By YCL_TEST_ADOBE'
                         attachment   =  iv_xdp_layout
                         attach1      =  cl_abap_context_info=>get_system_date(  )
                         attach2      =  ' '
                         mimetype     = 'application/vnd.adobe.xdp+xml'
                         filename     =  |{ template1 }.xdp| ) ) .
     MODIFY ztemplate_store FROM TABLE @lv_data .
     COMMIT work and wait .


     TAB1-attachment  = iv_xdp_layout .
ENDIF .

try .
    cl_fp_ads_util=>render_pdf( EXPORTING is_options      = is_options          "| PDF rendering parameters (optional)
                                          iv_xdp_layout   = tab1-attachment     "| Adobe XDP form template
                                          iv_xml_data     = xco_cp=>string( cl_web_http_utility=>encode_base64( xmldata_1 ) )->as_xstring( xco_cp_binary=>text_encoding->base64 )->value         "| XML data
                                          iv_locale       = 'en_US'             "| Locale for the rending: language_COUNTRY, e.g. en_US
                                IMPORTING ev_pages        = ev_pages            "| Number of pages
                                          ev_pdf          = ev_pdf              "| PDF rendering result
                                          ev_trace_string = ev_trace_string ) . "| Trace string  )
  CATCH cx_fp_ads_util INTO data(lx_fp_ads_util).


  endtry .

result = xco_cp=>xstring( ev_pdf
      )->as_string( xco_cp_binary=>text_encoding->base64
      )->value .



  ENDMETHOD.


  METHOD if_oo_adt_classrun~main.


    DATA(result) = BTP_DATA(  )  .
  ENDMETHOD.
ENDCLASS.
