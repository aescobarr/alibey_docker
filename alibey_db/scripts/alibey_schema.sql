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
-- Name: sipan_mbibliografia; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA sipan_mbibliografia;


ALTER SCHEMA sipan_mbibliografia OWNER TO postgres;

--
-- Name: sipan_mcartografia; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA sipan_mcartografia;


ALTER SCHEMA sipan_mcartografia OWNER TO postgres;

--
-- Name: sipan_mgeneral; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA sipan_mgeneral;


ALTER SCHEMA sipan_mgeneral OWNER TO postgres;

--
-- Name: sipan_mgeoreferenciacio; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA sipan_mgeoreferenciacio;


ALTER SCHEMA sipan_mgeoreferenciacio OWNER TO postgres;

--
-- Name: sipan_mmedia; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA sipan_mmedia;


ALTER SCHEMA sipan_mmedia OWNER TO postgres;

--
-- Name: sipan_mseguretat; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA sipan_mseguretat;


ALTER SCHEMA sipan_mseguretat OWNER TO postgres;

--
-- Name: sipan_msipan; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA sipan_msipan;


ALTER SCHEMA sipan_msipan OWNER TO postgres;

--
-- Name: sipan_mtaxons; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA sipan_mtaxons;


ALTER SCHEMA sipan_mtaxons OWNER TO postgres;

--
-- Name: sipan_mzoologia; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA sipan_mzoologia;


ALTER SCHEMA sipan_mzoologia OWNER TO postgres;

--
-- Name: topology; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA topology;


ALTER SCHEMA topology OWNER TO postgres;

--
-- Name: SCHEMA topology; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA topology IS 'PostGIS Topology schema';


--
-- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;


--
-- Name: EXTENSION pg_trgm; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';


--
-- Name: postgis; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;


--
-- Name: EXTENSION postgis; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis IS 'PostGIS geometry, geography, and raster spatial types and functions';


--
-- Name: postgis_topology; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis_topology WITH SCHEMA topology;


--
-- Name: EXTENSION postgis_topology; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis_topology IS 'PostGIS topology spatial types and functions';


