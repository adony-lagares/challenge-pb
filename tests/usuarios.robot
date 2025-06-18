*** Settings ***
Library    RequestsLibrary
Library    String
Resource   ../resources/variables.robot

*** Test Cases ***

CT001 - Criar usuário válido
    Create Session    serve    ${BASE_URL}
    ${rand}=    Generate Random String    5
    ${email}=    Set Variable    batman${rand}@teste.com
    ${body}=    Create Dictionary    nome=Batman    email=${email}    password=123456    administrador=true
    ${response}=    POST On Session    serve    /usuarios    json=${body}    expected_status=any
    Status Should Be    201    ${response}
    Should Contain    ${response.json()["message"]}    Cadastro realizado com sucesso

CT002 - Criar usuário com e-mail já cadastrado
    Create Session    serve    ${BASE_URL}
    ${email}=    Set Variable    batman@teste.com
    ${body}=    Create Dictionary    nome=Batman    email=${email}    password=123456    administrador=true
    ${res1}=    POST On Session    serve    /usuarios    json=${body}
    ${res2}=    POST On Session    serve    /usuarios    json=${body}    expected_status=any
    Status Should Be    400    ${res2}
    Should Contain    ${res2.json()["message"]}    Este email já está sendo usado

CT003 - Criar usuário com e-mail @gmail.com
    Create Session    serve    ${BASE_URL}
    ${rand}=    Generate Random String    5
    ${email}=    Set Variable    bat${rand}@gmail.com
    ${body}=    Create Dictionary    nome=Batman    email=${email}    password=123456    administrador=true
    ${response}=    POST On Session    serve    /usuarios    json=${body}    expected_status=any
    Status Should Be    201    ${response}
    Should Contain    ${response.json()["message"]}    Cadastro realizado com sucesso

CT004 - Criar usuário com e-mail @hotmail.com
    Create Session    serve    ${BASE_URL}
    ${rand}=    Generate Random String    5
    ${email}=    Set Variable    bat${rand}@hotmail.com
    ${body}=    Create Dictionary    nome=Batman    email=${email}    password=123456    administrador=true
    ${response}=    POST On Session    serve    /usuarios    json=${body}    expected_status=any
    Status Should Be    201    ${response}
    Should Contain    ${response.json()["message"]}    Cadastro realizado com sucesso

CT005 - Criar usuário com e-mail inválido
    Create Session    serve    ${BASE_URL}
    ${body}=    Create Dictionary    nome=Batman    email=batmanmail.com    password=123456    administrador=true
    ${response}=    POST On Session    serve    /usuarios    json=${body}    expected_status=any
    Status Should Be    400    ${response}
    Should Contain    ${response.json()["email"]}    email deve ser um email válido

CT006 - Criar usuário com senha < 5 caracteres
    Create Session    serve    ${BASE_URL}
    ${rand}=    Generate Random String    4
    ${email}=    Set Variable    curto${rand}@teste.com
    ${body}=    Create Dictionary    nome=SenhaCurta    email=${email}    password=123    administrador=true
    ${response}=    POST On Session    serve    /usuarios    json=${body}
    Status Should Be    201    ${response}
    Should Contain    ${response.json()["message"]}    Cadastro realizado com sucesso

CT007 - Criar usuário com senha > 10 caracteres
    Create Session    serve    ${BASE_URL}
    ${rand}=    Generate Random String    4
    ${email}=    Set Variable    longo${rand}@teste.com
    ${body}=    Create Dictionary    nome=SenhaLonga    email=${email}    password=12345678901    administrador=true
    ${response}=    POST On Session    serve    /usuarios    json=${body}
    Status Should Be    201    ${response}
    Should Contain    ${response.json()["message"]}    Cadastro realizado com sucesso

CT008 - Atualizar usuário existente com dados válidos
    Create Session    serve    ${BASE_URL}
    ${rand}=    Generate Random String    5
    ${email}=    Set Variable    update${rand}@teste.com
    ${body}=    Create Dictionary    nome=Update    email=${email}    password=123456    administrador=false
    ${create}=    POST On Session    serve    /usuarios    json=${body}    expected_status=any
    ${id}=    Set Variable    ${create.json()["_id"]}
    ${update}=    Create Dictionary    nome=Atualizado    email=atualizado${rand}@teste.com    password=654321    administrador=true
    ${response}=    PUT On Session    serve    /usuarios/${id}    json=${update}    expected_status=any
    Status Should Be    200    ${response}
    Should Contain    ${response.json()["message"]}    Registro alterado com sucesso

CT009 - Atualizar usuário com ID inexistente
    Create Session    serve    ${BASE_URL}
    ${id_falso}=    Set Variable    000000000000000000000000
    ${body}=    Create Dictionary    nome=Fake    email=fake@teste.com    password=123456    administrador=false
    ${response}=    PUT On Session    serve    /usuarios/${id_falso}    json=${body}    expected_status=any
    Status Should Be    400    ${response}
    Should Contain    ${response.text}    Usuário não encontrado


