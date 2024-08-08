// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"

import 'jquery';
import 'datatables.net-bs4';
import 'datatables.net-bs4/css/dataTables.bootstrap4.min.css';

$(document).on('turbolinks:load', () => {
  $('#authors-table').DataTable();
});
