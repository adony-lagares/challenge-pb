*** Settings ***
Library    RequestsLibrary
Library    String
Resource   ../resources/variables.robot

Suite Setup    Create Session    serve    ${BASE_URL}

*** Test Cases ***

CT031 - Cadastrar produto com usuário autenticado
    ${rand}=    Generate Random String    5
    ${email}=    Set Variable    produto${rand}@teste.com
    ${senha}=    Set Variable    123456
    ${usuario}=    Create Dictionary    nome=ProdUser    email=${email}    password=${senha}    administrador=true
    POST On Session    serve    /usuarios    json=${usuario}
    ${login}=    Create Dictionary    email=${email}    password=${senha}
    ${res}=    POST On Session    serve    /login    json=${login}
    ${token}=    Set Variable    ${res.json()["authorization"]}
    ${headers}=    Create Dictionary    Authorization=${token}
    ${produto}=    Create Dictionary    nome=Produto${rand}    preco=99    descricao=Produto Teste    quantidade=10
    ${res_prod}=    POST On Session    serve    /produtos    headers=${headers}    json=${produto}
    Status Should Be    201    ${res_prod}
    Should Contain    ${res_prod.json()["message"]}    Cadastro realizado com sucesso

CT032 - Cadastrar produto com nome já existente
    ${rand}=    Generate Random String    4
    ${email}=    Set Variable    duplicado${rand}@teste.com
    ${senha}=    Set Variable    123456
    ${usuario}=    Create Dictionary    nome=Dup    email=${email}    password=${senha}    administrador=true
    POST On Session    serve    /usuarios    json=${usuario}
    ${login}=    Create Dictionary    email=${email}    password=${senha}
    ${res}=    POST On Session    serve    /login    json=${login}
    ${token}=    Set Variable    ${res.json()["authorization"]}
    ${headers}=    Create Dictionary    Authorization=${token}
    ${produto}=    Create Dictionary    nome=ProdutoUnico${rand}    preco=50    descricao=Teste    quantidade=5
    POST On Session    serve    /produtos    headers=${headers}    json=${produto}
    ${res_dup}=    POST On Session    serve    /produtos    headers=${headers}    json=${produto}    expected_status=any
    Status Should Be    400    ${res_dup}
    Should Contain    ${res_dup.json()["message"]}    Já existe produto com esse nome

CT033 - Cadastrar produto sem autenticação
    ${produto}=    Create Dictionary    nome=SemToken    preco=20    descricao=SemToken    quantidade=5
    ${res}=    POST On Session    serve    /produtos    json=${produto}    expected_status=any
    Status Should Be    401    ${res}
    Should Contain    ${res.json()["message"]}    Token de acesso ausente, inválido, expirado ou usuário do token não existe mais

CT034 - Cadastrar produto com token inválido
    ${headers}=    Create Dictionary    Authorization=Bearer 123abc.token.invalido
    ${produto}=    Create Dictionary    nome=TokenInvalido    preco=20    descricao=TokenFail    quantidade=1
    ${res}=    POST On Session    serve    /produtos    headers=${headers}    json=${produto}    expected_status=any
    Status Should Be    401    ${res}
    Should Contain    ${res.json()["message"]}    Token de acesso ausente, inválido, expirado ou usuário do token não existe mais

CT035 - Cadastrar produto com campos obrigatórios ausentes
    ${rand}=    Generate Random String    4
    ${email}=    Set Variable    campos${rand}@teste.com
    ${senha}=    Set Variable    123456
    ${usuario}=    Create Dictionary    nome=Campos    email=${email}    password=${senha}    administrador=true
    POST On Session    serve    /usuarios    json=${usuario}
    ${login}=    Create Dictionary    email=${email}    password=${senha}
    ${res}=    POST On Session    serve    /login    json=${login}
    ${token}=    Set Variable    ${res.json()["authorization"]}
    ${headers}=    Create Dictionary    Authorization=${token}
    ${produto}=    Create Dictionary    nome=ProdutoSemPreco
    ${res}=    POST On Session    serve    /produtos    headers=${headers}    json=${produto}    expected_status=any
    Status Should Be    400    ${res}
    Should Contain    ${res.text}    preco é obrigatório

CT036 - Atualizar produto com ID inexistente
    ${rand}=    Generate Random String    3
    ${email}=    Set Variable    upd${rand}@teste.com
    ${senha}=    Set Variable    123456
    ${usuario}=    Create Dictionary    nome=UpdateFake    email=${email}    password=${senha}    administrador=true
    POST On Session    serve    /usuarios    json=${usuario}
    ${login}=    Create Dictionary    email=${email}    password=${senha}
    ${res}=    POST On Session    serve    /login    json=${login}
    ${token}=    Set Variable    ${res.json()["authorization"]}
    ${headers}=    Create Dictionary    Authorization=${token}
    ${produto}=    Create Dictionary    nome=Atualiza    preco=30    descricao=Update    quantidade=3
    ${res}=    PUT On Session    serve    /produtos/1234567890abcdef    headers=${headers}    json=${produto}    expected_status=any
    Status Should Be    400    ${res}
    Should Contain    ${res.text}    Produto não encontrado