--
-- Name: affine(public.geometry, double precision, double precision, double precision, double precision, double precision, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.affine(public.geometry, double precision, double precision, double precision, double precision, double precision, double precision) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT st_affine($1,  $2, $3, 0,  $4, $5, 0,  0, 0, 1,  $6, $7, 0)$_$;


ALTER FUNCTION public.affine(public.geometry, double precision, double precision, double precision, double precision, double precision, double precision) OWNER TO postgres;

--
-- Name: asgml(public.geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.asgml(public.geometry) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_AsGML(2, $1, 15, 0, null, null)$_$;


ALTER FUNCTION public.asgml(public.geometry) OWNER TO postgres;

--
-- Name: asgml(public.geometry, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.asgml(public.geometry, integer) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_AsGML(2, $1, $2, 0, null, null)$_$;


ALTER FUNCTION public.asgml(public.geometry, integer) OWNER TO postgres;

--
-- Name: askml(public.geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.askml(public.geometry) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_AsKML(2, ST_Transform($1,4326), 15, null)$_$;


ALTER FUNCTION public.askml(public.geometry) OWNER TO postgres;

--
-- Name: askml(public.geometry, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.askml(public.geometry, integer) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_AsKML(2, ST_transform($1,4326), $2, null)$_$;


ALTER FUNCTION public.askml(public.geometry, integer) OWNER TO postgres;

--
-- Name: askml(integer, public.geometry, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.askml(integer, public.geometry, integer) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_AsKML($1, ST_Transform($2,4326), $3, null)$_$;


ALTER FUNCTION public.askml(integer, public.geometry, integer) OWNER TO postgres;

--
-- Name: bdmpolyfromtext(text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.bdmpolyfromtext(text, integer) RETURNS public.geometry
    LANGUAGE plpgsql IMMUTABLE STRICT
    AS $_$
DECLARE
	geomtext alias for $1;
	srid alias for $2;
	mline geometry;
	geom geometry;
BEGIN
	mline := ST_MultiLineStringFromText(geomtext, srid);

	IF mline IS NULL
	THEN
		RAISE EXCEPTION 'Input is not a MultiLinestring';
	END IF;

	geom := ST_Multi(ST_BuildArea(mline));

	RETURN geom;
END;
$_$;


ALTER FUNCTION public.bdmpolyfromtext(text, integer) OWNER TO postgres;

--
-- Name: bdpolyfromtext(text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.bdpolyfromtext(text, integer) RETURNS public.geometry
    LANGUAGE plpgsql IMMUTABLE STRICT
    AS $_$
DECLARE
	geomtext alias for $1;
	srid alias for $2;
	mline geometry;
	geom geometry;
BEGIN
	mline := ST_MultiLineStringFromText(geomtext, srid);

	IF mline IS NULL
	THEN
		RAISE EXCEPTION 'Input is not a MultiLinestring';
	END IF;

	geom := ST_BuildArea(mline);

	IF GeometryType(geom) != 'POLYGON'
	THEN
		RAISE EXCEPTION 'Input returns more then a single polygon, try using BdMPolyFromText instead';
	END IF;

	RETURN geom;
END;
$_$;


ALTER FUNCTION public.bdpolyfromtext(text, integer) OWNER TO postgres;

--
-- Name: buffer(public.geometry, double precision, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.buffer(public.geometry, double precision, integer) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT ST_Buffer($1, $2, $3)$_$;


ALTER FUNCTION public.buffer(public.geometry, double precision, integer) OWNER TO postgres;

--
-- Name: copiacampsversio(character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.copiacampsversio(idversio0 character varying, idversio1 character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	UPDATE sipan_mgeoreferenciacio.toponimversio SET coordenada_x_origen=(SELECT coordenada_x_origen FROM 

sipan_mgeoreferenciacio.toponimversio WHERE id=idVersio0) 		WHERE id=idVersio1;

	UPDATE sipan_mgeoreferenciacio.toponimversio SET coordenada_y_origen=(SELECT coordenada_y_origen FROM 

sipan_mgeoreferenciacio.toponimversio WHERE id=idVersio0) 		WHERE id=idVersio1;

	UPDATE sipan_mgeoreferenciacio.toponimversio SET idrecursgeoref=(SELECT idrecursgeoref FROM 

sipan_mgeoreferenciacio.toponimversio WHERE id=idVersio0) 				WHERE id=idVersio1;

	DELETE FROM sipan_mgeoreferenciacio.toponimversio WHERE id=idVersio0;
END;
$$;


ALTER FUNCTION public.copiacampsversio(idversio0 character varying, idversio1 character varying) OWNER TO postgres;

--
-- Name: find_extent(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.find_extent(text, text) RETURNS public.box2d
    LANGUAGE plpgsql IMMUTABLE STRICT
    AS $_$
DECLARE
	tablename alias for $1;
	columnname alias for $2;
	myrec RECORD;

BEGIN
	FOR myrec IN EXECUTE 'SELECT ST_Extent("' || columnname || '") As extent FROM "' || tablename || '"' LOOP
		return myrec.extent;
	END LOOP;
END;
$_$;


ALTER FUNCTION public.find_extent(text, text) OWNER TO postgres;

--
-- Name: find_extent(text, text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.find_extent(text, text, text) RETURNS public.box2d
    LANGUAGE plpgsql IMMUTABLE STRICT
    AS $_$
DECLARE
	schemaname alias for $1;
	tablename alias for $2;
	columnname alias for $3;
	myrec RECORD;

BEGIN
	FOR myrec IN EXECUTE 'SELECT ST_Extent("' || columnname || '") FROM "' || schemaname || '"."' || tablename || '" As extent ' LOOP
		return myrec.extent;
	END LOOP;
END;
$_$;


ALTER FUNCTION public.find_extent(text, text, text) OWNER TO postgres;

--
-- Name: fix_geometry_columns(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fix_geometry_columns() RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
	mislinked record;
	result text;
	linked integer;
	deleted integer;
	foundschema integer;
BEGIN

	-- Since 7.3 schema support has been added.
	-- Previous postgis versions used to put the database name in
	-- the schema column. This needs to be fixed, so we try to
	-- set the correct schema for each geometry_colums record
	-- looking at table, column, type and srid.
	
	return 'This function is obsolete now that geometry_columns is a view';

END;
$$;


ALTER FUNCTION public.fix_geometry_columns() OWNER TO postgres;

--
-- Name: geomcollfromtext(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.geomcollfromtext(text) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE
	WHEN geometrytype(GeomFromText($1)) = 'GEOMETRYCOLLECTION'
	THEN GeomFromText($1)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.geomcollfromtext(text) OWNER TO postgres;

--
-- Name: geomcollfromtext(text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.geomcollfromtext(text, integer) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE
	WHEN geometrytype(GeomFromText($1, $2)) = 'GEOMETRYCOLLECTION'
	THEN GeomFromText($1,$2)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.geomcollfromtext(text, integer) OWNER TO postgres;

--
-- Name: geomcollfromwkb(bytea); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.geomcollfromwkb(bytea) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE
	WHEN geometrytype(GeomFromWKB($1)) = 'GEOMETRYCOLLECTION'
	THEN GeomFromWKB($1)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.geomcollfromwkb(bytea) OWNER TO postgres;

--
-- Name: geomcollfromwkb(bytea, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.geomcollfromwkb(bytea, integer) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE
	WHEN geometrytype(GeomFromWKB($1, $2)) = 'GEOMETRYCOLLECTION'
	THEN GeomFromWKB($1, $2)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.geomcollfromwkb(bytea, integer) OWNER TO postgres;

--
-- Name: geomfromtext(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.geomfromtext(text) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT ST_GeomFromText($1)$_$;


ALTER FUNCTION public.geomfromtext(text) OWNER TO postgres;

--
-- Name: geomfromtext(text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.geomfromtext(text, integer) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT ST_GeomFromText($1, $2)$_$;


ALTER FUNCTION public.geomfromtext(text, integer) OWNER TO postgres;

--
-- Name: geomfromwkb(bytea, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.geomfromwkb(bytea, integer) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT ST_SetSRID(ST_GeomFromWKB($1), $2)$_$;


ALTER FUNCTION public.geomfromwkb(bytea, integer) OWNER TO postgres;

--
-- Name: linefromtext(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.linefromtext(text) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromText($1)) = 'LINESTRING'
	THEN GeomFromText($1)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.linefromtext(text) OWNER TO postgres;

--
-- Name: linefromtext(text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.linefromtext(text, integer) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromText($1, $2)) = 'LINESTRING'
	THEN GeomFromText($1,$2)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.linefromtext(text, integer) OWNER TO postgres;

--
-- Name: linefromwkb(bytea); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.linefromwkb(bytea) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromWKB($1)) = 'LINESTRING'
	THEN GeomFromWKB($1)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.linefromwkb(bytea) OWNER TO postgres;

--
-- Name: linefromwkb(bytea, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.linefromwkb(bytea, integer) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromWKB($1, $2)) = 'LINESTRING'
	THEN GeomFromWKB($1, $2)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.linefromwkb(bytea, integer) OWNER TO postgres;

--
-- Name: linestringfromtext(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.linestringfromtext(text) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT LineFromText($1)$_$;


ALTER FUNCTION public.linestringfromtext(text) OWNER TO postgres;

--
-- Name: linestringfromtext(text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.linestringfromtext(text, integer) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT LineFromText($1, $2)$_$;


ALTER FUNCTION public.linestringfromtext(text, integer) OWNER TO postgres;

--
-- Name: linestringfromwkb(bytea); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.linestringfromwkb(bytea) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromWKB($1)) = 'LINESTRING'
	THEN GeomFromWKB($1)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.linestringfromwkb(bytea) OWNER TO postgres;

--
-- Name: linestringfromwkb(bytea, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.linestringfromwkb(bytea, integer) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromWKB($1, $2)) = 'LINESTRING'
	THEN GeomFromWKB($1, $2)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.linestringfromwkb(bytea, integer) OWNER TO postgres;

--
-- Name: locate_along_measure(public.geometry, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.locate_along_measure(public.geometry, double precision) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$ SELECT ST_locate_between_measures($1, $2, $2) $_$;


ALTER FUNCTION public.locate_along_measure(public.geometry, double precision) OWNER TO postgres;

--
-- Name: mlinefromtext(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.mlinefromtext(text) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromText($1)) = 'MULTILINESTRING'
	THEN GeomFromText($1)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.mlinefromtext(text) OWNER TO postgres;

--
-- Name: mlinefromtext(text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.mlinefromtext(text, integer) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE
	WHEN geometrytype(GeomFromText($1, $2)) = 'MULTILINESTRING'
	THEN GeomFromText($1,$2)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.mlinefromtext(text, integer) OWNER TO postgres;

--
-- Name: mlinefromwkb(bytea); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.mlinefromwkb(bytea) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromWKB($1)) = 'MULTILINESTRING'
	THEN GeomFromWKB($1)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.mlinefromwkb(bytea) OWNER TO postgres;

--
-- Name: mlinefromwkb(bytea, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.mlinefromwkb(bytea, integer) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromWKB($1, $2)) = 'MULTILINESTRING'
	THEN GeomFromWKB($1, $2)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.mlinefromwkb(bytea, integer) OWNER TO postgres;

--
-- Name: mpointfromtext(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.mpointfromtext(text) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromText($1)) = 'MULTIPOINT'
	THEN GeomFromText($1)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.mpointfromtext(text) OWNER TO postgres;

--
-- Name: mpointfromtext(text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.mpointfromtext(text, integer) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromText($1,$2)) = 'MULTIPOINT'
	THEN GeomFromText($1,$2)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.mpointfromtext(text, integer) OWNER TO postgres;

--
-- Name: mpointfromwkb(bytea); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.mpointfromwkb(bytea) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromWKB($1)) = 'MULTIPOINT'
	THEN GeomFromWKB($1)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.mpointfromwkb(bytea) OWNER TO postgres;

--
-- Name: mpointfromwkb(bytea, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.mpointfromwkb(bytea, integer) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromWKB($1,$2)) = 'MULTIPOINT'
	THEN GeomFromWKB($1, $2)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.mpointfromwkb(bytea, integer) OWNER TO postgres;

--
-- Name: mpolyfromtext(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.mpolyfromtext(text) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromText($1)) = 'MULTIPOLYGON'
	THEN GeomFromText($1)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.mpolyfromtext(text) OWNER TO postgres;

--
-- Name: mpolyfromtext(text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.mpolyfromtext(text, integer) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromText($1, $2)) = 'MULTIPOLYGON'
	THEN GeomFromText($1,$2)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.mpolyfromtext(text, integer) OWNER TO postgres;

--
-- Name: mpolyfromwkb(bytea); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.mpolyfromwkb(bytea) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromWKB($1)) = 'MULTIPOLYGON'
	THEN GeomFromWKB($1)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.mpolyfromwkb(bytea) OWNER TO postgres;

--
-- Name: mpolyfromwkb(bytea, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.mpolyfromwkb(bytea, integer) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromWKB($1, $2)) = 'MULTIPOLYGON'
	THEN GeomFromWKB($1, $2)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.mpolyfromwkb(bytea, integer) OWNER TO postgres;

--
-- Name: multilinefromwkb(bytea); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.multilinefromwkb(bytea) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromWKB($1)) = 'MULTILINESTRING'
	THEN GeomFromWKB($1)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.multilinefromwkb(bytea) OWNER TO postgres;

--
-- Name: multilinefromwkb(bytea, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.multilinefromwkb(bytea, integer) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromWKB($1, $2)) = 'MULTILINESTRING'
	THEN GeomFromWKB($1, $2)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.multilinefromwkb(bytea, integer) OWNER TO postgres;

--
-- Name: multilinestringfromtext(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.multilinestringfromtext(text) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT ST_MLineFromText($1)$_$;


ALTER FUNCTION public.multilinestringfromtext(text) OWNER TO postgres;

--
-- Name: multilinestringfromtext(text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.multilinestringfromtext(text, integer) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT MLineFromText($1, $2)$_$;


ALTER FUNCTION public.multilinestringfromtext(text, integer) OWNER TO postgres;

--
-- Name: multipointfromtext(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.multipointfromtext(text) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT MPointFromText($1)$_$;


ALTER FUNCTION public.multipointfromtext(text) OWNER TO postgres;

--
-- Name: multipointfromtext(text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.multipointfromtext(text, integer) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT MPointFromText($1, $2)$_$;


ALTER FUNCTION public.multipointfromtext(text, integer) OWNER TO postgres;

--
-- Name: multipointfromwkb(bytea); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.multipointfromwkb(bytea) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromWKB($1)) = 'MULTIPOINT'
	THEN GeomFromWKB($1)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.multipointfromwkb(bytea) OWNER TO postgres;

--
-- Name: multipointfromwkb(bytea, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.multipointfromwkb(bytea, integer) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromWKB($1,$2)) = 'MULTIPOINT'
	THEN GeomFromWKB($1, $2)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.multipointfromwkb(bytea, integer) OWNER TO postgres;

--
-- Name: multipolyfromwkb(bytea); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.multipolyfromwkb(bytea) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromWKB($1)) = 'MULTIPOLYGON'
	THEN GeomFromWKB($1)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.multipolyfromwkb(bytea) OWNER TO postgres;

--
-- Name: multipolyfromwkb(bytea, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.multipolyfromwkb(bytea, integer) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromWKB($1, $2)) = 'MULTIPOLYGON'
	THEN GeomFromWKB($1, $2)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.multipolyfromwkb(bytea, integer) OWNER TO postgres;

--
-- Name: multipolygonfromtext(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.multipolygonfromtext(text) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT MPolyFromText($1)$_$;


ALTER FUNCTION public.multipolygonfromtext(text) OWNER TO postgres;

--
-- Name: multipolygonfromtext(text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.multipolygonfromtext(text, integer) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT MPolyFromText($1, $2)$_$;


ALTER FUNCTION public.multipolygonfromtext(text, integer) OWNER TO postgres;

--
-- Name: pointfromtext(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.pointfromtext(text) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromText($1)) = 'POINT'
	THEN GeomFromText($1)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.pointfromtext(text) OWNER TO postgres;

--
-- Name: pointfromtext(text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.pointfromtext(text, integer) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromText($1, $2)) = 'POINT'
	THEN GeomFromText($1,$2)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.pointfromtext(text, integer) OWNER TO postgres;

--
-- Name: pointfromwkb(bytea); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.pointfromwkb(bytea) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromWKB($1)) = 'POINT'
	THEN GeomFromWKB($1)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.pointfromwkb(bytea) OWNER TO postgres;

--
-- Name: pointfromwkb(bytea, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.pointfromwkb(bytea, integer) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(ST_GeomFromWKB($1, $2)) = 'POINT'
	THEN GeomFromWKB($1, $2)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.pointfromwkb(bytea, integer) OWNER TO postgres;

--
-- Name: polyfromtext(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.polyfromtext(text) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromText($1)) = 'POLYGON'
	THEN GeomFromText($1)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.polyfromtext(text) OWNER TO postgres;

--
-- Name: polyfromtext(text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.polyfromtext(text, integer) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromText($1, $2)) = 'POLYGON'
	THEN GeomFromText($1,$2)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.polyfromtext(text, integer) OWNER TO postgres;

--
-- Name: polyfromwkb(bytea); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.polyfromwkb(bytea) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromWKB($1)) = 'POLYGON'
	THEN GeomFromWKB($1)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.polyfromwkb(bytea) OWNER TO postgres;

--
-- Name: polyfromwkb(bytea, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.polyfromwkb(bytea, integer) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromWKB($1, $2)) = 'POLYGON'
	THEN GeomFromWKB($1, $2)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.polyfromwkb(bytea, integer) OWNER TO postgres;

--
-- Name: polygonfromtext(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.polygonfromtext(text) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT PolyFromText($1)$_$;


ALTER FUNCTION public.polygonfromtext(text) OWNER TO postgres;

--
-- Name: polygonfromtext(text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.polygonfromtext(text, integer) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT PolyFromText($1, $2)$_$;


ALTER FUNCTION public.polygonfromtext(text, integer) OWNER TO postgres;

--
-- Name: polygonfromwkb(bytea); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.polygonfromwkb(bytea) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromWKB($1)) = 'POLYGON'
	THEN GeomFromWKB($1)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.polygonfromwkb(bytea) OWNER TO postgres;

--
-- Name: polygonfromwkb(bytea, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.polygonfromwkb(bytea, integer) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromWKB($1,$2)) = 'POLYGON'
	THEN GeomFromWKB($1, $2)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.polygonfromwkb(bytea, integer) OWNER TO postgres;

--
-- Name: probe_geometry_columns(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.probe_geometry_columns() RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
	inserted integer;
	oldcount integer;
	probed integer;
	stale integer;
BEGIN


	RETURN 'This function is obsolete now that geometry_columns is a view';
END

$$;


ALTER FUNCTION public.probe_geometry_columns() OWNER TO postgres;

--
-- Name: processar(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.processar(codi character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
	CASE codi WHEN '08006','08029','17032','08035','08040','08110','MARINELAND','08121','08126','08163','08172','17152','08197','08235','08264','43002','29028','08219','08118','RICA ESTAN','TANC LLACU','ENCA LLACU' THEN
		RETURN FALSE;
	ELSE
		RETURN TRUE;
	END CASE;	
END;
$$;


ALTER FUNCTION public.processar(codi character varying) OWNER TO postgres;

--
-- Name: recorrefiles(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.recorrefiles() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
	mviews RECORD;
	id0 character varying(200);
	id1 character varying(200);
BEGIN	
	FOR mviews in SELECT nom, codi, count(nom), count(codi) FROM SIPAN_MGEOREFERENCIACIO.TOPONIMVERSIO WHERE codi is not 

null GROUP BY nom,codi HAVING count(nom) >= 2 ORDER BY count(nom) DESC,nom
	LOOP
		RAISE INFO '%', mviews.nom;
		IF processar(mviews.codi) THEN
			id0:=(SELECT ID FROM SIPAN_MGEOREFERENCIACIO.TOPONIMVERSIO WHERE nom=mviews.nom AND codi=mviews.codi AND numero_versio=0);
			id1:=(SELECT ID FROM SIPAN_MGEOREFERENCIACIO.TOPONIMVERSIO WHERE nom=mviews.nom AND codi=mviews.codi AND numero_versio=1);		
			PERFORM copiaCampsVersio(id0,id1);
		END IF;
	END LOOP;
END;
$$;


ALTER FUNCTION public.recorrefiles() OWNER TO postgres;

--
-- Name: rename_geometry_table_constraints(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.rename_geometry_table_constraints() RETURNS text
    LANGUAGE sql IMMUTABLE
    AS $$
SELECT 'rename_geometry_table_constraint() is obsoleted'::text
$$;


ALTER FUNCTION public.rename_geometry_table_constraints() OWNER TO postgres;

--
-- Name: rotate(public.geometry, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.rotate(public.geometry, double precision) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT st_rotateZ($1, $2)$_$;


ALTER FUNCTION public.rotate(public.geometry, double precision) OWNER TO postgres;

--
-- Name: rotatex(public.geometry, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.rotatex(public.geometry, double precision) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT st_affine($1, 1, 0, 0, 0, cos($2), -sin($2), 0, sin($2), cos($2), 0, 0, 0)$_$;


ALTER FUNCTION public.rotatex(public.geometry, double precision) OWNER TO postgres;

--
-- Name: rotatey(public.geometry, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.rotatey(public.geometry, double precision) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT st_affine($1,  cos($2), 0, sin($2),  0, 1, 0,  -sin($2), 0, cos($2), 0,  0, 0)$_$;


ALTER FUNCTION public.rotatey(public.geometry, double precision) OWNER TO postgres;

--
-- Name: rotatez(public.geometry, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.rotatez(public.geometry, double precision) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT st_affine($1,  cos($2), -sin($2), 0,  sin($2), cos($2), 0,  0, 0, 1,  0, 0, 0)$_$;


ALTER FUNCTION public.rotatez(public.geometry, double precision) OWNER TO postgres;

--
-- Name: scale(public.geometry, double precision, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.scale(public.geometry, double precision, double precision) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT st_scale($1, $2, $3, 1)$_$;


ALTER FUNCTION public.scale(public.geometry, double precision, double precision) OWNER TO postgres;

--
-- Name: scale(public.geometry, double precision, double precision, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.scale(public.geometry, double precision, double precision, double precision) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT st_affine($1,  $2, 0, 0,  0, $3, 0,  0, 0, $4,  0, 0, 0)$_$;


ALTER FUNCTION public.scale(public.geometry, double precision, double precision, double precision) OWNER TO postgres;

--
-- Name: se_envelopesintersect(public.geometry, public.geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.se_envelopesintersect(public.geometry, public.geometry) RETURNS boolean
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$ 
	SELECT $1 && $2
	$_$;


ALTER FUNCTION public.se_envelopesintersect(public.geometry, public.geometry) OWNER TO postgres;

--
-- Name: se_locatealong(public.geometry, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.se_locatealong(public.geometry, double precision) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$ SELECT SE_LocateBetween($1, $2, $2) $_$;


ALTER FUNCTION public.se_locatealong(public.geometry, double precision) OWNER TO postgres;

--
-- Name: snaptogrid(public.geometry, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.snaptogrid(public.geometry, double precision) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT ST_SnapToGrid($1, 0, 0, $2, $2)$_$;


ALTER FUNCTION public.snaptogrid(public.geometry, double precision) OWNER TO postgres;

--
-- Name: snaptogrid(public.geometry, double precision, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.snaptogrid(public.geometry, double precision, double precision) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT ST_SnapToGrid($1, 0, 0, $2, $3)$_$;


ALTER FUNCTION public.snaptogrid(public.geometry, double precision, double precision) OWNER TO postgres;

--
-- Name: st_asbinary(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.st_asbinary(text) RETURNS bytea
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$ SELECT ST_AsBinary($1::geometry);$_$;


ALTER FUNCTION public.st_asbinary(text) OWNER TO postgres;

--
-- Name: st_astext(bytea); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.st_astext(bytea) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$ SELECT ST_AsText($1::geometry);$_$;


ALTER FUNCTION public.st_astext(bytea) OWNER TO postgres;

--
-- Name: translate(public.geometry, double precision, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.translate(public.geometry, double precision, double precision) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT st_translate($1, $2, $3, 0)$_$;


ALTER FUNCTION public.translate(public.geometry, double precision, double precision) OWNER TO postgres;

--
-- Name: translate(public.geometry, double precision, double precision, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.translate(public.geometry, double precision, double precision, double precision) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT st_affine($1, 1, 0, 0, 0, 1, 0, 0, 0, 1, $2, $3, $4)$_$;


ALTER FUNCTION public.translate(public.geometry, double precision, double precision, double precision) OWNER TO postgres;

--
-- Name: transscale(public.geometry, double precision, double precision, double precision, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.transscale(public.geometry, double precision, double precision, double precision, double precision) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT st_affine($1,  $4, 0, 0,  0, $5, 0,
		0, 0, 1,  $2 * $4, $3 * $5, 0)$_$;


ALTER FUNCTION public.transscale(public.geometry, double precision, double precision, double precision, double precision) OWNER TO postgres;

--
-- Name: utmzone(public.geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.utmzone(public.geometry) RETURNS integer
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
 DECLARE
     geomgeog geometry;
     zone int;
     pref int;

 BEGIN
     geomgeog:= ST_Transform($1,4326);

     IF (ST_Y(geomgeog))>0 THEN
        pref:=32600;
     ELSE
        pref:=32700;
     END IF;

     zone:=floor((ST_X(geomgeog)+180)/6)+1;

     RETURN zone+pref;
 END;
 $_$;


ALTER FUNCTION public.utmzone(public.geometry) OWNER TO postgres;

--
-- Name: within(public.geometry, public.geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.within(public.geometry, public.geometry) RETURNS boolean
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT ST_Within($1, $2)$_$;


ALTER FUNCTION public.within(public.geometry, public.geometry) OWNER TO postgres;

--
-- Name: memcollect(public.geometry); Type: AGGREGATE; Schema: public; Owner: postgres
--

CREATE AGGREGATE public.memcollect(public.geometry) (
    SFUNC = public.st_collect,
    STYPE = public.geometry
);


ALTER AGGREGATE public.memcollect(public.geometry) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: ambitexclosrecursgeoref; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ambitexclosrecursgeoref (
    id character varying(100) NOT NULL,
    idambitgeografic character varying(100) NOT NULL,
    idrecursgeoref character varying(100) NOT NULL
);


ALTER TABLE public.ambitexclosrecursgeoref OWNER TO postgres;

--
-- Name: ambitgeografic; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ambitgeografic (
    id character varying(100) NOT NULL,
    nom character varying(100) NOT NULL,
    codi character varying(100)
);


ALTER TABLE public.ambitgeografic OWNER TO postgres;

--
-- Name: ambitgeograficrecursgeoref; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ambitgeograficrecursgeoref (
    id character varying(100) NOT NULL,
    idambitgeografic character varying(100) NOT NULL,
    idrecursgeoref character varying(100) NOT NULL
);


ALTER TABLE public.ambitgeograficrecursgeoref OWNER TO postgres;

--
-- Name: auth_group; Type: TABLE; Schema: public; Owner: aplicacio_georef
--

CREATE TABLE public.auth_group (
    id integer NOT NULL,
    name character varying(150) NOT NULL
);


ALTER TABLE public.auth_group OWNER TO aplicacio_georef;

--
-- Name: auth_group_id_seq; Type: SEQUENCE; Schema: public; Owner: aplicacio_georef
--

CREATE SEQUENCE public.auth_group_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.auth_group_id_seq OWNER TO aplicacio_georef;

--
-- Name: auth_group_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aplicacio_georef
--

ALTER SEQUENCE public.auth_group_id_seq OWNED BY public.auth_group.id;


--
-- Name: auth_group_permissions; Type: TABLE; Schema: public; Owner: aplicacio_georef
--

CREATE TABLE public.auth_group_permissions (
    id integer NOT NULL,
    group_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE public.auth_group_permissions OWNER TO aplicacio_georef;

--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: aplicacio_georef
--

CREATE SEQUENCE public.auth_group_permissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.auth_group_permissions_id_seq OWNER TO aplicacio_georef;

--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aplicacio_georef
--

ALTER SEQUENCE public.auth_group_permissions_id_seq OWNED BY public.auth_group_permissions.id;


--
-- Name: auth_permission; Type: TABLE; Schema: public; Owner: aplicacio_georef
--

CREATE TABLE public.auth_permission (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    content_type_id integer NOT NULL,
    codename character varying(100) NOT NULL
);


ALTER TABLE public.auth_permission OWNER TO aplicacio_georef;

--
-- Name: auth_permission_id_seq; Type: SEQUENCE; Schema: public; Owner: aplicacio_georef
--

CREATE SEQUENCE public.auth_permission_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.auth_permission_id_seq OWNER TO aplicacio_georef;

--
-- Name: auth_permission_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aplicacio_georef
--

ALTER SEQUENCE public.auth_permission_id_seq OWNED BY public.auth_permission.id;


--
-- Name: auth_user; Type: TABLE; Schema: public; Owner: aplicacio_georef
--

CREATE TABLE public.auth_user (
    id integer NOT NULL,
    password character varying(128) NOT NULL,
    last_login timestamp with time zone,
    is_superuser boolean NOT NULL,
    username character varying(150) NOT NULL,
    first_name character varying(150) NOT NULL,
    last_name character varying(150) NOT NULL,
    email character varying(254) NOT NULL,
    is_staff boolean NOT NULL,
    is_active boolean NOT NULL,
    date_joined timestamp with time zone NOT NULL
);


ALTER TABLE public.auth_user OWNER TO aplicacio_georef;

--
-- Name: auth_user_groups; Type: TABLE; Schema: public; Owner: aplicacio_georef
--

CREATE TABLE public.auth_user_groups (
    id integer NOT NULL,
    user_id integer NOT NULL,
    group_id integer NOT NULL
);


ALTER TABLE public.auth_user_groups OWNER TO aplicacio_georef;

--
-- Name: auth_user_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: aplicacio_georef
--

CREATE SEQUENCE public.auth_user_groups_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.auth_user_groups_id_seq OWNER TO aplicacio_georef;

--
-- Name: auth_user_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aplicacio_georef
--

ALTER SEQUENCE public.auth_user_groups_id_seq OWNED BY public.auth_user_groups.id;


--
-- Name: auth_user_id_seq; Type: SEQUENCE; Schema: public; Owner: aplicacio_georef
--

CREATE SEQUENCE public.auth_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.auth_user_id_seq OWNER TO aplicacio_georef;

--
-- Name: auth_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aplicacio_georef
--

ALTER SEQUENCE public.auth_user_id_seq OWNED BY public.auth_user.id;


--
-- Name: auth_user_user_permissions; Type: TABLE; Schema: public; Owner: aplicacio_georef
--

CREATE TABLE public.auth_user_user_permissions (
    id integer NOT NULL,
    user_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE public.auth_user_user_permissions OWNER TO aplicacio_georef;

--
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: aplicacio_georef
--

CREATE SEQUENCE public.auth_user_user_permissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.auth_user_user_permissions_id_seq OWNER TO aplicacio_georef;

--
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aplicacio_georef
--

ALTER SEQUENCE public.auth_user_user_permissions_id_seq OWNED BY public.auth_user_user_permissions.id;


--
-- Name: authority; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.authority (
    id character varying(100) NOT NULL,
    authority character varying(100)
);


ALTER TABLE public.authority OWNER TO postgres;

--
-- Name: autorrecursgeoref; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.autorrecursgeoref (
    id character varying(100) NOT NULL,
    idrecursgeoref character varying(100) NOT NULL,
    idpersona character varying(100) NOT NULL
);


ALTER TABLE public.autorrecursgeoref OWNER TO postgres;

--
-- Name: basescartografiques; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.basescartografiques (
    idbasecarto character varying(100) NOT NULL,
    nombasecarto character varying(1000) NOT NULL
);


ALTER TABLE public.basescartografiques OWNER TO postgres;

--
-- Name: bloquejosobjectessipan; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bloquejosobjectessipan (
    idbloqueigobjecte character varying(100) NOT NULL,
    idmodul character varying(100) NOT NULL,
    tipusobjecte character varying(35) NOT NULL,
    idobjectebloquejat character varying(100) NOT NULL,
    idusuari character varying(100),
    ip character varying(15),
    timestamp_ date
);


ALTER TABLE public.bloquejosobjectessipan OWNER TO postgres;

--
-- Name: capawms; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.capawms (
    id character varying(200) NOT NULL,
    baseurlservidor character varying(400) NOT NULL,
    name character varying(400) NOT NULL,
    label character varying(400),
    minx double precision,
    maxx double precision,
    miny double precision,
    maxy double precision,
    boundary public.geometry(Polygon,4326)
);


ALTER TABLE public.capawms OWNER TO postgres;

--
-- Name: capesrecurs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.capesrecurs (
    idcapa character varying(200),
    idrecurs character varying(200),
    id character varying(200) NOT NULL
);


ALTER TABLE public.capesrecurs OWNER TO postgres;

--
-- Name: cartovisual; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cartovisual (
    id character varying(200) NOT NULL,
    idcartografia character varying(200),
    idobjectesipan character varying(200)
);


ALTER TABLE public.cartovisual OWNER TO postgres;

--
-- Name: comarques; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.comarques (
    idcomarca character varying(100) NOT NULL,
    codicomarca character varying(100),
    nomcomarca character varying(255) NOT NULL,
    areaoficial numeric,
    areareal numeric,
    iddemarcacioterritorial character varying(100),
    idgeometria character varying(100)
);


ALTER TABLE public.comarques OWNER TO postgres;

--
-- Name: comarquesprovincies; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.comarquesprovincies (
    idcomarca character varying(100) NOT NULL,
    idprovincia character varying(100) NOT NULL
);


ALTER TABLE public.comarquesprovincies OWNER TO postgres;

--
-- Name: comments; Type: TABLE; Schema: public; Owner: aplicacio_georef
--

CREATE TABLE public.comments (
    id integer NOT NULL,
    comment text,
    data date,
    attachment character varying(500),
    nom_original character varying(500),
    author character varying(500),
    idversio character varying(200)
);


ALTER TABLE public.comments OWNER TO aplicacio_georef;

--
-- Name: comments_id_seq; Type: SEQUENCE; Schema: public; Owner: aplicacio_georef
--

CREATE SEQUENCE public.comments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.comments_id_seq OWNER TO aplicacio_georef;

--
-- Name: comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aplicacio_georef
--

ALTER SEQUENCE public.comments_id_seq OWNED BY public.comments.id;


--
-- Name: comunitatsautonomes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.comunitatsautonomes (
    id character varying(100) NOT NULL,
    nomcomunitatautonoma character varying(100) NOT NULL
);


ALTER TABLE public.comunitatsautonomes OWNER TO postgres;

--
-- Name: comunitatsautonomesprovincies; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.comunitatsautonomesprovincies (
    id character varying(100) NOT NULL,
    idcomunitatautonoma character varying(100) NOT NULL,
    idprovincia character varying(100) NOT NULL
);


ALTER TABLE public.comunitatsautonomesprovincies OWNER TO postgres;

--
-- Name: conversio; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.conversio (
    id character varying(100) NOT NULL,
    nom character varying(100) NOT NULL
);


ALTER TABLE public.conversio OWNER TO postgres;

--
-- Name: coordenades; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.coordenades (
    idcoordenada character varying(200) NOT NULL,
    coordx character varying(40) NOT NULL,
    coordy character varying(40) NOT NULL,
    coordz character varying(40)
);


ALTER TABLE public.coordenades OWNER TO postgres;

--
-- Name: coordenadeslinies; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.coordenadeslinies (
    idcoordenadalinia character varying(100) NOT NULL,
    idlinia character varying(100) NOT NULL,
    idcoordenada character varying(100) NOT NULL,
    ordre numeric NOT NULL
);


ALTER TABLE public.coordenadeslinies OWNER TO postgres;

--
-- Name: dades_municipipuntradi; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dades_municipipuntradi (
    municipi character varying(250),
    comarca character varying(250),
    longitud double precision,
    latitud double precision,
    precisio double precision,
    xutm31ed50 double precision,
    yutm31hnub double precision
);


ALTER TABLE public.dades_municipipuntradi OWNER TO postgres;

--
-- Name: datum; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.datum (
    id character varying(100) NOT NULL,
    nom character varying(100) NOT NULL,
    codi character varying(100) NOT NULL,
    idmarcreferencia character varying(100)
);


ALTER TABLE public.datum OWNER TO postgres;

--
-- Name: demarcacionsterritorials; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.demarcacionsterritorials (
    iddemarcacioterritorial character varying(100) NOT NULL,
    nomdemarcacioterritorial character varying(255) NOT NULL
);


ALTER TABLE public.demarcacionsterritorials OWNER TO postgres;

--
-- Name: detallsusuari; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.detallsusuari (
    id character varying(200) NOT NULL,
    idusuari character varying(100),
    nom character varying(100),
    cognom1 character varying(100),
    cognom2 character varying(100),
    email character varying(100)
);


ALTER TABLE public.detallsusuari OWNER TO postgres;

--
-- Name: django_admin_log; Type: TABLE; Schema: public; Owner: aplicacio_georef
--

CREATE TABLE public.django_admin_log (
    id integer NOT NULL,
    action_time timestamp with time zone NOT NULL,
    object_id text,
    object_repr character varying(200) NOT NULL,
    action_flag smallint NOT NULL,
    change_message text NOT NULL,
    content_type_id integer,
    user_id integer NOT NULL,
    CONSTRAINT django_admin_log_action_flag_check CHECK ((action_flag >= 0))
);


ALTER TABLE public.django_admin_log OWNER TO aplicacio_georef;

--
-- Name: django_admin_log_id_seq; Type: SEQUENCE; Schema: public; Owner: aplicacio_georef
--

CREATE SEQUENCE public.django_admin_log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.django_admin_log_id_seq OWNER TO aplicacio_georef;

--
-- Name: django_admin_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aplicacio_georef
--

ALTER SEQUENCE public.django_admin_log_id_seq OWNED BY public.django_admin_log.id;


--
-- Name: django_content_type; Type: TABLE; Schema: public; Owner: aplicacio_georef
--

CREATE TABLE public.django_content_type (
    id integer NOT NULL,
    app_label character varying(100) NOT NULL,
    model character varying(100) NOT NULL
);


ALTER TABLE public.django_content_type OWNER TO aplicacio_georef;

--
-- Name: django_content_type_id_seq; Type: SEQUENCE; Schema: public; Owner: aplicacio_georef
--

CREATE SEQUENCE public.django_content_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.django_content_type_id_seq OWNER TO aplicacio_georef;

--
-- Name: django_content_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aplicacio_georef
--

ALTER SEQUENCE public.django_content_type_id_seq OWNED BY public.django_content_type.id;


--
-- Name: django_migrations; Type: TABLE; Schema: public; Owner: aplicacio_georef
--

CREATE TABLE public.django_migrations (
    id integer NOT NULL,
    app character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    applied timestamp with time zone NOT NULL
);


ALTER TABLE public.django_migrations OWNER TO aplicacio_georef;

--
-- Name: django_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: aplicacio_georef
--

CREATE SEQUENCE public.django_migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.django_migrations_id_seq OWNER TO aplicacio_georef;

--
-- Name: django_migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aplicacio_georef
--

ALTER SEQUENCE public.django_migrations_id_seq OWNED BY public.django_migrations.id;


--
-- Name: django_session; Type: TABLE; Schema: public; Owner: aplicacio_georef
--

CREATE TABLE public.django_session (
    session_key character varying(40) NOT NULL,
    session_data text NOT NULL,
    expire_date timestamp with time zone NOT NULL
);


ALTER TABLE public.django_session OWNER TO aplicacio_georef;

--
-- Name: documentsrecursos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.documentsrecursos (
    iddocument character varying(100),
    idrecurs character varying(200)
);


ALTER TABLE public.documentsrecursos OWNER TO postgres;

--
-- Name: documentsversions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.documentsversions (
    iddocument character varying(100),
    idversio character varying(200)
);


ALTER TABLE public.documentsversions OWNER TO postgres;

--
-- Name: epsg_alias; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.epsg_alias (
    alias_code integer NOT NULL,
    object_table_name character varying(80) NOT NULL,
    object_code integer NOT NULL,
    naming_system_code integer NOT NULL,
    alias character varying(80) NOT NULL,
    remarks character varying(254)
);


ALTER TABLE public.epsg_alias OWNER TO postgres;

--
-- Name: epsg_area; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.epsg_area (
    area_code integer NOT NULL,
    area_name character varying(80) NOT NULL,
    area_of_use text NOT NULL,
    area_south_bound_lat double precision,
    area_north_bound_lat double precision,
    area_west_bound_lon double precision,
    area_east_bound_lon double precision,
    area_polygon_file_ref character varying(254),
    iso_a2_code character varying(2),
    iso_a3_code character varying(3),
    iso_n_code integer,
    remarks character varying(254),
    information_source character varying(254),
    data_source character varying(40) NOT NULL,
    revision_date date NOT NULL,
    change_id character varying(255),
    deprecated smallint NOT NULL
);


ALTER TABLE public.epsg_area OWNER TO postgres;

--
-- Name: epsg_change; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.epsg_change (
    change_id double precision NOT NULL,
    report_date date NOT NULL,
    date_closed date,
    reporter character varying(254) NOT NULL,
    request character varying(254) NOT NULL,
    tables_affected character varying(254),
    codes_affected character varying(254),
    change_comment character varying(254),
    action text
);


ALTER TABLE public.epsg_change OWNER TO postgres;

--
-- Name: epsg_coordinateaxis; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.epsg_coordinateaxis (
    coord_axis_code integer,
    coord_sys_code integer NOT NULL,
    coord_axis_name_code integer NOT NULL,
    coord_axis_orientation character varying(24) NOT NULL,
    coord_axis_abbreviation character varying(24) NOT NULL,
    uom_code integer NOT NULL,
    coord_axis_order smallint NOT NULL
);


ALTER TABLE public.epsg_coordinateaxis OWNER TO postgres;

--
-- Name: epsg_coordinateaxisname; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.epsg_coordinateaxisname (
    coord_axis_name_code integer NOT NULL,
    coord_axis_name character varying(80) NOT NULL,
    description character varying(254),
    remarks character varying(254),
    information_source character varying(254),
    data_source character varying(40) NOT NULL,
    revision_date date NOT NULL,
    change_id character varying(255),
    deprecated smallint NOT NULL
);


ALTER TABLE public.epsg_coordinateaxisname OWNER TO postgres;

--
-- Name: epsg_coordinatereferencesystem; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.epsg_coordinatereferencesystem (
    coord_ref_sys_code integer NOT NULL,
    coord_ref_sys_name character varying(80) NOT NULL,
    area_of_use_code integer NOT NULL,
    coord_ref_sys_kind character varying(24) NOT NULL,
    coord_sys_code integer,
    datum_code integer,
    source_geogcrs_code integer,
    projection_conv_code integer,
    cmpd_horizcrs_code integer,
    cmpd_vertcrs_code integer,
    crs_scope character varying(254) NOT NULL,
    remarks character varying(254),
    information_source character varying(254),
    data_source character varying(40) NOT NULL,
    revision_date date NOT NULL,
    change_id character varying(255),
    show_crs smallint NOT NULL,
    deprecated smallint NOT NULL
);


ALTER TABLE public.epsg_coordinatereferencesystem OWNER TO postgres;

--
-- Name: epsg_coordinatesystem; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.epsg_coordinatesystem (
    coord_sys_code integer NOT NULL,
    coord_sys_name character varying(254) NOT NULL,
    coord_sys_type character varying(24) NOT NULL,
    dimension smallint NOT NULL,
    remarks character varying(254),
    information_source character varying(254),
    data_source character varying(50) NOT NULL,
    revision_date date NOT NULL,
    change_id character varying(255),
    deprecated smallint NOT NULL
);


ALTER TABLE public.epsg_coordinatesystem OWNER TO postgres;

--
-- Name: epsg_coordoperation; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.epsg_coordoperation (
    coord_op_code integer NOT NULL,
    coord_op_name character varying(80) NOT NULL,
    coord_op_type character varying(24) NOT NULL,
    source_crs_code integer,
    target_crs_code integer,
    coord_tfm_version character varying(24),
    coord_op_variant smallint,
    area_of_use_code integer NOT NULL,
    coord_op_scope character varying(254) NOT NULL,
    coord_op_accuracy double precision,
    coord_op_method_code integer,
    uom_code_source_coord_diff integer,
    uom_code_target_coord_diff integer,
    remarks character varying(254),
    information_source character varying(254),
    data_source character varying(40) NOT NULL,
    revision_date date NOT NULL,
    change_id character varying(255),
    show_operation smallint NOT NULL,
    deprecated smallint NOT NULL
);


ALTER TABLE public.epsg_coordoperation OWNER TO postgres;

--
-- Name: epsg_coordoperationmethod; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.epsg_coordoperationmethod (
    coord_op_method_code integer NOT NULL,
    coord_op_method_name character varying(50) NOT NULL,
    reverse_op smallint NOT NULL,
    formula text,
    example text,
    remarks character varying(254),
    information_source character varying(254),
    data_source character varying(40) NOT NULL,
    revision_date date NOT NULL,
    change_id character varying(255),
    deprecated smallint NOT NULL
);


ALTER TABLE public.epsg_coordoperationmethod OWNER TO postgres;

--
-- Name: epsg_coordoperationparam; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.epsg_coordoperationparam (
    parameter_code integer NOT NULL,
    parameter_name character varying(80) NOT NULL,
    description text,
    information_source character varying(254),
    data_source character varying(40) NOT NULL,
    revision_date date NOT NULL,
    change_id character varying(255),
    deprecated smallint NOT NULL
);


ALTER TABLE public.epsg_coordoperationparam OWNER TO postgres;

--
-- Name: epsg_coordoperationparamusage; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.epsg_coordoperationparamusage (
    coord_op_method_code integer NOT NULL,
    parameter_code integer NOT NULL,
    sort_order smallint NOT NULL,
    param_sign_reversal character varying(3)
);


ALTER TABLE public.epsg_coordoperationparamusage OWNER TO postgres;

--
-- Name: epsg_coordoperationparamvalue; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.epsg_coordoperationparamvalue (
    coord_op_code integer NOT NULL,
    coord_op_method_code integer NOT NULL,
    parameter_code integer NOT NULL,
    parameter_value double precision,
    param_value_file_ref character varying(254),
    uom_code integer
);


ALTER TABLE public.epsg_coordoperationparamvalue OWNER TO postgres;

--
-- Name: epsg_coordoperationpath; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.epsg_coordoperationpath (
    concat_operation_code integer NOT NULL,
    single_operation_code integer NOT NULL,
    op_path_step smallint NOT NULL
);


ALTER TABLE public.epsg_coordoperationpath OWNER TO postgres;

--
-- Name: epsg_datum; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.epsg_datum (
    datum_code integer NOT NULL,
    datum_name character varying(80) NOT NULL,
    datum_type character varying(24) NOT NULL,
    origin_description character varying(254),
    realization_epoch character varying(4),
    ellipsoid_code integer,
    prime_meridian_code integer,
    area_of_use_code integer NOT NULL,
    datum_scope character varying(254) NOT NULL,
    remarks character varying(254),
    information_source character varying(254),
    data_source character varying(40) NOT NULL,
    revision_date date NOT NULL,
    change_id character varying(255),
    deprecated smallint NOT NULL
);


ALTER TABLE public.epsg_datum OWNER TO postgres;

--
-- Name: epsg_deprecation; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.epsg_deprecation (
    deprecation_id integer DEFAULT 0 NOT NULL,
    deprecation_date date,
    change_id double precision NOT NULL,
    object_table_name character varying(80),
    object_code integer,
    replaced_by integer,
    deprecation_reason character varying(254)
);


ALTER TABLE public.epsg_deprecation OWNER TO postgres;

--
-- Name: epsg_ellipsoid; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.epsg_ellipsoid (
    ellipsoid_code integer NOT NULL,
    ellipsoid_name character varying(80) NOT NULL,
    semi_major_axis double precision NOT NULL,
    uom_code integer NOT NULL,
    inv_flattening double precision,
    semi_minor_axis double precision,
    ellipsoid_shape smallint NOT NULL,
    remarks character varying(254),
    information_source character varying(254),
    data_source character varying(40) NOT NULL,
    revision_date date NOT NULL,
    change_id character varying(255),
    deprecated smallint NOT NULL
);


ALTER TABLE public.epsg_ellipsoid OWNER TO postgres;

--
-- Name: epsg_namingsystem; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.epsg_namingsystem (
    naming_system_code integer NOT NULL,
    naming_system_name character varying(80) NOT NULL,
    remarks character varying(254),
    information_source character varying(254),
    data_source character varying(40) NOT NULL,
    revision_date date NOT NULL,
    change_id character varying(255),
    deprecated smallint NOT NULL
);


ALTER TABLE public.epsg_namingsystem OWNER TO postgres;

--
-- Name: epsg_primemeridian; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.epsg_primemeridian (
    prime_meridian_code integer NOT NULL,
    prime_meridian_name character varying(80) NOT NULL,
    greenwich_longitude double precision NOT NULL,
    uom_code integer NOT NULL,
    remarks character varying(254),
    information_source character varying(254),
    data_source character varying(40) NOT NULL,
    revision_date date NOT NULL,
    change_id character varying(255),
    deprecated smallint NOT NULL
);


ALTER TABLE public.epsg_primemeridian OWNER TO postgres;

--
-- Name: epsg_supersession; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.epsg_supersession (
    supersession_id integer DEFAULT 0 NOT NULL,
    object_table_name character varying(80) NOT NULL,
    object_code integer NOT NULL,
    superseded_by integer,
    supersession_type character varying(50),
    supersession_year smallint,
    remarks character varying(254)
);


ALTER TABLE public.epsg_supersession OWNER TO postgres;

--
-- Name: epsg_unitofmeasure; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.epsg_unitofmeasure (
    uom_code integer NOT NULL,
    unit_of_meas_name character varying(80) NOT NULL,
    unit_of_meas_type character varying(50),
    target_uom_code integer NOT NULL,
    factor_b double precision,
    factor_c double precision,
    remarks character varying(254),
    information_source character varying(254),
    data_source character varying(40) NOT NULL,
    revision_date date NOT NULL,
    change_id character varying(255),
    deprecated smallint NOT NULL
);


ALTER TABLE public.epsg_unitofmeasure OWNER TO postgres;

--
-- Name: epsg_versionhistory; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.epsg_versionhistory (
    version_history_code integer NOT NULL,
    version_date date,
    version_number character varying(10) NOT NULL,
    version_remarks character varying(254) NOT NULL,
    superceded_by character varying(10),
    supercedes character varying(10)
);


ALTER TABLE public.epsg_versionhistory OWNER TO postgres;

--
-- Name: filtrejson; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.filtrejson (
    idfiltre character varying(100) NOT NULL,
    "json" text,
    modul character varying(100),
    nomfiltre character varying(200)
);


ALTER TABLE public.filtrejson OWNER TO postgres;

--
-- Name: filtres; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.filtres (
    idfiltre character varying(100) NOT NULL,
    idusuari character varying(100) NOT NULL,
    ip character varying(15),
    idmodul character varying(100) NOT NULL,
    tipusobjecte character varying(25) NOT NULL,
    idobjectesipan character varying(100) NOT NULL
);


ALTER TABLE public.filtres OWNER TO postgres;

--
-- Name: geometria; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.geometria (
    idgeometria character varying(200) NOT NULL,
    idpolipunt character varying(200),
    idpolilinia character varying(200),
    idpolipoligon character varying(200),
    idsistemareferencia character varying(100),
    escala character varying(100),
    minx numeric,
    maxx numeric,
    miny numeric,
    maxy numeric
);


ALTER TABLE public.geometria OWNER TO postgres;

--
-- Name: geometriaobjectessipan; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.geometriaobjectessipan (
    id character varying(200) NOT NULL,
    idgeometria character varying(200),
    idobjectessipan character varying(200),
    editable character(1) NOT NULL
);


ALTER TABLE public.geometriaobjectessipan OWNER TO postgres;

--
-- Name: geometries_api; Type: TABLE; Schema: public; Owner: aplicacio_georef
--

CREATE TABLE public.geometries_api (
    id character varying(200) NOT NULL,
    geometria public.geometry(Geometry,4326) NOT NULL
);


ALTER TABLE public.geometries_api OWNER TO aplicacio_georef;

--
-- Name: georef_addenda_autor; Type: TABLE; Schema: public; Owner: aplicacio_georef
--

CREATE TABLE public.georef_addenda_autor (
    id character varying(200) NOT NULL,
    nom character varying(500) NOT NULL,
    description text
);


ALTER TABLE public.georef_addenda_autor OWNER TO aplicacio_georef;

--
-- Name: georef_addenda_autor_id_seq; Type: SEQUENCE; Schema: public; Owner: aplicacio_georef
--

CREATE SEQUENCE public.georef_addenda_autor_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.georef_addenda_autor_id_seq OWNER TO aplicacio_georef;

--
-- Name: georef_addenda_autor_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aplicacio_georef
--

ALTER SEQUENCE public.georef_addenda_autor_id_seq OWNED BY public.georef_addenda_autor.id;


--
-- Name: georef_addenda_geometriarecurs; Type: TABLE; Schema: public; Owner: aplicacio_georef
--

CREATE TABLE public.georef_addenda_geometriarecurs (
    id integer NOT NULL,
    geometria public.geometry(Geometry,4326) NOT NULL,
    idrecurs character varying(100)
);


ALTER TABLE public.georef_addenda_geometriarecurs OWNER TO aplicacio_georef;

--
-- Name: georef_addenda_geometriarecurs_id_seq; Type: SEQUENCE; Schema: public; Owner: aplicacio_georef
--

CREATE SEQUENCE public.georef_addenda_geometriarecurs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.georef_addenda_geometriarecurs_id_seq OWNER TO aplicacio_georef;

--
-- Name: georef_addenda_geometriarecurs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aplicacio_georef
--

ALTER SEQUENCE public.georef_addenda_geometriarecurs_id_seq OWNED BY public.georef_addenda_geometriarecurs.id;


--
-- Name: georef_addenda_geometriatoponimversio; Type: TABLE; Schema: public; Owner: aplicacio_georef
--

CREATE TABLE public.georef_addenda_geometriatoponimversio (
    id integer NOT NULL,
    geometria public.geometry(Geometry,4326) NOT NULL,
    idversio character varying(200),
    x_max double precision,
    x_min double precision,
    y_max double precision,
    y_min double precision
);


ALTER TABLE public.georef_addenda_geometriatoponimversio OWNER TO aplicacio_georef;

--
-- Name: georef_addenda_geometriatoponimversio_id_seq; Type: SEQUENCE; Schema: public; Owner: aplicacio_georef
--

CREATE SEQUENCE public.georef_addenda_geometriatoponimversio_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.georef_addenda_geometriatoponimversio_id_seq OWNER TO aplicacio_georef;

--
-- Name: georef_addenda_geometriatoponimversio_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aplicacio_georef
--

ALTER SEQUENCE public.georef_addenda_geometriatoponimversio_id_seq OWNED BY public.georef_addenda_geometriatoponimversio.id;


--
-- Name: georef_addenda_georeferenceprotocol; Type: TABLE; Schema: public; Owner: aplicacio_georef
--

CREATE TABLE public.georef_addenda_georeferenceprotocol (
    id integer NOT NULL,
    name character varying(500) NOT NULL,
    description text
);


ALTER TABLE public.georef_addenda_georeferenceprotocol OWNER TO aplicacio_georef;

--
-- Name: georef_addenda_georeferenceprotocol_id_seq; Type: SEQUENCE; Schema: public; Owner: aplicacio_georef
--

CREATE SEQUENCE public.georef_addenda_georeferenceprotocol_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.georef_addenda_georeferenceprotocol_id_seq OWNER TO aplicacio_georef;

--
-- Name: georef_addenda_georeferenceprotocol_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aplicacio_georef
--

ALTER SEQUENCE public.georef_addenda_georeferenceprotocol_id_seq OWNED BY public.georef_addenda_georeferenceprotocol.id;


--
-- Name: georef_addenda_helpfile; Type: TABLE; Schema: public; Owner: aplicacio_georef
--

CREATE TABLE public.georef_addenda_helpfile (
    id character varying(200) NOT NULL,
    titol text NOT NULL,
    h_file character varying(100) NOT NULL,
    created_on date NOT NULL
);


ALTER TABLE public.georef_addenda_helpfile OWNER TO aplicacio_georef;

--
-- Name: georef_addenda_lookupdescription; Type: TABLE; Schema: public; Owner: aplicacio_georef
--

CREATE TABLE public.georef_addenda_lookupdescription (
    id integer NOT NULL,
    locale character varying(10),
    description text,
    model_fully_qualified_name character varying(300),
    model_label character varying(200)
);


ALTER TABLE public.georef_addenda_lookupdescription OWNER TO aplicacio_georef;

--
-- Name: georef_addenda_lookupdescription_id_seq; Type: SEQUENCE; Schema: public; Owner: aplicacio_georef
--

CREATE SEQUENCE public.georef_addenda_lookupdescription_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.georef_addenda_lookupdescription_id_seq OWNER TO aplicacio_georef;

--
-- Name: georef_addenda_lookupdescription_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aplicacio_georef
--

ALTER SEQUENCE public.georef_addenda_lookupdescription_id_seq OWNED BY public.georef_addenda_lookupdescription.id;


--
-- Name: georef_addenda_menuitem; Type: TABLE; Schema: public; Owner: aplicacio_georef
--

CREATE TABLE public.georef_addenda_menuitem (
    id integer NOT NULL,
    title text,
    link character varying(200),
    open_in_outside_tab boolean NOT NULL,
    language character varying(5),
    "order" integer,
    is_separator boolean NOT NULL
);


ALTER TABLE public.georef_addenda_menuitem OWNER TO aplicacio_georef;

--
-- Name: georef_addenda_menuitem_id_seq; Type: SEQUENCE; Schema: public; Owner: aplicacio_georef
--

CREATE SEQUENCE public.georef_addenda_menuitem_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.georef_addenda_menuitem_id_seq OWNER TO aplicacio_georef;

--
-- Name: georef_addenda_menuitem_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aplicacio_georef
--

ALTER SEQUENCE public.georef_addenda_menuitem_id_seq OWNED BY public.georef_addenda_menuitem.id;


--
-- Name: georef_addenda_organization; Type: TABLE; Schema: public; Owner: aplicacio_georef
--

CREATE TABLE public.georef_addenda_organization (
    id integer NOT NULL,
    name character varying(200) NOT NULL,
    description text
);


ALTER TABLE public.georef_addenda_organization OWNER TO aplicacio_georef;

--
-- Name: georef_addenda_organization_id_seq; Type: SEQUENCE; Schema: public; Owner: aplicacio_georef
--

CREATE SEQUENCE public.georef_addenda_organization_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.georef_addenda_organization_id_seq OWNER TO aplicacio_georef;

--
-- Name: georef_addenda_organization_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aplicacio_georef
--

ALTER SEQUENCE public.georef_addenda_organization_id_seq OWNED BY public.georef_addenda_organization.id;


--
-- Name: georef_addenda_profile; Type: TABLE; Schema: public; Owner: aplicacio_georef
--

CREATE TABLE public.georef_addenda_profile (
    id integer NOT NULL,
    toponim_permission character varying(200),
    user_id integer NOT NULL,
    permission_administrative boolean NOT NULL,
    permission_filter_edition boolean NOT NULL,
    permission_tesaure_edition boolean NOT NULL,
    permission_recurs_edition boolean NOT NULL,
    permission_toponim_edition boolean NOT NULL,
    organization_id integer
);


ALTER TABLE public.georef_addenda_profile OWNER TO aplicacio_georef;

--
-- Name: georef_addenda_profile_id_seq; Type: SEQUENCE; Schema: public; Owner: aplicacio_georef
--

CREATE SEQUENCE public.georef_addenda_profile_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.georef_addenda_profile_id_seq OWNER TO aplicacio_georef;

--
-- Name: georef_addenda_profile_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aplicacio_georef
--

ALTER SEQUENCE public.georef_addenda_profile_id_seq OWNED BY public.georef_addenda_profile.id;


--
-- Name: linies; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.linies (
    idlinia character varying(100) NOT NULL,
    longitud numeric,
    idcartocaptura character varying(100),
    precisioh character varying(40),
    precisiov character varying(40),
    atribut character varying(100),
    idtipusatribut character varying(100),
    carto_epsg23031 public.geometry,
    CONSTRAINT enforce_dims_carto_epsg23031 CHECK ((public.st_ndims(carto_epsg23031) = 2)),
    CONSTRAINT enforce_geotype_carto_epsg23031 CHECK (((public.geometrytype(carto_epsg23031) = 'LINESTRING'::text) OR (carto_epsg23031 IS NULL))),
    CONSTRAINT enforce_srid_carto_epsg23031 CHECK ((public.st_srid(carto_epsg23031) = 4326))
);


ALTER TABLE public.linies OWNER TO postgres;

--
-- Name: liniesobjectessipan; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.liniesobjectessipan (
    id character varying(100) NOT NULL,
    idobjectessipan character varying(100) NOT NULL,
    idlinies character varying(100) NOT NULL
);


ALTER TABLE public.liniesobjectessipan OWNER TO postgres;

--
-- Name: liniespolilinies; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.liniespolilinies (
    idliniapolilinia character varying(100) NOT NULL,
    idpolilinia character varying(100) NOT NULL,
    idlinia character varying(100) NOT NULL
);


ALTER TABLE public.liniespolilinies OWNER TO postgres;

--
-- Name: logactivitatobjectessipan; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.logactivitatobjectessipan (
    idlog character varying(200) NOT NULL,
    idusuari character varying(100) NOT NULL,
    ip character varying(15),
    idmodul character varying(100) NOT NULL,
    tipusobjecte character varying(35) NOT NULL,
    idobjectesipan character varying(200),
    operacio character varying(10) NOT NULL,
    timestamp_ date NOT NULL
);


ALTER TABLE public.logactivitatobjectessipan OWNER TO postgres;

--
-- Name: marcreferencia; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.marcreferencia (
    id character varying(100) NOT NULL,
    nom character varying(100) NOT NULL
);


ALTER TABLE public.marcreferencia OWNER TO postgres;

--
-- Name: municipis; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.municipis (
    idmunicipi character varying(100) NOT NULL,
    codiine character varying(6),
    datamunicipi date,
    nommunicipi character varying(255),
    areaoficial numeric,
    areareal numeric,
    perimetrereal numeric,
    perimetreoficial numeric,
    idcomarca character varying(100),
    idprovincia character varying(100),
    nifcif character varying(10),
    idgeometria character varying(100)
);


ALTER TABLE public.municipis OWNER TO postgres;

--
-- Name: pais; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pais (
    id character varying(100) NOT NULL,
    nom character varying(200) NOT NULL,
    description text
);


ALTER TABLE public.pais OWNER TO postgres;

--
-- Name: paraulaclau; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.paraulaclau (
    id character varying(100) NOT NULL,
    paraula character varying(500) NOT NULL,
    description text
);


ALTER TABLE public.paraulaclau OWNER TO postgres;

--
-- Name: paraulaclaurecursgeoref; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.paraulaclaurecursgeoref (
    id character varying(100) NOT NULL,
    idrecursgeoref character varying(100) NOT NULL,
    idparaula character varying(100) NOT NULL
);


ALTER TABLE public.paraulaclaurecursgeoref OWNER TO postgres;

--
-- Name: poligons; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.poligons (
    idpoligon character varying(100) NOT NULL,
    idpoligoncontenidor character varying(100),
    area numeric,
    atribut character varying(100),
    idtipusatribut character varying(100),
    idpolilinia character varying(100) NOT NULL,
    carto_epsg23031 public.geometry,
    CONSTRAINT enforce_dims_carto_epsg23031 CHECK ((public.st_ndims(carto_epsg23031) = 2)),
    CONSTRAINT enforce_geotype_carto_epsg23031 CHECK (((public.geometrytype(carto_epsg23031) = 'POLYGON'::text) OR (carto_epsg23031 IS NULL))),
    CONSTRAINT enforce_srid_carto_epsg23031 CHECK ((public.st_srid(carto_epsg23031) = 4326))
);


ALTER TABLE public.poligons OWNER TO postgres;

--
-- Name: poligonsobjectessipan; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.poligonsobjectessipan (
    id character varying(100) NOT NULL,
    idobjectessipan character varying(100) NOT NULL,
    idpoligons character varying(100) NOT NULL
);


ALTER TABLE public.poligonsobjectessipan OWNER TO postgres;

--
-- Name: poligonspolipoligons; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.poligonspolipoligons (
    idpoligonpolipoligon character varying(100) NOT NULL,
    idpolipoligon character varying(100) NOT NULL,
    idpoligon character varying(100) NOT NULL
);


ALTER TABLE public.poligonspolipoligons OWNER TO postgres;

--
-- Name: polilinies; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.polilinies (
    idpolilinia character varying(200) NOT NULL,
    atribut character varying(100),
    idtipusatribut character varying(100)
);


ALTER TABLE public.polilinies OWNER TO postgres;

--
-- Name: polipoligons; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.polipoligons (
    idpolipoligon character varying(200) NOT NULL,
    atribut character varying(100),
    idtipusatribut character varying(100)
);


ALTER TABLE public.polipoligons OWNER TO postgres;

--
-- Name: polipunts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.polipunts (
    idpolipunt character varying(200) NOT NULL,
    atribut character varying(100),
    idtipusatribut character varying(100)
);


ALTER TABLE public.polipunts OWNER TO postgres;

--
-- Name: prefs_visibilitat_capes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.prefs_visibilitat_capes (
    id character varying(100) NOT NULL,
    idusuari character varying(100),
    prefscapesjson text,
    iduser integer
);


ALTER TABLE public.prefs_visibilitat_capes OWNER TO postgres;

--
-- Name: projeccio; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.projeccio (
    id character varying(100) NOT NULL,
    nom character varying(100) NOT NULL
);


ALTER TABLE public.projeccio OWNER TO postgres;

--
-- Name: provincies; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.provincies (
    idprovincia character varying(100) NOT NULL,
    codiprovincia character varying(3),
    nomprovincia character varying(255) NOT NULL,
    idgeometria character varying(100)
);


ALTER TABLE public.provincies OWNER TO postgres;

--
-- Name: punts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.punts (
    idpunt character varying(200) NOT NULL,
    idcoordenada character varying(200),
    idcartocaptura character varying(100),
    precisioh character varying(40),
    precisiov character varying(40),
    atribut character varying(100),
    idtipusatribut character varying(100),
    carto_epsg23031 public.geometry,
    CONSTRAINT enforce_dims_carto_epsg23031 CHECK ((public.st_ndims(carto_epsg23031) = 2)),
    CONSTRAINT enforce_geotype_carto_epsg23031 CHECK (((public.geometrytype(carto_epsg23031) = 'POINT'::text) OR (carto_epsg23031 IS NULL))),
    CONSTRAINT enforce_srid_carto_epsg23031 CHECK ((public.st_srid(carto_epsg23031) = 4326))
);


ALTER TABLE public.punts OWNER TO postgres;

--
-- Name: puntsobjectessipan; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.puntsobjectessipan (
    id character varying(100) NOT NULL,
    idobjectessipan character varying(100) NOT NULL,
    idpunts character varying(100) NOT NULL
);


ALTER TABLE public.puntsobjectessipan OWNER TO postgres;

--
-- Name: puntspolipunts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.puntspolipunts (
    idpuntpolipunt character varying(200) NOT NULL,
    idpolipunt character varying(200),
    idpunt character varying(200)
);


ALTER TABLE public.puntspolipunts OWNER TO postgres;

--
-- Name: qualificadorversio; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.qualificadorversio (
    id character varying(100) NOT NULL,
    qualificador character varying(500) NOT NULL,
    description text
);


ALTER TABLE public.qualificadorversio OWNER TO postgres;

--
-- Name: recursgeoref; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.recursgeoref (
    id character varying(100) NOT NULL,
    nom character varying(500) NOT NULL,
    idtipusrecursgeoref character varying(100),
    comentarisnoambit character varying(500),
    campidtoponim character varying(500),
    idsistemareferenciaepsg character varying(100),
    versio character varying(100),
    fitxergraficbase character varying(100),
    idsuport character varying(100),
    urlsuport character varying(250),
    ubicaciorecurs character varying(200),
    actualitzaciosuport character varying(250),
    mapa character varying(100),
    comentariinfo text,
    comentariconsulta text,
    comentariqualitat text,
    classificacio character varying(300),
    divisiopoliticoadministrativa character varying(300),
    idambit character varying(100),
    acronim character varying(100),
    idsistemareferenciamm character varying(100),
    idtipusunitatscarto character varying(100),
    idgeometria character varying(200),
    base_url_wms character varying(255),
    capes_wms_json text,
    iduser integer
);


ALTER TABLE public.recursgeoref OWNER TO postgres;

--
-- Name: recursgeoreftoponim; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.recursgeoreftoponim (
    id character varying(100) NOT NULL,
    idrecursgeoref character varying(100) NOT NULL,
    idtoponim character varying(200)
);


ALTER TABLE public.recursgeoreftoponim OWNER TO postgres;

--
-- Name: recursosgeoreferenciacio; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.recursosgeoreferenciacio AS
 SELECT id,
    nom,
    acronim,
    idsuport,
    tipus_geom,
    paraulaclau,
    carto_epsg23031
   FROM ( SELECT DISTINCT t2.id,
            t2.nom,
            t2.acronim,
            t2.idsuport,
                CASE
                    WHEN (public.st_geometrytype(public.st_transform(gr.geometria, 4326)) = 'ST_Point'::text) THEN 'T'::text
                    WHEN (public.st_geometrytype(public.st_transform(gr.geometria, 4326)) = 'ST_Polygon'::text) THEN 'P'::text
                    WHEN (public.st_geometrytype(public.st_transform(gr.geometria, 4326)) = 'ST_Line'::text) THEN 'A'::text
                    ELSE NULL::text
                END AS tipus_geom,
            string_agg((pc.paraula)::text, ' '::text) AS paraulaclau,
            public.st_transform(gr.geometria, 4326) AS carto_epsg23031
           FROM (((public.recursgeoref t2
             JOIN public.georef_addenda_geometriarecurs gr ON (((gr.idrecurs)::text = (t2.id)::text)))
             LEFT JOIN public.paraulaclaurecursgeoref pcr ON (((t2.id)::text = (pcr.idrecursgeoref)::text)))
             LEFT JOIN public.paraulaclau pc ON (((pc.id)::text = (pcr.idparaula)::text)))
          GROUP BY t2.id, t2.nom, t2.acronim, t2.idsuport, (public.st_transform(gr.geometria, 4326))) uniogeom;


ALTER VIEW public.recursosgeoreferenciacio OWNER TO postgres;

--
-- Name: recursosgeoreferenciacio_wms_bound; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.recursosgeoreferenciacio_wms_bound AS
 SELECT c.id,
    r.nom,
    r.acronim,
    r.idsuport,
    string_agg((pc.paraula)::text, ' '::text) AS paraulaclau,
    c.name,
    c.label,
    'P'::text AS tipus_geom,
    c.boundary AS carto_epsg23031
   FROM ((((public.recursgeoref r
     JOIN public.capesrecurs cr ON (((cr.idrecurs)::text = (r.id)::text)))
     JOIN public.capawms c ON (((c.id)::text = (cr.idcapa)::text)))
     LEFT JOIN public.paraulaclaurecursgeoref pcr ON (((r.id)::text = (pcr.idrecursgeoref)::text)))
     LEFT JOIN public.paraulaclau pc ON (((pc.id)::text = (pcr.idparaula)::text)))
  GROUP BY c.id, r.nom, r.acronim, r.idsuport, c.name, c.label, c.boundary;


ALTER VIEW public.recursosgeoreferenciacio_wms_bound OWNER TO postgres;

--
-- Name: registresrafel; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.registresrafel (
    max text,
    codi character varying(50),
    nom character varying(250),
    datacaptura date,
    coordenada_x double precision,
    coordenada_y double precision,
    coordenada_z double precision,
    precisio_h double precision,
    precisio_z double precision,
    idsistemareferenciarecurs character varying(100),
    coordenada_x_origen character varying(50),
    coordenada_y_origen character varying(50),
    coordenada_z_origen character varying(50),
    precisio_h_origen character varying(50),
    precisio_z_origen character varying(50),
    idpersona character varying(100),
    observacions text,
    idlimitcartooriginal character varying(100),
    idrecursgeoref character varying(100),
    idtoponim character varying(200),
    numero_versio integer
);


ALTER TABLE public.registresrafel OWNER TO postgres;

--
-- Name: registreusuaris; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.registreusuaris (
    id character varying(100) NOT NULL,
    idusuari character varying(100),
    ip character varying(15),
    horaentrada date,
    horasortida date,
    idmodul character varying(100)
);


ALTER TABLE public.registreusuaris OWNER TO postgres;

--
-- Name: rols; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.rols (
    idrol character varying(100) NOT NULL,
    rol character varying(100) NOT NULL,
    idmodul character varying(100) NOT NULL,
    descripcio character varying(4000)
);


ALTER TABLE public.rols OWNER TO postgres;

--
-- Name: rolsaplicaciousuari; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.rolsaplicaciousuari (
    idfuncionalitat character varying(100) NOT NULL,
    funcionalitat character varying(100) NOT NULL,
    idmodul character varying(100) NOT NULL,
    idusuari character varying(100) NOT NULL
);


ALTER TABLE public.rolsaplicaciousuari OWNER TO postgres;

--
-- Name: rolsdadesusuari; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.rolsdadesusuari (
    idroldadesusuari character varying(100) NOT NULL,
    idrol character varying(100) NOT NULL,
    valorrol character varying(500) NOT NULL,
    idusuari character varying(100) NOT NULL,
    editar character(1),
    inserir character(1),
    esborrar character(1),
    veure character(1)
);


ALTER TABLE public.rolsdadesusuari OWNER TO postgres;

--
-- Name: servidorswms; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.servidorswms (
    idservidorwms character varying(40) NOT NULL,
    titolservidor character varying(255),
    urlservidor character varying(255),
    idmodul character varying(100)
);


ALTER TABLE public.servidorswms OWNER TO postgres;

--
-- Name: sistemareferencia; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sistemareferencia (
    id character varying(100) NOT NULL,
    idepsg integer NOT NULL
);


ALTER TABLE public.sistemareferencia OWNER TO postgres;

--
-- Name: sistemareferenciamm; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sistemareferenciamm (
    id character varying(100) NOT NULL,
    nom character varying(500) NOT NULL
);


ALTER TABLE public.sistemareferenciamm OWNER TO postgres;

--
-- Name: sistemareferenciarecurs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sistemareferenciarecurs (
    id character varying(100) NOT NULL,
    idrecursgeoref character varying(100) NOT NULL,
    idsistemareferenciamm character varying(100),
    sistemareferencia character varying(1000),
    conversio character varying(250)
);


ALTER TABLE public.sistemareferenciarecurs OWNER TO postgres;

--
-- Name: sistemesreferencia; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sistemesreferencia (
    idsistemareferencia character varying(100) NOT NULL,
    sistemareferencia character varying(100) NOT NULL
);


ALTER TABLE public.sistemesreferencia OWNER TO postgres;

--
-- Name: suport; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.suport (
    id character varying(100) NOT NULL,
    nom character varying(100) NOT NULL,
    description text
);


ALTER TABLE public.suport OWNER TO postgres;

--
-- Name: tipusatributs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tipusatributs (
    idtipusatribut character varying(100) NOT NULL,
    tipusatribut character varying(100) NOT NULL
);


ALTER TABLE public.tipusatributs OWNER TO postgres;

--
-- Name: tipusclassificaciosol; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tipusclassificaciosol (
    id character varying(100) NOT NULL,
    nom character varying(100) NOT NULL
);


ALTER TABLE public.tipusclassificaciosol OWNER TO postgres;

--
-- Name: tipusrecursgeoref; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tipusrecursgeoref (
    id character varying(100) NOT NULL,
    nom character varying(100) NOT NULL,
    description text
);


ALTER TABLE public.tipusrecursgeoref OWNER TO postgres;

--
-- Name: tipustoponim; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tipustoponim (
    id character varying(100) NOT NULL,
    nom character varying(100) NOT NULL,
    description text
);


ALTER TABLE public.tipustoponim OWNER TO postgres;

--
-- Name: tipusunitats; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tipusunitats (
    id character varying(100) NOT NULL,
    tipusunitat character varying(500) NOT NULL,
    description text
);


ALTER TABLE public.tipusunitats OWNER TO postgres;

--
-- Name: toponim; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.toponim (
    id character varying(200) NOT NULL,
    codi character varying(50),
    nom character varying(250) NOT NULL,
    aquatic character(1),
    idtipustoponim character varying(100) NOT NULL,
    idpais character varying(100),
    idpare character varying(200),
    nom_fitxer_importacio character varying(255),
    linia_fitxer_importacio text,
    denormalized_toponimtree text,
    idorganization_id integer,
    sinonims character varying(500)
);


ALTER TABLE public.toponim OWNER TO postgres;

--
-- Name: toponims_api; Type: TABLE; Schema: public; Owner: aplicacio_georef
--

CREATE TABLE public.toponims_api (
    id character varying(200) NOT NULL,
    nomtoponim character varying(255),
    nom character varying(500),
    aquatic boolean,
    tipus character varying(255),
    idtipus character varying(255),
    datacaptura date,
    coordenadaxcentroide double precision,
    coordenadaycentroide double precision,
    incertesa double precision
);


ALTER TABLE public.toponims_api OWNER TO aplicacio_georef;

--
-- Name: toponimversio; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.toponimversio (
    id character varying(200) NOT NULL,
    codi character varying(50),
    nom character varying(250) NOT NULL,
    datacaptura date,
    coordenada_x double precision,
    coordenada_y double precision,
    coordenada_z double precision,
    precisio_h double precision,
    precisio_z double precision,
    idsistemareferenciarecurs character varying(100),
    coordenada_x_origen character varying(50),
    coordenada_y_origen character varying(50),
    coordenada_z_origen character varying(50),
    precisio_h_origen character varying(50),
    precisio_z_origen character varying(50),
    idpersona character varying(100),
    observacions text,
    idlimitcartooriginal character varying(100),
    idrecursgeoref character varying(100),
    idtoponim character varying(200),
    numero_versio integer,
    idqualificador character varying(100),
    coordenada_x_centroide character varying(50),
    coordenada_y_centroide character varying(50),
    idgeometria character varying(200),
    iduser integer,
    last_version boolean,
    altitud_profunditat_minima integer,
    altitud_profunditat_maxima integer,
    georefcalc_string text,
    georefcalc_uncertainty double precision,
    centroid_calc_method integer NOT NULL,
    georeference_protocol_id integer NOT NULL
);


ALTER TABLE public.toponimversio OWNER TO postgres;

--
-- Name: toponimsbasatsenrecurs; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.toponimsbasatsenrecurs AS
 SELECT DISTINCT t2.codi,
    t2.id,
    t2.nom,
    t2.numero_versio,
    r.id AS idrecurs,
    r.nom AS nomrecurs,
        CASE
            WHEN (public.st_geometrytype(gt.geometria) = 'ST_Point'::text) THEN 'T'::text
            WHEN (public.st_geometrytype(gt.geometria) = 'ST_Polygon'::text) THEN 'P'::text
            WHEN (public.st_geometrytype(gt.geometria) = 'ST_Line'::text) THEN 'A'::text
            ELSE NULL::text
        END AS tipus_geom,
    gt.geometria AS carto_epsg23031
   FROM ( SELECT tv.codi,
            tv.id,
            max(tv.numero_versio) AS numero_versio
           FROM public.toponimversio tv
          WHERE (tv.numero_versio IS NOT NULL)
          GROUP BY tv.codi, tv.id) t1,
    public.toponimversio t2,
    public.recursgeoref r,
    public.georef_addenda_geometriatoponimversio gt
  WHERE (((t1.id)::text = (t2.id)::text) AND ((t2.id)::text = (gt.idversio)::text) AND (t1.numero_versio = t2.numero_versio) AND ((t2.idrecursgeoref)::text = (r.id)::text));


ALTER VIEW public.toponimsbasatsenrecurs OWNER TO postgres;

--
-- Name: toponimsdarreraversio; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.toponimsdarreraversio AS
 SELECT uniogeom.codi,
    uniogeom.idversio,
    uniogeom.idq,
    uniogeom.idtoponim,
    uniogeom.idorg,
    uniogeom.aquatic,
    uniogeom.nomtoponim,
    uniogeom.denormalized_toponimtree,
    uniogeom.tipustoponim,
    uniogeom.idtipustoponim,
    ''::text AS nompais,
    NULL::text AS idpais,
    uniogeom.nomversio,
    uniogeom.numero_versio,
    uniogeom.tipus_geom,
    uniogeom.geometria,
    public.st_setsrid(uniogeom.geometria, 0) AS carto_epsg23031_cql,
    uniogeom.iduser
   FROM ( SELECT DISTINCT t2.codi,
            t2.id AS idversio,
            t2.idqualificador AS idq,
            top.id AS idtoponim,
            top.idorganization_id AS idorg,
            top.aquatic,
            top.nom AS nomtoponim,
            top.denormalized_toponimtree,
            tt.nom AS tipustoponim,
            tt.id AS idtipustoponim,
            t2.nom AS nomversio,
            t2.numero_versio,
                CASE
                    WHEN (public.st_geometrytype(gt.geometria) = 'ST_Point'::text) THEN 'T'::text
                    WHEN (public.st_geometrytype(gt.geometria) = 'ST_Polygon'::text) THEN 'P'::text
                    WHEN (public.st_geometrytype(gt.geometria) = 'ST_Line'::text) THEN 'A'::text
                    ELSE NULL::text
                END AS tipus_geom,
            gt.geometria,
            t2.iduser
           FROM public.toponimversio t2,
            public.toponim top,
            public.tipustoponim tt,
            public.georef_addenda_geometriatoponimversio gt
          WHERE (((t2.id)::text = (gt.idversio)::text) AND ((t2.idtoponim)::text = (top.id)::text) AND ((top.idtipustoponim)::text = (tt.id)::text))) uniogeom,
    ( SELECT toponimversio.idtoponim,
            max(toponimversio.numero_versio) AS numero_versio
           FROM public.toponimversio
          GROUP BY toponimversio.idtoponim
         HAVING (max(toponimversio.numero_versio) IS NOT NULL)) darreraversio
  WHERE (((uniogeom.idtoponim)::text = (darreraversio.idtoponim)::text) AND (uniogeom.numero_versio = darreraversio.numero_versio))
  ORDER BY uniogeom.nomtoponim;


ALTER VIEW public.toponimsdarreraversio OWNER TO postgres;

--
-- Name: toponimsdarreraversio_nocalc; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.toponimsdarreraversio_nocalc AS
 SELECT uniogeom.codi,
    uniogeom.idversio,
    uniogeom.idtoponim,
    uniogeom.aquatic,
    uniogeom.nomtoponim,
    uniogeom.tipustoponim,
    uniogeom.idtipustoponim,
    uniogeom.nompais,
    uniogeom.idpais,
    uniogeom.nomversio,
    uniogeom.numero_versio,
    uniogeom.tipus_geom,
    uniogeom.coordenada_x_centroide,
    uniogeom.coordenada_y_centroide,
    uniogeom.precisio_h,
    public.st_transform(public.st_buffer(public.st_transform(public.st_setsrid(public.st_makepoint((uniogeom.coordenada_x_centroide)::double precision, (uniogeom.coordenada_y_centroide)::double precision), 4326), public.utmzone(public.st_setsrid(public.st_makepoint((uniogeom.coordenada_x_centroide)::double precision, (uniogeom.coordenada_y_centroide)::double precision), 4326))), uniogeom.precisio_h), 4326) AS carto_epsg23031
   FROM ( SELECT DISTINCT t2.codi,
            t2.precisio_h,
            t2.coordenada_x_centroide,
            t2.coordenada_y_centroide,
            t2.id AS idversio,
            top.id AS idtoponim,
            top.aquatic,
            top.nom AS nomtoponim,
            tt.nom AS tipustoponim,
            tt.id AS idtipustoponim,
            pa.nom AS nompais,
            pa.id AS idpais,
            t2.nom AS nomversio,
            t2.numero_versio,
                CASE
                    WHEN (public.st_geometrytype(gt.geometria) = 'ST_Point'::text) THEN 'T'::text
                    WHEN (public.st_geometrytype(gt.geometria) = 'ST_Polygon'::text) THEN 'P'::text
                    WHEN (public.st_geometrytype(gt.geometria) = 'ST_Line'::text) THEN 'A'::text
                    ELSE NULL::text
                END AS tipus_geom,
            gt.geometria
           FROM public.toponimversio t2,
            public.toponim top,
            public.tipustoponim tt,
            public.pais pa,
            public.georef_addenda_geometriatoponimversio gt
          WHERE (((t2.id)::text = (gt.idversio)::text) AND ((t2.idtoponim)::text = (top.id)::text) AND ((top.idtipustoponim)::text = (tt.id)::text) AND ((top.idpais)::text = (pa.id)::text))) uniogeom,
    ( SELECT toponimversio.idtoponim,
            max(toponimversio.numero_versio) AS numero_versio
           FROM public.toponimversio
          GROUP BY toponimversio.idtoponim
         HAVING (max(toponimversio.numero_versio) IS NOT NULL)) darreraversio
  WHERE (((uniogeom.idtoponim)::text = (darreraversio.idtoponim)::text) AND (uniogeom.numero_versio = darreraversio.numero_versio) AND ((uniogeom.coordenada_x_centroide)::text <> ''::text) AND ((uniogeom.coordenada_y_centroide)::text <> ''::text));


ALTER VIEW public.toponimsdarreraversio_nocalc OWNER TO postgres;

--
-- Name: toponimsdarreraversio_radi; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.toponimsdarreraversio_radi AS
 SELECT int4(row_number() OVER (ORDER BY uniogeom.idversio)) AS id,
    uniogeom.codi,
    uniogeom.idversio,
    uniogeom.idtoponim,
    uniogeom.aquatic,
    uniogeom.nomtoponim,
    uniogeom.tipustoponim,
    uniogeom.idtipustoponim,
    uniogeom.nompais,
    uniogeom.idpais,
    uniogeom.nomversio,
    uniogeom.numero_versio,
    uniogeom.precisio_h,
    uniogeom.coordenada_x_centroide,
    uniogeom.coordenada_y_centroide,
    uniogeom.tipus_geom,
    uniogeom.carto_epsg23031
   FROM ( SELECT DISTINCT t2.codi,
            t2.precisio_h,
            public.st_x(public.st_centroid(gt.geometria)) AS coordenada_x_centroide,
            public.st_y(public.st_centroid(gt.geometria)) AS coordenada_y_centroide,
            t2.id AS idversio,
            top.id AS idtoponim,
            top.aquatic,
            top.nom AS nomtoponim,
            tt.nom AS tipustoponim,
            tt.id AS idtipustoponim,
            pa.nom AS nompais,
            pa.id AS idpais,
            t2.nom AS nomversio,
            t2.numero_versio,
                CASE
                    WHEN (public.st_geometrytype(gt.geometria) = 'ST_Point'::text) THEN 'T'::text
                    WHEN (public.st_geometrytype(gt.geometria) = 'ST_Polygon'::text) THEN 'P'::text
                    WHEN (public.st_geometrytype(gt.geometria) = 'ST_Line'::text) THEN 'A'::text
                    ELSE NULL::text
                END AS tipus_geom,
            public.st_transform(public.st_buffer(public.st_transform(gt.geometria, public.utmzone(public.st_centroid(gt.geometria))), t2.precisio_h), 4326) AS carto_epsg23031
           FROM public.toponimversio t2,
            public.toponim top,
            public.tipustoponim tt,
            public.pais pa,
            public.georef_addenda_geometriatoponimversio gt
          WHERE (((t2.id)::text = (gt.idversio)::text) AND ((t2.idtoponim)::text = (top.id)::text) AND ((top.idtipustoponim)::text = (tt.id)::text) AND ((top.idpais)::text = (pa.id)::text))) uniogeom,
    ( SELECT toponimversio.idtoponim,
            max(toponimversio.numero_versio) AS numero_versio
           FROM public.toponimversio
          GROUP BY toponimversio.idtoponim
         HAVING (max(toponimversio.numero_versio) IS NOT NULL)) darreraversio
  WHERE (((uniogeom.idtoponim)::text = (darreraversio.idtoponim)::text) AND (uniogeom.numero_versio = darreraversio.numero_versio) AND (uniogeom.precisio_h >= (0)::double precision));


ALTER VIEW public.toponimsdarreraversio_radi OWNER TO postgres;

--
-- Name: toponimsdarreraversiocentroide; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.toponimsdarreraversiocentroide AS
 SELECT uniogeom.codi,
    uniogeom.idversio,
    uniogeom.idtoponim,
    uniogeom.aquatic,
    uniogeom.nomtoponim,
    uniogeom.tipustoponim,
    uniogeom.idtipustoponim,
    uniogeom.nompais,
    uniogeom.idpais,
    uniogeom.nomversio,
    uniogeom.numero_versio,
    uniogeom.tipus_geom,
    public.st_centroid(uniogeom.carto_epsg23031) AS carto_epsg23031
   FROM ( SELECT DISTINCT t2.codi,
            t2.id AS idversio,
            top.id AS idtoponim,
            top.aquatic,
            top.nom AS nomtoponim,
            tt.nom AS tipustoponim,
            tt.id AS idtipustoponim,
            pa.nom AS nompais,
            pa.id AS idpais,
            t2.nom AS nomversio,
            t2.numero_versio,
            'T'::text AS tipus_geom,
            p.carto_epsg23031
           FROM public.toponimversio t2,
            public.toponim top,
            public.geometria g,
            public.puntspolipunts ppp,
            public.punts p,
            public.coordenades c,
            public.tipustoponim tt,
            public.pais pa
          WHERE (((t2.idgeometria)::text = (g.idgeometria)::text) AND ((g.idpolipunt)::text = (ppp.idpolipunt)::text) AND ((ppp.idpunt)::text = (p.idpunt)::text) AND ((p.idcoordenada)::text = (c.idcoordenada)::text) AND ((t2.idtoponim)::text = (top.id)::text) AND ((top.idtipustoponim)::text = (tt.id)::text) AND ((top.idpais)::text = (pa.id)::text))
        UNION
         SELECT DISTINCT t2.codi,
            t2.id AS idversio,
            top.id AS idtoponim,
            top.aquatic,
            top.nom AS nomtoponim,
            tt.nom AS tipustoponim,
            tt.id AS idtipustoponim,
            pa.nom AS nompais,
            pa.id AS idpais,
            t2.nom AS nomversio,
            t2.numero_versio,
            'P'::text AS tipus_geom,
            poligon.carto_epsg23031
           FROM public.toponimversio t2,
            public.toponim top,
            public.geometria g,
            public.poligonspolipoligons polip,
            public.poligons poligon,
            public.tipustoponim tt,
            public.pais pa
          WHERE (((t2.idgeometria)::text = (g.idgeometria)::text) AND ((g.idpolipoligon)::text = (polip.idpolipoligon)::text) AND ((polip.idpoligon)::text = (poligon.idpoligon)::text) AND ((t2.idtoponim)::text = (top.id)::text) AND ((top.idtipustoponim)::text = (tt.id)::text) AND ((top.idpais)::text = (pa.id)::text))
        UNION
         SELECT DISTINCT t2.codi,
            t2.id AS idversio,
            top.id AS idtoponim,
            top.aquatic,
            top.nom AS nomtoponim,
            tt.nom AS tipustoponim,
            tt.id AS idtipustoponim,
            pa.nom AS nompais,
            pa.id AS idpais,
            t2.nom AS nomversio,
            t2.numero_versio,
            'A'::text AS tipus_geom,
            linies.carto_epsg23031
           FROM public.toponimversio t2,
            public.toponim top,
            public.geometria g,
            public.liniespolilinies linp,
            public.linies linies,
            public.tipustoponim tt,
            public.pais pa
          WHERE (((t2.idgeometria)::text = (g.idgeometria)::text) AND ((g.idpolilinia)::text = (linp.idpolilinia)::text) AND ((linp.idlinia)::text = (linies.idlinia)::text) AND ((t2.idtoponim)::text = (top.id)::text) AND ((top.idtipustoponim)::text = (tt.id)::text) AND ((top.idpais)::text = (pa.id)::text))) uniogeom,
    ( SELECT toponimversio.idtoponim,
            max(toponimversio.numero_versio) AS numero_versio
           FROM public.toponimversio
          GROUP BY toponimversio.idtoponim
         HAVING (max(toponimversio.numero_versio) IS NOT NULL)) darreraversio
  WHERE (((uniogeom.idtoponim)::text = (darreraversio.idtoponim)::text) AND (uniogeom.numero_versio = darreraversio.numero_versio));


ALTER VIEW public.toponimsdarreraversiocentroide OWNER TO postgres;

--
-- Name: toponimsdarreraversiocentroide_nocalc; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.toponimsdarreraversiocentroide_nocalc AS
 SELECT uniogeom.codi,
    uniogeom.idversio,
    uniogeom.idtoponim,
    uniogeom.aquatic,
    uniogeom.nomtoponim,
    uniogeom.tipustoponim,
    uniogeom.idtipustoponim,
    uniogeom.nompais,
    uniogeom.idpais,
    uniogeom.nomversio,
    uniogeom.numero_versio,
    uniogeom.tipus_geom,
    uniogeom.coordenada_x_centroide,
    uniogeom.coordenada_y_centroide,
    uniogeom.precisio_h,
    public.st_transform(public.st_buffer(public.st_transform(public.st_setsrid(public.st_makepoint((uniogeom.coordenada_x_centroide)::double precision, (uniogeom.coordenada_y_centroide)::double precision), 4326), public.utmzone(public.st_setsrid(public.st_makepoint((uniogeom.coordenada_x_centroide)::double precision, (uniogeom.coordenada_y_centroide)::double precision), 4326))), uniogeom.precisio_h), 4326) AS carto_epsg23031
   FROM ( SELECT DISTINCT t2.codi,
            t2.precisio_h,
            t2.coordenada_x_centroide,
            t2.coordenada_y_centroide,
            t2.id AS idversio,
            top.id AS idtoponim,
            top.aquatic,
            top.nom AS nomtoponim,
            tt.nom AS tipustoponim,
            tt.id AS idtipustoponim,
            pa.nom AS nompais,
            pa.id AS idpais,
            t2.nom AS nomversio,
            t2.numero_versio,
            'T'::text AS tipus_geom,
            p.carto_epsg23031
           FROM public.toponimversio t2,
            public.toponim top,
            public.geometria g,
            public.puntspolipunts ppp,
            public.punts p,
            public.tipustoponim tt,
            public.pais pa
          WHERE (((t2.idgeometria)::text = (g.idgeometria)::text) AND ((g.idpolipunt)::text = (ppp.idpolipunt)::text) AND ((ppp.idpunt)::text = (p.idpunt)::text) AND ((t2.idtoponim)::text = (top.id)::text) AND ((top.idtipustoponim)::text = (tt.id)::text) AND ((top.idpais)::text = (pa.id)::text))
        UNION
         SELECT DISTINCT t2.codi,
            t2.precisio_h,
            t2.coordenada_x_centroide,
            t2.coordenada_y_centroide,
            t2.id AS idversio,
            top.id AS idtoponim,
            top.aquatic,
            top.nom AS nomtoponim,
            tt.nom AS tipustoponim,
            tt.id AS idtipustoponim,
            pa.nom AS nompais,
            pa.id AS idpais,
            t2.nom AS nomversio,
            t2.numero_versio,
            'P'::text AS tipus_geom,
            poligon.carto_epsg23031
           FROM public.toponimversio t2,
            public.toponim top,
            public.geometria g,
            public.poligonspolipoligons polip,
            public.poligons poligon,
            public.tipustoponim tt,
            public.pais pa
          WHERE (((t2.idgeometria)::text = (g.idgeometria)::text) AND ((g.idpolipoligon)::text = (polip.idpolipoligon)::text) AND ((polip.idpoligon)::text = (poligon.idpoligon)::text) AND ((t2.idtoponim)::text = (top.id)::text) AND ((top.idtipustoponim)::text = (tt.id)::text) AND ((top.idpais)::text = (pa.id)::text))
        UNION
         SELECT DISTINCT t2.codi,
            t2.precisio_h,
            t2.coordenada_x_centroide,
            t2.coordenada_y_centroide,
            t2.id AS idversio,
            top.id AS idtoponim,
            top.aquatic,
            top.nom AS nomtoponim,
            tt.nom AS tipustoponim,
            tt.id AS idtipustoponim,
            pa.nom AS nompais,
            pa.id AS idpais,
            t2.nom AS nomversio,
            t2.numero_versio,
            'A'::text AS tipus_geom,
            linies.carto_epsg23031
           FROM public.toponimversio t2,
            public.toponim top,
            public.geometria g,
            public.liniespolilinies linp,
            public.linies linies,
            public.tipustoponim tt,
            public.pais pa
          WHERE (((t2.idgeometria)::text = (g.idgeometria)::text) AND ((g.idpolilinia)::text = (linp.idpolilinia)::text) AND ((linp.idlinia)::text = (linies.idlinia)::text) AND ((t2.idtoponim)::text = (top.id)::text) AND ((top.idtipustoponim)::text = (tt.id)::text) AND ((top.idpais)::text = (pa.id)::text))) uniogeom,
    ( SELECT toponimversio.idtoponim,
            max(toponimversio.numero_versio) AS numero_versio
           FROM public.toponimversio
          GROUP BY toponimversio.idtoponim
         HAVING (max(toponimversio.numero_versio) IS NOT NULL)) darreraversio
  WHERE (((uniogeom.idtoponim)::text = (darreraversio.idtoponim)::text) AND (uniogeom.numero_versio = darreraversio.numero_versio) AND ((uniogeom.coordenada_x_centroide)::text <> ''::text) AND ((uniogeom.coordenada_y_centroide)::text <> ''::text));


ALTER VIEW public.toponimsdarreraversiocentroide_nocalc OWNER TO postgres;

--
-- Name: toponimsexclosos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.toponimsexclosos (
    idtoponim character varying(100) NOT NULL,
    idtoponimexclos character varying(100) NOT NULL
);


ALTER TABLE public.toponimsexclosos OWNER TO postgres;

--
-- Name: toponimsversio_api; Type: TABLE; Schema: public; Owner: aplicacio_georef
--

CREATE TABLE public.toponimsversio_api (
    id character varying(200) NOT NULL,
    nom character varying(500),
    nomtoponim character varying(255),
    tipus character varying(100),
    versio integer,
    qualificadorversio character varying(500),
    recurscaptura character varying(500),
    sistrefrecurs character varying(1000),
    datacaptura date,
    coordxoriginal character varying(100),
    coordyoriginal character varying(100),
    coordz double precision,
    incertesaz double precision,
    georeferenciatper character varying(500),
    observacions text,
    coordxcentroide double precision,
    coordycentroide double precision,
    incertesacoord double precision,
    idtoponim character varying(200)
);


ALTER TABLE public.toponimsversio_api OWNER TO aplicacio_georef;

--
-- Name: toponimsversiorecurs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.toponimsversiorecurs (
    idrecursgeoref character varying(100),
    idtoponimversio character varying(100)
);


ALTER TABLE public.toponimsversiorecurs OWNER TO postgres;

--
-- Name: toponimversio_backup; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.toponimversio_backup (
    id character varying(200),
    codi character varying(50),
    nom character varying(250),
    datacaptura date,
    coordenada_x double precision,
    coordenada_y double precision,
    coordenada_z double precision,
    precisio_h double precision,
    precisio_z double precision,
    idsistemareferenciarecurs character varying(100),
    coordenada_x_origen character varying(50),
    coordenada_y_origen character varying(50),
    coordenada_z_origen character varying(50),
    precisio_h_origen character varying(50),
    precisio_z_origen character varying(50),
    idpersona character varying(100),
    observacions text,
    idlimitcartooriginal character varying(100),
    idrecursgeoref character varying(100),
    idtoponim character varying(200),
    numero_versio integer
);


ALTER TABLE public.toponimversio_backup OWNER TO postgres;

--
-- Name: usuariauthority; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.usuariauthority (
    idusuari character varying(100),
    idauthority character varying(100)
);


ALTER TABLE public.usuariauthority OWNER TO postgres;

--
-- Name: usuaripermisediciotoponimauth; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.usuaripermisediciotoponimauth (
    id character varying(200) NOT NULL,
    idusuari character varying(100),
    idauthority character varying(100),
    idtoponim character varying(200)
);


ALTER TABLE public.usuaripermisediciotoponimauth OWNER TO postgres;

--
-- Name: usuaris; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.usuaris (
    idusuari character varying(100) NOT NULL,
    nomusuari character varying(100) NOT NULL,
    idtecnic character varying(100),
    idpersona character varying(100),
    idorganitzacio character varying(100),
    nom character varying(100),
    primercognom character varying(100),
    pwdsecure character varying(200),
    alta character varying(1) DEFAULT 'S'::character varying,
    CONSTRAINT chck_alta_s_n CHECK (((alta)::text = ANY (ARRAY[('S'::character varying)::text, ('N'::character varying)::text])))
);


ALTER TABLE public.usuaris OWNER TO postgres;

--
-- Name: versions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.versions (
    idtoponim character varying(200),
    idversio character varying(200)
);


ALTER TABLE public.versions OWNER TO postgres;

--
-- Name: cartografia; Type: TABLE; Schema: sipan_mmedia; Owner: postgres
--

CREATE TABLE sipan_mmedia.cartografia (
    idcarto character varying(200) NOT NULL,
    titol character varying(500),
    observacions character varying(500),
    idextensio character varying(100),
    nomoriginal character varying(255),
    fitxer bytea
);


ALTER TABLE sipan_mmedia.cartografia OWNER TO postgres;

--
-- Name: documents; Type: TABLE; Schema: sipan_mmedia; Owner: postgres
--

CREATE TABLE sipan_mmedia.documents (
    iddocument character varying(100) NOT NULL,
    titol character varying(500),
    observacions character varying(500),
    idextensio character varying(100),
    nomoriginal character varying(255),
    fitxer bytea,
    data timestamp without time zone
);


ALTER TABLE sipan_mmedia.documents OWNER TO postgres;

--
-- Name: extensions; Type: TABLE; Schema: sipan_mmedia; Owner: postgres
--

CREATE TABLE sipan_mmedia.extensions (
    idextensio character varying(100) NOT NULL,
    extensio character varying(25),
    descripcio character varying(500),
    fitxericona bytea
);


ALTER TABLE sipan_mmedia.extensions OWNER TO postgres;

--
-- Name: imatges; Type: TABLE; Schema: sipan_mmedia; Owner: postgres
--

CREATE TABLE sipan_mmedia.imatges (
    idimatge character varying(100) NOT NULL,
    titol character varying(500),
    observacions character varying(500),
    idextensio character varying(100),
    nomoriginal character varying(255),
    thumbnail bytea,
    fitxer bytea
);


ALTER TABLE sipan_mmedia.imatges OWNER TO postgres;

--
-- Name: autors; Type: TABLE; Schema: sipan_msipan; Owner: postgres
--

CREATE TABLE sipan_msipan.autors (
    id character varying(100) NOT NULL
);


ALTER TABLE sipan_msipan.autors OWNER TO postgres;

--
-- Name: configuracio; Type: TABLE; Schema: sipan_msipan; Owner: postgres
--

CREATE TABLE sipan_msipan.configuracio (
    id character varying(100) NOT NULL,
    idorganitzacio character varying(100) NOT NULL,
    clau character varying(100) NOT NULL,
    valor character varying(200)
);


ALTER TABLE sipan_msipan.configuracio OWNER TO postgres;

--
-- Name: georeferenciadors; Type: TABLE; Schema: sipan_msipan; Owner: postgres
--

CREATE TABLE sipan_msipan.georeferenciadors (
    id character varying(100) NOT NULL
);


ALTER TABLE sipan_msipan.georeferenciadors OWNER TO postgres;

--
-- Name: moduls; Type: TABLE; Schema: sipan_msipan; Owner: postgres
--

CREATE TABLE sipan_msipan.moduls (
    idmodul character varying(100) NOT NULL,
    abreviacio character varying(30) NOT NULL,
    titol character varying(150) NOT NULL,
    descripcio character varying(4000)
);


ALTER TABLE sipan_msipan.moduls OWNER TO postgres;

--
-- Name: objectessipan; Type: TABLE; Schema: sipan_msipan; Owner: postgres
--

CREATE TABLE sipan_msipan.objectessipan (
    id character varying(200) NOT NULL,
    idusuari character varying(100)
);


ALTER TABLE sipan_msipan.objectessipan OWNER TO postgres;

--
-- Name: organigramesorganitzacions; Type: TABLE; Schema: sipan_msipan; Owner: postgres
--

CREATE TABLE sipan_msipan.organigramesorganitzacions (
    idseccioorganitzacio character varying(100) NOT NULL,
    idorganitzacio character varying(100) NOT NULL,
    codiorganigrama character varying(4) NOT NULL,
    anno numeric NOT NULL,
    nomseccio character varying(255) NOT NULL
);


ALTER TABLE sipan_msipan.organigramesorganitzacions OWNER TO postgres;

--
-- Name: organitzacions; Type: TABLE; Schema: sipan_msipan; Owner: postgres
--

CREATE TABLE sipan_msipan.organitzacions (
    idorganitzacio character varying(100) NOT NULL,
    codiorganitzacio character varying(15) NOT NULL,
    organitzacio character varying(255) NOT NULL
);


ALTER TABLE sipan_msipan.organitzacions OWNER TO postgres;

--
-- Name: persona; Type: TABLE; Schema: sipan_msipan; Owner: postgres
--

CREATE TABLE sipan_msipan.persona (
    id character varying(100) NOT NULL,
    discriminatorjuridica character varying(100)
);


ALTER TABLE sipan_msipan.persona OWNER TO postgres;

--
-- Name: personafisica; Type: TABLE; Schema: sipan_msipan; Owner: postgres
--

CREATE TABLE sipan_msipan.personafisica (
    id character varying(100) NOT NULL,
    nif character varying(25),
    nom character varying(100) NOT NULL,
    primercognom character varying(100) NOT NULL,
    segoncognom character varying(100),
    correuelectronic character varying(100),
    telefon character varying(30),
    mobil character varying(15),
    adreca character varying(100),
    codipostal character varying(30),
    poblacio character varying(100)
);


ALTER TABLE sipan_msipan.personafisica OWNER TO postgres;

--
-- Name: personajuridica; Type: TABLE; Schema: sipan_msipan; Owner: postgres
--

CREATE TABLE sipan_msipan.personajuridica (
    id character varying(100) NOT NULL,
    cif character varying(20),
    nom character varying(500) NOT NULL,
    idtipusorganisme character varying(100)
);


ALTER TABLE sipan_msipan.personajuridica OWNER TO postgres;

--
-- Name: rangs; Type: TABLE; Schema: sipan_msipan; Owner: postgres
--

CREATE TABLE sipan_msipan.rangs (
    idrang character varying(100) NOT NULL,
    rang character varying(50) NOT NULL
);


ALTER TABLE sipan_msipan.rangs OWNER TO postgres;

--
-- Name: tecnics; Type: TABLE; Schema: sipan_msipan; Owner: postgres
--

CREATE TABLE sipan_msipan.tecnics (
    idtecnic character varying(100) NOT NULL,
    niftecnic character varying(25),
    nomtecnic character varying(255) NOT NULL,
    email character varying(255),
    idrang character varying(100)
);


ALTER TABLE sipan_msipan.tecnics OWNER TO postgres;

--
-- Name: tecnicsorganitzacio; Type: TABLE; Schema: sipan_msipan; Owner: postgres
--

CREATE TABLE sipan_msipan.tecnicsorganitzacio (
    idtecnicorganitzacio character varying(100) NOT NULL,
    idtecnic character varying(100) NOT NULL,
    idorganitzacio character varying(100) NOT NULL
);


ALTER TABLE sipan_msipan.tecnicsorganitzacio OWNER TO postgres;

--
-- Name: tipusobjectes; Type: TABLE; Schema: sipan_msipan; Owner: postgres
--

CREATE TABLE sipan_msipan.tipusobjectes (
    idtipusobjecte character varying(100) NOT NULL,
    tipusobjecte character varying(100) NOT NULL,
    idmodul character varying(100)
);


ALTER TABLE sipan_msipan.tipusobjectes OWNER TO postgres;

--
-- Name: tipusorganisme; Type: TABLE; Schema: sipan_msipan; Owner: postgres
--

CREATE TABLE sipan_msipan.tipusorganisme (
    id character varying(100) NOT NULL,
    tipus character varying(100) NOT NULL
);


ALTER TABLE sipan_msipan.tipusorganisme OWNER TO postgres;

--
-- Name: unitat; Type: TABLE; Schema: sipan_msipan; Owner: postgres
--

CREATE TABLE sipan_msipan.unitat (
    id character varying(100) NOT NULL,
    nom character varying(100) NOT NULL
);


ALTER TABLE sipan_msipan.unitat OWNER TO postgres;

--
-- Name: nomvulgar; Type: TABLE; Schema: sipan_mtaxons; Owner: postgres
--

CREATE TABLE sipan_mtaxons.nomvulgar (
    id character varying(100) NOT NULL,
    nomvulgar character varying(100) NOT NULL
);


ALTER TABLE sipan_mtaxons.nomvulgar OWNER TO postgres;

--
-- Name: nomvulgartaxon; Type: TABLE; Schema: sipan_mtaxons; Owner: postgres
--

CREATE TABLE sipan_mtaxons.nomvulgartaxon (
    id character varying(100) NOT NULL,
    idtaxon character varying(100) NOT NULL,
    idnomvulgar character varying(100) NOT NULL
);


ALTER TABLE sipan_mtaxons.nomvulgartaxon OWNER TO postgres;

--
-- Name: taxon; Type: TABLE; Schema: sipan_mtaxons; Owner: postgres
--

CREATE TABLE sipan_mtaxons.taxon (
    id character varying(100) NOT NULL,
    tesaurebiocat character varying(100) NOT NULL,
    codibiocat character varying(100) NOT NULL,
    genere character varying(100) NOT NULL,
    especie character varying(100) NOT NULL,
    autorespecie character varying(100),
    subespecie character varying(100),
    autorsubespecie character varying(100),
    varietat character varying(100),
    autorvarietat character varying(100),
    subvarietat character varying(100),
    autorsubvarietat character varying(100),
    forma character varying(100),
    autorforma character varying(100),
    codieorca character varying(100),
    familia character varying(100)
);


ALTER TABLE sipan_mtaxons.taxon OWNER TO postgres;

--
-- Name: ambitexclosrecursgeoref; Type: TABLE; Schema: sipan_mzoologia; Owner: postgres
--

CREATE TABLE sipan_mzoologia.ambitexclosrecursgeoref (
    id character varying(100) NOT NULL,
    idambitgeografic character varying(100) NOT NULL,
    idrecursgeoref character varying(100) NOT NULL
);


ALTER TABLE sipan_mzoologia.ambitexclosrecursgeoref OWNER TO postgres;

--
-- Name: ambitgeografic; Type: TABLE; Schema: sipan_mzoologia; Owner: postgres
--

CREATE TABLE sipan_mzoologia.ambitgeografic (
    id character varying(100) NOT NULL,
    nom character varying(100) NOT NULL,
    codi character varying(100) NOT NULL
);


ALTER TABLE sipan_mzoologia.ambitgeografic OWNER TO postgres;

--
-- Name: ambitgeograficrecursgeoref; Type: TABLE; Schema: sipan_mzoologia; Owner: postgres
--

CREATE TABLE sipan_mzoologia.ambitgeograficrecursgeoref (
    id character varying(100) NOT NULL,
    idambitgeografic character varying(100) NOT NULL,
    idrecursgeoref character varying(100) NOT NULL
);


ALTER TABLE sipan_mzoologia.ambitgeograficrecursgeoref OWNER TO postgres;

--
-- Name: autorrecursgeoref; Type: TABLE; Schema: sipan_mzoologia; Owner: postgres
--

CREATE TABLE sipan_mzoologia.autorrecursgeoref (
    id character varying(100) NOT NULL,
    idrecursgeoref character varying(100) NOT NULL,
    idpersona character varying(100) NOT NULL
);


ALTER TABLE sipan_mzoologia.autorrecursgeoref OWNER TO postgres;

--
-- Name: conversio; Type: TABLE; Schema: sipan_mzoologia; Owner: postgres
--

CREATE TABLE sipan_mzoologia.conversio (
    id character varying(100) NOT NULL,
    nom character varying(100) NOT NULL
);


ALTER TABLE sipan_mzoologia.conversio OWNER TO postgres;

--
-- Name: recursgeoref; Type: TABLE; Schema: sipan_mzoologia; Owner: postgres
--

CREATE TABLE sipan_mzoologia.recursgeoref (
    id character varying(100) NOT NULL,
    nom character varying(500) NOT NULL,
    comentarisnoambit character varying(500),
    toponim character varying(500),
    idprojeccio character varying(500),
    iddatum character varying(500),
    idunitath character varying(500),
    idunitatv character varying(500),
    versio character varying(100),
    fitxergraficbase character varying(100),
    idconversio character varying(100),
    idsuport character varying(100),
    urlsuport character varying(250),
    ubicaciorecurs character varying(200),
    actualitzaciosuport character varying(250),
    mapa character varying(100),
    comentariinfo text,
    comentariconsulta text,
    comentariqualitat text,
    classificacio character varying(300),
    divisiopoliticoadministrativa character varying(300)
);


ALTER TABLE sipan_mzoologia.recursgeoref OWNER TO postgres;

--
-- Name: auth_group id; Type: DEFAULT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.auth_group ALTER COLUMN id SET DEFAULT nextval('public.auth_group_id_seq'::regclass);


--
-- Name: auth_group_permissions id; Type: DEFAULT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.auth_group_permissions ALTER COLUMN id SET DEFAULT nextval('public.auth_group_permissions_id_seq'::regclass);


--
-- Name: auth_permission id; Type: DEFAULT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.auth_permission ALTER COLUMN id SET DEFAULT nextval('public.auth_permission_id_seq'::regclass);


--
-- Name: auth_user id; Type: DEFAULT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.auth_user ALTER COLUMN id SET DEFAULT nextval('public.auth_user_id_seq'::regclass);


--
-- Name: auth_user_groups id; Type: DEFAULT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.auth_user_groups ALTER COLUMN id SET DEFAULT nextval('public.auth_user_groups_id_seq'::regclass);


--
-- Name: auth_user_user_permissions id; Type: DEFAULT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.auth_user_user_permissions ALTER COLUMN id SET DEFAULT nextval('public.auth_user_user_permissions_id_seq'::regclass);


--
-- Name: comments id; Type: DEFAULT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.comments ALTER COLUMN id SET DEFAULT nextval('public.comments_id_seq'::regclass);


--
-- Name: django_admin_log id; Type: DEFAULT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.django_admin_log ALTER COLUMN id SET DEFAULT nextval('public.django_admin_log_id_seq'::regclass);


--
-- Name: django_content_type id; Type: DEFAULT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.django_content_type ALTER COLUMN id SET DEFAULT nextval('public.django_content_type_id_seq'::regclass);


--
-- Name: django_migrations id; Type: DEFAULT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.django_migrations ALTER COLUMN id SET DEFAULT nextval('public.django_migrations_id_seq'::regclass);


--
-- Name: georef_addenda_geometriarecurs id; Type: DEFAULT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.georef_addenda_geometriarecurs ALTER COLUMN id SET DEFAULT nextval('public.georef_addenda_geometriarecurs_id_seq'::regclass);


--
-- Name: georef_addenda_geometriatoponimversio id; Type: DEFAULT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.georef_addenda_geometriatoponimversio ALTER COLUMN id SET DEFAULT nextval('public.georef_addenda_geometriatoponimversio_id_seq'::regclass);


--
-- Name: georef_addenda_georeferenceprotocol id; Type: DEFAULT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.georef_addenda_georeferenceprotocol ALTER COLUMN id SET DEFAULT nextval('public.georef_addenda_georeferenceprotocol_id_seq'::regclass);


--
-- Name: georef_addenda_lookupdescription id; Type: DEFAULT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.georef_addenda_lookupdescription ALTER COLUMN id SET DEFAULT nextval('public.georef_addenda_lookupdescription_id_seq'::regclass);


--
-- Name: georef_addenda_menuitem id; Type: DEFAULT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.georef_addenda_menuitem ALTER COLUMN id SET DEFAULT nextval('public.georef_addenda_menuitem_id_seq'::regclass);


--
-- Name: georef_addenda_organization id; Type: DEFAULT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.georef_addenda_organization ALTER COLUMN id SET DEFAULT nextval('public.georef_addenda_organization_id_seq'::regclass);


--
-- Name: georef_addenda_profile id; Type: DEFAULT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.georef_addenda_profile ALTER COLUMN id SET DEFAULT nextval('public.georef_addenda_profile_id_seq'::regclass);


--
-- Name: ambitexclosrecursgeoref ambitexclosrecursgeoref_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ambitexclosrecursgeoref
    ADD CONSTRAINT ambitexclosrecursgeoref_pkey PRIMARY KEY (id);


--
-- Name: ambitgeografic ambitgeografic_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ambitgeografic
    ADD CONSTRAINT ambitgeografic_pkey PRIMARY KEY (id);


--
-- Name: ambitgeograficrecursgeoref ambitgeograficrecursgeoref_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ambitgeograficrecursgeoref
    ADD CONSTRAINT ambitgeograficrecursgeoref_pkey PRIMARY KEY (id);


--
-- Name: auth_group auth_group_name_key; Type: CONSTRAINT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.auth_group
    ADD CONSTRAINT auth_group_name_key UNIQUE (name);


--
-- Name: auth_group_permissions auth_group_permissions_group_id_permission_id_0cd325b0_uniq; Type: CONSTRAINT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_permission_id_0cd325b0_uniq UNIQUE (group_id, permission_id);


--
-- Name: auth_group_permissions auth_group_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_pkey PRIMARY KEY (id);


--
-- Name: auth_group auth_group_pkey; Type: CONSTRAINT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.auth_group
    ADD CONSTRAINT auth_group_pkey PRIMARY KEY (id);


--
-- Name: auth_permission auth_permission_content_type_id_codename_01ab375a_uniq; Type: CONSTRAINT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_codename_01ab375a_uniq UNIQUE (content_type_id, codename);


--
-- Name: auth_permission auth_permission_pkey; Type: CONSTRAINT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_pkey PRIMARY KEY (id);


--
-- Name: auth_user_groups auth_user_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_pkey PRIMARY KEY (id);


--
-- Name: auth_user_groups auth_user_groups_user_id_group_id_94350c0c_uniq; Type: CONSTRAINT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_user_id_group_id_94350c0c_uniq UNIQUE (user_id, group_id);


--
-- Name: auth_user auth_user_pkey; Type: CONSTRAINT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.auth_user
    ADD CONSTRAINT auth_user_pkey PRIMARY KEY (id);


--
-- Name: auth_user_user_permissions auth_user_user_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_pkey PRIMARY KEY (id);


--
-- Name: auth_user_user_permissions auth_user_user_permissions_user_id_permission_id_14a6b632_uniq; Type: CONSTRAINT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_user_id_permission_id_14a6b632_uniq UNIQUE (user_id, permission_id);


--
-- Name: auth_user auth_user_username_key; Type: CONSTRAINT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.auth_user
    ADD CONSTRAINT auth_user_username_key UNIQUE (username);


--
-- Name: autorrecursgeoref autorrecursgeoref_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.autorrecursgeoref
    ADD CONSTRAINT autorrecursgeoref_pkey PRIMARY KEY (id);


--
-- Name: basescartografiques basescartografiques_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.basescartografiques
    ADD CONSTRAINT basescartografiques_pkey PRIMARY KEY (idbasecarto);


--
-- Name: capawms capawms_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.capawms
    ADD CONSTRAINT capawms_pkey PRIMARY KEY (id);


--
-- Name: capesrecurs capesrecurs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.capesrecurs
    ADD CONSTRAINT capesrecurs_pkey PRIMARY KEY (id);


--
-- Name: cartovisual cartovisual_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cartovisual
    ADD CONSTRAINT cartovisual_pkey PRIMARY KEY (id);


--
-- Name: epsg_change change_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.epsg_change
    ADD CONSTRAINT change_id UNIQUE (change_id);


--
-- Name: comarques comarques_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comarques
    ADD CONSTRAINT comarques_pkey PRIMARY KEY (idcomarca);


--
-- Name: comarquesprovincies comarquesprovincies_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comarquesprovincies
    ADD CONSTRAINT comarquesprovincies_pkey PRIMARY KEY (idcomarca, idprovincia);


--
-- Name: comments comments_pkey; Type: CONSTRAINT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (id);


--
-- Name: comunitatsautonomes comunitatsautonomes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comunitatsautonomes
    ADD CONSTRAINT comunitatsautonomes_pkey PRIMARY KEY (id);


--
-- Name: comunitatsautonomesprovincies comunitatsautonomesprovincies_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comunitatsautonomesprovincies
    ADD CONSTRAINT comunitatsautonomesprovincies_pkey PRIMARY KEY (id);


--
-- Name: conversio conversio_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.conversio
    ADD CONSTRAINT conversio_pkey PRIMARY KEY (id);


--
-- Name: epsg_coordinateaxis coord_axis_code; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.epsg_coordinateaxis
    ADD CONSTRAINT coord_axis_code UNIQUE (coord_axis_code);


--
-- Name: coordenades coordenades_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coordenades
    ADD CONSTRAINT coordenades_pkey PRIMARY KEY (idcoordenada);


--
-- Name: coordenadeslinies coordenadeslinies_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coordenadeslinies
    ADD CONSTRAINT coordenadeslinies_pkey PRIMARY KEY (idcoordenadalinia);


--
-- Name: datum datum_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.datum
    ADD CONSTRAINT datum_pkey PRIMARY KEY (id);


--
-- Name: demarcacionsterritorials demarcacionsterritorials_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.demarcacionsterritorials
    ADD CONSTRAINT demarcacionsterritorials_pkey PRIMARY KEY (iddemarcacioterritorial);


--
-- Name: django_admin_log django_admin_log_pkey; Type: CONSTRAINT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_pkey PRIMARY KEY (id);


--
-- Name: django_content_type django_content_type_app_label_model_76bd3d3b_uniq; Type: CONSTRAINT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.django_content_type
    ADD CONSTRAINT django_content_type_app_label_model_76bd3d3b_uniq UNIQUE (app_label, model);


--
-- Name: django_content_type django_content_type_pkey; Type: CONSTRAINT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.django_content_type
    ADD CONSTRAINT django_content_type_pkey PRIMARY KEY (id);


--
-- Name: django_migrations django_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.django_migrations
    ADD CONSTRAINT django_migrations_pkey PRIMARY KEY (id);


--
-- Name: django_session django_session_pkey; Type: CONSTRAINT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.django_session
    ADD CONSTRAINT django_session_pkey PRIMARY KEY (session_key);


--
-- Name: epsg_alias epsg_alias_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.epsg_alias
    ADD CONSTRAINT epsg_alias_pkey PRIMARY KEY (alias_code);


--
-- Name: epsg_area epsg_area_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.epsg_area
    ADD CONSTRAINT epsg_area_pkey PRIMARY KEY (area_code);


--
-- Name: epsg_coordinateaxis epsg_coordinateaxis_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.epsg_coordinateaxis
    ADD CONSTRAINT epsg_coordinateaxis_pkey PRIMARY KEY (coord_axis_name_code, coord_sys_code);


--
-- Name: epsg_coordinateaxisname epsg_coordinateaxisname_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.epsg_coordinateaxisname
    ADD CONSTRAINT epsg_coordinateaxisname_pkey PRIMARY KEY (coord_axis_name_code);


--
-- Name: epsg_coordinatereferencesystem epsg_coordinatereferencesystem_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.epsg_coordinatereferencesystem
    ADD CONSTRAINT epsg_coordinatereferencesystem_pkey PRIMARY KEY (coord_ref_sys_code);


--
-- Name: epsg_coordinatesystem epsg_coordinatesystem_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.epsg_coordinatesystem
    ADD CONSTRAINT epsg_coordinatesystem_pkey PRIMARY KEY (coord_sys_code);


--
-- Name: epsg_coordoperation epsg_coordoperation_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.epsg_coordoperation
    ADD CONSTRAINT epsg_coordoperation_pkey PRIMARY KEY (coord_op_code);


--
-- Name: epsg_coordoperationmethod epsg_coordoperationmethod_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.epsg_coordoperationmethod
    ADD CONSTRAINT epsg_coordoperationmethod_pkey PRIMARY KEY (coord_op_method_code);


--
-- Name: epsg_coordoperationparam epsg_coordoperationparam_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.epsg_coordoperationparam
    ADD CONSTRAINT epsg_coordoperationparam_pkey PRIMARY KEY (parameter_code);


--
-- Name: epsg_coordoperationparamusage epsg_coordoperationparamusage_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.epsg_coordoperationparamusage
    ADD CONSTRAINT epsg_coordoperationparamusage_pkey PRIMARY KEY (coord_op_method_code, parameter_code);


--
-- Name: epsg_coordoperationparamvalue epsg_coordoperationparamvalue_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.epsg_coordoperationparamvalue
    ADD CONSTRAINT epsg_coordoperationparamvalue_pkey PRIMARY KEY (coord_op_code, coord_op_method_code, parameter_code);


--
-- Name: epsg_coordoperationpath epsg_coordoperationpath_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.epsg_coordoperationpath
    ADD CONSTRAINT epsg_coordoperationpath_pkey PRIMARY KEY (concat_operation_code, single_operation_code);


--
-- Name: epsg_datum epsg_datum_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.epsg_datum
    ADD CONSTRAINT epsg_datum_pkey PRIMARY KEY (datum_code);


--
-- Name: epsg_deprecation epsg_deprecation_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.epsg_deprecation
    ADD CONSTRAINT epsg_deprecation_pkey PRIMARY KEY (deprecation_id);


--
-- Name: epsg_ellipsoid epsg_ellipsoid_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.epsg_ellipsoid
    ADD CONSTRAINT epsg_ellipsoid_pkey PRIMARY KEY (ellipsoid_code);


--
-- Name: epsg_namingsystem epsg_namingsystem_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.epsg_namingsystem
    ADD CONSTRAINT epsg_namingsystem_pkey PRIMARY KEY (naming_system_code);


--
-- Name: epsg_primemeridian epsg_primemeridian_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.epsg_primemeridian
    ADD CONSTRAINT epsg_primemeridian_pkey PRIMARY KEY (prime_meridian_code);


--
-- Name: epsg_supersession epsg_supersession_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.epsg_supersession
    ADD CONSTRAINT epsg_supersession_pkey PRIMARY KEY (supersession_id);


--
-- Name: epsg_unitofmeasure epsg_unitofmeasure_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.epsg_unitofmeasure
    ADD CONSTRAINT epsg_unitofmeasure_pkey PRIMARY KEY (uom_code);


--
-- Name: epsg_versionhistory epsg_versionhistory_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.epsg_versionhistory
    ADD CONSTRAINT epsg_versionhistory_pkey PRIMARY KEY (version_history_code);


--
-- Name: geometria geometria_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.geometria
    ADD CONSTRAINT geometria_pkey PRIMARY KEY (idgeometria);


--
-- Name: geometriaobjectessipan geometriaobjectessipan_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.geometriaobjectessipan
    ADD CONSTRAINT geometriaobjectessipan_pkey PRIMARY KEY (id);


--
-- Name: geometries_api geometries_api_pkey; Type: CONSTRAINT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.geometries_api
    ADD CONSTRAINT geometries_api_pkey PRIMARY KEY (id);


--
-- Name: georef_addenda_autor georef_addenda_autor_pkey; Type: CONSTRAINT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.georef_addenda_autor
    ADD CONSTRAINT georef_addenda_autor_pkey PRIMARY KEY (id);


--
-- Name: georef_addenda_geometriarecurs georef_addenda_geometriarecurs_pkey; Type: CONSTRAINT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.georef_addenda_geometriarecurs
    ADD CONSTRAINT georef_addenda_geometriarecurs_pkey PRIMARY KEY (id);


--
-- Name: georef_addenda_geometriatoponimversio georef_addenda_geometriatoponimversio_pkey; Type: CONSTRAINT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.georef_addenda_geometriatoponimversio
    ADD CONSTRAINT georef_addenda_geometriatoponimversio_pkey PRIMARY KEY (id);


--
-- Name: georef_addenda_georeferenceprotocol georef_addenda_georeferenceprotocol_pkey; Type: CONSTRAINT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.georef_addenda_georeferenceprotocol
    ADD CONSTRAINT georef_addenda_georeferenceprotocol_pkey PRIMARY KEY (id);


--
-- Name: georef_addenda_helpfile georef_addenda_helpfile_pkey; Type: CONSTRAINT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.georef_addenda_helpfile
    ADD CONSTRAINT georef_addenda_helpfile_pkey PRIMARY KEY (id);


--
-- Name: georef_addenda_lookupdescription georef_addenda_lookupdescription_pkey; Type: CONSTRAINT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.georef_addenda_lookupdescription
    ADD CONSTRAINT georef_addenda_lookupdescription_pkey PRIMARY KEY (id);


--
-- Name: georef_addenda_menuitem georef_addenda_menuitem_pkey; Type: CONSTRAINT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.georef_addenda_menuitem
    ADD CONSTRAINT georef_addenda_menuitem_pkey PRIMARY KEY (id);


--
-- Name: georef_addenda_organization georef_addenda_organization_pkey; Type: CONSTRAINT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.georef_addenda_organization
    ADD CONSTRAINT georef_addenda_organization_pkey PRIMARY KEY (id);


--
-- Name: georef_addenda_profile georef_addenda_profile_pkey; Type: CONSTRAINT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.georef_addenda_profile
    ADD CONSTRAINT georef_addenda_profile_pkey PRIMARY KEY (id);


--
-- Name: georef_addenda_profile georef_addenda_profile_user_id_key; Type: CONSTRAINT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.georef_addenda_profile
    ADD CONSTRAINT georef_addenda_profile_user_id_key UNIQUE (user_id);


--
-- Name: linies linies_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.linies
    ADD CONSTRAINT linies_pkey PRIMARY KEY (idlinia);


--
-- Name: liniesobjectessipan liniesobjectessipan_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.liniesobjectessipan
    ADD CONSTRAINT liniesobjectessipan_pkey PRIMARY KEY (id);


--
-- Name: liniespolilinies liniespolilinies_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.liniespolilinies
    ADD CONSTRAINT liniespolilinies_pkey PRIMARY KEY (idliniapolilinia);


--
-- Name: logactivitatobjectessipan logactivitatobjectessipan_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.logactivitatobjectessipan
    ADD CONSTRAINT logactivitatobjectessipan_pkey PRIMARY KEY (idlog);


--
-- Name: marcreferencia marcreferencia_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.marcreferencia
    ADD CONSTRAINT marcreferencia_pkey PRIMARY KEY (id);


--
-- Name: municipis municipis_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.municipis
    ADD CONSTRAINT municipis_pkey PRIMARY KEY (idmunicipi);


--
-- Name: pais pais_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pais
    ADD CONSTRAINT pais_pkey PRIMARY KEY (id);


--
-- Name: paraulaclau paraulaclau_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.paraulaclau
    ADD CONSTRAINT paraulaclau_pkey PRIMARY KEY (id);


--
-- Name: paraulaclaurecursgeoref paraulaclaurecursgeoref_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.paraulaclaurecursgeoref
    ADD CONSTRAINT paraulaclaurecursgeoref_pkey PRIMARY KEY (id);


--
-- Name: authority pkauthority; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.authority
    ADD CONSTRAINT pkauthority PRIMARY KEY (id);


--
-- Name: detallsusuari pkdetallusr; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.detallsusuari
    ADD CONSTRAINT pkdetallusr PRIMARY KEY (id);


--
-- Name: usuaripermisediciotoponimauth pkusrpermedtopoauth; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuaripermisediciotoponimauth
    ADD CONSTRAINT pkusrpermedtopoauth PRIMARY KEY (id);


--
-- Name: poligons poligons_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.poligons
    ADD CONSTRAINT poligons_pkey PRIMARY KEY (idpoligon);


--
-- Name: poligonsobjectessipan poligonsobjectessipan_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.poligonsobjectessipan
    ADD CONSTRAINT poligonsobjectessipan_pkey PRIMARY KEY (id);


--
-- Name: poligonspolipoligons poligonspolipoligons_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.poligonspolipoligons
    ADD CONSTRAINT poligonspolipoligons_pkey PRIMARY KEY (idpoligonpolipoligon);


--
-- Name: polilinies polilinies_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.polilinies
    ADD CONSTRAINT polilinies_pkey PRIMARY KEY (idpolilinia);


--
-- Name: polipoligons polipoligons_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.polipoligons
    ADD CONSTRAINT polipoligons_pkey PRIMARY KEY (idpolipoligon);


--
-- Name: polipunts polipunts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.polipunts
    ADD CONSTRAINT polipunts_pkey PRIMARY KEY (idpolipunt);


--
-- Name: prefs_visibilitat_capes prefs_visibilitat_capes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.prefs_visibilitat_capes
    ADD CONSTRAINT prefs_visibilitat_capes_pkey PRIMARY KEY (id);


--
-- Name: projeccio projeccio_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.projeccio
    ADD CONSTRAINT projeccio_pkey PRIMARY KEY (id);


--
-- Name: provincies provincies_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.provincies
    ADD CONSTRAINT provincies_pkey PRIMARY KEY (idprovincia);


--
-- Name: punts punts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.punts
    ADD CONSTRAINT punts_pkey PRIMARY KEY (idpunt);


--
-- Name: puntsobjectessipan puntsobjectessipan_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.puntsobjectessipan
    ADD CONSTRAINT puntsobjectessipan_pkey PRIMARY KEY (id);


--
-- Name: puntspolipunts puntspolipunts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.puntspolipunts
    ADD CONSTRAINT puntspolipunts_pkey PRIMARY KEY (idpuntpolipunt);


--
-- Name: qualificadorversio qualificadorversio_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.qualificadorversio
    ADD CONSTRAINT qualificadorversio_pkey PRIMARY KEY (id);


--
-- Name: recursgeoref recursgeoref_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recursgeoref
    ADD CONSTRAINT recursgeoref_pkey PRIMARY KEY (id);


--
-- Name: recursgeoreftoponim recursgeoreftoponim_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recursgeoreftoponim
    ADD CONSTRAINT recursgeoreftoponim_pkey PRIMARY KEY (id);


--
-- Name: registreusuaris registreusuaris_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.registreusuaris
    ADD CONSTRAINT registreusuaris_pkey PRIMARY KEY (id);


--
-- Name: rols rols_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rols
    ADD CONSTRAINT rols_pkey PRIMARY KEY (idrol);


--
-- Name: rolsaplicaciousuari rolsaplicaciousuari_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rolsaplicaciousuari
    ADD CONSTRAINT rolsaplicaciousuari_pkey PRIMARY KEY (idfuncionalitat);


--
-- Name: rolsdadesusuari rolsdadesusuari_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rolsdadesusuari
    ADD CONSTRAINT rolsdadesusuari_pkey PRIMARY KEY (idroldadesusuari);


--
-- Name: servidorswms servidorswms_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.servidorswms
    ADD CONSTRAINT servidorswms_pkey PRIMARY KEY (idservidorwms);


--
-- Name: sistemareferencia sistemareferencia_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sistemareferencia
    ADD CONSTRAINT sistemareferencia_pkey PRIMARY KEY (id);


--
-- Name: sistemareferenciamm sistemareferenciamm_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sistemareferenciamm
    ADD CONSTRAINT sistemareferenciamm_pkey PRIMARY KEY (id);


--
-- Name: sistemareferenciarecurs sistemareferenciarecurs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sistemareferenciarecurs
    ADD CONSTRAINT sistemareferenciarecurs_pkey PRIMARY KEY (id);


--
-- Name: sistemesreferencia sistemesreferencia_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sistemesreferencia
    ADD CONSTRAINT sistemesreferencia_pkey PRIMARY KEY (idsistemareferencia);


--
-- Name: suport suport_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.suport
    ADD CONSTRAINT suport_pkey PRIMARY KEY (id);


--
-- Name: tipusatributs tipusatributs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tipusatributs
    ADD CONSTRAINT tipusatributs_pkey PRIMARY KEY (idtipusatribut);


--
-- Name: tipusclassificaciosol tipusclassificaciosol_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tipusclassificaciosol
    ADD CONSTRAINT tipusclassificaciosol_pkey PRIMARY KEY (id);


--
-- Name: tipusrecursgeoref tipusrecursgeoref_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tipusrecursgeoref
    ADD CONSTRAINT tipusrecursgeoref_pkey PRIMARY KEY (id);


--
-- Name: tipustoponim tipustoponim_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tipustoponim
    ADD CONSTRAINT tipustoponim_pkey PRIMARY KEY (id);


--
-- Name: tipusunitats tipusunitats_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tipusunitats
    ADD CONSTRAINT tipusunitats_pkey PRIMARY KEY (id);


--
-- Name: toponim toponim_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.toponim
    ADD CONSTRAINT toponim_pkey PRIMARY KEY (id);


--
-- Name: toponims_api toponims_api_pkey; Type: CONSTRAINT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.toponims_api
    ADD CONSTRAINT toponims_api_pkey PRIMARY KEY (id);


--
-- Name: toponimsversio_api toponimsversio_api_pkey; Type: CONSTRAINT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.toponimsversio_api
    ADD CONSTRAINT toponimsversio_api_pkey PRIMARY KEY (id);


--
-- Name: toponimversio toponimversio_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.toponimversio
    ADD CONSTRAINT toponimversio_pkey PRIMARY KEY (id);


--
-- Name: ambitexclosrecursgeoref unambitexclosrecursgeoref; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ambitexclosrecursgeoref
    ADD CONSTRAINT unambitexclosrecursgeoref UNIQUE (idambitgeografic, idrecursgeoref);


--
-- Name: ambitgeograficrecursgeoref unambitgeograficrecursgeoref; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ambitgeograficrecursgeoref
    ADD CONSTRAINT unambitgeograficrecursgeoref UNIQUE (idambitgeografic, idrecursgeoref);


--
-- Name: autorrecursgeoref unautorrecursgeoref; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.autorrecursgeoref
    ADD CONSTRAINT unautorrecursgeoref UNIQUE (idpersona, idrecursgeoref);


--
-- Name: municipis unique_codiine; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.municipis
    ADD CONSTRAINT unique_codiine UNIQUE (codiine);


--
-- Name: recursgeoreftoponim unrecursgeoreftoponim; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recursgeoreftoponim
    ADD CONSTRAINT unrecursgeoreftoponim UNIQUE (idtoponim, idrecursgeoref);


--
-- Name: usuaris usuaris_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuaris
    ADD CONSTRAINT usuaris_pkey PRIMARY KEY (idusuari);


--
-- Name: epsg_versionhistory version_number; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.epsg_versionhistory
    ADD CONSTRAINT version_number UNIQUE (version_number);


--
-- Name: cartografia cartografia_pkey; Type: CONSTRAINT; Schema: sipan_mmedia; Owner: postgres
--

ALTER TABLE ONLY sipan_mmedia.cartografia
    ADD CONSTRAINT cartografia_pkey PRIMARY KEY (idcarto);


--
-- Name: documents documents_pkey; Type: CONSTRAINT; Schema: sipan_mmedia; Owner: postgres
--

ALTER TABLE ONLY sipan_mmedia.documents
    ADD CONSTRAINT documents_pkey PRIMARY KEY (iddocument);


--
-- Name: extensions extensions_pkey; Type: CONSTRAINT; Schema: sipan_mmedia; Owner: postgres
--

ALTER TABLE ONLY sipan_mmedia.extensions
    ADD CONSTRAINT extensions_pkey PRIMARY KEY (idextensio);


--
-- Name: imatges imatges_pkey; Type: CONSTRAINT; Schema: sipan_mmedia; Owner: postgres
--

ALTER TABLE ONLY sipan_mmedia.imatges
    ADD CONSTRAINT imatges_pkey PRIMARY KEY (idimatge);


--
-- Name: autors autor_pkey; Type: CONSTRAINT; Schema: sipan_msipan; Owner: postgres
--

ALTER TABLE ONLY sipan_msipan.autors
    ADD CONSTRAINT autor_pkey PRIMARY KEY (id);


--
-- Name: configuracio configuracio_pkey; Type: CONSTRAINT; Schema: sipan_msipan; Owner: postgres
--

ALTER TABLE ONLY sipan_msipan.configuracio
    ADD CONSTRAINT configuracio_pkey PRIMARY KEY (id);


--
-- Name: georeferenciadors georeferenciador_pkey; Type: CONSTRAINT; Schema: sipan_msipan; Owner: postgres
--

ALTER TABLE ONLY sipan_msipan.georeferenciadors
    ADD CONSTRAINT georeferenciador_pkey PRIMARY KEY (id);


--
-- Name: moduls moduls_pkey; Type: CONSTRAINT; Schema: sipan_msipan; Owner: postgres
--

ALTER TABLE ONLY sipan_msipan.moduls
    ADD CONSTRAINT moduls_pkey PRIMARY KEY (idmodul);


--
-- Name: objectessipan objectessipan_pkey; Type: CONSTRAINT; Schema: sipan_msipan; Owner: postgres
--

ALTER TABLE ONLY sipan_msipan.objectessipan
    ADD CONSTRAINT objectessipan_pkey PRIMARY KEY (id);


--
-- Name: organigramesorganitzacions organigramesorganitzacions_pkey; Type: CONSTRAINT; Schema: sipan_msipan; Owner: postgres
--

ALTER TABLE ONLY sipan_msipan.organigramesorganitzacions
    ADD CONSTRAINT organigramesorganitzacions_pkey PRIMARY KEY (idseccioorganitzacio);


--
-- Name: organitzacions organitzacions_pkey; Type: CONSTRAINT; Schema: sipan_msipan; Owner: postgres
--

ALTER TABLE ONLY sipan_msipan.organitzacions
    ADD CONSTRAINT organitzacions_pkey PRIMARY KEY (idorganitzacio);


--
-- Name: persona persona_pkey; Type: CONSTRAINT; Schema: sipan_msipan; Owner: postgres
--

ALTER TABLE ONLY sipan_msipan.persona
    ADD CONSTRAINT persona_pkey PRIMARY KEY (id);


--
-- Name: personafisica personafisica_pkey; Type: CONSTRAINT; Schema: sipan_msipan; Owner: postgres
--

ALTER TABLE ONLY sipan_msipan.personafisica
    ADD CONSTRAINT personafisica_pkey PRIMARY KEY (id);


--
-- Name: personajuridica personajuridica_pkey; Type: CONSTRAINT; Schema: sipan_msipan; Owner: postgres
--

ALTER TABLE ONLY sipan_msipan.personajuridica
    ADD CONSTRAINT personajuridica_pkey PRIMARY KEY (id);


--
-- Name: rangs rangs_pkey; Type: CONSTRAINT; Schema: sipan_msipan; Owner: postgres
--

ALTER TABLE ONLY sipan_msipan.rangs
    ADD CONSTRAINT rangs_pkey PRIMARY KEY (idrang);


--
-- Name: tecnics tecnics_pkey; Type: CONSTRAINT; Schema: sipan_msipan; Owner: postgres
--

ALTER TABLE ONLY sipan_msipan.tecnics
    ADD CONSTRAINT tecnics_pkey PRIMARY KEY (idtecnic);


--
-- Name: tecnicsorganitzacio tecnicsorganitzacio_pkey; Type: CONSTRAINT; Schema: sipan_msipan; Owner: postgres
--

ALTER TABLE ONLY sipan_msipan.tecnicsorganitzacio
    ADD CONSTRAINT tecnicsorganitzacio_pkey PRIMARY KEY (idtecnicorganitzacio);


--
-- Name: tipusobjectes tipusobjectes_pkey; Type: CONSTRAINT; Schema: sipan_msipan; Owner: postgres
--

ALTER TABLE ONLY sipan_msipan.tipusobjectes
    ADD CONSTRAINT tipusobjectes_pkey PRIMARY KEY (idtipusobjecte);


--
-- Name: tipusorganisme tipusorganisme_pkey; Type: CONSTRAINT; Schema: sipan_msipan; Owner: postgres
--

ALTER TABLE ONLY sipan_msipan.tipusorganisme
    ADD CONSTRAINT tipusorganisme_pkey PRIMARY KEY (id);


--
-- Name: unitat unitat_pkey; Type: CONSTRAINT; Schema: sipan_msipan; Owner: postgres
--

ALTER TABLE ONLY sipan_msipan.unitat
    ADD CONSTRAINT unitat_pkey PRIMARY KEY (id);


--
-- Name: nomvulgar nomvulgar_pkey; Type: CONSTRAINT; Schema: sipan_mtaxons; Owner: postgres
--

ALTER TABLE ONLY sipan_mtaxons.nomvulgar
    ADD CONSTRAINT nomvulgar_pkey PRIMARY KEY (id);


--
-- Name: nomvulgartaxon nomvulgartaxon_pkey; Type: CONSTRAINT; Schema: sipan_mtaxons; Owner: postgres
--

ALTER TABLE ONLY sipan_mtaxons.nomvulgartaxon
    ADD CONSTRAINT nomvulgartaxon_pkey PRIMARY KEY (id);


--
-- Name: taxon taxon_pkey; Type: CONSTRAINT; Schema: sipan_mtaxons; Owner: postgres
--

ALTER TABLE ONLY sipan_mtaxons.taxon
    ADD CONSTRAINT taxon_pkey PRIMARY KEY (id);


--
-- Name: ambitexclosrecursgeoref ambitexclosrecursgeoref_pkey; Type: CONSTRAINT; Schema: sipan_mzoologia; Owner: postgres
--

ALTER TABLE ONLY sipan_mzoologia.ambitexclosrecursgeoref
    ADD CONSTRAINT ambitexclosrecursgeoref_pkey PRIMARY KEY (id);


--
-- Name: ambitgeografic ambitgeografic_pkey; Type: CONSTRAINT; Schema: sipan_mzoologia; Owner: postgres
--

ALTER TABLE ONLY sipan_mzoologia.ambitgeografic
    ADD CONSTRAINT ambitgeografic_pkey PRIMARY KEY (id);


--
-- Name: ambitgeograficrecursgeoref ambitgeograficrecursgeoref_pkey; Type: CONSTRAINT; Schema: sipan_mzoologia; Owner: postgres
--

ALTER TABLE ONLY sipan_mzoologia.ambitgeograficrecursgeoref
    ADD CONSTRAINT ambitgeograficrecursgeoref_pkey PRIMARY KEY (id);


--
-- Name: autorrecursgeoref autorrecursgeoref_pkey; Type: CONSTRAINT; Schema: sipan_mzoologia; Owner: postgres
--

ALTER TABLE ONLY sipan_mzoologia.autorrecursgeoref
    ADD CONSTRAINT autorrecursgeoref_pkey PRIMARY KEY (id);


--
-- Name: conversio conversio_pkey; Type: CONSTRAINT; Schema: sipan_mzoologia; Owner: postgres
--

ALTER TABLE ONLY sipan_mzoologia.conversio
    ADD CONSTRAINT conversio_pkey PRIMARY KEY (id);


--
-- Name: recursgeoref recursgeoref_pkey; Type: CONSTRAINT; Schema: sipan_mzoologia; Owner: postgres
--

ALTER TABLE ONLY sipan_mzoologia.recursgeoref
    ADD CONSTRAINT recursgeoref_pkey PRIMARY KEY (id);


--
-- Name: auth_group_name_a6ea08ec_like; Type: INDEX; Schema: public; Owner: aplicacio_georef
--

CREATE INDEX auth_group_name_a6ea08ec_like ON public.auth_group USING btree (name varchar_pattern_ops);


--
-- Name: auth_group_permissions_group_id_b120cbf9; Type: INDEX; Schema: public; Owner: aplicacio_georef
--

CREATE INDEX auth_group_permissions_group_id_b120cbf9 ON public.auth_group_permissions USING btree (group_id);


--
-- Name: auth_group_permissions_permission_id_84c5c92e; Type: INDEX; Schema: public; Owner: aplicacio_georef
--

CREATE INDEX auth_group_permissions_permission_id_84c5c92e ON public.auth_group_permissions USING btree (permission_id);


--
-- Name: auth_permission_content_type_id_2f476e4b; Type: INDEX; Schema: public; Owner: aplicacio_georef
--

CREATE INDEX auth_permission_content_type_id_2f476e4b ON public.auth_permission USING btree (content_type_id);


--
-- Name: auth_user_groups_group_id_97559544; Type: INDEX; Schema: public; Owner: aplicacio_georef
--

CREATE INDEX auth_user_groups_group_id_97559544 ON public.auth_user_groups USING btree (group_id);


--
-- Name: auth_user_groups_user_id_6a12ed8b; Type: INDEX; Schema: public; Owner: aplicacio_georef
--

CREATE INDEX auth_user_groups_user_id_6a12ed8b ON public.auth_user_groups USING btree (user_id);


--
-- Name: auth_user_user_permissions_permission_id_1fbb5f2c; Type: INDEX; Schema: public; Owner: aplicacio_georef
--

CREATE INDEX auth_user_user_permissions_permission_id_1fbb5f2c ON public.auth_user_user_permissions USING btree (permission_id);


--
-- Name: auth_user_user_permissions_user_id_a95ead1b; Type: INDEX; Schema: public; Owner: aplicacio_georef
--

CREATE INDEX auth_user_user_permissions_user_id_a95ead1b ON public.auth_user_user_permissions USING btree (user_id);


--
-- Name: auth_user_username_6821ab7c_like; Type: INDEX; Schema: public; Owner: aplicacio_georef
--

CREATE INDEX auth_user_username_6821ab7c_like ON public.auth_user USING btree (username varchar_pattern_ops);


--
-- Name: django_admin_log_content_type_id_c4bce8eb; Type: INDEX; Schema: public; Owner: aplicacio_georef
--

CREATE INDEX django_admin_log_content_type_id_c4bce8eb ON public.django_admin_log USING btree (content_type_id);


--
-- Name: django_admin_log_user_id_c564eba6; Type: INDEX; Schema: public; Owner: aplicacio_georef
--

CREATE INDEX django_admin_log_user_id_c564eba6 ON public.django_admin_log USING btree (user_id);


--
-- Name: django_session_expire_date_a5c62663; Type: INDEX; Schema: public; Owner: aplicacio_georef
--

CREATE INDEX django_session_expire_date_a5c62663 ON public.django_session USING btree (expire_date);


--
-- Name: django_session_session_key_c0390e0f_like; Type: INDEX; Schema: public; Owner: aplicacio_georef
--

CREATE INDEX django_session_session_key_c0390e0f_like ON public.django_session USING btree (session_key varchar_pattern_ops);


--
-- Name: fk_area_of_use_code1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fk_area_of_use_code1 ON public.epsg_coordinatereferencesystem USING btree (area_of_use_code);


--
-- Name: fk_area_of_use_code21; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fk_area_of_use_code21 ON public.epsg_datum USING btree (area_of_use_code);


--
-- Name: fk_area_of_use_code31; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fk_area_of_use_code31 ON public.epsg_coordoperation USING btree (area_of_use_code);


--
-- Name: fk_cartovisual_carto1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fk_cartovisual_carto1 ON public.cartovisual USING btree (idcartografia);


--
-- Name: fk_cartovisual_objectessipan1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fk_cartovisual_objectessipan1 ON public.cartovisual USING btree (idobjectesipan);


--
-- Name: fk_change_id1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fk_change_id1 ON public.epsg_deprecation USING btree (change_id);


--
-- Name: fk_cmpd_horizcrs_code1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fk_cmpd_horizcrs_code1 ON public.epsg_coordinatereferencesystem USING btree (cmpd_horizcrs_code);


--
-- Name: fk_cmpd_vertcrs_code1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fk_cmpd_vertcrs_code1 ON public.epsg_coordinatereferencesystem USING btree (cmpd_vertcrs_code);


--
-- Name: fk_coord_axis_name_code1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fk_coord_axis_name_code1 ON public.epsg_coordinateaxis USING btree (coord_axis_name_code);


--
-- Name: fk_coord_op_method_code1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fk_coord_op_method_code1 ON public.epsg_coordoperation USING btree (coord_op_method_code);


--
-- Name: fk_coord_op_method_code21; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fk_coord_op_method_code21 ON public.epsg_coordoperationparamusage USING btree (coord_op_method_code);


--
-- Name: fk_coord_sys_code21; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fk_coord_sys_code21 ON public.epsg_coordinatereferencesystem USING btree (coord_sys_code);


--
-- Name: fk_datum_code1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fk_datum_code1 ON public.epsg_coordinatereferencesystem USING btree (datum_code);


--
-- Name: fk_ellipsoid_code1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fk_ellipsoid_code1 ON public.epsg_datum USING btree (ellipsoid_code);


--
-- Name: fk_naming_system_code1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fk_naming_system_code1 ON public.epsg_alias USING btree (naming_system_code);


--
-- Name: fk_parameter_codecoord_op_meth1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fk_parameter_codecoord_op_meth1 ON public.epsg_coordoperationparamvalue USING btree (parameter_code, coord_op_method_code);


--
-- Name: fk_prime_meridian_code1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fk_prime_meridian_code1 ON public.epsg_datum USING btree (prime_meridian_code);


--
-- Name: fk_single_operation_code1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fk_single_operation_code1 ON public.epsg_coordoperationpath USING btree (single_operation_code);


--
-- Name: fk_source_crs_code1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fk_source_crs_code1 ON public.epsg_coordoperation USING btree (source_crs_code);


--
-- Name: fk_source_geogcrs_code1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fk_source_geogcrs_code1 ON public.epsg_coordinatereferencesystem USING btree (source_geogcrs_code);


--
-- Name: fk_target_crs_code1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fk_target_crs_code1 ON public.epsg_coordoperation USING btree (target_crs_code);


--
-- Name: fk_target_uom_code1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fk_target_uom_code1 ON public.epsg_unitofmeasure USING btree (target_uom_code);


--
-- Name: fk_uom_code1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fk_uom_code1 ON public.epsg_primemeridian USING btree (uom_code);


--
-- Name: fk_uom_code21; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fk_uom_code21 ON public.epsg_coordinateaxis USING btree (uom_code);


--
-- Name: fk_uom_code31; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fk_uom_code31 ON public.epsg_coordoperationparamvalue USING btree (uom_code);


--
-- Name: fk_uom_code41; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fk_uom_code41 ON public.epsg_ellipsoid USING btree (uom_code);


--
-- Name: fk_uom_code_source_coord_diff1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fk_uom_code_source_coord_diff1 ON public.epsg_coordoperation USING btree (uom_code_source_coord_diff);


--
-- Name: fk_uom_code_target_coord_diff1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fk_uom_code_target_coord_diff1 ON public.epsg_coordoperation USING btree (uom_code_target_coord_diff);


--
-- Name: fkambitexclosrecursgeorefr1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fkambitexclosrecursgeorefr1 ON public.ambitexclosrecursgeoref USING btree (idrecursgeoref);


--
-- Name: fkambitgeograficrecursgeorefr1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fkambitgeograficrecursgeorefr1 ON public.ambitgeograficrecursgeoref USING btree (idrecursgeoref);


--
-- Name: fkautorrecursgeorefr1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fkautorrecursgeorefr1 ON public.autorrecursgeoref USING btree (idrecursgeoref);


--
-- Name: fkbloquejosobjectessipanm1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fkbloquejosobjectessipanm1 ON public.bloquejosobjectessipan USING btree (idmodul);


--
-- Name: fkcprov_prov1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fkcprov_prov1 ON public.comarquesprovincies USING btree (idprovincia);


--
-- Name: fkdatummr1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fkdatummr1 ON public.datum USING btree (idmarcreferencia);


--
-- Name: fkgeometriasr1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fkgeometriasr1 ON public.geometria USING btree (idsistemareferencia);


--
-- Name: fkpoligons_poligons1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fkpoligons_poligons1 ON public.poligons USING btree (idpoligoncontenidor);


--
-- Name: fkrecgeotv1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fkrecgeotv1 ON public.recursgeoref USING btree (idambit);


--
-- Name: fkrecursgeorefs1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fkrecursgeorefs1 ON public.recursgeoref USING btree (idsuport);


--
-- Name: fkrecursgeoreftoponimt1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fkrecursgeoreftoponimt1 ON public.recursgeoreftoponim USING btree (idtoponim);


--
-- Name: fkservidorswms_moduls1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fkservidorswms_moduls1 ON public.servidorswms USING btree (idmodul);


--
-- Name: fksistemareferenciaepsg1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fksistemareferenciaepsg1 ON public.sistemareferencia USING btree (idepsg);


--
-- Name: fktoponimos1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fktoponimos1 ON public.toponim USING btree (id);


--
-- Name: fktvrrecursgeoref1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fktvrrecursgeoref1 ON public.toponimsversiorecurs USING btree (idrecursgeoref);


--
-- Name: fktvrversio1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fktvrversio1 ON public.toponimsversiorecurs USING btree (idtoponimversio);


--
-- Name: fkvtoponim1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fkvtoponim1 ON public.versions USING btree (idtoponim);


--
-- Name: fkvversio1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fkvversio1 ON public.versions USING btree (idversio);


--
-- Name: geometries_api_idx; Type: INDEX; Schema: public; Owner: aplicacio_georef
--

CREATE INDEX geometries_api_idx ON public.geometries_api USING gist (geometria);


--
-- Name: georef_addenda_geometriarecurs_geometria_id; Type: INDEX; Schema: public; Owner: aplicacio_georef
--

CREATE INDEX georef_addenda_geometriarecurs_geometria_id ON public.georef_addenda_geometriarecurs USING gist (geometria);


--
-- Name: georef_addenda_geometriarecurs_idrecurs_5b7466ad; Type: INDEX; Schema: public; Owner: aplicacio_georef
--

CREATE INDEX georef_addenda_geometriarecurs_idrecurs_5b7466ad ON public.georef_addenda_geometriarecurs USING btree (idrecurs);


--
-- Name: georef_addenda_geometriarecurs_idrecurs_5b7466ad_like; Type: INDEX; Schema: public; Owner: aplicacio_georef
--

CREATE INDEX georef_addenda_geometriarecurs_idrecurs_5b7466ad_like ON public.georef_addenda_geometriarecurs USING btree (idrecurs varchar_pattern_ops);


--
-- Name: georef_addenda_geometriatoponimversio_geometria_id; Type: INDEX; Schema: public; Owner: aplicacio_georef
--

CREATE INDEX georef_addenda_geometriatoponimversio_geometria_id ON public.georef_addenda_geometriatoponimversio USING gist (geometria);


--
-- Name: georef_addenda_geometriatoponimversio_idversio_1b15db1f; Type: INDEX; Schema: public; Owner: aplicacio_georef
--

CREATE INDEX georef_addenda_geometriatoponimversio_idversio_1b15db1f ON public.georef_addenda_geometriatoponimversio USING btree (idversio);


--
-- Name: georef_addenda_geometriatoponimversio_idversio_1b15db1f_like; Type: INDEX; Schema: public; Owner: aplicacio_georef
--

CREATE INDEX georef_addenda_geometriatoponimversio_idversio_1b15db1f_like ON public.georef_addenda_geometriatoponimversio USING btree (idversio varchar_pattern_ops);


--
-- Name: georef_addenda_helpfile_id_b2b27e92_like; Type: INDEX; Schema: public; Owner: aplicacio_georef
--

CREATE INDEX georef_addenda_helpfile_id_b2b27e92_like ON public.georef_addenda_helpfile USING btree (id varchar_pattern_ops);


--
-- Name: georef_addenda_profile_organization_id_5cbdfe9b; Type: INDEX; Schema: public; Owner: aplicacio_georef
--

CREATE INDEX georef_addenda_profile_organization_id_5cbdfe9b ON public.georef_addenda_profile USING btree (organization_id);


--
-- Name: georef_addenda_profile_toponim_permission_id_483645ea_like; Type: INDEX; Schema: public; Owner: aplicacio_georef
--

CREATE INDEX georef_addenda_profile_toponim_permission_id_483645ea_like ON public.georef_addenda_profile USING btree (toponim_permission varchar_pattern_ops);


--
-- Name: idtipus_toponimapi_idx; Type: INDEX; Schema: public; Owner: aplicacio_georef
--

CREATE INDEX idtipus_toponimapi_idx ON public.toponims_api USING btree (idtipus);


--
-- Name: idtoponim_toponimvapi_idx; Type: INDEX; Schema: public; Owner: aplicacio_georef
--

CREATE INDEX idtoponim_toponimvapi_idx ON public.toponimsversio_api USING btree (idtoponim);


--
-- Name: idx_linia_fitxer_importacio; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_linia_fitxer_importacio ON public.toponim USING btree (linia_fitxer_importacio);


--
-- Name: idxcaprovca; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idxcaprovca ON public.comunitatsautonomesprovincies USING btree (idcomunitatautonoma);


--
-- Name: idxcaprovprov; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idxcaprovprov ON public.comunitatsautonomesprovincies USING btree (idprovincia);


--
-- Name: idxcomarquesiddemterr; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idxcomarquesiddemterr ON public.comarques USING btree (iddemarcacioterritorial);


--
-- Name: idxcomarquesidgeometria; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idxcomarquesidgeometria ON public.comarques USING btree (idgeometria);


--
-- Name: idxcoordenadeslin_coord; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idxcoordenadeslin_coord ON public.coordenadeslinies USING btree (idcoordenada);


--
-- Name: idxcoordenadeslin_linies; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idxcoordenadeslin_linies ON public.coordenadeslinies USING btree (idlinia);


--
-- Name: idxexclosost; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idxexclosost ON public.toponimsexclosos USING btree (idtoponim);


--
-- Name: idxexclososte; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idxexclososte ON public.toponimsexclosos USING btree (idtoponimexclos);


--
-- Name: idxfiltresidm; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idxfiltresidm ON public.filtres USING btree (idmodul);


--
-- Name: idxfiltresido; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idxfiltresido ON public.filtres USING btree (idobjectesipan);


--
-- Name: idxfiltresto; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idxfiltresto ON public.filtres USING btree (tipusobjecte);


--
-- Name: idxfiltresus; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idxfiltresus ON public.filtres USING btree (idusuari);


--
-- Name: idxgeometria_linia; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idxgeometria_linia ON public.geometria USING btree (idpolilinia);


--
-- Name: idxgeometria_poligon; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idxgeometria_poligon ON public.geometria USING btree (idpolipoligon);


--
-- Name: idxgeometria_punt; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idxgeometria_punt ON public.geometria USING btree (idpolipunt);


--
-- Name: idxgeometria_sr; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idxgeometria_sr ON public.geometria USING btree (idsistemareferencia);


--
-- Name: idxgeometriaobjsipan_g; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idxgeometriaobjsipan_g ON public.geometriaobjectessipan USING btree (idgeometria);


--
-- Name: idxgeometriaobjsipan_o; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idxgeometriaobjsipan_o ON public.geometriaobjectessipan USING btree (idobjectessipan);


--
-- Name: idxlinies_cartocapt; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idxlinies_cartocapt ON public.linies USING btree (idcartocaptura);


--
-- Name: idxlinies_ta; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idxlinies_ta ON public.linies USING btree (idtipusatribut);


--
-- Name: idxliniesobjectessipan_o; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idxliniesobjectessipan_o ON public.liniesobjectessipan USING btree (idobjectessipan);


--
-- Name: idxliniesobjectessipan_po; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idxliniesobjectessipan_po ON public.liniesobjectessipan USING btree (idlinies);


--
-- Name: idxliniespolilinies_linia; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idxliniespolilinies_linia ON public.liniespolilinies USING btree (idlinia);


--
-- Name: idxliniespolilinies_poli; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idxliniespolilinies_poli ON public.liniespolilinies USING btree (idpolilinia);


--
-- Name: idxlogactivitatsipanidobj; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idxlogactivitatsipanidobj ON public.logactivitatobjectessipan USING btree (idobjectesipan);


--
-- Name: idxlogactivitatsipanmod; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idxlogactivitatsipanmod ON public.logactivitatobjectessipan USING btree (idmodul);


--
-- Name: idxlogactivitatsipantime; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idxlogactivitatsipantime ON public.logactivitatobjectessipan USING btree (timestamp_);


--
-- Name: idxlogactivitatsipantobj; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idxlogactivitatsipantobj ON public.logactivitatobjectessipan USING btree (tipusobjecte);


--
-- Name: idxlogactivitatsipanus; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idxlogactivitatsipanus ON public.logactivitatobjectessipan USING btree (idusuari);


--
-- Name: idxmunicipisidcomarca; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idxmunicipisidcomarca ON public.municipis USING btree (idcomarca);


--
-- Name: idxmunicipisidgeometria; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idxmunicipisidgeometria ON public.municipis USING btree (idgeometria);


--
-- Name: idxmunicipisidprovincia; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idxmunicipisidprovincia ON public.municipis USING btree (idprovincia);


--
-- Name: idxpoligons_pl; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idxpoligons_pl ON public.poligons USING btree (idpolilinia);


--
-- Name: idxpoligons_ta; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idxpoligons_ta ON public.poligons USING btree (idtipusatribut);


--
-- Name: idxpoligonsobjectessipan_o; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idxpoligonsobjectessipan_o ON public.poligonsobjectessipan USING btree (idobjectessipan);


--
-- Name: idxpoligonsobjectessipan_po; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idxpoligonsobjectessipan_po ON public.poligonsobjectessipan USING btree (idpoligons);


--
-- Name: idxpoligonspolipoligons_p; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idxpoligonspolipoligons_p ON public.poligonspolipoligons USING btree (idpoligon);


--
-- Name: idxpoligonspolipoligons_pp; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idxpoligonspolipoligons_pp ON public.poligonspolipoligons USING btree (idpolipoligon);


--
-- Name: idxpolilinies_ta; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idxpolilinies_ta ON public.polilinies USING btree (idtipusatribut);


--
-- Name: idxpolipoligons_ta; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idxpolipoligons_ta ON public.polipoligons USING btree (idtipusatribut);


--
-- Name: idxpolipunts_ta; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idxpolipunts_ta ON public.polipunts USING btree (idtipusatribut);


--
-- Name: idxprovinciesidgeometria; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idxprovinciesidgeometria ON public.provincies USING btree (idgeometria);


--
-- Name: idxpunts_capt; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idxpunts_capt ON public.punts USING btree (idcartocaptura);


--
-- Name: idxpunts_coord; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idxpunts_coord ON public.punts USING btree (idcoordenada);


--
-- Name: idxpunts_ta; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idxpunts_ta ON public.punts USING btree (idtipusatribut);


--
-- Name: idxpuntsobjectessipan_o; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idxpuntsobjectessipan_o ON public.puntsobjectessipan USING btree (idobjectessipan);


--
-- Name: idxpuntsobjectessipan_po; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idxpuntsobjectessipan_po ON public.puntsobjectessipan USING btree (idpunts);


--
-- Name: idxpuntspolipunts_poli; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idxpuntspolipunts_poli ON public.puntspolipunts USING btree (idpolipunt);


--
-- Name: idxpuntspolipunts_punt; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idxpuntspolipunts_punt ON public.puntspolipunts USING btree (idpunt);


--
-- Name: idxrecursgeorefepsg; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idxrecursgeorefepsg ON public.recursgeoref USING btree (idsistemareferenciaepsg);


--
-- Name: idxrecursgeorefparaula; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idxrecursgeorefparaula ON public.paraulaclaurecursgeoref USING btree (idparaula);


--
-- Name: idxrecursgeorefrecursgeoref; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idxrecursgeorefrecursgeoref ON public.paraulaclaurecursgeoref USING btree (idrecursgeoref);


--
-- Name: idxrecursgeoreftoponimrg; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idxrecursgeoreftoponimrg ON public.recursgeoreftoponim USING btree (idrecursgeoref);


--
-- Name: idxrecursgeoreftoponimt; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idxrecursgeoreftoponimt ON public.recursgeoreftoponim USING btree (idtoponim);


--
-- Name: idxrecursgeoreftr; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idxrecursgeoreftr ON public.recursgeoref USING btree (idtipusrecursgeoref);


--
-- Name: idxrecurssistemarefmm; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idxrecurssistemarefmm ON public.recursgeoref USING btree (idsistemareferenciamm);


--
-- Name: idxrecurstipusunitats; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idxrecurstipusunitats ON public.recursgeoref USING btree (idtipusunitatscarto);


--
-- Name: idxrolsaplicaciousuari_idu; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idxrolsaplicaciousuari_idu ON public.rolsaplicaciousuari USING btree (idusuari);


--
-- Name: idxrolsaplicaciousuari_mod; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idxrolsaplicaciousuari_mod ON public.rolsaplicaciousuari USING btree (idmodul);


--
-- Name: idxrolsdadesusuari_idr; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idxrolsdadesusuari_idr ON public.rolsdadesusuari USING btree (idrol);


--
-- Name: idxrolsdadesusuari_idu; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idxrolsdadesusuari_idu ON public.rolsdadesusuari USING btree (idusuari);


--
-- Name: idxrolsmoduls; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idxrolsmoduls ON public.rols USING btree (idmodul);


--
-- Name: idxsistemareferenciaepsg; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idxsistemareferenciaepsg ON public.sistemareferencia USING btree (idepsg);


--
-- Name: idxsistemareferenciarecursrg; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idxsistemareferenciarecursrg ON public.sistemareferenciarecurs USING btree (idrecursgeoref);


--
-- Name: idxsistemareferenciarecurssrmm; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idxsistemareferenciarecurssrmm ON public.sistemareferenciarecurs USING btree (idsistemareferenciamm);


--
-- Name: idxtoponimdoc; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idxtoponimdoc ON public.toponimversio USING btree (idlimitcartooriginal);


--
-- Name: idxtoponimr; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idxtoponimr ON public.toponimversio USING btree (idrecursgeoref);


--
-- Name: idxtoponimtt; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idxtoponimtt ON public.toponim USING btree (idtipustoponim);


--
-- Name: idxtoponimversioqualificador; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idxtoponimversioqualificador ON public.toponimversio USING btree (idqualificador);


--
-- Name: idxtoponimvp; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idxtoponimvp ON public.toponimversio USING btree (idpersona);


--
-- Name: idxtoponimvsr; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idxtoponimvsr ON public.toponimversio USING btree (idsistemareferenciarecurs);


--
-- Name: idxversionst; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idxversionst ON public.versions USING btree (idtoponim);


--
-- Name: idxversionsv; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idxversionsv ON public.versions USING btree (idversio);


--
-- Name: nomtoponim_toponimapi_idx; Type: INDEX; Schema: public; Owner: aplicacio_georef
--

CREATE INDEX nomtoponim_toponimapi_idx ON public.toponims_api USING btree (nomtoponim);


--
-- Name: toponimversio_georeference_protocol_id_029104cf; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX toponimversio_georeference_protocol_id_029104cf ON public.toponimversio USING btree (georeference_protocol_id);


--
-- Name: fkext_imatges1; Type: INDEX; Schema: sipan_mmedia; Owner: postgres
--

CREATE INDEX fkext_imatges1 ON sipan_mmedia.imatges USING btree (idextensio);


--
-- Name: idxcartografiaidformat; Type: INDEX; Schema: sipan_mmedia; Owner: postgres
--

CREATE INDEX idxcartografiaidformat ON sipan_mmedia.cartografia USING btree (idextensio);


--
-- Name: idxdocumentsidextensio; Type: INDEX; Schema: sipan_mmedia; Owner: postgres
--

CREATE INDEX idxdocumentsidextensio ON sipan_mmedia.documents USING btree (idextensio);


--
-- Name: fkobjectessipanusuaris1; Type: INDEX; Schema: sipan_msipan; Owner: postgres
--

CREATE INDEX fkobjectessipanusuaris1 ON sipan_msipan.objectessipan USING btree (idusuari);


--
-- Name: fktecnics_rangs1; Type: INDEX; Schema: sipan_msipan; Owner: postgres
--

CREATE INDEX fktecnics_rangs1 ON sipan_msipan.tecnics USING btree (idrang);


--
-- Name: idxconfiguracio_org; Type: INDEX; Schema: sipan_msipan; Owner: postgres
--

CREATE INDEX idxconfiguracio_org ON sipan_msipan.configuracio USING btree (idorganitzacio);


--
-- Name: idxmodul_tipusobjectes; Type: INDEX; Schema: sipan_msipan; Owner: postgres
--

CREATE INDEX idxmodul_tipusobjectes ON sipan_msipan.tipusobjectes USING btree (idmodul);


--
-- Name: idxorganigramesidorg; Type: INDEX; Schema: sipan_msipan; Owner: postgres
--

CREATE INDEX idxorganigramesidorg ON sipan_msipan.organigramesorganitzacions USING btree (idorganitzacio);


--
-- Name: idxpersonajuridicato; Type: INDEX; Schema: sipan_msipan; Owner: postgres
--

CREATE INDEX idxpersonajuridicato ON sipan_msipan.personajuridica USING btree (idtipusorganisme);


--
-- Name: idxpersonanif; Type: INDEX; Schema: sipan_msipan; Owner: postgres
--

CREATE INDEX idxpersonanif ON sipan_msipan.personafisica USING btree (nif);


--
-- Name: idxpersonapc; Type: INDEX; Schema: sipan_msipan; Owner: postgres
--

CREATE INDEX idxpersonapc ON sipan_msipan.personafisica USING btree (primercognom);


--
-- Name: idxpersonasc; Type: INDEX; Schema: sipan_msipan; Owner: postgres
--

CREATE INDEX idxpersonasc ON sipan_msipan.personafisica USING btree (segoncognom);


--
-- Name: idxtecnicsorgorg; Type: INDEX; Schema: sipan_msipan; Owner: postgres
--

CREATE INDEX idxtecnicsorgorg ON sipan_msipan.tecnicsorganitzacio USING btree (idorganitzacio);


--
-- Name: idxtecnicsorgtecnic; Type: INDEX; Schema: sipan_msipan; Owner: postgres
--

CREATE INDEX idxtecnicsorgtecnic ON sipan_msipan.tecnicsorganitzacio USING btree (idtecnic);


--
-- Name: idxnomvulgartaxon_nv; Type: INDEX; Schema: sipan_mtaxons; Owner: postgres
--

CREATE INDEX idxnomvulgartaxon_nv ON sipan_mtaxons.nomvulgartaxon USING btree (idnomvulgar);


--
-- Name: idxnomvulgartaxon_tx; Type: INDEX; Schema: sipan_mtaxons; Owner: postgres
--

CREATE INDEX idxnomvulgartaxon_tx ON sipan_mtaxons.nomvulgartaxon USING btree (idtaxon);


--
-- Name: idxtaxon_biocat; Type: INDEX; Schema: sipan_mtaxons; Owner: postgres
--

CREATE INDEX idxtaxon_biocat ON sipan_mtaxons.taxon USING btree (codibiocat);


--
-- Name: fkambitexclosrecursgeorefa1; Type: INDEX; Schema: sipan_mzoologia; Owner: postgres
--

CREATE INDEX fkambitexclosrecursgeorefa1 ON sipan_mzoologia.ambitexclosrecursgeoref USING btree (idambitgeografic);


--
-- Name: fkambitexclosrecursgeorefr1; Type: INDEX; Schema: sipan_mzoologia; Owner: postgres
--

CREATE INDEX fkambitexclosrecursgeorefr1 ON sipan_mzoologia.ambitexclosrecursgeoref USING btree (idrecursgeoref);


--
-- Name: fkambitgeograficrecursgeorefa1; Type: INDEX; Schema: sipan_mzoologia; Owner: postgres
--

CREATE INDEX fkambitgeograficrecursgeorefa1 ON sipan_mzoologia.ambitgeograficrecursgeoref USING btree (idambitgeografic);


--
-- Name: fkambitgeograficrecursgeorefr1; Type: INDEX; Schema: sipan_mzoologia; Owner: postgres
--

CREATE INDEX fkambitgeograficrecursgeorefr1 ON sipan_mzoologia.ambitgeograficrecursgeoref USING btree (idrecursgeoref);


--
-- Name: fkautorrecursgeorefa1; Type: INDEX; Schema: sipan_mzoologia; Owner: postgres
--

CREATE INDEX fkautorrecursgeorefa1 ON sipan_mzoologia.autorrecursgeoref USING btree (idpersona);


--
-- Name: fkautorrecursgeorefr1; Type: INDEX; Schema: sipan_mzoologia; Owner: postgres
--

CREATE INDEX fkautorrecursgeorefr1 ON sipan_mzoologia.autorrecursgeoref USING btree (idrecursgeoref);


--
-- Name: fkrecursgeorefc1; Type: INDEX; Schema: sipan_mzoologia; Owner: postgres
--

CREATE INDEX fkrecursgeorefc1 ON sipan_mzoologia.recursgeoref USING btree (idconversio);


--
-- Name: fkrecursgeorefd1; Type: INDEX; Schema: sipan_mzoologia; Owner: postgres
--

CREATE INDEX fkrecursgeorefd1 ON sipan_mzoologia.recursgeoref USING btree (iddatum);


--
-- Name: fkrecursgeorefp1; Type: INDEX; Schema: sipan_mzoologia; Owner: postgres
--

CREATE INDEX fkrecursgeorefp1 ON sipan_mzoologia.recursgeoref USING btree (idprojeccio);


--
-- Name: fkrecursgeorefs1; Type: INDEX; Schema: sipan_mzoologia; Owner: postgres
--

CREATE INDEX fkrecursgeorefs1 ON sipan_mzoologia.recursgeoref USING btree (idsuport);


--
-- Name: fkrecursgeorefuh1; Type: INDEX; Schema: sipan_mzoologia; Owner: postgres
--

CREATE INDEX fkrecursgeorefuh1 ON sipan_mzoologia.recursgeoref USING btree (idunitath);


--
-- Name: fkrecursgeorefuv1; Type: INDEX; Schema: sipan_mzoologia; Owner: postgres
--

CREATE INDEX fkrecursgeorefuv1 ON sipan_mzoologia.recursgeoref USING btree (idunitatv);


--
-- Name: auth_group_permissions auth_group_permissio_permission_id_84c5c92e_fk_auth_perm; Type: FK CONSTRAINT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissio_permission_id_84c5c92e_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_group_permissions auth_group_permissions_group_id_b120cbf9_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_b120cbf9_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES public.auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_permission auth_permission_content_type_id_2f476e4b_fk_django_co; Type: FK CONSTRAINT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_2f476e4b_fk_django_co FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_groups auth_user_groups_group_id_97559544_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_group_id_97559544_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES public.auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_groups auth_user_groups_user_id_6a12ed8b_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_user_id_6a12ed8b_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_user_permissions auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm; Type: FK CONSTRAINT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_user_permissions auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_admin_log django_admin_log_content_type_id_c4bce8eb_fk_django_co; Type: FK CONSTRAINT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_content_type_id_c4bce8eb_fk_django_co FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_admin_log django_admin_log_user_id_c564eba6_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_user_id_c564eba6_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: epsg_coordinatereferencesystem fk_area_of_use_code; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.epsg_coordinatereferencesystem
    ADD CONSTRAINT fk_area_of_use_code FOREIGN KEY (area_of_use_code) REFERENCES public.epsg_area(area_code) MATCH FULL;


--
-- Name: epsg_datum fk_area_of_use_code2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.epsg_datum
    ADD CONSTRAINT fk_area_of_use_code2 FOREIGN KEY (area_of_use_code) REFERENCES public.epsg_area(area_code) MATCH FULL;


--
-- Name: epsg_coordoperation fk_area_of_use_code3; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.epsg_coordoperation
    ADD CONSTRAINT fk_area_of_use_code3 FOREIGN KEY (area_of_use_code) REFERENCES public.epsg_area(area_code) MATCH FULL;


--
-- Name: cartovisual fk_cartovisual_carto; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cartovisual
    ADD CONSTRAINT fk_cartovisual_carto FOREIGN KEY (idcartografia) REFERENCES sipan_mmedia.cartografia(idcarto) ON DELETE CASCADE;


--
-- Name: cartovisual fk_cartovisual_objectessipan; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cartovisual
    ADD CONSTRAINT fk_cartovisual_objectessipan FOREIGN KEY (idobjectesipan) REFERENCES sipan_msipan.objectessipan(id) ON DELETE CASCADE;


--
-- Name: epsg_deprecation fk_change_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.epsg_deprecation
    ADD CONSTRAINT fk_change_id FOREIGN KEY (change_id) REFERENCES public.epsg_change(change_id) MATCH FULL;


--
-- Name: epsg_coordinatereferencesystem fk_cmpd_horizcrs_code; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.epsg_coordinatereferencesystem
    ADD CONSTRAINT fk_cmpd_horizcrs_code FOREIGN KEY (cmpd_horizcrs_code) REFERENCES public.epsg_coordinatereferencesystem(coord_ref_sys_code) MATCH FULL;


--
-- Name: epsg_coordinatereferencesystem fk_cmpd_vertcrs_code; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.epsg_coordinatereferencesystem
    ADD CONSTRAINT fk_cmpd_vertcrs_code FOREIGN KEY (cmpd_vertcrs_code) REFERENCES public.epsg_coordinatereferencesystem(coord_ref_sys_code) MATCH FULL;


--
-- Name: epsg_coordoperationpath fk_concat_operation_code; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.epsg_coordoperationpath
    ADD CONSTRAINT fk_concat_operation_code FOREIGN KEY (concat_operation_code) REFERENCES public.epsg_coordoperation(coord_op_code) MATCH FULL;


--
-- Name: epsg_coordinateaxis fk_coord_axis_name_code; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.epsg_coordinateaxis
    ADD CONSTRAINT fk_coord_axis_name_code FOREIGN KEY (coord_axis_name_code) REFERENCES public.epsg_coordinateaxisname(coord_axis_name_code) MATCH FULL;


--
-- Name: epsg_coordoperationparamvalue fk_coord_op_code; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.epsg_coordoperationparamvalue
    ADD CONSTRAINT fk_coord_op_code FOREIGN KEY (coord_op_code) REFERENCES public.epsg_coordoperation(coord_op_code) MATCH FULL;


--
-- Name: epsg_coordoperation fk_coord_op_method_code; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.epsg_coordoperation
    ADD CONSTRAINT fk_coord_op_method_code FOREIGN KEY (coord_op_method_code) REFERENCES public.epsg_coordoperationmethod(coord_op_method_code) MATCH FULL;


--
-- Name: epsg_coordoperationparamusage fk_coord_op_method_code2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.epsg_coordoperationparamusage
    ADD CONSTRAINT fk_coord_op_method_code2 FOREIGN KEY (coord_op_method_code) REFERENCES public.epsg_coordoperationmethod(coord_op_method_code) MATCH FULL;


--
-- Name: epsg_coordinateaxis fk_coord_sys_code; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.epsg_coordinateaxis
    ADD CONSTRAINT fk_coord_sys_code FOREIGN KEY (coord_sys_code) REFERENCES public.epsg_coordinatesystem(coord_sys_code) MATCH FULL;


--
-- Name: epsg_coordinatereferencesystem fk_coord_sys_code2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.epsg_coordinatereferencesystem
    ADD CONSTRAINT fk_coord_sys_code2 FOREIGN KEY (coord_sys_code) REFERENCES public.epsg_coordinatesystem(coord_sys_code) MATCH FULL;


--
-- Name: epsg_coordinatereferencesystem fk_datum_code; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.epsg_coordinatereferencesystem
    ADD CONSTRAINT fk_datum_code FOREIGN KEY (datum_code) REFERENCES public.epsg_datum(datum_code) MATCH FULL;


--
-- Name: epsg_datum fk_ellipsoid_code; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.epsg_datum
    ADD CONSTRAINT fk_ellipsoid_code FOREIGN KEY (ellipsoid_code) REFERENCES public.epsg_ellipsoid(ellipsoid_code) MATCH FULL;


--
-- Name: epsg_alias fk_naming_system_code; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.epsg_alias
    ADD CONSTRAINT fk_naming_system_code FOREIGN KEY (naming_system_code) REFERENCES public.epsg_namingsystem(naming_system_code) MATCH FULL;


--
-- Name: epsg_coordoperationparamusage fk_parameter_code; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.epsg_coordoperationparamusage
    ADD CONSTRAINT fk_parameter_code FOREIGN KEY (parameter_code) REFERENCES public.epsg_coordoperationparam(parameter_code) MATCH FULL;


--
-- Name: epsg_coordoperationparamvalue fk_parameter_codecoord_op_meth; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.epsg_coordoperationparamvalue
    ADD CONSTRAINT fk_parameter_codecoord_op_meth FOREIGN KEY (parameter_code, coord_op_method_code) REFERENCES public.epsg_coordoperationparamusage(parameter_code, coord_op_method_code) MATCH FULL;


--
-- Name: epsg_datum fk_prime_meridian_code; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.epsg_datum
    ADD CONSTRAINT fk_prime_meridian_code FOREIGN KEY (prime_meridian_code) REFERENCES public.epsg_primemeridian(prime_meridian_code) MATCH FULL;


--
-- Name: epsg_coordoperationpath fk_single_operation_code; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.epsg_coordoperationpath
    ADD CONSTRAINT fk_single_operation_code FOREIGN KEY (single_operation_code) REFERENCES public.epsg_coordoperation(coord_op_code) MATCH FULL;


--
-- Name: epsg_coordoperation fk_source_crs_code; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.epsg_coordoperation
    ADD CONSTRAINT fk_source_crs_code FOREIGN KEY (source_crs_code) REFERENCES public.epsg_coordinatereferencesystem(coord_ref_sys_code) MATCH FULL;


--
-- Name: epsg_coordinatereferencesystem fk_source_geogcrs_code; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.epsg_coordinatereferencesystem
    ADD CONSTRAINT fk_source_geogcrs_code FOREIGN KEY (source_geogcrs_code) REFERENCES public.epsg_coordinatereferencesystem(coord_ref_sys_code) MATCH FULL;


--
-- Name: epsg_coordoperation fk_target_crs_code; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.epsg_coordoperation
    ADD CONSTRAINT fk_target_crs_code FOREIGN KEY (target_crs_code) REFERENCES public.epsg_coordinatereferencesystem(coord_ref_sys_code) MATCH FULL;


--
-- Name: epsg_unitofmeasure fk_target_uom_code; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.epsg_unitofmeasure
    ADD CONSTRAINT fk_target_uom_code FOREIGN KEY (target_uom_code) REFERENCES public.epsg_unitofmeasure(uom_code) MATCH FULL;


--
-- Name: epsg_primemeridian fk_uom_code; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.epsg_primemeridian
    ADD CONSTRAINT fk_uom_code FOREIGN KEY (uom_code) REFERENCES public.epsg_unitofmeasure(uom_code) MATCH FULL;


--
-- Name: epsg_coordinateaxis fk_uom_code2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.epsg_coordinateaxis
    ADD CONSTRAINT fk_uom_code2 FOREIGN KEY (uom_code) REFERENCES public.epsg_unitofmeasure(uom_code) MATCH FULL;


--
-- Name: epsg_coordoperationparamvalue fk_uom_code3; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.epsg_coordoperationparamvalue
    ADD CONSTRAINT fk_uom_code3 FOREIGN KEY (uom_code) REFERENCES public.epsg_unitofmeasure(uom_code) MATCH FULL;


--
-- Name: epsg_ellipsoid fk_uom_code4; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.epsg_ellipsoid
    ADD CONSTRAINT fk_uom_code4 FOREIGN KEY (uom_code) REFERENCES public.epsg_unitofmeasure(uom_code) MATCH FULL;


--
-- Name: epsg_coordoperation fk_uom_code_source_coord_diff; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.epsg_coordoperation
    ADD CONSTRAINT fk_uom_code_source_coord_diff FOREIGN KEY (uom_code_source_coord_diff) REFERENCES public.epsg_unitofmeasure(uom_code) MATCH FULL;


--
-- Name: epsg_coordoperation fk_uom_code_target_coord_diff; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.epsg_coordoperation
    ADD CONSTRAINT fk_uom_code_target_coord_diff FOREIGN KEY (uom_code_target_coord_diff) REFERENCES public.epsg_unitofmeasure(uom_code) MATCH FULL;


--
-- Name: ambitexclosrecursgeoref fkambitexclosrecursgeorefa; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ambitexclosrecursgeoref
    ADD CONSTRAINT fkambitexclosrecursgeorefa FOREIGN KEY (idambitgeografic) REFERENCES public.ambitgeografic(id) MATCH FULL ON DELETE CASCADE;


--
-- Name: ambitexclosrecursgeoref fkambitexclosrecursgeorefr; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ambitexclosrecursgeoref
    ADD CONSTRAINT fkambitexclosrecursgeorefr FOREIGN KEY (idrecursgeoref) REFERENCES public.recursgeoref(id) MATCH FULL ON DELETE CASCADE;


--
-- Name: ambitgeograficrecursgeoref fkambitgeograficrecursgeorefa; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ambitgeograficrecursgeoref
    ADD CONSTRAINT fkambitgeograficrecursgeorefa FOREIGN KEY (idambitgeografic) REFERENCES public.ambitgeografic(id) MATCH FULL ON DELETE CASCADE;


--
-- Name: ambitgeograficrecursgeoref fkambitgeograficrecursgeorefr; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ambitgeograficrecursgeoref
    ADD CONSTRAINT fkambitgeograficrecursgeorefr FOREIGN KEY (idrecursgeoref) REFERENCES public.recursgeoref(id) MATCH FULL ON DELETE CASCADE;


--
-- Name: autorrecursgeoref fkautorrecursgeorefa; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.autorrecursgeoref
    ADD CONSTRAINT fkautorrecursgeorefa FOREIGN KEY (idpersona) REFERENCES public.georef_addenda_autor(id) MATCH FULL;


--
-- Name: autorrecursgeoref fkautorrecursgeorefr; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.autorrecursgeoref
    ADD CONSTRAINT fkautorrecursgeorefr FOREIGN KEY (idrecursgeoref) REFERENCES public.recursgeoref(id) MATCH FULL ON DELETE CASCADE;


--
-- Name: comunitatsautonomes fkca_objectessipan; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comunitatsautonomes
    ADD CONSTRAINT fkca_objectessipan FOREIGN KEY (id) REFERENCES sipan_msipan.objectessipan(id);


--
-- Name: capesrecurs fkcapareccapa; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.capesrecurs
    ADD CONSTRAINT fkcapareccapa FOREIGN KEY (idcapa) REFERENCES public.capawms(id) MATCH FULL;


--
-- Name: capesrecurs fkcaparecrec; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.capesrecurs
    ADD CONSTRAINT fkcaparecrec FOREIGN KEY (idrecurs) REFERENCES public.recursgeoref(id) MATCH FULL;


--
-- Name: comunitatsautonomesprovincies fkcapro_ca; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comunitatsautonomesprovincies
    ADD CONSTRAINT fkcapro_ca FOREIGN KEY (idcomunitatautonoma) REFERENCES public.comunitatsautonomes(id) MATCH FULL ON DELETE CASCADE;


--
-- Name: comunitatsautonomesprovincies fkcapro_prov; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comunitatsautonomesprovincies
    ADD CONSTRAINT fkcapro_prov FOREIGN KEY (idprovincia) REFERENCES public.provincies(idprovincia) MATCH FULL ON DELETE CASCADE;


--
-- Name: comarques fkcomarques_geom; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comarques
    ADD CONSTRAINT fkcomarques_geom FOREIGN KEY (idgeometria) REFERENCES public.geometria(idgeometria) ON DELETE SET NULL;


--
-- Name: municipis fkcomarques_municipis; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.municipis
    ADD CONSTRAINT fkcomarques_municipis FOREIGN KEY (idcomarca) REFERENCES public.comarques(idcomarca) MATCH FULL;


--
-- Name: comarques fkcomarques_os; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comarques
    ADD CONSTRAINT fkcomarques_os FOREIGN KEY (idcomarca) REFERENCES sipan_msipan.objectessipan(id);


--
-- Name: comments fkcommentversio; Type: FK CONSTRAINT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT fkcommentversio FOREIGN KEY (idversio) REFERENCES public.toponimversio(id) ON DELETE CASCADE;


--
-- Name: punts fkcoordenades_punts; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.punts
    ADD CONSTRAINT fkcoordenades_punts FOREIGN KEY (idcoordenada) REFERENCES public.coordenades(idcoordenada) MATCH FULL ON DELETE CASCADE;


--
-- Name: coordenadeslinies fkcoordenadeslinies_coord; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coordenadeslinies
    ADD CONSTRAINT fkcoordenadeslinies_coord FOREIGN KEY (idcoordenada) REFERENCES public.coordenades(idcoordenada) MATCH FULL ON DELETE CASCADE;


--
-- Name: coordenadeslinies fkcoordenadeslinies_linies; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coordenadeslinies
    ADD CONSTRAINT fkcoordenadeslinies_linies FOREIGN KEY (idlinia) REFERENCES public.linies(idlinia) MATCH FULL ON DELETE CASCADE;


--
-- Name: comarquesprovincies fkcprov_com; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comarquesprovincies
    ADD CONSTRAINT fkcprov_com FOREIGN KEY (idcomarca) REFERENCES public.comarques(idcomarca) MATCH FULL;


--
-- Name: comarquesprovincies fkcprov_prov; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comarquesprovincies
    ADD CONSTRAINT fkcprov_prov FOREIGN KEY (idprovincia) REFERENCES public.provincies(idprovincia) MATCH FULL;


--
-- Name: comarques fkdemarcacions_comarques; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comarques
    ADD CONSTRAINT fkdemarcacions_comarques FOREIGN KEY (iddemarcacioterritorial) REFERENCES public.demarcacionsterritorials(iddemarcacioterritorial) MATCH FULL;


--
-- Name: demarcacionsterritorials fkdemarcacionsterritorials_os; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.demarcacionsterritorials
    ADD CONSTRAINT fkdemarcacionsterritorials_os FOREIGN KEY (iddemarcacioterritorial) REFERENCES sipan_msipan.objectessipan(id);


--
-- Name: documentsversions fkdocdoc; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.documentsversions
    ADD CONSTRAINT fkdocdoc FOREIGN KEY (iddocument) REFERENCES sipan_mmedia.documents(iddocument) MATCH FULL ON DELETE CASCADE;


--
-- Name: documentsrecursos fkdocrecdoc; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.documentsrecursos
    ADD CONSTRAINT fkdocrecdoc FOREIGN KEY (iddocument) REFERENCES sipan_mmedia.documents(iddocument) MATCH FULL ON DELETE CASCADE;


--
-- Name: documentsrecursos fkdocrecrec; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.documentsrecursos
    ADD CONSTRAINT fkdocrecrec FOREIGN KEY (idrecurs) REFERENCES public.recursgeoref(id) MATCH FULL ON DELETE CASCADE;


--
-- Name: documentsversions fkdocversio; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.documentsversions
    ADD CONSTRAINT fkdocversio FOREIGN KEY (idversio) REFERENCES public.toponimversio(id) MATCH FULL ON DELETE CASCADE;


--
-- Name: geometria fkgeometria_polilinies; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.geometria
    ADD CONSTRAINT fkgeometria_polilinies FOREIGN KEY (idpolilinia) REFERENCES public.polilinies(idpolilinia) MATCH FULL ON DELETE SET NULL;


--
-- Name: geometria fkgeometria_polipoligons; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.geometria
    ADD CONSTRAINT fkgeometria_polipoligons FOREIGN KEY (idpolipoligon) REFERENCES public.polipoligons(idpolipoligon) MATCH FULL ON DELETE SET NULL;


--
-- Name: geometria fkgeometria_polipunts; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.geometria
    ADD CONSTRAINT fkgeometria_polipunts FOREIGN KEY (idpolipunt) REFERENCES public.polipunts(idpolipunt) MATCH FULL ON DELETE SET NULL;


--
-- Name: geometriaobjectessipan fkgeometriaobjectessipan_g; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.geometriaobjectessipan
    ADD CONSTRAINT fkgeometriaobjectessipan_g FOREIGN KEY (idgeometria) REFERENCES public.geometria(idgeometria) MATCH FULL ON DELETE CASCADE;


--
-- Name: geometriaobjectessipan fkgeometriaobjectessipan_o; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.geometriaobjectessipan
    ADD CONSTRAINT fkgeometriaobjectessipan_o FOREIGN KEY (idobjectessipan) REFERENCES sipan_msipan.objectessipan(id) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;


--
-- Name: geometria fkgeometriasr; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.geometria
    ADD CONSTRAINT fkgeometriasr FOREIGN KEY (idsistemareferencia) REFERENCES public.sistemareferencia(id) MATCH FULL;


--
-- Name: linies fklinies_cartocapt; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.linies
    ADD CONSTRAINT fklinies_cartocapt FOREIGN KEY (idcartocaptura) REFERENCES public.basescartografiques(idbasecarto) MATCH FULL;


--
-- Name: linies fklinies_ta; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.linies
    ADD CONSTRAINT fklinies_ta FOREIGN KEY (idtipusatribut) REFERENCES public.tipusatributs(idtipusatribut) MATCH FULL;


--
-- Name: liniesobjectessipan fkliniesobjectessipan_li; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.liniesobjectessipan
    ADD CONSTRAINT fkliniesobjectessipan_li FOREIGN KEY (idlinies) REFERENCES public.linies(idlinia) MATCH FULL ON DELETE CASCADE;


--
-- Name: liniesobjectessipan fkliniesobjectessipan_os; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.liniesobjectessipan
    ADD CONSTRAINT fkliniesobjectessipan_os FOREIGN KEY (idobjectessipan) REFERENCES sipan_msipan.objectessipan(id) ON DELETE CASCADE;


--
-- Name: liniespolilinies fkliniespolilinies_linies; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.liniespolilinies
    ADD CONSTRAINT fkliniespolilinies_linies FOREIGN KEY (idlinia) REFERENCES public.linies(idlinia) MATCH FULL ON DELETE CASCADE;


--
-- Name: liniespolilinies fkliniespolilinies_polilinia; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.liniespolilinies
    ADD CONSTRAINT fkliniespolilinies_polilinia FOREIGN KEY (idpolilinia) REFERENCES public.polilinies(idpolilinia) MATCH FULL ON DELETE CASCADE;


--
-- Name: logactivitatobjectessipan fklogactivitatsipantes_u; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.logactivitatobjectessipan
    ADD CONSTRAINT fklogactivitatsipantes_u FOREIGN KEY (idusuari) REFERENCES public.usuaris(idusuari) MATCH FULL;


--
-- Name: municipis fkmunicipis_geom; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.municipis
    ADD CONSTRAINT fkmunicipis_geom FOREIGN KEY (idgeometria) REFERENCES public.geometria(idgeometria) ON DELETE SET NULL;


--
-- Name: municipis fkmunicipis_os; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.municipis
    ADD CONSTRAINT fkmunicipis_os FOREIGN KEY (idmunicipi) REFERENCES sipan_msipan.objectessipan(id);


--
-- Name: toponim fkorgtoponim; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.toponim
    ADD CONSTRAINT fkorgtoponim FOREIGN KEY (idorganization_id) REFERENCES public.georef_addenda_organization(id) MATCH FULL DEFERRABLE INITIALLY DEFERRED;


--
-- Name: toponim fkpaistoponim; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.toponim
    ADD CONSTRAINT fkpaistoponim FOREIGN KEY (idpais) REFERENCES public.pais(id) MATCH FULL DEFERRABLE INITIALLY DEFERRED;


--
-- Name: toponim fkparetoponim; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.toponim
    ADD CONSTRAINT fkparetoponim FOREIGN KEY (idpare) REFERENCES public.toponim(id) MATCH FULL ON DELETE SET NULL DEFERRABLE INITIALLY DEFERRED;


--
-- Name: poligons fkpoligons_poligons; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.poligons
    ADD CONSTRAINT fkpoligons_poligons FOREIGN KEY (idpoligoncontenidor) REFERENCES public.poligons(idpoligon) MATCH FULL ON DELETE SET NULL;


--
-- Name: poligons fkpoligons_polilinia; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.poligons
    ADD CONSTRAINT fkpoligons_polilinia FOREIGN KEY (idpolilinia) REFERENCES public.polilinies(idpolilinia) MATCH FULL ON DELETE CASCADE;


--
-- Name: poligons fkpoligons_ta; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.poligons
    ADD CONSTRAINT fkpoligons_ta FOREIGN KEY (idtipusatribut) REFERENCES public.tipusatributs(idtipusatribut) MATCH FULL;


--
-- Name: poligonsobjectessipan fkpoligonsobjectessipan_os; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.poligonsobjectessipan
    ADD CONSTRAINT fkpoligonsobjectessipan_os FOREIGN KEY (idobjectessipan) REFERENCES sipan_msipan.objectessipan(id) ON DELETE CASCADE;


--
-- Name: poligonsobjectessipan fkpoligonsobjectessipan_po; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.poligonsobjectessipan
    ADD CONSTRAINT fkpoligonsobjectessipan_po FOREIGN KEY (idpoligons) REFERENCES public.poligons(idpoligon) MATCH FULL ON DELETE CASCADE;


--
-- Name: poligonspolipoligons fkpoligonspolipoligons_pol; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.poligonspolipoligons
    ADD CONSTRAINT fkpoligonspolipoligons_pol FOREIGN KEY (idpoligon) REFERENCES public.poligons(idpoligon) MATCH FULL ON DELETE CASCADE;


--
-- Name: poligonspolipoligons fkpoligonspolipoligons_polipol; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.poligonspolipoligons
    ADD CONSTRAINT fkpoligonspolipoligons_polipol FOREIGN KEY (idpolipoligon) REFERENCES public.polipoligons(idpolipoligon) MATCH FULL ON DELETE CASCADE;


--
-- Name: polilinies fkpolilinies_ta; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.polilinies
    ADD CONSTRAINT fkpolilinies_ta FOREIGN KEY (idtipusatribut) REFERENCES public.tipusatributs(idtipusatribut) MATCH FULL;


--
-- Name: polipoligons fkpolipoligons_ta; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.polipoligons
    ADD CONSTRAINT fkpolipoligons_ta FOREIGN KEY (idtipusatribut) REFERENCES public.tipusatributs(idtipusatribut) MATCH FULL;


--
-- Name: polipunts fkpolipunts_ta; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.polipunts
    ADD CONSTRAINT fkpolipunts_ta FOREIGN KEY (idtipusatribut) REFERENCES public.tipusatributs(idtipusatribut) MATCH FULL;


--
-- Name: provincies fkprovincies_geom; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.provincies
    ADD CONSTRAINT fkprovincies_geom FOREIGN KEY (idgeometria) REFERENCES public.geometria(idgeometria) ON DELETE SET NULL;


--
-- Name: municipis fkprovincies_municipis; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.municipis
    ADD CONSTRAINT fkprovincies_municipis FOREIGN KEY (idprovincia) REFERENCES public.provincies(idprovincia) MATCH FULL;


--
-- Name: provincies fkprovincies_os; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.provincies
    ADD CONSTRAINT fkprovincies_os FOREIGN KEY (idprovincia) REFERENCES sipan_msipan.objectessipan(id);


--
-- Name: punts fkpunts_cartocapt; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.punts
    ADD CONSTRAINT fkpunts_cartocapt FOREIGN KEY (idcartocaptura) REFERENCES public.basescartografiques(idbasecarto) MATCH FULL;


--
-- Name: punts fkpunts_ta; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.punts
    ADD CONSTRAINT fkpunts_ta FOREIGN KEY (idtipusatribut) REFERENCES public.tipusatributs(idtipusatribut) MATCH FULL;


--
-- Name: puntsobjectessipan fkpuntsobjectessipan_os; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.puntsobjectessipan
    ADD CONSTRAINT fkpuntsobjectessipan_os FOREIGN KEY (idobjectessipan) REFERENCES sipan_msipan.objectessipan(id) ON DELETE CASCADE;


--
-- Name: puntsobjectessipan fkpuntsobjectessipan_pu; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.puntsobjectessipan
    ADD CONSTRAINT fkpuntsobjectessipan_pu FOREIGN KEY (idpunts) REFERENCES public.punts(idpunt) MATCH FULL ON DELETE CASCADE;


--
-- Name: puntspolipunts fkpuntspolipunts_polipunts; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.puntspolipunts
    ADD CONSTRAINT fkpuntspolipunts_polipunts FOREIGN KEY (idpolipunt) REFERENCES public.polipunts(idpolipunt) MATCH FULL ON DELETE CASCADE;


--
-- Name: puntspolipunts fkpuntspolipunts_punts; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.puntspolipunts
    ADD CONSTRAINT fkpuntspolipunts_punts FOREIGN KEY (idpunt) REFERENCES public.punts(idpunt) MATCH FULL ON DELETE CASCADE;


--
-- Name: toponimversio fkqualificadorsversioqualificadors; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.toponimversio
    ADD CONSTRAINT fkqualificadorsversioqualificadors FOREIGN KEY (idqualificador) REFERENCES public.qualificadorversio(id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: recursgeoref fkrecgeotv; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recursgeoref
    ADD CONSTRAINT fkrecgeotv FOREIGN KEY (idambit) REFERENCES public.toponimversio(id) MATCH FULL;


--
-- Name: recursgeoref fkrecursgeogeometria; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recursgeoref
    ADD CONSTRAINT fkrecursgeogeometria FOREIGN KEY (idgeometria) REFERENCES public.geometria(idgeometria) ON DELETE CASCADE;


--
-- Name: recursgeoref fkrecursgeorefepsg; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recursgeoref
    ADD CONSTRAINT fkrecursgeorefepsg FOREIGN KEY (idsistemareferenciaepsg) REFERENCES public.sistemareferencia(id);


--
-- Name: paraulaclaurecursgeoref fkrecursgeorefparaula; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.paraulaclaurecursgeoref
    ADD CONSTRAINT fkrecursgeorefparaula FOREIGN KEY (idparaula) REFERENCES public.paraulaclau(id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: paraulaclaurecursgeoref fkrecursgeorefrecursgeoref; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.paraulaclaurecursgeoref
    ADD CONSTRAINT fkrecursgeorefrecursgeoref FOREIGN KEY (idrecursgeoref) REFERENCES public.recursgeoref(id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: recursgeoref fkrecursgeorefs; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recursgeoref
    ADD CONSTRAINT fkrecursgeorefs FOREIGN KEY (idsuport) REFERENCES public.suport(id) MATCH FULL;


--
-- Name: recursgeoreftoponim fkrecursgeoreftoponimrg; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recursgeoreftoponim
    ADD CONSTRAINT fkrecursgeoreftoponimrg FOREIGN KEY (idrecursgeoref) REFERENCES public.recursgeoref(id) ON DELETE CASCADE;


--
-- Name: recursgeoreftoponim fkrecursgeoreftoponimt; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recursgeoreftoponim
    ADD CONSTRAINT fkrecursgeoreftoponimt FOREIGN KEY (idtoponim) REFERENCES public.toponim(id) MATCH FULL ON DELETE CASCADE;


--
-- Name: recursgeoref fkrecursgeoreftr; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recursgeoref
    ADD CONSTRAINT fkrecursgeoreftr FOREIGN KEY (idtipusrecursgeoref) REFERENCES public.tipusrecursgeoref(id) MATCH FULL;


--
-- Name: recursgeoref fkrecurssistemarefmm; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recursgeoref
    ADD CONSTRAINT fkrecurssistemarefmm FOREIGN KEY (idsistemareferenciamm) REFERENCES public.sistemareferenciamm(id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: recursgeoref fkrecurstipusunitat; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recursgeoref
    ADD CONSTRAINT fkrecurstipusunitat FOREIGN KEY (idtipusunitatscarto) REFERENCES public.tipusunitats(id) MATCH FULL ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: rolsaplicaciousuari fkrolsaplicaciousuari_u; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rolsaplicaciousuari
    ADD CONSTRAINT fkrolsaplicaciousuari_u FOREIGN KEY (idusuari) REFERENCES public.usuaris(idusuari) MATCH FULL;


--
-- Name: rolsdadesusuari fkrolsdadesusuari_r; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rolsdadesusuari
    ADD CONSTRAINT fkrolsdadesusuari_r FOREIGN KEY (idrol) REFERENCES public.rols(idrol) MATCH FULL;


--
-- Name: rolsdadesusuari fkrolsdadesusuari_u; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rolsdadesusuari
    ADD CONSTRAINT fkrolsdadesusuari_u FOREIGN KEY (idusuari) REFERENCES public.usuaris(idusuari) MATCH FULL;


--
-- Name: servidorswms fkservidorswms_moduls; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.servidorswms
    ADD CONSTRAINT fkservidorswms_moduls FOREIGN KEY (idmodul) REFERENCES sipan_msipan.moduls(idmodul);


--
-- Name: sistemareferencia fksistemareferenciaepsg; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sistemareferencia
    ADD CONSTRAINT fksistemareferenciaepsg FOREIGN KEY (idepsg) REFERENCES public.epsg_coordinatereferencesystem(coord_ref_sys_code) MATCH FULL;


--
-- Name: sistemareferenciarecurs fksistemareferenciarecursrg; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sistemareferenciarecurs
    ADD CONSTRAINT fksistemareferenciarecursrg FOREIGN KEY (idrecursgeoref) REFERENCES public.recursgeoref(id) MATCH FULL ON DELETE CASCADE;


--
-- Name: sistemareferenciarecurs fksistemareferenciarecurssrmm; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sistemareferenciarecurs
    ADD CONSTRAINT fksistemareferenciarecurssrmm FOREIGN KEY (idsistemareferenciamm) REFERENCES public.sistemareferenciamm(id) MATCH FULL ON DELETE CASCADE;


--
-- Name: toponimsexclosos fktetoponim; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.toponimsexclosos
    ADD CONSTRAINT fktetoponim FOREIGN KEY (idtoponim) REFERENCES public.toponim(id) MATCH FULL;


--
-- Name: toponimsexclosos fktetoponimexcl; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.toponimsexclosos
    ADD CONSTRAINT fktetoponimexcl FOREIGN KEY (idtoponimexclos) REFERENCES public.toponim(id) MATCH FULL;


--
-- Name: toponimversio fktoponimgeometria; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.toponimversio
    ADD CONSTRAINT fktoponimgeometria FOREIGN KEY (idgeometria) REFERENCES public.geometria(idgeometria) ON DELETE CASCADE;


--
-- Name: toponim fktoponimtt; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.toponim
    ADD CONSTRAINT fktoponimtt FOREIGN KEY (idtipustoponim) REFERENCES public.tipustoponim(id) MATCH FULL;


--
-- Name: toponimversio fktoponimversiotoponim; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.toponimversio
    ADD CONSTRAINT fktoponimversiotoponim FOREIGN KEY (idtoponim) REFERENCES public.toponim(id) MATCH FULL ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;


--
-- Name: toponimversio fktvdocs; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.toponimversio
    ADD CONSTRAINT fktvdocs FOREIGN KEY (idlimitcartooriginal) REFERENCES sipan_mmedia.documents(iddocument) ON DELETE CASCADE;


--
-- Name: toponimversio fktvrecgeo; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.toponimversio
    ADD CONSTRAINT fktvrecgeo FOREIGN KEY (idrecursgeoref) REFERENCES public.recursgeoref(id);


--
-- Name: toponimsversiorecurs fktvrrecursgeoref; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.toponimsversiorecurs
    ADD CONSTRAINT fktvrrecursgeoref FOREIGN KEY (idrecursgeoref) REFERENCES public.recursgeoref(id) MATCH FULL;


--
-- Name: toponimversio fktvsistrefmm; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.toponimversio
    ADD CONSTRAINT fktvsistrefmm FOREIGN KEY (idsistemareferenciarecurs) REFERENCES public.sistemareferenciarecurs(id);


--
-- Name: usuariauthority fkusuariauthorityauthority; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuariauthority
    ADD CONSTRAINT fkusuariauthorityauthority FOREIGN KEY (idauthority) REFERENCES public.authority(id);


--
-- Name: prefs_visibilitat_capes fkusuprefs; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.prefs_visibilitat_capes
    ADD CONSTRAINT fkusuprefs FOREIGN KEY (idusuari) REFERENCES public.usuaris(idusuari) MATCH FULL;


--
-- Name: versions fkvtoponim; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.versions
    ADD CONSTRAINT fkvtoponim FOREIGN KEY (idtoponim) REFERENCES public.toponim(id) MATCH FULL ON DELETE CASCADE;


--
-- Name: versions fkvversio; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.versions
    ADD CONSTRAINT fkvversio FOREIGN KEY (idversio) REFERENCES public.toponimversio(id) MATCH FULL ON DELETE CASCADE;


--
-- Name: georef_addenda_geometriarecurs georef_addenda_geome_idrecurs_5b7466ad_fk_recursgeo; Type: FK CONSTRAINT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.georef_addenda_geometriarecurs
    ADD CONSTRAINT georef_addenda_geome_idrecurs_5b7466ad_fk_recursgeo FOREIGN KEY (idrecurs) REFERENCES public.recursgeoref(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: georef_addenda_geometriatoponimversio georef_addenda_geome_idversio_1b15db1f_fk_toponimve; Type: FK CONSTRAINT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.georef_addenda_geometriatoponimversio
    ADD CONSTRAINT georef_addenda_geome_idversio_1b15db1f_fk_toponimve FOREIGN KEY (idversio) REFERENCES public.toponimversio(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: georef_addenda_profile georef_addenda_profi_organization_id_5cbdfe9b_fk_georef_ad; Type: FK CONSTRAINT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.georef_addenda_profile
    ADD CONSTRAINT georef_addenda_profi_organization_id_5cbdfe9b_fk_georef_ad FOREIGN KEY (organization_id) REFERENCES public.georef_addenda_organization(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: georef_addenda_profile georef_addenda_profile_user_id_54bb2e4f_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: aplicacio_georef
--

ALTER TABLE ONLY public.georef_addenda_profile
    ADD CONSTRAINT georef_addenda_profile_user_id_54bb2e4f_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: toponimversio toponimversio_georeference_protoco_029104cf_fk_georef_ad; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.toponimversio
    ADD CONSTRAINT toponimversio_georeference_protoco_029104cf_fk_georef_ad FOREIGN KEY (georeference_protocol_id) REFERENCES public.georef_addenda_georeferenceprotocol(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: cartografia fkext_cartografia; Type: FK CONSTRAINT; Schema: sipan_mmedia; Owner: postgres
--

ALTER TABLE ONLY sipan_mmedia.cartografia
    ADD CONSTRAINT fkext_cartografia FOREIGN KEY (idextensio) REFERENCES sipan_mmedia.extensions(idextensio) MATCH FULL ON DELETE SET NULL;


--
-- Name: documents fkext_documents; Type: FK CONSTRAINT; Schema: sipan_mmedia; Owner: postgres
--

ALTER TABLE ONLY sipan_mmedia.documents
    ADD CONSTRAINT fkext_documents FOREIGN KEY (idextensio) REFERENCES sipan_mmedia.extensions(idextensio) MATCH FULL ON DELETE SET NULL;


--
-- Name: imatges fkext_imatges; Type: FK CONSTRAINT; Schema: sipan_mmedia; Owner: postgres
--

ALTER TABLE ONLY sipan_mmedia.imatges
    ADD CONSTRAINT fkext_imatges FOREIGN KEY (idextensio) REFERENCES sipan_mmedia.extensions(idextensio) MATCH FULL ON DELETE SET NULL;


--
-- Name: tecnicsorganitzacio fk_orgs_tecnicsorg; Type: FK CONSTRAINT; Schema: sipan_msipan; Owner: postgres
--

ALTER TABLE ONLY sipan_msipan.tecnicsorganitzacio
    ADD CONSTRAINT fk_orgs_tecnicsorg FOREIGN KEY (idorganitzacio) REFERENCES sipan_msipan.organitzacions(idorganitzacio) MATCH FULL ON DELETE CASCADE;


--
-- Name: tecnicsorganitzacio fk_tecnics_tecnicsorg; Type: FK CONSTRAINT; Schema: sipan_msipan; Owner: postgres
--

ALTER TABLE ONLY sipan_msipan.tecnicsorganitzacio
    ADD CONSTRAINT fk_tecnics_tecnicsorg FOREIGN KEY (idtecnic) REFERENCES sipan_msipan.tecnics(idtecnic) MATCH FULL ON DELETE CASCADE;


--
-- Name: autors fkautorpersona; Type: FK CONSTRAINT; Schema: sipan_msipan; Owner: postgres
--

ALTER TABLE ONLY sipan_msipan.autors
    ADD CONSTRAINT fkautorpersona FOREIGN KEY (id) REFERENCES sipan_msipan.persona(id) MATCH FULL ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;


--
-- Name: configuracio fkconfiguracio_org; Type: FK CONSTRAINT; Schema: sipan_msipan; Owner: postgres
--

ALTER TABLE ONLY sipan_msipan.configuracio
    ADD CONSTRAINT fkconfiguracio_org FOREIGN KEY (idorganitzacio) REFERENCES sipan_msipan.organitzacions(idorganitzacio) MATCH FULL;


--
-- Name: georeferenciadors fkgeoreferenciadorpersona; Type: FK CONSTRAINT; Schema: sipan_msipan; Owner: postgres
--

ALTER TABLE ONLY sipan_msipan.georeferenciadors
    ADD CONSTRAINT fkgeoreferenciadorpersona FOREIGN KEY (id) REFERENCES sipan_msipan.personafisica(id) MATCH FULL ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;


--
-- Name: objectessipan fkobjectessipanusuaris; Type: FK CONSTRAINT; Schema: sipan_msipan; Owner: postgres
--

ALTER TABLE ONLY sipan_msipan.objectessipan
    ADD CONSTRAINT fkobjectessipanusuaris FOREIGN KEY (idusuari) REFERENCES public.usuaris(idusuari);


--
-- Name: organigramesorganitzacions fkorganitzacions_organigrames; Type: FK CONSTRAINT; Schema: sipan_msipan; Owner: postgres
--

ALTER TABLE ONLY sipan_msipan.organigramesorganitzacions
    ADD CONSTRAINT fkorganitzacions_organigrames FOREIGN KEY (idorganitzacio) REFERENCES sipan_msipan.organitzacions(idorganitzacio) MATCH FULL ON DELETE CASCADE;


--
-- Name: personafisica fkpersonafisica; Type: FK CONSTRAINT; Schema: sipan_msipan; Owner: postgres
--

ALTER TABLE ONLY sipan_msipan.personafisica
    ADD CONSTRAINT fkpersonafisica FOREIGN KEY (id) REFERENCES sipan_msipan.persona(id) MATCH FULL ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;


--
-- Name: personajuridica fkpersonajuridica; Type: FK CONSTRAINT; Schema: sipan_msipan; Owner: postgres
--

ALTER TABLE ONLY sipan_msipan.personajuridica
    ADD CONSTRAINT fkpersonajuridica FOREIGN KEY (id) REFERENCES sipan_msipan.persona(id) MATCH FULL ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;


--
-- Name: personajuridica fkpersonajuridicato; Type: FK CONSTRAINT; Schema: sipan_msipan; Owner: postgres
--

ALTER TABLE ONLY sipan_msipan.personajuridica
    ADD CONSTRAINT fkpersonajuridicato FOREIGN KEY (idtipusorganisme) REFERENCES sipan_msipan.tipusorganisme(id) MATCH FULL ON DELETE SET NULL;


--
-- Name: tecnics fktecnics_rangs; Type: FK CONSTRAINT; Schema: sipan_msipan; Owner: postgres
--

ALTER TABLE ONLY sipan_msipan.tecnics
    ADD CONSTRAINT fktecnics_rangs FOREIGN KEY (idrang) REFERENCES sipan_msipan.rangs(idrang) MATCH FULL ON DELETE CASCADE;


--
-- Name: tipusobjectes fktipusobjectes_modul; Type: FK CONSTRAINT; Schema: sipan_msipan; Owner: postgres
--

ALTER TABLE ONLY sipan_msipan.tipusobjectes
    ADD CONSTRAINT fktipusobjectes_modul FOREIGN KEY (idmodul) REFERENCES sipan_msipan.moduls(idmodul) MATCH FULL ON DELETE CASCADE;


--
-- Name: nomvulgartaxon fk_nomvulgartaxon_nv; Type: FK CONSTRAINT; Schema: sipan_mtaxons; Owner: postgres
--

ALTER TABLE ONLY sipan_mtaxons.nomvulgartaxon
    ADD CONSTRAINT fk_nomvulgartaxon_nv FOREIGN KEY (idnomvulgar) REFERENCES sipan_mtaxons.nomvulgar(id) MATCH FULL ON DELETE CASCADE;


--
-- Name: nomvulgartaxon fk_nomvulgartaxon_tx; Type: FK CONSTRAINT; Schema: sipan_mtaxons; Owner: postgres
--

ALTER TABLE ONLY sipan_mtaxons.nomvulgartaxon
    ADD CONSTRAINT fk_nomvulgartaxon_tx FOREIGN KEY (idtaxon) REFERENCES sipan_mtaxons.taxon(id) MATCH FULL ON DELETE CASCADE;


--
-- Name: ambitexclosrecursgeoref fkambitexclosrecursgeorefa; Type: FK CONSTRAINT; Schema: sipan_mzoologia; Owner: postgres
--

ALTER TABLE ONLY sipan_mzoologia.ambitexclosrecursgeoref
    ADD CONSTRAINT fkambitexclosrecursgeorefa FOREIGN KEY (idambitgeografic) REFERENCES sipan_mzoologia.ambitgeografic(id) ON DELETE CASCADE;


--
-- Name: ambitexclosrecursgeoref fkambitexclosrecursgeorefr; Type: FK CONSTRAINT; Schema: sipan_mzoologia; Owner: postgres
--

ALTER TABLE ONLY sipan_mzoologia.ambitexclosrecursgeoref
    ADD CONSTRAINT fkambitexclosrecursgeorefr FOREIGN KEY (idrecursgeoref) REFERENCES public.recursgeoref(id) ON DELETE CASCADE;


--
-- Name: ambitgeograficrecursgeoref fkambitgeograficrecursgeorefa; Type: FK CONSTRAINT; Schema: sipan_mzoologia; Owner: postgres
--

ALTER TABLE ONLY sipan_mzoologia.ambitgeograficrecursgeoref
    ADD CONSTRAINT fkambitgeograficrecursgeorefa FOREIGN KEY (idambitgeografic) REFERENCES sipan_mzoologia.ambitgeografic(id) ON DELETE CASCADE;


--
-- Name: autorrecursgeoref fkautorrecursgeorefr; Type: FK CONSTRAINT; Schema: sipan_mzoologia; Owner: postgres
--

ALTER TABLE ONLY sipan_mzoologia.autorrecursgeoref
    ADD CONSTRAINT fkautorrecursgeorefr FOREIGN KEY (idrecursgeoref) REFERENCES sipan_mzoologia.recursgeoref(id) MATCH FULL ON DELETE CASCADE;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT ALL ON SCHEMA public TO aplicacio_georef;


--
-- Name: SCHEMA sipan_mbibliografia; Type: ACL; Schema: -; Owner: postgres
--

GRANT ALL ON SCHEMA sipan_mbibliografia TO aplicacio_georef;


--
-- Name: SCHEMA sipan_mcartografia; Type: ACL; Schema: -; Owner: postgres
--

GRANT ALL ON SCHEMA sipan_mcartografia TO aplicacio_georef;


--
-- Name: SCHEMA sipan_mgeneral; Type: ACL; Schema: -; Owner: postgres
--

GRANT ALL ON SCHEMA sipan_mgeneral TO aplicacio_georef;


--
-- Name: SCHEMA sipan_mgeoreferenciacio; Type: ACL; Schema: -; Owner: postgres
--

GRANT ALL ON SCHEMA sipan_mgeoreferenciacio TO aplicacio_georef;


--
-- Name: SCHEMA sipan_mmedia; Type: ACL; Schema: -; Owner: postgres
--

GRANT ALL ON SCHEMA sipan_mmedia TO aplicacio_georef;


--
-- Name: SCHEMA sipan_mseguretat; Type: ACL; Schema: -; Owner: postgres
--

GRANT ALL ON SCHEMA sipan_mseguretat TO aplicacio_georef;


--
-- Name: SCHEMA sipan_msipan; Type: ACL; Schema: -; Owner: postgres
--

GRANT ALL ON SCHEMA sipan_msipan TO aplicacio_georef;


--
-- Name: SCHEMA sipan_mtaxons; Type: ACL; Schema: -; Owner: postgres
--

GRANT ALL ON SCHEMA sipan_mtaxons TO aplicacio_georef;


--
-- Name: SCHEMA sipan_mzoologia; Type: ACL; Schema: -; Owner: postgres
--

GRANT ALL ON SCHEMA sipan_mzoologia TO aplicacio_georef;


--
-- Name: TABLE ambitexclosrecursgeoref; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.ambitexclosrecursgeoref TO aplicacio_georef;


--
-- Name: TABLE ambitgeografic; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.ambitgeografic TO aplicacio_georef;


--
-- Name: TABLE ambitgeograficrecursgeoref; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.ambitgeograficrecursgeoref TO aplicacio_georef;


--
-- Name: TABLE authority; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.authority TO aplicacio_georef;


--
-- Name: TABLE autorrecursgeoref; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.autorrecursgeoref TO aplicacio_georef;


--
-- Name: TABLE basescartografiques; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.basescartografiques TO aplicacio_georef;


--
-- Name: TABLE bloquejosobjectessipan; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.bloquejosobjectessipan TO aplicacio_georef;


--
-- Name: TABLE capawms; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.capawms TO aplicacio_georef;


--
-- Name: TABLE capesrecurs; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.capesrecurs TO aplicacio_georef;


--
-- Name: TABLE cartovisual; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.cartovisual TO aplicacio_georef;


--
-- Name: TABLE comarques; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.comarques TO aplicacio_georef;


--
-- Name: TABLE comarquesprovincies; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.comarquesprovincies TO aplicacio_georef;


--
-- Name: TABLE comunitatsautonomes; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.comunitatsautonomes TO aplicacio_georef;


--
-- Name: TABLE comunitatsautonomesprovincies; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.comunitatsautonomesprovincies TO aplicacio_georef;


--
-- Name: TABLE conversio; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.conversio TO aplicacio_georef;


--
-- Name: TABLE coordenades; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.coordenades TO aplicacio_georef;


--
-- Name: TABLE coordenadeslinies; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.coordenadeslinies TO aplicacio_georef;


--
-- Name: TABLE dades_municipipuntradi; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.dades_municipipuntradi TO aplicacio_georef;


--
-- Name: TABLE datum; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.datum TO aplicacio_georef;


--
-- Name: TABLE demarcacionsterritorials; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.demarcacionsterritorials TO aplicacio_georef;


--
-- Name: TABLE detallsusuari; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.detallsusuari TO aplicacio_georef;


--
-- Name: TABLE documentsrecursos; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.documentsrecursos TO aplicacio_georef;


--
-- Name: TABLE documentsversions; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.documentsversions TO aplicacio_georef;


--
-- Name: TABLE epsg_alias; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.epsg_alias TO aplicacio_georef;


--
-- Name: TABLE epsg_area; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.epsg_area TO aplicacio_georef;


--
-- Name: TABLE epsg_change; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.epsg_change TO aplicacio_georef;


--
-- Name: TABLE epsg_coordinateaxis; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.epsg_coordinateaxis TO aplicacio_georef;


--
-- Name: TABLE epsg_coordinateaxisname; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.epsg_coordinateaxisname TO aplicacio_georef;


--
-- Name: TABLE epsg_coordinatereferencesystem; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.epsg_coordinatereferencesystem TO aplicacio_georef;


--
-- Name: TABLE epsg_coordinatesystem; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.epsg_coordinatesystem TO aplicacio_georef;


--
-- Name: TABLE epsg_coordoperation; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.epsg_coordoperation TO aplicacio_georef;


--
-- Name: TABLE epsg_coordoperationmethod; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.epsg_coordoperationmethod TO aplicacio_georef;


--
-- Name: TABLE epsg_coordoperationparam; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.epsg_coordoperationparam TO aplicacio_georef;


--
-- Name: TABLE epsg_coordoperationparamusage; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.epsg_coordoperationparamusage TO aplicacio_georef;


--
-- Name: TABLE epsg_coordoperationparamvalue; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.epsg_coordoperationparamvalue TO aplicacio_georef;


--
-- Name: TABLE epsg_coordoperationpath; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.epsg_coordoperationpath TO aplicacio_georef;


--
-- Name: TABLE epsg_datum; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.epsg_datum TO aplicacio_georef;


--
-- Name: TABLE epsg_deprecation; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.epsg_deprecation TO aplicacio_georef;


--
-- Name: TABLE epsg_ellipsoid; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.epsg_ellipsoid TO aplicacio_georef;


--
-- Name: TABLE epsg_namingsystem; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.epsg_namingsystem TO aplicacio_georef;


--
-- Name: TABLE epsg_primemeridian; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.epsg_primemeridian TO aplicacio_georef;


--
-- Name: TABLE epsg_supersession; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.epsg_supersession TO aplicacio_georef;


--
-- Name: TABLE epsg_unitofmeasure; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.epsg_unitofmeasure TO aplicacio_georef;


--
-- Name: TABLE epsg_versionhistory; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.epsg_versionhistory TO aplicacio_georef;


--
-- Name: TABLE filtrejson; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.filtrejson TO aplicacio_georef;


--
-- Name: TABLE filtres; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.filtres TO aplicacio_georef;


--
-- Name: TABLE geography_columns; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.geography_columns TO aplicacio_georef;


--
-- Name: TABLE geometria; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.geometria TO aplicacio_georef;


--
-- Name: TABLE geometriaobjectessipan; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.geometriaobjectessipan TO aplicacio_georef;


--
-- Name: TABLE geometry_columns; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.geometry_columns TO aplicacio_georef;


--
-- Name: TABLE linies; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.linies TO aplicacio_georef;


--
-- Name: TABLE liniesobjectessipan; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.liniesobjectessipan TO aplicacio_georef;


--
-- Name: TABLE liniespolilinies; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.liniespolilinies TO aplicacio_georef;


--
-- Name: TABLE logactivitatobjectessipan; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.logactivitatobjectessipan TO aplicacio_georef;


--
-- Name: TABLE marcreferencia; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.marcreferencia TO aplicacio_georef;


--
-- Name: TABLE municipis; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.municipis TO aplicacio_georef;


--
-- Name: TABLE pais; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.pais TO aplicacio_georef;


--
-- Name: TABLE paraulaclau; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.paraulaclau TO aplicacio_georef;


--
-- Name: TABLE paraulaclaurecursgeoref; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.paraulaclaurecursgeoref TO aplicacio_georef;


--
-- Name: TABLE poligons; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.poligons TO aplicacio_georef;


--
-- Name: TABLE poligonsobjectessipan; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.poligonsobjectessipan TO aplicacio_georef;


--
-- Name: TABLE poligonspolipoligons; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.poligonspolipoligons TO aplicacio_georef;


--
-- Name: TABLE polilinies; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.polilinies TO aplicacio_georef;


--
-- Name: TABLE polipoligons; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.polipoligons TO aplicacio_georef;


--
-- Name: TABLE polipunts; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.polipunts TO aplicacio_georef;


--
-- Name: TABLE prefs_visibilitat_capes; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.prefs_visibilitat_capes TO aplicacio_georef;


--
-- Name: TABLE projeccio; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.projeccio TO aplicacio_georef;


--
-- Name: TABLE provincies; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.provincies TO aplicacio_georef;


--
-- Name: TABLE punts; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.punts TO aplicacio_georef;


--
-- Name: TABLE puntsobjectessipan; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.puntsobjectessipan TO aplicacio_georef;


--
-- Name: TABLE puntspolipunts; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.puntspolipunts TO aplicacio_georef;


--
-- Name: TABLE qualificadorversio; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.qualificadorversio TO aplicacio_georef;


--
-- Name: TABLE recursgeoref; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.recursgeoref TO aplicacio_georef;


--
-- Name: TABLE recursgeoreftoponim; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.recursgeoreftoponim TO aplicacio_georef;


--
-- Name: TABLE recursosgeoreferenciacio; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.recursosgeoreferenciacio TO aplicacio_georef;


--
-- Name: TABLE recursosgeoreferenciacio_wms_bound; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.recursosgeoreferenciacio_wms_bound TO aplicacio_georef;


--
-- Name: TABLE registresrafel; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.registresrafel TO aplicacio_georef;


--
-- Name: TABLE registreusuaris; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.registreusuaris TO aplicacio_georef;


--
-- Name: TABLE rols; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.rols TO aplicacio_georef;


--
-- Name: TABLE rolsaplicaciousuari; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.rolsaplicaciousuari TO aplicacio_georef;


--
-- Name: TABLE rolsdadesusuari; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.rolsdadesusuari TO aplicacio_georef;


--
-- Name: TABLE servidorswms; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.servidorswms TO aplicacio_georef;


--
-- Name: TABLE sistemareferencia; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.sistemareferencia TO aplicacio_georef;


--
-- Name: TABLE sistemareferenciamm; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.sistemareferenciamm TO aplicacio_georef;


--
-- Name: TABLE sistemareferenciarecurs; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.sistemareferenciarecurs TO aplicacio_georef;


--
-- Name: TABLE sistemesreferencia; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.sistemesreferencia TO aplicacio_georef;


--
-- Name: TABLE spatial_ref_sys; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.spatial_ref_sys TO aplicacio_georef;


--
-- Name: TABLE suport; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.suport TO aplicacio_georef;


--
-- Name: TABLE tipusatributs; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.tipusatributs TO aplicacio_georef;


--
-- Name: TABLE tipusclassificaciosol; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.tipusclassificaciosol TO aplicacio_georef;


--
-- Name: TABLE tipusrecursgeoref; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.tipusrecursgeoref TO aplicacio_georef;


--
-- Name: TABLE tipustoponim; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.tipustoponim TO aplicacio_georef;


--
-- Name: TABLE tipusunitats; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.tipusunitats TO aplicacio_georef;


--
-- Name: TABLE toponim; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.toponim TO aplicacio_georef;


--
-- Name: TABLE toponimversio; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.toponimversio TO aplicacio_georef;


--
-- Name: TABLE toponimsbasatsenrecurs; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.toponimsbasatsenrecurs TO aplicacio_georef;


--
-- Name: TABLE toponimsdarreraversio; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.toponimsdarreraversio TO aplicacio_georef;


--
-- Name: TABLE toponimsdarreraversio_nocalc; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.toponimsdarreraversio_nocalc TO aplicacio_georef;


--
-- Name: TABLE toponimsdarreraversio_radi; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.toponimsdarreraversio_radi TO aplicacio_georef;


--
-- Name: TABLE toponimsdarreraversiocentroide; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.toponimsdarreraversiocentroide TO aplicacio_georef;


--
-- Name: TABLE toponimsdarreraversiocentroide_nocalc; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.toponimsdarreraversiocentroide_nocalc TO aplicacio_georef;


--
-- Name: TABLE toponimsexclosos; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.toponimsexclosos TO aplicacio_georef;


--
-- Name: TABLE toponimsversiorecurs; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.toponimsversiorecurs TO aplicacio_georef;


--
-- Name: TABLE toponimversio_backup; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.toponimversio_backup TO aplicacio_georef;


--
-- Name: TABLE usuariauthority; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.usuariauthority TO aplicacio_georef;


--
-- Name: TABLE usuaripermisediciotoponimauth; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.usuaripermisediciotoponimauth TO aplicacio_georef;


--
-- Name: TABLE usuaris; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.usuaris TO aplicacio_georef;


--
-- Name: TABLE versions; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.versions TO aplicacio_georef;


--
-- Name: TABLE cartografia; Type: ACL; Schema: sipan_mmedia; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE sipan_mmedia.cartografia TO aplicacio_georef;


--
-- Name: TABLE documents; Type: ACL; Schema: sipan_mmedia; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE sipan_mmedia.documents TO aplicacio_georef;


--
-- Name: TABLE extensions; Type: ACL; Schema: sipan_mmedia; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE sipan_mmedia.extensions TO aplicacio_georef;


--
-- Name: TABLE imatges; Type: ACL; Schema: sipan_mmedia; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE sipan_mmedia.imatges TO aplicacio_georef;


--
-- Name: TABLE autors; Type: ACL; Schema: sipan_msipan; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE sipan_msipan.autors TO aplicacio_georef;


--
-- Name: TABLE configuracio; Type: ACL; Schema: sipan_msipan; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE sipan_msipan.configuracio TO aplicacio_georef;


--
-- Name: TABLE georeferenciadors; Type: ACL; Schema: sipan_msipan; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE sipan_msipan.georeferenciadors TO aplicacio_georef;


--
-- Name: TABLE moduls; Type: ACL; Schema: sipan_msipan; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE sipan_msipan.moduls TO aplicacio_georef;


--
-- Name: TABLE objectessipan; Type: ACL; Schema: sipan_msipan; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE sipan_msipan.objectessipan TO aplicacio_georef;


--
-- Name: TABLE organigramesorganitzacions; Type: ACL; Schema: sipan_msipan; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE sipan_msipan.organigramesorganitzacions TO aplicacio_georef;


--
-- Name: TABLE organitzacions; Type: ACL; Schema: sipan_msipan; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE sipan_msipan.organitzacions TO aplicacio_georef;


--
-- Name: TABLE persona; Type: ACL; Schema: sipan_msipan; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE sipan_msipan.persona TO aplicacio_georef;


--
-- Name: TABLE personafisica; Type: ACL; Schema: sipan_msipan; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE sipan_msipan.personafisica TO aplicacio_georef;


--
-- Name: TABLE personajuridica; Type: ACL; Schema: sipan_msipan; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE sipan_msipan.personajuridica TO aplicacio_georef;


--
-- Name: TABLE rangs; Type: ACL; Schema: sipan_msipan; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE sipan_msipan.rangs TO aplicacio_georef;


--
-- Name: TABLE tecnics; Type: ACL; Schema: sipan_msipan; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE sipan_msipan.tecnics TO aplicacio_georef;


--
-- Name: TABLE tecnicsorganitzacio; Type: ACL; Schema: sipan_msipan; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE sipan_msipan.tecnicsorganitzacio TO aplicacio_georef;


--
-- Name: TABLE tipusobjectes; Type: ACL; Schema: sipan_msipan; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE sipan_msipan.tipusobjectes TO aplicacio_georef;


--
-- Name: TABLE tipusorganisme; Type: ACL; Schema: sipan_msipan; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE sipan_msipan.tipusorganisme TO aplicacio_georef;


--
-- Name: TABLE unitat; Type: ACL; Schema: sipan_msipan; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE sipan_msipan.unitat TO aplicacio_georef;


--
-- Name: TABLE nomvulgar; Type: ACL; Schema: sipan_mtaxons; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE sipan_mtaxons.nomvulgar TO aplicacio_georef;


--
-- Name: TABLE nomvulgartaxon; Type: ACL; Schema: sipan_mtaxons; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE sipan_mtaxons.nomvulgartaxon TO aplicacio_georef;


--
-- Name: TABLE taxon; Type: ACL; Schema: sipan_mtaxons; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE sipan_mtaxons.taxon TO aplicacio_georef;


--
-- Name: TABLE ambitexclosrecursgeoref; Type: ACL; Schema: sipan_mzoologia; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE sipan_mzoologia.ambitexclosrecursgeoref TO aplicacio_georef;


--
-- Name: TABLE ambitgeografic; Type: ACL; Schema: sipan_mzoologia; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE sipan_mzoologia.ambitgeografic TO aplicacio_georef;


--
-- Name: TABLE ambitgeograficrecursgeoref; Type: ACL; Schema: sipan_mzoologia; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE sipan_mzoologia.ambitgeograficrecursgeoref TO aplicacio_georef;


--
-- Name: TABLE autorrecursgeoref; Type: ACL; Schema: sipan_mzoologia; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE sipan_mzoologia.autorrecursgeoref TO aplicacio_georef;


--
-- Name: TABLE conversio; Type: ACL; Schema: sipan_mzoologia; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE sipan_mzoologia.conversio TO aplicacio_georef;


--
-- Name: TABLE recursgeoref; Type: ACL; Schema: sipan_mzoologia; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE sipan_mzoologia.recursgeoref TO aplicacio_georef;


--
-- PostgreSQL database dump complete
--

