$(document).ready(function() {
  $('form.delete').submit(function(event) {
      if (!confirm("Are you sure you want to delete this?")) {
        event.preventDefault();
      }
  });
});