CT010 - Atualizar usuário com email já existente
    Create Session    serve    ${BASE_URL}
    ${rand1}=    Generate Random String    4
    ${rand2}=    Generate Random String    4
    ${email1}=    Set Variable    user${rand1}@teste.com
    ${email2}=    Set Variable    user${rand2}@teste.com
    ${body1}=    Create Dictionary    nome=User1    email=${email1}    password=123456    administrador=true
    ${body2}=    Create Dictionary    nome=User2    email=${email2}    password=123456    administrador=true
    ${res1}=    POST On Session    serve    /usuarios    json=${body1}    expected_status=any
    ${res2}=    POST On Session    serve    /usuarios    json=${body2}    expected_status=any
    ${id}=    Set Variable    ${res2.json()["_id"]}
    ${update}=    Create Dictionary    nome=User2    email=${email1}    password=123456    administrador=true
    ${response}=    PUT On Session    serve    /usuarios/${id}    json=${update}    expected_status=any
    Status Should Be    400    ${response}
    Should Contain    ${response.json()["message"]}    Este email já está sendo usado

CT011 - Listar todos os usuários
    Create Session    serve    ${BASE_URL}
    ${response}=    GET On Session    serve    /usuarios    expected_status=any
    Status Should Be    200    ${response}
    Should Contain    ${response.json()}    usuarios

CT012 - Listar usuário por ID válido
    Create Session    serve    ${BASE_URL}
    ${rand}=    Generate Random String    5
    ${email}=    Set Variable    user${rand}@teste.com
    ${body}=    Create Dictionary    nome=Usuário    email=${email}    password=123456    administrador=true
    ${create}=    POST On Session    serve    /usuarios    json=${body}    expected_status=any
    ${id}=    Set Variable    ${create.json()["_id"]}
    ${response}=    GET On Session    serve    /usuarios/${id}    expected_status=any
    Status Should Be    200    ${response}
    Should Contain    ${response.json()["nome"]}    Usuário

CT013 - Listar usuário por ID inexistente
    Create Session    serve    ${BASE_URL}
    ${id_falso}=    Set Variable    000000000000000000000000
    ${response}=    GET On Session    serve    /usuarios/${id_falso}    expected_status=any
    Status Should Be    400    ${response}
    Should Contain    ${response.text}    id deve ter exatamente 24 caracteres alfanuméricos

CT014 - Deletar usuário existente
    Create Session    serve    ${BASE_URL}
    ${rand}=    Generate Random String    5
    ${email}=    Set Variable    del${rand}@teste.com
    ${body}=    Create Dictionary    nome=Deletável    email=${email}    password=123456    administrador=true
    ${create}=    POST On Session    serve    /usuarios    json=${body}    expected_status=any
    ${id}=    Set Variable    ${create.json()["_id"]}
    ${response}=    DELETE On Session    serve    /usuarios/${id}    expected_status=any
    Status Should Be    200    ${response}
    Should Contain    ${response.json()["message"]}    Registro excluído com sucesso


CT015 - Deletar usuário inexistente
    Create Session    serve    ${BASE_URL}
    ${id_falso}=    Set Variable    507f191e810c19729de860ea
    ${response}=    DELETE On Session    serve    /usuarios/${id_falso}    expected_status=any
    Status Should Be    200    ${response}
    Should Contain    ${response.json()["message"]}    Nenhum registro excluído

CT016 - Acessar rota de usuário inexistente com token
    Create Session    serve    ${BASE_URL}
    ${rand}=    Generate Random String    4
    ${email}=    Set Variable    token${rand}@teste.com
    ${body}=    Create Dictionary    nome=TokenUser    email=${email}    password=123456    administrador=true
    POST On Session    serve    /usuarios    json=${body}
    ${login_body}=    Create Dictionary    email=${email}    password=123456
    ${login}=    POST On Session    serve    /login    json=${login_body}
    ${token}=    Set Variable    ${login.json()["authorization"]}
    ${headers}=    Create Dictionary    Authorization=Bearer ${token}
    ${id_falso}=    Set Variable    abcd00000000000000000000
    ${response}=    GET On Session    serve    /usuarios/aaaaaaaaaaaaaaaaaaaaaaaa    headers=${headers}    expected_status=any
    Should Contain    ${response.text}    Usuário não encontrado

CT017 - Validação de campos obrigatórios
    Create Session    serve    ${BASE_URL}
    ${body}=    Create Dictionary    email=semnome@teste.com    password=123456    administrador=true
    ${response}=    POST On Session    serve    /usuarios    json=${body}    expected_status=any
    Status Should Be    400    ${response}
    Should Contain    ${response.text}    nome é obrigatório

CT018 - Criar usuário com admin false
    Create Session    serve    ${BASE_URL}
    ${rand}=    Generate Random String    4
    ${email}=    Set Variable    noadmin${rand}@teste.com
    ${body}=    Create Dictionary    nome=SemAdmin    email=${email}    password=123456    administrador=false
    ${response}=    POST On Session    serve    /usuarios    json=${body}    expected_status=any
    Status Should Be    201    ${response}
    Should Contain    ${response.json()["message"]}    Cadastro realizado com sucesso

CT019 - Enviar payload com campo extra
    Create Session    serve    ${BASE_URL}
    ${rand}=    Generate Random String    4
    ${email}=    Set Variable    extra${rand}@teste.com
    ${body}=    Create Dictionary    nome=Extra    email=${email}    password=123456    administrador=true    planeta=Terra
    ${response}=    POST On Session    serve    /usuarios    json=${body}    expected_status=any
    Status Should Be    400    ${response}
    Should Contain    ${response.text}    planeta não é permitido

CT020 - Enviar payload vazio
    Create Session    serve    ${BASE_URL}
    ${body}=    Create Dictionary
    ${response}=    POST On Session    serve    /usuarios    json=${body}    expected_status=any
    Status Should Be    400    ${response}
    Should Contain    ${response.text}    nome é obrigatório