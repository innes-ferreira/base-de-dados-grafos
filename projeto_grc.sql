-- Projeto GRC
-- Conteúdos programáticos
-- Grafos e Redes Complexas

DROP DATABASE IF EXISTS projeto_grc;
CREATE DATABASE projeto_grc;
USE projeto_grc;

# 1. Classes, atributos e enumerados

CREATE TABLE disciplinas (
  sigla       char(4)                 PRIMARY KEY,           
  nome        varchar(80)             NOT NULL    UNIQUE,    
  descricao   text,                                          
  CHECK ((char_length(sigla) between 1 and 4))               
);


CREATE TABLE capitulos (
  disciplina  char(4)                 NOT NULL,             
  numero      tinyint unsigned        NOT NULL,             
  nome        varchar(100)            NOT NULL,              
  PRIMARY KEY (disciplina, numero),                          
  UNIQUE (disciplina, nome),                                
  FOREIGN KEY (disciplina)
    REFERENCES disciplinas (sigla), 
  CHECK ((numero >= 1)) 
);


CREATE TABLE conceitos (
  id                int unsigned              PRIMARY KEY      AUTO_INCREMENT,  
  nome              varchar(100)              NOT NULL,                         
  descricao         text                      NOT NULL,                        
  ordem             tinyint unsigned          NOT NULL,                         
  disciplina        char(4)                   NOT NULL,                         
  capitulo_numero   tinyint unsigned          NOT NULL,                        
  conceito_pai      int unsigned,                                              
  UNIQUE (disciplina, nome),                                                    
  FOREIGN KEY (disciplina, capitulo_numero)
    REFERENCES capitulos (disciplina, numero)
      ON UPDATE CASCADE                                                        
      ON DELETE CASCADE,                                                        
  FOREIGN KEY (conceito_pai)
    REFERENCES conceitos (id),                                                  
  CHECK ((ordem >= 1))                                                        
);

CREATE TABLE formatos_conceito (
  id          int unsigned            PRIMARY KEY      AUTO_INCREMENT,
  nome        varchar(80)             NOT NULL,                      
  conceito    int unsigned            NOT NULL,                      
  UNIQUE (conceito, nome),                                   
  FOREIGN KEY (conceito)
    REFERENCES conceitos (id)                                         
);


CREATE TABLE tipos_ferramenta (
  id          int unsigned            PRIMARY KEY      AUTO_INCREMENT, 
  nome        varchar(80)             NOT NULL        UNIQUE          
);

CREATE TABLE ferramentas (
  id               int unsigned            PRIMARY KEY      AUTO_INCREMENT,
  nome             varchar(80)             NOT NULL        UNIQUE,          
  descricao        text,                                                   
  tipo_ferramenta  int unsigned            NOT NULL,                       
  FOREIGN KEY (tipo_ferramenta)
    REFERENCES tipos_ferramenta (id)                                       
);


CREATE TABLE competencias (
  id            int unsigned            PRIMARY KEY      AUTO_INCREMENT, 
  nome          varchar(120)            NOT NULL        UNIQUE,          
  descricao     text                    NOT NULL,                        
  importancia   tinyint unsigned        NOT NULL,                      
  CHECK ((importancia between 1 and 5))                                  
);


#2. Associações muitos-para-muitos (M-para-N)


CREATE TABLE conceitos_competencias (
  conceito      int unsigned    NOT NULL,					 
  competencia   int unsigned    NOT NULL,                    
  PRIMARY KEY (conceito, competencia),
  FOREIGN KEY (conceito)
    REFERENCES conceitos (id),                               
  FOREIGN KEY (competencia)
    REFERENCES competencias (id)                            
);


CREATE TABLE ferramentas_competencias (
  ferramenta    int unsigned    NOT NULL,					
  competencia   int unsigned    NOT NULL,                  
  PRIMARY KEY (ferramenta, competencia),                    
  FOREIGN KEY (ferramenta)
    REFERENCES ferramentas (id),                           
  FOREIGN KEY (competencia)
    REFERENCES competencias (id)                            
);

-- 3. Associações recursivas


