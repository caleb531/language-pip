describe 'pip requirements grammar', ->
  grammar = null

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage('language-pip')

    runs ->
      grammar = atom.grammars.grammarForScopeName('text.pip.requirements')

  it 'parses the grammar', ->
    expect(grammar).toBeTruthy()
    expect(grammar.scopeName).toBe 'text.pip.requirements'

  it 'tokenizes comments', ->
    {tokens} = grammar.tokenizeLine '# foo'
    expect(tokens[0]).toEqual value: '#', scopes: ['text.pip.requirements', 'comment.line.number-sign.pip', 'punctuation.definition.comment.pip']
    expect(tokens[1]).toEqual value: ' foo', scopes: ['text.pip.requirements', 'comment.line.number-sign.pip']

  it 'tokenizes package names', ->
    {tokens} = grammar.tokenizeLine 'coverage'
    expect(tokens[0]).toEqual value: 'coverage', scopes: ['text.pip.requirements', 'meta.package-name.pip']

  it 'tokenizes version specifier ==', ->
    {tokens} = grammar.tokenizeLine '=='
    expect(tokens[0]).toEqual value: '==', scopes: ['text.pip.requirements', 'keyword.version-specifier.pip']

  it 'tokenizes trailing line comments', ->
    {tokens} = grammar.tokenizeLine 'coverage # trailing comments'
    expect(tokens[0]).toEqual value: 'coverage', scopes: ['text.pip.requirements', 'meta.package-name.pip']
    expect(tokens[1]).toEqual value: ' ', scopes: ['text.pip.requirements']
    expect(tokens[2]).toEqual value: '#', scopes: ['text.pip.requirements', 'comment.line.number-sign.pip', 'punctuation.definition.comment.pip']
    expect(tokens[3]).toEqual value: ' trailing comments', scopes: ['text.pip.requirements', 'comment.line.number-sign.pip']

  it 'does NOT tokenize  trailing line comments in the absence of preceding whitespace', ->
    {tokens} = grammar.tokenizeLine 'MyProject#egg=hatched'
    expect(tokens[0]).toEqual value: 'MyProject', scopes: ['text.pip.requirements', 'meta.package-name.pip']
    # [TABULON]: for some reason, this is tokenized separately (most probably unrelated to the change that introduced trailing comments),
    #            Hwoever, it doesn't seem to hurt in any case  (since we are indeed avoiding to trigger a COMMENT scope)
    expect(tokens[1]).toEqual value: '#egg=hatched', scopes: ['text.pip.requirements']

  it 'correctly tokenizes trailing line comments, and respects the rule related to preceding whitespace', ->
    {tokens} = grammar.tokenizeLine 'MyProject#egg=hatched # trailing comments'
    expect(tokens[0]).toEqual value: 'MyProject', scopes: ['text.pip.requirements', 'meta.package-name.pip']
    # [TABULON]: for some reason, this is tokenized separately (most probably unrelated to the change that introduced trailing comments),
    #            Hwoever, it doesn't seem to hurt in any case  (since we are indeed avoiding to trigger a COMMENT scope)
    expect(tokens[1]).toEqual value: '#egg=hatched', scopes: ['text.pip.requirements']
    expect(tokens[2]).toEqual value: ' ', scopes: ['text.pip.requirements']
    expect(tokens[3]).toEqual value: '#', scopes: ['text.pip.requirements', 'comment.line.number-sign.pip', 'punctuation.definition.comment.pip']
    expect(tokens[4]).toEqual value: ' trailing comments', scopes: ['text.pip.requirements', 'comment.line.number-sign.pip']
