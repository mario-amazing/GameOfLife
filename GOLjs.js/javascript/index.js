function randomBoolean() {
  return Math.random() < 0.5;
}
function generateField() {
  var height = parseInt($('#field-height').val());
  var width = parseInt($('#field-width').val());
  $('#field-grid').html('');
  for (var i = 0; i < height; i++) {
    var row = $('#field-grid').append(`<div class="field-row" data-row=${i}></div>`);
    for (var j = 0; j < width; j++) {
      $(`div.field-row[data-row=${i}]`).append(`<div class="field-col" data-row=${i} data-col=${j} data-state=false></div>`)
    }
  }
  $('.field-col').on('click', function() { $(this).attr('data-state', $(this).attr('data-state') != 'true'); })
}

function randomField() {
  $('.field-col').each(function() { $(this).attr('data-state', randomBoolean()); })
}

function clearField() {
  $('.field-col').each(function() { $(this).attr('data-state', false); })
}

function getField() {
  return $.makeArray($('.field-row').map(function() {
    return [$.makeArray($(this).children().map(function() {
      return $(this).attr('data-state');
    }))];
  }));
}

function nextGen() {
  var field = getField();
  var fieldRowsCount = field.length
  var fieldColsCount = field[0].length
  return $.map(field, function(row_val, row_index) {
    return [$.map(row_val, function(_, col_index) {
      return analizeOfLife(row_index, col_index)
    })]
  })

  function analizeOfLife(i, j){
    var liveNeighbors = 0;
    var neighbors = [
      [i-1, j-1], [i-1, j], [i-1, j+1],
      [i, j-1],             [i, j+1],
      [i+1, j-1], [i+1, j], [i+1, j+1]
    ]
    $.each(neighbors, function(){ liveNeighbors += getLiveNeighbors(this[0], this[1]); })
    return aliveCell(i, j, liveNeighbors);
  }

  function getLiveNeighbors(row_index, col_index) {
    if (row_index < 0) {
      row_index = fieldRowsCount-1
    } else if (row_index >= fieldRowsCount) {
      row_index = 1
    }
    if (col_index < 0) {
      col_index = fieldColsCount-1
    } else if (col_index >= fieldColsCount) {
      col_index = 1
    }

    return field[row_index][col_index] == 'true'
  }

  function aliveCell(row_index, col_index, liveNeighbors) {
    if (field[row_index][col_index] == 'true') {
      return liveNeighbors >= 2 && liveNeighbors <= 3 ? 'true' : 'false'
    } else { return liveNeighbors == 3 ? 'true' : 'false' }
  }
}
function renderNextGen() {
  $.each(nextGen(), function(row_index) {
    $.each(this, function(col_index) {
      $(`div.field-col[data-row=${row_index}][data-col=${col_index}]`).attr('data-state', this)
    })
  })
}
const timer = ms => new Promise(res => setTimeout(res, ms))
async function startGenerations () {
  for (var i = 0; i < 1000; i++) {
    renderNextGen();
    await timer(100);
  }
}

$( document ).ready(function() {
  generateField();
  randomField();
  $('#generate-field').on("click", generateField);
  $('#random-field').on("click", randomField);
  $('#clear-field').on("click", clearField);
  $('#step').on("click", renderNextGen);
  $('#start').on("click", startGenerations);
});
