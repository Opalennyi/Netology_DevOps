--
-- PostgreSQL database dump
--

-- Dumped from database version 12.11 (Debian 12.11-1.pgdg110+1)
-- Dumped by pg_dump version 12.11 (Debian 12.11-1.pgdg110+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: test_db; Type: SCHEMA; Schema: -; Owner: test-admin-user
--

CREATE SCHEMA test_db;


ALTER SCHEMA test_db OWNER TO "test-admin-user";

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: clients; Type: TABLE; Schema: test_db; Owner: test-admin-user
--

CREATE TABLE test_db.clients (
    id integer NOT NULL,
    surname character varying(50),
    country character varying(35),
    order_id integer
);


ALTER TABLE test_db.clients OWNER TO "test-admin-user";

--
-- Name: clients_id_seq; Type: SEQUENCE; Schema: test_db; Owner: test-admin-user
--

CREATE SEQUENCE test_db.clients_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE test_db.clients_id_seq OWNER TO "test-admin-user";

--
-- Name: clients_id_seq; Type: SEQUENCE OWNED BY; Schema: test_db; Owner: test-admin-user
--

ALTER SEQUENCE test_db.clients_id_seq OWNED BY test_db.clients.id;


--
-- Name: orders; Type: TABLE; Schema: test_db; Owner: test-admin-user
--

CREATE TABLE test_db.orders (
    id integer NOT NULL,
    name character varying(100),
    price integer
);


ALTER TABLE test_db.orders OWNER TO "test-admin-user";

--
-- Name: orders_id_seq; Type: SEQUENCE; Schema: test_db; Owner: test-admin-user
--

CREATE SEQUENCE test_db.orders_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE test_db.orders_id_seq OWNER TO "test-admin-user";

--
-- Name: orders_id_seq; Type: SEQUENCE OWNED BY; Schema: test_db; Owner: test-admin-user
--

ALTER SEQUENCE test_db.orders_id_seq OWNED BY test_db.orders.id;


--
-- Name: clients id; Type: DEFAULT; Schema: test_db; Owner: test-admin-user
--

ALTER TABLE ONLY test_db.clients ALTER COLUMN id SET DEFAULT nextval('test_db.clients_id_seq'::regclass);


--
-- Name: orders id; Type: DEFAULT; Schema: test_db; Owner: test-admin-user
--

ALTER TABLE ONLY test_db.orders ALTER COLUMN id SET DEFAULT nextval('test_db.orders_id_seq'::regclass);


--
-- Data for Name: clients; Type: TABLE DATA; Schema: test_db; Owner: test-admin-user
--

COPY test_db.clients (id, surname, country, order_id) FROM stdin;
4	Ронни Джеймс Дио	Russia	\N
5	Ritchie Blackmore	Russia	\N
1	Иванов Иван Иванович	USA	3
2	Петров Петр Петрович	Canada	4
3	Иоганн Себастьян Бах	Japan	5
\.


--
-- Data for Name: orders; Type: TABLE DATA; Schema: test_db; Owner: test-admin-user
--

COPY test_db.orders (id, name, price) FROM stdin;
1	Шоколад	10
2	Принтер	3000
3	Книга	500
4	Монитор	7000
5	Гитара	4000
\.


--
-- Name: clients_id_seq; Type: SEQUENCE SET; Schema: test_db; Owner: test-admin-user
--

SELECT pg_catalog.setval('test_db.clients_id_seq', 5, true);


--
-- Name: orders_id_seq; Type: SEQUENCE SET; Schema: test_db; Owner: test-admin-user
--

SELECT pg_catalog.setval('test_db.orders_id_seq', 5, true);


--
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: test_db; Owner: test-admin-user
--

ALTER TABLE ONLY test_db.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id);


--
-- Name: country_index; Type: INDEX; Schema: test_db; Owner: test-admin-user
--

CREATE INDEX country_index ON test_db.clients USING hash (country);


--
-- Name: clients clients_order_id_fkey; Type: FK CONSTRAINT; Schema: test_db; Owner: test-admin-user
--

ALTER TABLE ONLY test_db.clients
    ADD CONSTRAINT clients_order_id_fkey FOREIGN KEY (order_id) REFERENCES test_db.orders(id);


--
-- Name: TABLE clients; Type: ACL; Schema: test_db; Owner: test-admin-user
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE test_db.clients TO "test-simple-user";


--
-- Name: TABLE orders; Type: ACL; Schema: test_db; Owner: test-admin-user
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE test_db.orders TO "test-simple-user";


--
-- PostgreSQL database dump complete
--