CREATE TABLE competencias_componentes (
  competencia_composta     int unsigned    NOT NULL,		  
  competencia_componente   int unsigned    NOT NULL,          
  PRIMARY KEY (competencia_composta, competencia_componente),  
  FOREIGN KEY (competencia_composta)
    REFERENCES competencias (id),                              
  FOREIGN KEY (competencia_componente)
    REFERENCES competencias (id)                             
);

-- --------------------------------------------------
-- 4. Dados

INSERT INTO disciplinas (sigla, nome, descricao)
VALUES
  ('GRC', 'Grafos e Redes Complexas', 'Estudo de grafos, redes e suas aplicações');

INSERT INTO capitulos (disciplina, numero, nome)
VALUES
  ('GRC', 1, 'Fundamentos de Grafos'),
  ('GRC', 2, 'Redes Complexas'),
  ('GRC', 3, 'Métricas de Redes'),
  ('GRC', 4, 'Aplicações de Redes');

INSERT INTO conceitos (nome, descricao, ordem, disciplina, capitulo_numero)
VALUES
  ('Grafo', 'Estrutura composta por vértices e arestas', 1, 'GRC', 1),
  ('Vértice', 'Elemento de um grafo', 2, 'GRC', 1),
  ('Aresta', 'Ligação entre dois vértices', 3, 'GRC', 1),
  ('Ordem do grafo', 'Número de vértices de um grafo', 4, 'GRC', 1),
  ('Tamanho do grafo', 'Número de arestas de um grafo', 5, 'GRC', 1),
  ('Grafo orientado', 'Grafo em que as arestas têm direção', 6, 'GRC', 1),
  ('Grafo subjacente', 'Grafo não orientado equivalente a um digrafo', 7, 'GRC', 1),
  ('Laço', 'Aresta que liga um vértice a si próprio', 8, 'GRC', 1),
  ('Multiaresta', 'Arestas múltiplas entre o mesmo par de vértices', 9, 'GRC', 1),
  ('Grafo simples', 'Grafo sem laços nem multiarestas', 10, 'GRC', 1),
  ('Grafo completo', 'Grafo em que todos os vértices são adjacentes entre si', 11, 'GRC', 1),
  ('Grafo complementar', 'Grafo obtido pelas arestas que faltam ao grafo completo', 12, 'GRC', 1),
  ('Vizinhança', 'Conjunto de vértices adjacentes a um vértice', 13, 'GRC', 1),
  ('Subgrafo', 'Grafo cujos vértices e arestas pertencem a outro grafo', 14, 'GRC', 1),
  ('Subgrafo induzido', 'Subgrafo com alguns vértices e todas as arestas entre eles', 15, 'GRC', 1),

  ('Subgrafo gerado', 'Subgrafo com todos os vértices e apenas algumas arestas', 1, 'GRC', 2),
  ('Grau', 'Número de arestas incidentes num vértice', 2, 'GRC', 2),
  ('Indegree', 'Número de arcos que entram num vértice', 3, 'GRC', 2),
  ('Outdegree', 'Número de arcos que saem de um vértice', 4, 'GRC', 2),
  ('Handshaking Lemma', 'Teorema que relaciona a soma dos graus com o dobro do número de arestas', 5, 'GRC', 2),
  ('Matriz de adjacência', 'Representação matricial da adjacência entre vértices', 6, 'GRC', 2),
  ('Matriz de incidência', 'Representação matricial da incidência vértice-aresta', 7, 'GRC', 2),
  ('Isomorfismo', 'Equivalência estrutural entre dois grafos', 8, 'GRC', 2),
  ('Sequência de graus', 'Lista não ascendente dos graus dos vértices', 9, 'GRC', 2),
  ('Lista gráfica', 'Sequência de inteiros que corresponde a um grafo', 10, 'GRC', 2),
  ('Havel-Hakimi', 'Teorema/algoritmo para verificar se uma sequência é gráfica', 11, 'GRC', 2),

  ('Passeio', 'Sequência de vértices e arestas num grafo', 1, 'GRC', 3),
  ('Trilho', 'Passeio com arestas distintas', 2, 'GRC', 3),
  ('Caminho', 'Trilho com vértices distintos', 3, 'GRC', 3),
  ('Circuito', 'Trilho fechado', 4, 'GRC', 3),
  ('Ciclo', 'Caminho fechado', 5, 'GRC', 3),
  ('Conectividade', 'Propriedade de existência de percurso entre vértices', 6, 'GRC', 3),
  ('Componente conexa', 'Subgrafo conexo maximal', 7, 'GRC', 3),
  ('Trilho Euleriano', 'Trilho que contém todas as arestas do grafo', 8, 'GRC', 3),
  ('Circuito Euleriano', 'Circuito que contém todas as arestas do grafo', 9, 'GRC', 3),
  ('Teorema de Euler', 'Critério para existência de trilhos e circuitos eulerianos', 10, 'GRC', 3),
  ('Algoritmo de Fleury', 'Algoritmo para determinar trilho ou circuito euleriano', 11, 'GRC', 3),
  ('BFS', 'Algoritmo de pesquisa em largura', 12, 'GRC', 3),
  ('Dijkstra', 'Algoritmo para caminhos mínimos em grafos ponderados', 13, 'GRC', 3),

  ('Árvore', 'Grafo conexo e acíclico', 1, 'GRC', 4),
  ('Floresta', 'Grafo cujas componentes conexas são árvores', 2, 'GRC', 4),
  ('Árvore geradora', 'Subgrafo gerado que é árvore', 3, 'GRC', 4),
  ('MST', 'Árvore geradora de custo mínimo', 4, 'GRC', 4),
  ('Kruskal', 'Algoritmo para obter uma árvore geradora mínima', 5, 'GRC', 4),
  ('Prim', 'Algoritmo para obter uma árvore geradora mínima', 6, 'GRC', 4),
  ('BFS Tree', 'Árvore obtida a partir da BFS', 7, 'GRC', 4),
  ('Fluxo máximo', 'Valor máximo de fluxo de uma origem para um destino numa rede', 8, 'GRC', 4),
  ('Corte mínimo', 'Corte de capacidade mínima associado ao fluxo máximo', 9, 'GRC', 4),
  ('Densidade', 'Razão entre o número de arestas existentes e o número máximo possível', 10, 'GRC', 4),
  ('Excentricidade', 'Maior distância de um vértice aos restantes', 11, 'GRC', 4),
  ('Raio', 'Menor excentricidade do grafo', 12, 'GRC', 4),
  ('Diâmetro', 'Maior excentricidade do grafo', 13, 'GRC', 4),
  ('Centro', 'Conjunto dos vértices com excentricidade igual ao raio', 14, 'GRC', 4),
  ('Periferia', 'Conjunto dos vértices com excentricidade igual ao diâmetro', 15, 'GRC', 4),
  ('Clustering coefficient', 'Medida de densidade local e global em redes', 16, 'GRC', 4),
  ('Centralidade de grau', 'Centralidade baseada no grau do vértice', 17, 'GRC', 4),
  ('Centralidade de proximidade', 'Centralidade baseada na distância média aos outros vértices', 18, 'GRC', 4),
  ('Centralidade de intermediação', 'Centralidade baseada na passagem por caminhos mais curtos', 19, 'GRC', 4),
  ('Comunidades', 'Grupos de vértices mais ligados entre si do que ao resto da rede', 20, 'GRC', 4),
  ('Girvan-Newman', 'Algoritmo de deteção de comunidades', 21, 'GRC', 4),
  ('Assortatividade', 'Medida de preferência de ligação entre vértices por grau ou atributo', 22, 'GRC', 4);

