describe "SS grammar", ->
  grammar = null

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage("language-pip")

    runs ->
      grammar = atom.grammars.grammarForScopeName("text.pip")

  it "parses the grammar", ->
    expect(grammar).toBeTruthy()
    expect(grammar.scopeName).toBe "text.pip"

  it "tokenizes comments", ->
    {tokens} = grammar.tokenizeLine '# foo'
    expect(tokens[0]).toEqual value: '#', scopes: ['text.pip', 'comment.line.number-sign.pip', 'punctuation.definition.comment.pip']
    expect(tokens[1]).toEqual value: ' foo', scopes: ['text.pip', 'comment.line.number-sign.pip']

  it "tokenizes section headings", ->
    {tokens} = grammar.tokenizeLine '[list]'
    expect(tokens[0]).toEqual value: '[', scopes: ['text.pip', 'entity.name.section.group-title.pip', 'punctuation.definition.entity.pip']
    expect(tokens[1]).toEqual value: 'list', scopes: ['text.pip', 'entity.name.section.group-title.pip']
    expect(tokens[2]).toEqual value: ']', scopes: ['text.pip', 'entity.name.section.group-title.pip', 'punctuation.definition.entity.pip']

  it "tokenizes setting names with colon", ->
    {tokens} = grammar.tokenizeLine 'timeout:'
    expect(tokens[0]).toEqual value: 'timeout', scopes: ['text.pip', 'keyword.other.definition.pip']
    expect(tokens[1]).toEqual value: ':', scopes: ['text.pip', 'punctuation.separator.key-value.pip']

  it "tokenizes setting with boolean name", ->
    {tokens} = grammar.tokenizeLine 'yes:'
    expect(tokens[0]).toEqual value: 'yes', scopes: ['text.pip', 'keyword.other.definition.pip']
    expect(tokens[1]).toEqual value: ':', scopes: ['text.pip', 'punctuation.separator.key-value.pip']

  it "tokenizes setting names with equal sign", ->
    {tokens} = grammar.tokenizeLine 'timeout='
    expect(tokens[0]).toEqual value: 'timeout', scopes: ['text.pip', 'keyword.other.definition.pip']
    expect(tokens[1]).toEqual value: '=', scopes: ['text.pip', 'punctuation.separator.key-value.pip']

  it "tokenizes setting names with space and equal sign", ->
    {tokens} = grammar.tokenizeLine 'timeout ='
    expect(tokens[0]).toEqual value: 'timeout', scopes: ['text.pip', 'keyword.other.definition.pip']
    expect(tokens[2]).toEqual value: '=', scopes: ['text.pip', 'punctuation.separator.key-value.pip']

  it "tokenizes integers", ->
    {tokens} = grammar.tokenizeLine 'timeout = 60'
    expect(tokens[4]).toEqual value: '60', scopes: ['text.pip', 'constant.numeric.integer.pip']

  it "tokenizes boolean true", ->
    {tokens} = grammar.tokenizeLine 'yes = true'
    expect(tokens[4]).toEqual value: 'true', scopes: ['text.pip', 'constant.language.boolean.pip']

  it "tokenizes boolean yes", ->
    {tokens} = grammar.tokenizeLine 'yes = false'
    expect(tokens[4]).toEqual value: 'false', scopes: ['text.pip', 'constant.language.boolean.pip']

  it "tokenizes boolean yes", ->
    {tokens} = grammar.tokenizeLine 'disable_pip_version_check = yes'
    expect(tokens[4]).toEqual value: 'yes', scopes: ['text.pip', 'constant.language.boolean.pip']

  it "tokenizes boolean no", ->
    {tokens} = grammar.tokenizeLine 'disable_pip_version_check = no'
    expect(tokens[4]).toEqual value: 'no', scopes: ['text.pip', 'constant.language.boolean.pip']

  it "tokenizes string values", ->
    {tokens} = grammar.tokenizeLine 'format = freeze'
    expect(tokens[4]).toEqual value: 'freeze', scopes: ['text.pip', 'string.unquoted.pip']
