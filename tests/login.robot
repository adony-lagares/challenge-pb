*** Settings ***
Library    RequestsLibrary
Library    String
Resource   ../resources/variables.robot

Suite Setup    Create Session    serve    ${BASE_URL}

*** Test Cases ***

CT021 - Login com credenciais válidas
    ${rand}=    Generate Random String    5
    ${email}=    Set Variable    valido${rand}@teste.com
    ${senha}=    Set Variable    123456
    ${body}=    Create Dictionary    nome=LoginValido    email=${email}    password=${senha}    administrador=true
    POST On Session    serve    /usuarios    json=${body}
    ${login}=    Create Dictionary    email=${email}    password=${senha}
    ${res}=    POST On Session    serve    /login    json=${login}
    Status Should Be    200    ${res}
    Should Contain    ${res.json()}    authorization

CT022 - Login com e-mail não cadastrado
    ${login}=    Create Dictionary    email=naocadastrado@teste.com    password=123456
    ${res}=    POST On Session    serve    /login    json=${login}    expected_status=any
    Status Should Be    401    ${res}
    Should Contain    ${res.json()["message"]}    Email e/ou senha inválidos

CT023 - Login com senha incorreta
    ${rand}=    Generate Random String    4
    ${email}=    Set Variable    senhaerrada${rand}@teste.com
    ${body}=    Create Dictionary    nome=SenhaErrada    email=${email}    password=123456    administrador=true
    POST On Session    serve    /usuarios    json=${body}
    ${login}=    Create Dictionary    email=${email}    password=senhaerrada
    ${res}=    POST On Session    serve    /login    json=${login}    expected_status=any
    Status Should Be    401    ${res}
    Should Contain    ${res.json()["message"]}    Email e/ou senha inválidos

CT024 - Login com email inválido
    ${login}=    Create Dictionary    email=emailinvalido.com    password=123456
    ${res}=    POST On Session    serve    /login    json=${login}    expected_status=any
    Status Should Be    400    ${res}
    Should Contain    ${res.text}    email deve ser um email válido

CT025 - Login com senha fora dos limites
    ${login}=    Create Dictionary    email=teste@teste.com    password=12345678901
    ${res}=    POST On Session    serve    /login    json=${login}    expected_status=any
    Status Should Be    400    ${res}
    Should Contain    ${res.text}    password deve ter entre 5 e 10 caracteres

CT026 - Login com payload incompleto
    ${login}=    Create Dictionary    email=faltandados@teste.com
    ${res}=    POST On Session    serve    /login    json=${login}    expected_status=any
    Status Should Be    400    ${res}
    Should Contain    ${res.text}    password é obrigatório

CT027 - Login com payload vazio
    ${login}=    Create Dictionary
    ${res}=    POST On Session    serve    /login    json=${login}    expected_status=any
    Status Should Be    400    ${res}
    Should Contain    ${res.text}    email é obrigatório

CT028 - Verificar estrutura do token
    ${rand}=    Generate Random String    4
    ${email}=    Set Variable    token${rand}@teste.com
    ${body}=    Create Dictionary    nome=TokenCheck    email=${email}    password=123456    administrador=false
    POST On Session    serve    /usuarios    json=${body}
    ${login}=    Create Dictionary    email=${email}    password=123456
    ${res}=    POST On Session    serve    /login    json=${login}
    ${token}=    Set Variable    ${res.json()["authorization"]}
    Should Match Regexp    ${token}    ^[A-Za-z0-9-_=]+\.[A-Za-z0-9-_=]+\.[A-Za-z0-9-_.+/=]*$

CT029 - Verificar expiração do token
    [Tags]    simulado
    Comment    Não é possível forçar expiração real via API, mas podemos validar que token antigo falha
    ${headers}=    Create Dictionary    Authorization=Bearer tokeninvalido.abc.123
    ${res}=    GET On Session    serve    /usuarios    headers=${headers}    expected_status=any
    Status Should Be    401    ${res}
    Should Contain    ${res.json()["message"]}    Token inválido, tente novamente

CT030 - Verificar mensagem genérica de erro
    ${login}=    Create Dictionary    email=    password=
    ${res}=    POST On Session    serve    /login    json=${login}    expected_status=any
    Status Should Be    400    ${res}
    Should Contain    ${res.text}    email é obrigatório