INSERT INTO formatos_conceito (nome, conceito)
VALUES
  ('Orientado', 6),
  ('Não orientado', 1),
  ('Simples', 10),
  ('Completo', 11),
  ('Matriz', 21),
  ('Algoritmo', 38),
  ('Algoritmo', 39),
  ('Métrica', 57),
  ('Métrica', 58),
  ('Métrica', 59);

INSERT INTO tipos_ferramenta (nome)
VALUES
  ('Software'),
  ('Linguagem'),
  ('Biblioteca');

INSERT INTO ferramentas (nome, descricao, tipo_ferramenta)
VALUES
  ('Python', 'Linguagem de programação', 2),
  ('NetworkX', 'Biblioteca de grafos', 3),
  ('Gephi', 'Software de visualização de redes', 1);

INSERT INTO competencias (nome, descricao, importancia)
VALUES
  ('Aplicar conceitos fundamentais de grafos', 'Capacidade para reconhecer e aplicar os conceitos base de grafos e redes.', 5),
  ('Representar grafos através de matrizes', 'Capacidade para representar grafos usando matrizes de adjacência e de incidência.', 5),
  ('Analisar caminhos, trilhos e ciclos', 'Capacidade para distinguir e analisar percursos em grafos.', 4),
  ('Aplicar algoritmos de pesquisa em grafos', 'Capacidade para executar algoritmos como BFS e Dijkstra.', 5),
  ('Calcular métricas de centralidade', 'Capacidade para determinar medidas de centralidade em redes.', 4),
  ('Analisar estrutura de redes', 'Capacidade para estudar conectividade, componentes, densidade e outras propriedades estruturais.', 4),
  ('Modelar problemas com grafos', 'Capacidade para representar problemas reais através de grafos e redes.', 5),
  ('Utilizar Python', 'Capacidade para usar a linguagem Python no contexto da análise de grafos e redes.', 4),
  ('Utilizar NetworkX', 'Capacidade para usar a biblioteca NetworkX na modelação e análise de grafos.', 4),
  ('Utilizar Gephi', 'Capacidade para usar o software Gephi na visualização de redes.', 3),
  ('Analisar redes com Python e NetworkX', 'Capacidade composta que conjuga a utilização de Python com a utilização de NetworkX para analisar redes.', 5),
  ('Visualizar comunidades em Gephi', 'Capacidade composta que conjuga a deteção de comunidades com a utilização do Gephi para visualização.', 4);

