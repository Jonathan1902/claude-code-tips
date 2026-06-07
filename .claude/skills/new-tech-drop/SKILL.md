---
name: new-tech-drop
description: >
  Generates a complete HTML file for a new Jonnies Tech Drops episode: one Tip slide + an optional Concept block (definition, comparison, decision, recap), following the exact design system and file structure of the project. Aim for up to 10 slides total. Use this skill whenever the user asks to create a new tip, a new drop, a new episode, or wants to add content — even if they just say "quero criar a dica #X" or "novo drop sobre Y".
---

# new-tech-drop

Gera o arquivo HTML completo de um novo episódio Jonnies Tech Drops e insere o card na home automaticamente.

## Estrutura do projeto

```
docs/
├── index.html                          ← Home (lista de dicas)
├── slide-base.css                      ← Sistema de design compartilhado
├── deck-stage.js                       ← Web component de navegação
├── mascot.svg                          ← Mascote usado nas capas
├── claude-code/
│   ├── 01-configure-o-claude-md.html  ← referência: dica simples (sem bloco conceito)
│   └── 02-o-que-e-claude-code.html    ← referência: episódio completo (dica + conceito)
├── aws/
├── machine-learning/
├── dados/
└── analytics/
```

Temas disponíveis:

| Tema              | Pasta               | Classe CSS home     | Cor accent |
|-------------------|---------------------|---------------------|------------|
| Claude Code       | `claude-code/`      | `theme-claude-code` | `#FF6200`  |
| AWS               | `aws/`              | `theme-aws`         | `#FF9900`  |
| Machine Learning  | `machine-learning/` | `theme-ml`          | `#FFFFFF`  |
| Dados             | `dados/`            | `theme-dados`       | `#38BDF8`  |
| Analytics         | `analytics/`        | `theme-analytics`   | `#94A3B8`  |

## Passo 1 — Detectar contexto e coletar briefing

Antes de perguntar ao usuário, leia `docs/index.html` e identifique:
- O maior `card-number` com formato `Dica #NN` — o próximo número é esse + 1
- Quais temas já existem (seções `section-label` presentes)

Pergunte ao usuário (tudo de uma vez, em linguagem simples):

1. **Tema** — Claude Code, AWS, Machine Learning, Dados ou Analytics
2. **Assunto** — o que a dica ensina (ex.: "usar subagentes para tarefas paralelas")
3. **2–3 pontos principais** que o leitor deve levar — podem ser rascos, você vai refinar
4. **Slug** para o nome do arquivo (ex.: `use-subagentes`)

Não peça cor, número da dica, títulos de slide, bullets formatados, nem conteúdo de cada slide individualmente. Você vai gerar tudo isso.

## Passo 2 — Gerar o conteúdo dos slides

Com base no briefing, crie o conteúdo completo do episódio. Mire em até 10 slides no total (recomendação soft — prefira menos slides densos a muitos slides rasos).

- **Capa**: `series-label` no formato `"Tema · Categoria"` (ex.: `"Claude Code · Configuração"`, `"AWS · Segurança"`). Nunca use números. Título (máx. 55 chars, sem ponto final) + subtítulo (máx. 70 chars, tom conversacional).
- **Slide de Dica**: 3–4 bullets concisos e acionáveis + bloco de código se o assunto tiver exemplo de código natural. Se um diagrama ou print de tela ilustraria melhor o conceito do que texto, indique onde ele entraria com um `.visual-placeholder`.
- **Bloco de Conceito** (opcional, inclua só se agregar valor):
  - **Definição**: frase-âncora para o code-block + 3 bullets explicando o conceito. Inclua `.visual-placeholder` quando um gráfico, diagrama ou ícone tornaria o conceito mais imediato.
  - **Comparação**: 3 resource-cards com label e descrição (use `resource-url--plain` para texto corrido, não URLs).
  - **Decisão**: 2 bullets "Resolve" + 2 bullets "Não resolve" — use exemplos do mercado financeiro quando possível.
  - **Recap**: 3 frases curtas que fixam o conceito.
- **Saiba Mais**: subtítulo que reflita o conteúdo específico do drop (ex.: `"Recursos para dominar o CLAUDE.md"`). Inclua 2–4 resource-cards com os links mais relevantes — quantidade livre, mesma estrutura HTML sempre.
- **Contribua**: slide fixo, sem variação de conteúdo.

Adapte o tom ao público: profissionais do mercado financeiro que codificam mas não são necessariamente devs full-time. Prefira exemplos concretos do setor (risco, compliance, relatórios, dados de mercado).

## Passo 3 — Gerar o arquivo HTML

Crie `docs/<tema>/<número>-<slug>.html` usando `docs/claude-code/02-o-que-e-claude-code.html` como referência de estrutura (ele tem o episódio completo: dica + conceito).

Head obrigatório (sem bloco `<style>`):
```html
<link rel="stylesheet" href="../slide-base.css">
<script src="../deck-stage.js"></script>
```

