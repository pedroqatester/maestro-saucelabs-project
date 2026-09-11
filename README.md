# maestro-saucelabs-project

Projeto de automação de testes mobile com [Maestro](https://maestro.mobile.dev/), utilizando o app de demonstração oficial da Sauce Labs ([My Demo App](https://github.com/saucelabs/my-demo-app-rn)) como alvo de testes.

Desenvolvido com foco em boas práticas de QA: isolamento de testes, reutilização de commands, suporte a múltiplas plataformas (Android e iOS) e execução via CI/CD.

---

## Tecnologias

- [Maestro](https://maestro.mobile.dev/) — framework de automação mobile
- Android Emulator + iOS Simulator
- GitHub Actions — pipeline de CI/CD
- Shell Script — execução local parametrizada

---

## Estrutura do projeto
maestro-saucelabs-project/
├── .maestro/
│ ├── commands/
│ │ ├── login.yaml
│ │ ├── login_android.yaml
│ │ ├── login_ios.yaml
│ │ ├── open_menu.yaml
│ │ └── add_product_to_cart.yaml
│ ├── flows/
│ │ ├── login/
│ │ │ ├── smoke/
│ │ │ │ └── login_success.yaml
│ │ │ └── negative/
│ │ │ ├── login_invalid_credentials.yaml
│ │ │ └── login_locked_user.yaml
│ │ ├── catalog/
│ │ │ └── smoke/
│ │ │ └── browse_and_add_to_cart_guest.yaml
│ │ └── checkout/
│ │ └── negative/
│ │ └── checkout_requires_login.yaml
│ └── config.yaml
├── .github/
│ └── workflows/
│ └── maestro-ci.yml
├── run_tests.sh
├── .env.example
├── .gitignore
└── README.md

---

## Pré-requisitos

- [Maestro CLI](https://maestro.mobile.dev/getting-started/installing-maestro) instalado
- Android: emulador configurado e rodando (`adb devices` deve listar o dispositivo)
- iOS: Xcode com simulador configurado (macOS)
- App instalado nos dispositivos: [Sauce Labs My Demo App](https://github.com/saucelabs/my-demo-app-rn/releases)

---

## Configuração

1. Clone o repositório:

```bash
git clone git@github-pessoal:pedroqatester/maestro-saucelabs-project.git
cd maestro-saucelabs-project
```

2. Crie o arquivo `.env` com base no exemplo:

```bash
cp .env.example .env
```

3. Preencha as variáveis no `.env`:


4. Dê permissão de execução ao script:

```bash
chmod +x run_tests.sh
```

---

## Como rodar os testes

### Suíte completa por plataforma e tag

```bash
# Android
./run_tests.sh android login
./run_tests.sh android smoke
./run_tests.sh android regression

# iOS
./run_tests.sh ios login
./run_tests.sh ios smoke
```

### Flow específico

```bash
# Android
./run_tests.sh android "" login/negative/login_locked_user.yaml

# iOS
./run_tests.sh ios "" login/smoke/login_success.yaml
```

### Padrão (android + smoke)

```bash
./run_tests.sh
```

---

## Flows implementados

| Flow | Área | Tipo | Plataformas |
|---|---|---|---|
| `login_success` | Login | Smoke | Android, iOS |
| `login_invalid_credentials` | Login | Negative | Android, iOS |
| `login_locked_user` | Login | Negative | Android, iOS |
| `browse_and_add_to_cart_guest` | Catalog | Smoke | Android, iOS |
| `checkout_requires_login` | Checkout | Negative | Android, iOS |

---

## Decisões técnicas

**Separação de commands por plataforma**
Android e iOS expõem os elementos de forma diferente na árvore de acessibilidade. A abertura do menu (`open_menu.yaml`) e o preenchimento do formulário de login (`login_android.yaml` / `login_ios.yaml`) são separados por plataforma, enquanto o `login.yaml` permanece como ponto de entrada único — roteando para a implementação correta via `runFlow/when/platform`.

**`clearState: true` em todos os flows**
Garante isolamento completo entre execuções: sessão de login, carrinho e estado do app são resetados antes de cada flow, independente da ordem de execução.

**`clearText` antes de `inputText`**
O iOS mantém conteúdo residual nos campos de input entre execuções do simulador. O `clearText` garante que cada `inputText` começa com o campo limpo.

**Variáveis de ambiente centralizadas**
Credenciais e dados de teste ficam no `.env` local (nunca commitado). Em CI/CD, as mesmas variáveis são injetadas via GitHub Secrets.

---

## CI/CD

Os testes rodam automaticamente via GitHub Actions a cada push ou pull request na branch `main`. O workflow está configurado em `.github/workflows/maestro-ci.yml`.

---

## Autor

**Pedro Pereira** — QA Engineer
[LinkedIn](https://www.linkedin.com/in/pedro-pereira-qatester) · [GitHub](https://github.com/pedroqatester)