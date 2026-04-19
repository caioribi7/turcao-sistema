-- ╔══════════════════════════════════════════════════════════════╗
-- ║  Schema do Lavagem do Turcão — Supabase (Postgres)           ║
-- ║  Cole este arquivo inteiro no SQL Editor do Supabase e rode. ║
-- ╚══════════════════════════════════════════════════════════════╝

CREATE TABLE IF NOT EXISTS clientes (
  id         TEXT PRIMARY KEY,
  nome       TEXT NOT NULL,
  tel        TEXT    DEFAULT '',
  cpf        TEXT    DEFAULT '',
  email      TEXT    DEFAULT '',
  obs        TEXT    DEFAULT '',
  veiculo    TEXT    DEFAULT '',
  placa      TEXT    DEFAULT '',
  carros     JSONB   DEFAULT '[]'::jsonb,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS vendas (
  id              TEXT PRIMARY KEY,
  "clienteId"     TEXT    DEFAULT '',
  "clienteNome"   TEXT    DEFAULT '',
  placa           TEXT    DEFAULT '',
  "modeloVeiculo" TEXT    DEFAULT '',
  tipo            TEXT    DEFAULT '',
  modal           TEXT    DEFAULT '',
  "modalNome"     TEXT    DEFAULT '',
  valor           NUMERIC DEFAULT 0,
  pagamento       TEXT    DEFAULT '',
  obs             TEXT    DEFAULT '',
  data            DATE,
  hora            TEXT    DEFAULT '',
  ts              BIGINT,
  created_at      TIMESTAMPTZ DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_vendas_data       ON vendas(data);
CREATE INDEX IF NOT EXISTS idx_vendas_pagamento  ON vendas(pagamento);
CREATE INDEX IF NOT EXISTS idx_vendas_cliente    ON vendas("clienteId");

CREATE TABLE IF NOT EXISTS funcionarios (
  id             TEXT PRIMARY KEY,
  nome           TEXT    DEFAULT '',
  funcao         TEXT    DEFAULT '',
  diaria         NUMERIC DEFAULT 0,
  "diariaSemana" NUMERIC DEFAULT 0,
  "diariaFds"    NUMERIC DEFAULT 0,
  created_at     TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS presencas (
  "funcionarioId" TEXT PRIMARY KEY,
  dados JSONB DEFAULT '{}'::jsonb
);

CREATE TABLE IF NOT EXISTS saidas (
  id         TEXT PRIMARY KEY,
  data       DATE,
  descricao  TEXT    DEFAULT '',
  valor      NUMERIC DEFAULT 0,
  categoria  TEXT    DEFAULT '',
  origem     TEXT    DEFAULT '',
  ref        TEXT    DEFAULT '',
  created_at TIMESTAMPTZ DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_saidas_data ON saidas(data);

CREATE TABLE IF NOT EXISTS config (
  key   TEXT PRIMARY KEY,
  value TEXT
);

CREATE TABLE IF NOT EXISTS backups (
  id        BIGSERIAL PRIMARY KEY,
  timestamp TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  versao    INTEGER     DEFAULT 3,
  payload   JSONB       NOT NULL
);

-- ── Segurança (RLS): só usuário autenticado acessa ────────────────
ALTER TABLE clientes      ENABLE ROW LEVEL SECURITY;
ALTER TABLE vendas        ENABLE ROW LEVEL SECURITY;
ALTER TABLE funcionarios  ENABLE ROW LEVEL SECURITY;
ALTER TABLE presencas     ENABLE ROW LEVEL SECURITY;
ALTER TABLE saidas        ENABLE ROW LEVEL SECURITY;
ALTER TABLE config        ENABLE ROW LEVEL SECURITY;
ALTER TABLE backups       ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS auth_all ON clientes;
DROP POLICY IF EXISTS auth_all ON vendas;
DROP POLICY IF EXISTS auth_all ON funcionarios;
DROP POLICY IF EXISTS auth_all ON presencas;
DROP POLICY IF EXISTS auth_all ON saidas;
DROP POLICY IF EXISTS auth_all ON config;
DROP POLICY IF EXISTS auth_all ON backups;

CREATE POLICY auth_all ON clientes      FOR ALL TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY auth_all ON vendas        FOR ALL TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY auth_all ON funcionarios  FOR ALL TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY auth_all ON presencas     FOR ALL TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY auth_all ON saidas        FOR ALL TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY auth_all ON config        FOR ALL TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY auth_all ON backups       FOR ALL TO authenticated USING (true) WITH CHECK (true);