INSERT INTO conceitos_competencias
VALUES
  (1, 1), (2, 1), (3, 1), (10, 1), (11, 1),
  (21, 2), (22, 2),
  (27, 3), (28, 3), (29, 3), (30, 3), (31, 3), (34, 3), (35, 3),
  (38, 4), (39, 4), (47, 4),
  (57, 5), (58, 5), (59, 5),
  (32, 6), (33, 6), (50, 6), (51, 6), (52, 6), (53, 6), (54, 6), (55, 6), (56, 6),
  (40, 7), (41, 7), (42, 7), (43, 7), (48, 7), (49, 7);
  
INSERT INTO ferramentas_competencias
VALUES
  (1, 8),
  (2, 9),
  (3, 10);

INSERT INTO competencias_componentes
VALUES
  (11, 7),
  (11, 8),
  (11, 9),
  (12, 10),
  (12, 6);

###########################################################
# 2ª fase projeto 

#Adaptações
#foram feitos inserts para existirem conceitos com mais do que 1 formato para testar a Q4
INSERT INTO formatos_conceito (nome, conceito)
VALUES
('Representação Visual', 21),
('Representação em Lista', 21);

# Foi adicionada uma nova disciplina com o conceito "Grafo",
# permitindo validar a Q5 do enunciado.
INSERT INTO disciplinas (sigla, nome, descricao)
VALUES
('ARS', 'Análise de Redes Sociais', 'Disciplina complementar sobre análise de redes sociais.');

INSERT INTO capitulos (disciplina, numero, nome)
VALUES
('ARS', 1, 'Fundamentos de Redes Sociais');

INSERT INTO conceitos (nome, descricao, ordem, disciplina, capitulo_numero)
VALUES
('Grafo', 'Estrutura usada para representar relações entre entidades numa rede social.', 1, 'ARS', 1);

# Q1 

DROP VIEW IF EXISTS vw_competencias_grc; 

CREATE VIEW vw_competencias_grc AS 
SELECT DISTINCT comp.nome AS competencia, 
       CASE  
           WHEN cc.competencia_composta IS NOT NULL THEN 'mista' 
           WHEN fc.competencia IS NOT NULL THEN 'de ferramenta' 
           ELSE 'de conceito' 
       END AS tipo_competencia
FROM competencias comp
LEFT JOIN competencias_componentes cc 
       ON comp.id = cc.competencia_composta
LEFT JOIN ferramentas_competencias fc 
       ON comp.id = fc.competencia
