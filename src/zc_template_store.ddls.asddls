@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'Projection View for ZR_TEMPLATE_STORE'
@ObjectModel.semanticKey: [ 'Formtemplate' ]
define root view entity ZC_TEMPLATE_STORE
  provider contract transactional_query
  as projection on ZR_TEMPLATE_STORE
{
  key Formtemplate,
  Comments,
  Attachment,
  Mimetype,
  Filename,
  Attach1,
  Attach2,
  LastChangedAt
  
}
