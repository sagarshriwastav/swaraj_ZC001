@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: '##GENERATED ZTEMPLATE_STORE'
define root view entity ZR_TEMPLATE_STORE
  as select from ztemplate_store as ZDM_TEMPLATE_STORE
{
  key formtemplate as Formtemplate,
  comments as Comments,
   @Semantics.largeObject:{
        mimeType: 'Mimetype',
        fileName: 'Filename',        
        contentDispositionPreference: #ATTACHMENT
      }
  attachment as Attachment,
  mimetype as Mimetype,
  @Semantics.mimeType: true
  filename as Filename,
  attach1 as Attach1,
  attach2 as Attach2,
  @Semantics.user.createdBy: true
  created_by as CreatedBy,
  @Semantics.systemDateTime.createdAt: true
  created_at as CreatedAt,
  @Semantics.user.localInstanceLastChangedBy: true
  last_changed_by as LastChangedBy,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  last_changed_at as LastChangedAt,
  @Semantics.systemDateTime.lastChangedAt: true
  local_last_changed_at as LocalLastChangedAt
  
}