Substitua no template:
- Cor `--accent` no `:root` pela cor do tema
- `<span>Claude Code</span>` nas tags → nome do tema correto
- Conteúdo de cada slide pelo conteúdo gerado no Passo 2
- Caminhos relativos (`../index.html`, `../mascot.svg`) já estão corretos para qualquer subpasta de `docs/`

### Regras dos slides

**Tag de tema** — todas as tags usam o nome do tema, nunca "Conceito" ou número:
```html
<div class="tag"><span class="tag-dot"></span><span>NOME DO TEMA</span></div>
```

**Slide de Dica** — inclua `<div class="code-block">` apenas se houver código real. Se não houver, remova o `style="margin-bottom: var(--gap-section);"` da `<ul>`.

**Bullets "Não resolve"** (Decisão) — dot e texto em `var(--text-muted)`:
```html
<span class="bullet-dot" style="background: var(--text-muted);"></span>
<span style="color: var(--text-muted);">...</span>
```

**Comparação** — use `resource-url--plain` para descrições em texto corrido:
```html
<span class="resource-url resource-url--plain">Descrição aqui</span>
```

**Footer padrão** de cada slide:
```html
<div style="margin-top: auto; padding-top: 32px;">
  <div class="divider" style="width: 100%;"></div>
</div>
```

**Slide Saiba Mais** — o subtítulo deve refletir o conteúdo do drop (não uma frase genérica fixa). A quantidade de resource-cards é livre; a estrutura HTML é sempre a mesma:
```html
<section data-label="CTA · Saiba Mais" data-screen-label="Saiba Mais">
  <div class="slide-header">
    <span class="brand">Jonnies Tech Drops</span>
    <div class="tag"><span class="tag-dot"></span><span>Saiba Mais</span></div>
  </div>
  <div style="margin-top: var(--gap-section); margin-bottom: var(--gap-section);">
    <h2 class="tip-title">Quer aprofundar?</h2>
    <p class="subtitle" style="margin-top: 14px;">SUBTÍTULO ESPECÍFICO DO DROP</p>
  </div>
  <div class="resource-list">
    <div class="resource-card">
      <span class="resource-title">TÍTULO DO RECURSO</span>
      <span class="resource-url">url.do.recurso.com</span>
    </div>
    <!-- repetir resource-card para cada link -->
  </div>
  <div style="margin-top: auto; padding-top: 32px;"><div class="divider" style="width: 100%;"></div></div>
</section>
```

**Slide Contribua** — estrutura fixa, nunca alterar conteúdo:
```html
<section data-label="CTA · Contribua" data-screen-label="Contribua">
  <div class="slide-header">
    <span class="brand">Jonnies Tech Drops</span>
    <div class="tag"><span class="tag-dot"></span><span>Participe</span></div>
  </div>
  <div class="contribute-body">
    <div>
      <h2 class="tip-title">Você usa isso no trabalho?</h2>
      <p class="subtitle" style="margin-top: 16px;">Compartilhe seu caso real e apareça na próxima edição do Jonnies Tech Drops.</p>
    </div>
    <div class="contribute-box">
      <span class="contribute-cta">Enviar meu case</span>
      <span class="contribute-arrow">→</span>
    </div>
    <span class="contribute-url">jonathancosta888@gmail.com</span>
  </div>
  <div style="flex-shrink: 0;"><div class="divider" style="width: 100%;"></div></div>
</section>
```

**Visual placeholder** — use quando um gráfico, diagrama, print de tela ou ícone tornaria o conceito mais imediato do que texto. O placeholder sinaliza ao autor onde inserir o recurso visual depois:
```html
<div class="visual-placeholder">
  [ gráfico · diagrama de fluxo · print de tela ]<br>adicionar recurso visual aqui
</div>
```
Ajuste a descrição dentro dos colchetes para o tipo de visual esperado (ex.: `[ diagrama de arquitetura ]`, `[ captura de tela do terminal ]`, `[ ícone ilustrativo ]`).

## Passo 4 — Inserir o card na home

Edite `docs/index.html` diretamente. Não peça ao usuário para fazer isso manualmente.

**Se o tema já existe**: insira o novo `<a class="card">` como último item dentro do `<div class="card-grid">` desse tema, antes do `</div>` de fechamento.

**Se for um tema novo**: insira antes do comentário `<!-- Adicione novos temas -->` (ou antes do `<footer>`):

```html
<!-- ── NOME DO TEMA ── -->
<div class="section-label">NOME DO TEMA</div>
<div class="card-grid">

  <a class="card" href="<tema>/<número>-<slug>.html">
    <div class="card-theme theme-<classe-css>">
      <span class="card-theme-dot"></span>
      NOME DO TEMA
    </div>
    <div class="card-number">Dica #NN</div>
    <div class="card-title">TÍTULO DA DICA</div>
    <div class="card-desc">DESCRIÇÃO CURTA (1–2 frases, máx. 120 chars)</div>
    <span class="card-arrow">→</span>
  </a>

</div>
```

Use o número detectado no Passo 1. Após editar, confirme ao usuário o arquivo criado e o card inserido.
