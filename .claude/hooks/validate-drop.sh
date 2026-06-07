#!/usr/bin/env bash
# Valida invariantes estruturais de arquivos de deck (docs/**/*.html)
# Roda como PostToolUse após Write e Edit — saída informativa, nunca bloqueante.

set -euo pipefail

# Extrai o caminho do arquivo editado a partir do JSON recebido via stdin
FILE=$(jq -r '.tool_input.file_path // empty' 2>/dev/null)

# Ignora se não conseguiu extrair o caminho
[ -z "$FILE" ] && exit 0

# Só valida arquivos HTML dentro de docs/
[[ "$FILE" == *"/docs/"*".html" ]] || exit 0

# Ignora a home (index.html tem estrutura diferente)
BASENAME=$(basename "$FILE")

if [ "$BASENAME" = "index.html" ]; then
  # Valida apenas links quebrados na home
  ERRORS=()
  DIR=$(dirname "$FILE")

  while IFS= read -r href; do
    TARGET="$DIR/$href"
    if [ ! -f "$TARGET" ]; then
      ERRORS+=("  ✗ [link quebrado]   href=\"$href\" — arquivo não encontrado")
    fi
  done < <(grep -oP '(?<=href=")[^"]+\.html(?=")' "$FILE" 2>/dev/null || true)

  if [ ${#ERRORS[@]} -gt 0 ]; then
    echo ""
    echo "⚠️  Jonnies Tech Drops — validação: $BASENAME"
    for e in "${ERRORS[@]}"; do echo "$e"; done
    echo ""
  fi
  exit 0
fi

# Validações para arquivos de deck
ERRORS=()

# 1. slide-base.css linkado
grep -q 'slide-base\.css' "$FILE" \
  || ERRORS+=("  ✗ [slide-base.css]  Link ausente — arquivo não linka o CSS compartilhado")

# 2. deck-stage.js carregado
grep -q 'deck-stage\.js' "$FILE" \
  || ERRORS+=("  ✗ [deck-stage.js]   Script ausente — componente de navegação não carregado")

# 3. botão home presente
grep -q 'home-btn' "$FILE" \
  || ERRORS+=("  ✗ [home-btn]        Botão ← Home ausente fora do <deck-stage>")

# 4. series-label não contém número (#01, #02...)
if grep -q 'series-label' "$FILE"; then
  grep -oP '(?<=class="series-label">)[^<]+' "$FILE" 2>/dev/null \
    | grep -qP '#\d' \
    && ERRORS+=("  ✗ [series-label]    Contém número (#NN) — use formato \"Tema · Categoria\"")
fi

# 5. slide Saiba Mais presente
grep -q 'CTA · Saiba Mais' "$FILE" \
  || ERRORS+=("  ✗ [Saiba Mais]      Slide CTA · Saiba Mais ausente")

# 6. slide Contribua presente e é o último slide não-skip
grep -q 'CTA · Contribua' "$FILE" \
  || ERRORS+=("  ✗ [Contribua]       Slide CTA · Contribua ausente — deve ser o último slide")

# 7. Contribua vem depois de Saiba Mais (ordem)
if grep -q 'CTA · Saiba Mais' "$FILE" && grep -q 'CTA · Contribua' "$FILE"; then
  LINE_SAIBA=$(grep -n 'CTA · Saiba Mais' "$FILE" | head -1 | cut -d: -f1)
  LINE_CONTRIBUA=$(grep -n 'CTA · Contribua' "$FILE" | head -1 | cut -d: -f1)
  [ "$LINE_CONTRIBUA" -gt "$LINE_SAIBA" ] \
    || ERRORS+=("  ✗ [ordem CTAs]      Contribua deve vir depois de Saiba Mais")
fi

# 8. Sem bloco <style> inline além do override de --accent permitido (máx. 1 bloco, somente :root)
if grep -q '<style>' "$FILE" 2>/dev/null; then
  STYLE_COUNT=$(grep -c '<style>' "$FILE" 2>/dev/null; true)
  STYLE_CONTENT=$(sed -n '/<style>/,/<\/style>/p' "$FILE" 2>/dev/null || true)
  # Permitido: exatamente 1 bloco contendo apenas :root com --accent
  if [ "$STYLE_COUNT" -gt 1 ] || ! echo "$STYLE_CONTENT" | grep -qF -- '--accent'; then
    ERRORS+=("  ✗ [style inline]    Bloco <style> extra encontrado — use slide-base.css (apenas override de --accent é permitido)")
  fi
fi

# Exibe resultado apenas se houver erros
if [ ${#ERRORS[@]} -gt 0 ]; then
  echo ""
  echo "⚠️  Jonnies Tech Drops — validação: $(basename "$FILE")"
  for e in "${ERRORS[@]}"; do echo "$e"; done
  echo ""
fi

exit 0
