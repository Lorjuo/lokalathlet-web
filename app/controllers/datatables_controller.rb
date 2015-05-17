class DatatablesController < ApplicationController
  def datatable_i18n
    if true #params[:locale] == 'de-De'
      locale = {
          'sEmptyTable' =>     'Keine Einträge verfügbar',
          'sInfo'=>           'Zeige Eintrag _START_ bis _END_ von _TOTAL_',
          'sInfoEmpty'=>      'Zeige Eintrag 0 bis 0 von 0',
          'sInfoFiltered'=>   '(gefiltert von _MAX_ Einträgen)',
          'sInfoPostFix'=>    '',
          'sInfoThousands'=>  '.',
          'sLengthMenu'=>     '_MENU_ Einträge pro Seite',
          'sLoadingRecords'=> 'Laden...',
          'sProcessing'=>     'Bearbeiten...',
          'sSearch'=>         'Suche:',
          'sZeroRecords'=>    'Keine Einträge gefunden',
          'oPaginate'=> {
              'sFirst'=>    'Anfang',
              'sLast'=>     'Ende',
              'sNext'=>     'vor',
              'sPrevious'=> 'zurück'
          },
          'oAria'=> {
              'sSortAscending'=>  ': anklicken um Spalte aufsteigend zu sortieren',
              'sSortDescending'=> ': anklicken um Spalte absteigend zu sortieren'
          }
      }
    else
      locale = {
          'sEmptyTable'=>     'No data available in table',
          'sInfo'=>           'Showing _START_ to _END_ of _TOTAL_ entries',
          'sInfoEmpty'=>      'Showing 0 to 0 of 0 entries',
          'sInfoFiltered'=>   '(filtered from _MAX_ total entries)',
          'sInfoPostFix'=>    '',
          'sInfoThousands'=>  ',',
          'sLengthMenu'=>     '_MENU_ records per page',
          'sLoadingRecords'=> 'Loading...',
          'sProcessing'=>     'Processing...',
          'sSearch'=>         'Search:',
          'sZeroRecords'=>    'No matching records found',
          'oPaginate'=> {
              'sFirst'=>    'First',
              'sLast'=>     'Last',
              'sNext'=>     'Next',
              'sPrevious'=> 'Previous'
          },
          'oAria'=> {
              'sSortAscending'=>  ': activate to sort column ascending',
              'sSortDescending'=> ': activate to sort column descending'
          }
      }
    end
    render :json => locale
  end
 
end