WHERE comp.id IN (
    SELECT ccomp.competencia
    FROM disciplinas d
    JOIN capitulos cap
         ON d.sigla = cap.disciplina
    JOIN conceitos c
         ON cap.disciplina = c.disciplina
        AND cap.numero = c.capitulo_numero
    JOIN conceitos_competencias ccomp
         ON c.id = ccomp.conceito
    WHERE d.nome = 'Grafos e Redes Complexas'
) 
OR comp.id IN (
    SELECT cc.competencia_composta
    FROM competencias_componentes cc
) 
OR comp.id IN (
    SELECT cc.competencia_componente
    FROM competencias_componentes cc
);

#teste 
SELECT *
FROM vw_competencias_grc
ORDER BY competencia;

# Q2 

SELECT d.nome AS disciplina,
       COUNT(c.id) AS quantidade_conceitos 
FROM disciplinas d
LEFT JOIN conceitos c ON d.sigla = c.disciplina 
GROUP BY d.sigla, d.nome 
ORDER BY d.nome; 

# Q3 

SELECT cap.numero AS numero_capitulo,
       cap.nome AS capitulo,
       COUNT(c.id) AS quantidade_conceitos 
FROM capitulos cap
LEFT JOIN conceitos c
       ON cap.disciplina = c.disciplina
      AND cap.numero = c.capitulo_numero
WHERE cap.disciplina = 'GRC' 
GROUP BY cap.numero, cap.nome
ORDER BY cap.numero; 

# Q4 

SELECT COUNT(*) AS quantidade_conceitos_com_mais_de_um_formato 
FROM (
    SELECT conceito
    FROM formatos_conceito
    GROUP BY conceito 
    HAVING COUNT(*) > 1 
) AS conceitos_com_varios_formatos;

# Q5

SELECT c.nome AS conceito, 
       d.nome AS disciplina 
FROM conceitos c 
JOIN disciplinas d
     ON c.disciplina = d.sigla 
WHERE c.nome IN ( 
    SELECT nome
    FROM conceitos
    GROUP BY nome
    HAVING COUNT(DISTINCT disciplina) > 1
) 
ORDER BY c.nome, d.nome; 

# Q6 - Listar as competências mistas e as competências/componentes 
#      que fazem parte da sua composição.

SELECT cm.nome AS competencia_mista, 
       cc.nome AS competencia_componente
FROM competencias_componentes ccomp
JOIN competencias cm
     ON ccomp.competencia_composta = cm.id 
JOIN competencias cc
     ON ccomp.competencia_componente = cc.id 
ORDER BY cm.nome, cc.nome; 


# Q7 - Indicar, para cada capítulo da disciplina Grafos e Redes Complexas, 
#      quantas competências distintas estão associadas aos seus conceitos.

SELECT cap.numero AS numero_capitulo,
       cap.nome AS capitulo,
       COUNT(DISTINCT c.id) AS quantidade_conceitos,
       COUNT(DISTINCT cc.competencia) AS quantidade_competencias
FROM capitulos cap
LEFT JOIN conceitos c
       ON cap.disciplina = c.disciplina
      AND cap.numero = c.capitulo_numero
LEFT JOIN conceitos_competencias cc
       ON c.id = cc.conceito
WHERE cap.disciplina = 'GRC' 
GROUP BY cap.numero, cap.nome 
ORDER BY cap.numero;

# Q8 - Listar as competências cuja importância é 
#      superior à importância média de todas as competências registadas.

SELECT nome AS competencia,  
       importancia            
FROM competencias
WHERE importancia > (
    SELECT AVG(importancia) 
    FROM competencias       
)
ORDER BY importancia DESC, nome; 

# F1 

DROP FUNCTION IF EXISTS tipo_competencia;

DELIMITER $$
CREATE FUNCTION tipo_competencia (_nome_competencia varchar(120))
RETURNS char(1)
READS SQL DATA
BEGIN
    DECLARE _id_competencia int unsigned;
    DECLARE _tipo char(1);
    SELECT id INTO _id_competencia
    FROM competencias
    WHERE nome = _nome_competencia;
    IF _id_competencia IS NULL THEN
        SET _tipo = NULL;
    ELSEIF EXISTS (
        SELECT * FROM competencias_componentes
        WHERE competencia_composta = _id_competencia
    ) THEN
        SET _tipo = 'M';
    ELSEIF EXISTS (
        SELECT * FROM ferramentas_competencias
        WHERE competencia = _id_competencia
    ) THEN
        SET _tipo = 'F';
    ELSEIF EXISTS (
        SELECT * FROM conceitos_competencias
        WHERE competencia = _id_competencia
    ) THEN
        SET _tipo = 'C';
    ELSE
        SET _tipo = 'B';
    END IF;
    RETURN _tipo;
