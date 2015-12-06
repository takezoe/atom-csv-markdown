PaPa = require "./deps/papaparse.min.js"

module.exports = 
  convertCsvToMarkdownTable: ->
    editor = atom.workspace.getActivePaneItem()
    editor.replaceSelectedText(null, (text) =>
      csv = PaPa.parse(text)
      
      # Caluculate  column sizes
      width = []
      for line, i in csv.data
        for element, j in line
          if width.length <= j
            width[j] = if element.length < 4 then 4 else element.length
          else if width[j] < element.length
            width[j] = element.length
      
      # Build table
      table = ""
      for line, i in csv.data
        if line.length == 1 && line[0].trim() == ""
          continue
        for element, j in line
          table = table + "|" + element.trim()
          if element.length < width[j]
            for k in [0 ... width[j] - element.trim().length]
              table = table + " "
        table = table + "|\n"
        if i == 0
          for w in width
            table = table + "|"
            for k in [0 ... w]
              table = table + "-"
          table = table + "|\n"
      
      return table;
    )
    range = editor.getSelectedBufferRange()
    editor.setSelectedBufferRange({start: range.start, end: range.start})

  activate: (state) ->
    atom.commands.add 'atom-workspace', 'atom-csv-markdown:convertCsvToMarkdownTable', => @convertCsvToMarkdownTable()
