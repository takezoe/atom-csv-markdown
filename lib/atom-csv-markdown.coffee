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
          value = element.trim()
          if width.length <= j
            width[j] = if value.length < 4 then 4 else value.length
          else if width[j] < value.length
            width[j] = value.length
      
      # Build table
      table = ""
      for line, i in csv.data
        if line.length == 1 && line[0].trim() == ""
          continue
        for element, j in line
          value = element.trim()
          table = table + "|" + value
          if value.length < width[j]
            for k in [0 ... width[j] - value.length]
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