END$$
DELIMITER ;

#para testar 
SELECT tipo_competencia('Utilizar Python');
SELECT tipo_competencia('Aplicar algoritmos de pesquisa em grafos');
SELECT tipo_competencia('Analisar redes com Python e NetworkX');
SELECT tipo_competencia('Competência inexistente');

# P1 

DROP PROCEDURE IF EXISTS registar_competencia_mista;
DELIMITER $$ 

CREATE PROCEDURE registar_competencia_mista (
    IN _competencia1 varchar(120), 
    IN _competencia2 varchar(120)  
)
BEGIN
    DECLARE _id_comp1 int unsigned;       
    DECLARE _id_comp2 int unsigned;      
    DECLARE _id_nova int unsigned;    
    DECLARE _nome_nova varchar(120);   
    DECLARE _nome_ferramenta varchar(80); 
    DECLARE _importancia tinyint unsigned;

    SET _id_comp1 = (SELECT id FROM competencias WHERE nome = _competencia1);
    SET _id_comp2 = (SELECT id FROM competencias WHERE nome = _competencia2);

    IF tipo_competencia(_competencia2) = 'F' THEN 
        SET _nome_ferramenta = (
            SELECT f.nome
            FROM ferramentas f
            JOIN ferramentas_competencias fc ON f.id = fc.ferramenta
            WHERE fc.competencia = _id_comp2
            LIMIT 1 
        );
        SET _nome_nova = concat(_competencia1, ', usando ', _nome_ferramenta);
    ELSE
        SET _nome_nova = concat(_competencia1, ' e ', _competencia2);
    END IF;

    SET _importancia = (
        SELECT greatest(c1.importancia, c2.importancia) 
        FROM competencias c1, competencias c2
        WHERE c1.id = _id_comp1
          AND c2.id = _id_comp2
    );

    INSERT INTO competencias (nome, descricao, importancia)
    VALUES (
        _nome_nova,
        concat('Competência mista resultante da combinação de "',
               _competencia1, '" com "', _competencia2, '".'),
        _importancia
    );

    SET _id_nova = last_insert_id(); 

    INSERT INTO competencias_componentes
    VALUES
    (_id_nova, _id_comp1),
    (_id_nova, _id_comp2);
END
$$
DELIMITER ; 

#teste 
CALL registar_competencia_mista(
    'Calcular métricas de centralidade',
    'Utilizar Python'
);

#confirmação que criou também as componentes
SELECT *
FROM competencias
WHERE nome = 'Calcular métricas de centralidade, usando Python';

SELECT cm.nome AS competencia_mista,
       cc.nome AS competencia_componente
FROM competencias_componentes ccomp
JOIN competencias cm
     ON ccomp.competencia_composta = cm.id
JOIN competencias cc
     ON ccomp.competencia_componente = cc.id
WHERE cm.id = 13;

# T1

DROP TRIGGER IF EXISTS preencher_numero_capitulo;
DELIMITER $$ 

CREATE TRIGGER preencher_numero_capitulo
BEFORE INSERT ON capitulos 
FOR EACH ROW              
BEGIN
    IF NEW.numero IS NULL THEN 
        SET NEW.numero = (
            SELECT IFNULL(MAX(numero), 0) + 1
            FROM capitulos
            WHERE disciplina = NEW.disciplina
            
        );
    END IF; 
END
$$
DELIMITER ; 

#teste 
DELETE FROM capitulos WHERE disciplina = 'ARS' AND nome = 'Aplicações de Redes Sociais';
INSERT INTO capitulos (disciplina, numero, nome)
VALUES ('ARS', NULL, 'Aplicações de Redes Sociais');

SELECT *
FROM capitulos
WHERE disciplina = 'ARS'
ORDER BY numero;