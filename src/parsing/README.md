# PARSING.SH

Um script em Bash para extrair e resolver domínios de URLs a partir de uma página HTML.

## Pré-requisitos

- **bash**
- **wget**
- **host**
- **grep**
- **awk**
- **toilet** (opcional, para o banner)

## Instalação

Clone o repositório:
   ```bash
   git clone git@github.com:apolinario0x21/myToolsPlayground.git
```

## Navegue até o diretório do projeto:

```bash
cd myToolsPlayground/src
```

## Permissão de execução ao script:

```bash
chmod +x parsing.sh
```

## Funcionalidades
- Baixa a página HTML do domínio fornecido.
- Extrai todos os links da página HTML.
- Resolve os endereços IP dos domínios dos links.
- Exibe os resultados em formato de tabela.

## 🛠️ Como Usar
Execute o script passando o domínio como argumento:

```bash
./parsing.sh www.exemplo.com
```

## Exemplo de Saída

| Line | IP            | ADDRESS                |
|------|---------------|------------------------|
| 1    | ```IP``` | example.com            |
| 2    | ```IP```      | subdominio.exemplo.com |
| 3    | ```IP``` | test.exemplo.com       |




Feito com ❤️ por ```apolinario0x21```