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

  it 'tokenizes package names', ->
    {tokens} = grammar.tokenizeLine 'coverage'
    expect(tokens[0]).toEqual value: 'coverage', scopes: ['text.pip.requirements', 'meta.package-name.pip']

  it 'tokenizes version specifier ==', ->
    {tokens} = grammar.tokenizeLine '=='
    expect(tokens[0]).toEqual value: '==', scopes: ['text.pip.requirements', 'keyword.version-specifier.pip']
