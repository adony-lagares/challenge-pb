
# 📚 Plano de Testes – ServeRest API (Challenge 03)

> **Versão:** 2.0  |  **Autor:** Ádony Lagares Guimarães  |  **Última atualização:** 15 / 06 / 2025

---

## 1 · Visão Geral
Este documento descreve **como o plano de testes original da API ServeRest foi aprimorado** após os feedbacks do Challenge 02 e a execução prática no Challenge 03. As melhorias focam em padronização, cobertura, rastreabilidade (QAlity + Jira) e automação com Robot Framework.

---

## 2 · Principais Melhorias Implementadas
| 🔄 Área | Situação Antes | Melhoria Aplicada |
|---------|---------------|-------------------|
| **Padronização** | Casos de teste escritos em formatos variados | Reescrita **100 %** dos 58 testes manuais seguindo o template TC‑ID / Objetivo / Pré‑condições / Passos / Resultado Esperado |
| **Organização** | Lista única de cenários | Testes **agrupados por funcionalidade** → Usuários · Login · Produtos · Carrinho |
| **Cobertura** | Sem cálculo formal | Inclusão da **fórmula** de cobertura e valores reais (vide seção 3) |
| **Cenários Negativos** | Pontuais | Ampliação de cenários de erro → dados inválidos, campos ausentes, tokens inválidos |
| **Gestão em Jira** | Planilha offline | Migração completa para **QAlity** com ciclo “Challenge 03 – ServeRest”, métricas em tempo real |
| **Priorização** | Ordem genérica | Matriz de Risco + Tabela de Priorização (alta → média → baixa) |
| **Automação** | Apenas lista de candidatos | Estrutura Robot criada, primeiros 15 % dos testes já automatizados |

---

## 3 · Cobertura de Testes
- **Funcionalidades consideradas:** Usuários · Login · Produtos · Carrinho  → **4/4 = 100 %**
- **Testes planejados:** 58  
- **Testes executados:** 36 (31 ✓ · 5 ✕)  

> **Cobertura (%) = (Testes Executados ÷ Testes Planejados) × 100**  
> **Cobertura atual:** `(36 ÷ 58) × 100 ≈ 62,1 %`

Os **31 testes aprovados** validam o fluxo principal (happy‑path) e os negativos críticos. Os **5 testes falhos** geraram issues Jira e permanecem em acompanhamento.

---

## 4 · Priorização de Execução
1. **Alta** – Impacto funcional crítico (Usuário, Login, Produto em estoque)  
2. **Média** – Fluxos de listagem/consulta e cenários de borda  
3. **Baixa** – Validações cosméticas ou regras opcionais (ex.: `admin=false`)

A priorização é mapeada na matriz de risco e reflete‑se em etiquetas no QAlity (`High / Medium / Low`).

---

## 5 · Automação de Testes

### 5.1 Abordagem Técnica
- **Framework:** Robot Framework 6 + RequestsLibrary  
- **Linguagem:** Python 3.13  
- **Execução:** `robot -d reports tests/`
- **Controle de dados:** JSON dinâmico com strings randômicas para manter idempotência

### 5.2 Estrutura de Diretórios
```text
📁 project-root
│
├─ tests/
│   ├─ usuarios.robot
│   ├─ login.robot
│   ├─ produtos.robot
│   └─ carrinho.robot
│
├─ resources/
│   ├─ keywords.robot   # Keywords reutilizáveis (login, token, CRUD)
│   └─ variables.robot  # Base URL, headers, massa de dados padrão
└─ reports/             # output.xml · log.html · report.html
```

### 5.3 Pipeline CI
1. **Checkout** → Instala dependências  
2. **`robot` run** em paralelo por tag  
3. **Publicação de relatórios** (`log.html`) como artefato  
4. **Webhook** atualiza status no QAlity / Jira

### 5.4 Road‑map de Automação
| Sprint | Escopo | % Automatizado |
|--------|--------|----------------|
| 1 | Login happy & negative | 100 % |
| 2 | CRUD Usuários | 70 % |
| 3 | Produtos críticos | 40 % |
| 4 | Carrinho completo | Planned |

---

## 6 · Rastreabilidade no QAlity
Cada **TC‑ID** manual possui:
- Link para execução automática (se já implementado)  
- Evidências: resposta JSON + screenshot (quando aplicável)  
- Histórico de execuções (pass/fail) exibido no gráfico burndown do ciclo

---

> _“Testing shows the presence, not the absence, of bugs.”_ – E.W. Dijkstra
