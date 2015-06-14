# Function that reads value from input field and filters datatable by its value
filter_text = (tableContainer, element, colNum) ->
  if ($(tableContainer).length > 0)
    oTable = $(tableContainer).DataTable()
    oTable.fnFilter( $(element)[0].value, colNum )


# Function that reads value from input field and filters datatable by its value
filter_select = (tableContainer, element, colNum) ->
  if ($(tableContainer).length > 0)
    oTable = $(tableContainer).DataTable()

    selectedIds = new Array()
    $(element).children(":selected").each ->
      selectedIds.push(this.value)
    oTable.fnFilter( selectedIds.join(','), colNum )


# Export these functions to global scope
window.filter_text = filter_text
window.filter_select = filter_select

# Define default hash options for datatables
window.datatablesDefaults =
  sPaginationType: "bootstrap"
  # Setup for responsive datatables helper.
  bAutoWidth: false
  bStateSave: false
  sDom: "<r>t<'row'>"
  iDisplayLength: 9999
  bProcessing: true
  bServerSide: false #for ajax
  aoColumnDefs: [
    bSortable: false
    aTargets: ["no-sort"] # Prevent sorting by these rows
  ]
  bDestroy: true
  # For html column filtering: http://datatables.net/plug-ins/filtering#functions
  oLanguage: #https://gist.github.com/ricardodovalle/7244900
    sUrl: "datatable_i18n"

window.datatablesPageable =
  sDom: "<r>t<'row'<'col-md-6'i><'col-md-6'p>>"
  iDisplayLength: 10

window.datatablesSearchable =
  sDom: "<'row'<'col-md-6'l><'col-md-6 filterDiv'f>r>t<'row'<'col-md-6'i><'col-md-6'p>>"
  iDisplayLength: 10


# Callbacks for responsive Layout
# https://github.com/Comanche/datatables-responsive/blob/master/example/js/dom-bootstrap-multiple-table.js
preDrawCallback = ->
  if (!this.responsiveHelper)
    this.responsiveHelper = new ResponsiveDatatablesHelper(this, breakpointDefinition)

rowCallback = (nRow, aData, iDisplayIndex, iDisplayIndexFull) ->
  this.responsiveHelper.createExpandIcon nRow

drawCallback = (oSettings) ->
  this.responsiveHelper.respond()
  init_tooltips() # Notice: Maybe move this to rowcallback


# Set hash for responsive layout
window.datatablesResponsive =
  fnPreDrawCallback: preDrawCallback
  fnRowCallback: rowCallback
  fnDrawCallback: drawCallback


# Create Breakpoint definition depending on bootstrap
# https://github.com/thomas-mcdonald/bootstrap-sass/blob/master/vendor/assets/stylesheets/bootstrap/_variables.scss
window.breakpointDefinition =
  xxs: 480 # Smaller than ...
  xs: 768
  sm: 992
  md: 1200
  lg: 1900


# Attach onload actions
$ ->
  $('.datatable.defaults').dataTable $.extend( {}, datatablesDefaults, datatablesResponsive )
  $('.datatable.pageable').dataTable $.extend( {}, datatablesDefaults, datatablesPageable, datatablesResponsive )
  $('.datatable.searchable').dataTable $.extend( {}, datatablesDefaults, datatablesSearchable, datatablesResponsive )
  