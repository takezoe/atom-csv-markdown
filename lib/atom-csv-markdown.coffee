module.exports = 
  convertCsvToMarkdownTable: ->
    editor = atom.workspace.getActivePaneItem()
    editor.replaceSelectedText(null, (text) =>
      # Caluculate  column sizes
      width = []
      for line, i in text.split("\n")
        for element, j in line.split(",")
          if width.length <= j
            width[j] = if element.length < 4 then 4 else element.length
          else if width[j] < element.length
            width[j] = element.length
      
      # Build table
      table = ""
      for line, i in text.split("\n")
        console.log('"' + line.trim() + '""')
        if line.trim() == ""
          continue
        for element, j in line.split(",")
          table = table + "|" + element
          if element.length < width[j]
            for k in [0 ... width[j] - element.length]
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

  activate: (state) ->
    atom.commands.add 'atom-workspace', 'atom-csv-markdown:convertCsvToMarkdownTable', => @convertCsvToMarkdownTable()

###
aaoooooa,aaaaaaa
aaaa,aaaaaa
###