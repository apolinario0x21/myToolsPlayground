#!/bin/bash

# Banner com toilet
print_banner() {
  echo "#####################################################"
  toilet -F metal "PARSING HTML"
  echo "#####################################################"
  echo
}

# Modo de uso
usage() {
  echo "Modo de Uso: $0 [DOMÍNIO]"
  echo "Exemplo: $0 https://www.exemplo.com"
  echo
  echo "AVISO LEGAL: Este script é para fins educacionais."
  exit 1
}

# Função para extrair o domínio de uma URL
extract_domain() {
  echo "$1" | awk -F[/\"] '{print $3}'
}

# Verifica se o domínio está no formato válido
validate_domain() {
  local domain="$1"
  if [[ ! "$domain" =~ ^(http://|https://)[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}(/)?$ ]]; then
    echo "Erro: Domínio inválido. Use o formato 'http(s)://exemplo.com'"
    return 1
  fi
  return 0
}

# Verifica robots.txt (opcional)
check_robots_txt() {
  local domain="$1"
  local robots_url="${domain}/robots.txt"

  if wget -q --spider "$robots_url"; then
    echo "Verificando robots.txt..."
    if wget -q -O - "$robots_url" | grep -q "Disallow: /"; then
      echo "AVISO: Este domínio proíbe scraping no robots.txt"
      return 1
    fi
  fi
  return 0
}

# Mostra banner
print_banner

# Verifica se o domínio foi fornecido
if [ -z "$1" ]; then
  usage
fi

# Domínio alvo
domain="$1"

# Valida o formato do domínio
if ! validate_domain "$domain"; then
  exit 1
fi

# Verifica robots.txt
if ! check_robots_txt "$domain"; then
  read -p "Continuar mesmo assim? (s/n) " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Ss]$ ]]; then
    exit 1
  fi
fi

# Baixar a página HTML com limite de taxa
echo "Baixando página (aguarde 2 segundos por politeness)..."
wget -q --wait=2 --limit-rate=50k "$domain" -O index.html

# Verifica se o download foi bem-sucedido
if [ $? -ne 0 ]; then
  echo "Erro: Falha ao baixar a página do domínio $domain"
  exit 1
fi

# Extrair os links e resolver os DNS
echo -e "\nResultados:"
echo -e "Line\tIP\t\tADDRESS"
echo "----------------------------------------"

i=1
grep -oP 'href="\K[^"]+' index.html | while IFS= read -r url; do
  parsed_domain=$(extract_domain "$url")
  if [ -n "$parsed_domain" ]; then
    # Resolve DNS com timeout para evitar travamentos
    ip=$(timeout 2 host "$parsed_domain" | awk '/has address/ {print $4}')
    if [ -n "$ip" ]; then
      echo -e "$i\t$ip\t$parsed_domain"
      ((i++))
    fi
  fi
done

# Limpeza
rm -f index.html robots.txt 2>/dev/null

echo "----------------------------------------"
echo "Processo concluído. Total de domínios: $((i-1))"