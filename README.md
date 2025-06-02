# Melhorias no Planejamento de Testes – ServeRest API

## 1. Resumo das Melhorias Aplicadas

- Padronização e reescrita de todos os 58 testes manuais.
- Organização dos testes por funcionalidades: Usuários, Login, Produtos e Carrinho.
- Inclusão de cenários negativos, testes com dados inválidos e validações de campos obrigatórios.
- Migração completa dos testes para o plugin QAlity no Jira, com visibilidade gráfica das execuções.
- Priorização de testes críticos e de alto impacto funcional.

---

## 2. Cálculo e Descrição da Cobertura de Testes

A API ServeRest foi analisada com base em sua documentação e estrutura de endpoints REST. Foram consideradas as funcionalidades principais:

- Usuários
- Login
- Produtos
- Carrinho

Para cada uma, foram criados testes que cobrem:
- Cenários positivos (happy path)
- Cenários negativos (dados inválidos, campos ausentes)
- Casos de autenticação/autorização
- Erros de negócio

### 🔢 Cálculo da Cobertura:
- Total de funcionalidades cobertas: **4**
- Total de testes implementados: **58**
- Total de endpoints testados: **100%**

> A cobertura de testes foi estimada como **100% funcional**, com pelo menos 10 a 15 testes por área, validando todas as variações de entrada e resposta esperadas.

---

## 3. Planejamento de Automação com Robot Framework

Mesmo antes da implementação da automação, já foi estruturada a abordagem inicial para testes automatizados.

### 🧪 Testes candidatos à automação:
- CT001 - Criar usuário válido
- CT021 - Login com credenciais válidas
- CT031 - Cadastrar produto com autenticação
- CT045 - Criar carrinho com produtos válidos
- CT055 - Cancelar carrinho e restaurar estoque

### 🗂 Estrutura de diretórios planejada:
```
/tests
  ├── usuarios.robot
  ├── login.robot
  ├── produtos.robot
  ├── carrinho.robot
/resources
  ├── keywords.robot
  └── variables.robot
```

### ⚙ Estratégia de automação:
- Utilização do **Robot Framework** com **RequestsLibrary** para testes de APIs REST.
- Testes organizados por funcionalidades.
- Uso de `tags` para controle de execução e priorização.
- Keywords reutilizáveis para facilitar manutenção e padronização.
