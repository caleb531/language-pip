describe 'pypirc grammar', ->
  grammar = null

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage('language-pip')

    runs ->
      grammar = atom.grammars.grammarForScopeName('text.pip.pypirc')

  it 'parses the grammar', ->
    expect(grammar).toBeTruthy()
    expect(grammar.scopeName).toBe 'text.pip.pypirc'

  it 'tokenizes comments', ->
    {tokens} = grammar.tokenizeLine '# foo'
    expect(tokens[0]).toEqual value: '#', scopes: ['text.pip.pypirc', 'comment.line.number-sign.pip', 'punctuation.definition.comment.pip']
    expect(tokens[1]).toEqual value: ' foo', scopes: ['text.pip.pypirc', 'comment.line.number-sign.pip']

  it 'tokenizes section headings', ->
    {tokens} = grammar.tokenizeLine '[pypi]'
    expect(tokens[0]).toEqual value: '[', scopes: ['text.pip.pypirc', 'entity.name.section.group-title.pip', 'punctuation.definition.entity.pip']
    expect(tokens[1]).toEqual value: 'pypi', scopes: ['text.pip.pypirc', 'entity.name.section.group-title.pip']
    expect(tokens[2]).toEqual value: ']', scopes: ['text.pip.pypirc', 'entity.name.section.group-title.pip', 'punctuation.definition.entity.pip']

  it 'tokenizes setting names with colon', ->
    {tokens} = grammar.tokenizeLine 'repository:'
    expect(tokens[0]).toEqual value: 'repository', scopes: ['text.pip.pypirc', 'keyword.other.definition.pip']
    expect(tokens[1]).toEqual value: ':', scopes: ['text.pip.pypirc', 'punctuation.separator.key-value.pip']

  it 'tokenizes setting names with equal sign', ->
    {tokens} = grammar.tokenizeLine 'repository='
    expect(tokens[0]).toEqual value: 'repository', scopes: ['text.pip.pypirc', 'keyword.other.definition.pip']
    expect(tokens[1]).toEqual value: '=', scopes: ['text.pip.pypirc', 'punctuation.separator.key-value.pip']

  it 'tokenizes setting names with space and equal sign', ->
    {tokens} = grammar.tokenizeLine 'repository ='
    expect(tokens[0]).toEqual value: 'repository', scopes: ['text.pip.pypirc', 'keyword.other.definition.pip']
    expect(tokens[2]).toEqual value: '=', scopes: ['text.pip.pypirc', 'punctuation.separator.key-value.pip']

  it 'tokenizes unquoted strings', ->
    {tokens} = grammar.tokenizeLine 'username: user123'
    expect(tokens[3]).toEqual value: 'user123', scopes: ['text.pip.pypirc', 'string.unquoted.pip']

  it 'tokenizes comments following setting values', ->
    {tokens} = grammar.tokenizeLine 'username: user123 # foo'
    expect(tokens[4]).toEqual value: '#', scopes: ['text.pip.pypirc', 'comment.line.number-sign.pip', 'punctuation.definition.comment.pip']
    expect(tokens[5]).toEqual value: ' foo', scopes: ['text.pip.pypirc', 'comment.line.number-sign.pip']
