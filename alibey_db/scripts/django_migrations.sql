--
-- PostgreSQL database dump
--

-- Dumped from database version 17.4 (Debian 17.4-1.pgdg110+2)
-- Dumped by pg_dump version 17.4 (Debian 17.4-1.pgdg110+2)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Data for Name: django_migrations; Type: TABLE DATA; Schema: public; Owner: aplicacio_georef
--

COPY public.django_migrations (id, app, name, applied) FROM stdin;
1	contenttypes	0001_initial	2023-09-28 13:50:52.161273+00
2	auth	0001_initial	2023-09-28 13:50:52.383769+00
3	admin	0001_initial	2023-09-28 13:50:52.466803+00
4	admin	0002_logentry_remove_auto_add	2023-09-28 13:50:52.497766+00
5	contenttypes	0002_remove_content_type_name	2023-09-28 13:50:52.521697+00
6	auth	0002_alter_permission_name_max_length	2023-09-28 13:50:52.528828+00
7	auth	0003_alter_user_email_max_length	2023-09-28 13:50:52.54166+00
8	auth	0004_alter_user_username_opts	2023-09-28 13:50:52.551488+00
9	auth	0005_alter_user_last_login_null	2023-09-28 13:50:52.562334+00
10	auth	0006_require_contenttypes_0002	2023-09-28 13:50:52.564261+00
11	auth	0007_alter_validators_add_error_messages	2023-09-28 13:50:52.574233+00
12	auth	0008_alter_user_username_max_length	2023-09-28 13:50:52.595223+00
13	georef	0001_initial	2023-09-28 13:50:53.189571+00
14	georef_addenda	0001_initial	2023-09-28 13:50:53.487841+00
15	georef	0002_auto_20230928_1350	2023-09-28 13:50:54.370307+00
16	sessions	0001_initial	2023-09-28 13:50:54.429929+00
17	georef_addenda	0002_lookupdescription	2024-11-19 10:50:08.637692+00
18	georef_addenda	0003_lookupdescription_model_fully_qualified_name	2024-11-19 10:50:08.640622+00
19	georef_addenda	0004_auto_20241015_0933	2024-11-19 10:50:08.64332+00
20	georef_addenda	0005_auto_20241015_1153	2024-11-19 10:50:08.646027+00
21	georef_addenda	0003_auto_20241016_0711	2024-11-19 10:50:08.66242+00
22	georef_addenda	0004_auto_20241023_1427	2024-11-19 10:50:08.728243+00
23	georef_addenda	0005_init_geometry_extents	2024-11-19 10:50:30.058085+00
24	georef_addenda	0006_auto_20241106_1137	2024-11-19 10:50:30.08318+00
25	georef_addenda	0007_georeferenceprotocol	2024-11-19 10:50:30.108116+00
26	georef	0003_auto_20241106_1137	2024-11-19 10:50:30.189382+00
27	georef	0004_toponimversio_georeference_protocol	2024-11-19 10:50:30.267255+00
28	georef_addenda	0002_lookupdescription_squashed_0005_auto_20241015_1153	2024-11-19 10:50:30.27203+00
29	admin	0003_logentry_add_action_flag_choices	2025-03-25 09:42:06.226688+00
30	auth	0009_alter_user_last_name_max_length	2025-03-25 09:42:06.241201+00
31	auth	0010_alter_group_name_max_length	2025-03-25 09:42:06.262743+00
32	auth	0011_update_proxy_permissions	2025-03-25 09:42:06.274142+00
33	auth	0012_alter_user_first_name_max_length	2025-03-25 09:42:06.281732+00
\.


--
-- Name: django_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: aplicacio_georef
--

SELECT pg_catalog.setval('public.django_migrations_id_seq', 33, true);


--
-- PostgreSQL database dump complete
--

