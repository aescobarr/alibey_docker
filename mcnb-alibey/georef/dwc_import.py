from georef.import_utils import NumberOfColumnsException, EmptyFileException, toponim_exists, \
    get_model_by_attribute, get_georeferencer_by_name_simple, is_empty_field, get_toponim_nom_estructurat, find_all, \
    MissingColumnException
from georef.models import Toponim, Toponimversio, Tipustoponim, Recursgeoref
from georef_addenda.models import GeometriaToponimVersio
from dateutil import parser
from datetime import date
from django.contrib.gis.geos import GEOSGeometry
from django.db.models import Q
from georef.sec_calculation import compute_sec
import re

FIELD_MAP_DWC = {
    "locality": { "index": 0, "mandatory": True },
    "higherGeography": { "index": 1, "mandatory": True },
    "georeferenceSources": { "index": 2, "mandatory": True },
    "verbatimLongitude": { "index": 3, "mandatory": True }, 
    "verbatimLatitude": { "index": 4, "mandatory": True },
    "georeferencedDate": { "index": 5, "mandatory": False },
    "georeferencedBy": { "index": 6, "mandatory": False },
    "maximumDepthInMeters": { "index": 7, "mandatory": False },
    "minimumDepthInMeters": { "index": 8, "mandatory": False },
    "georeferenceRemarks": { "index": 9, "mandatory": False },
    "coordinateUncertaintyInMeters": { "index": 10, "mandatory": True},
    "footprintWKT": { "index": 11, "mandatory": True},
    "footprintSRS": { "index": 12, "mandatory": True }
}

def adjust_dwc_row_map(header):
    labels = header.split(';')
    for label in labels:
        try:
            FIELD_MAP_DWC[label]["index"] = labels.index(label)
        except KeyError:
            raise MissingColumnException({"msg":"Error en format de fitxer, la columna {0} no es correspon amb cap nom de columna de Darwin Core".format( label )})

def check_file_structure_dwc(file_array):
    if len(file_array) < 2:    
        raise EmptyFileException()
    numlinia = 1
    for rows in file_array:
        if len(rows) != len(FIELD_MAP_DWC):
            raise NumberOfColumnsException({"numrow": str(numlinia), "numcols": str(len(rows)), "numcols_expected": str(len(FIELD_MAP_DWC)) })
        numlinia = numlinia + 1    

def register_error(num_line, message, problems):
    lineNums = []
    try:
        lineNums = problems[message]
        lineNums.append(num_line)
        problems[message] = lineNums
    except KeyError:
        lineNums.append(num_line)
        problems[message] = lineNums

def parse_valid_name(name):
    pattern = r'^\s*(.+?)\s*-\s*([^-()]*)\s*\(\s*([^()]+?)\s*\)\s*\(\s*(Aquàtic|Terrestre)\s*\)\s*$'

    match = re.match(pattern, name)
    if not match:
        return None  # Invalid format
    name, country, site_type, environment = match.groups()
    # Strip any surrounding whitespace just in case
    return {
        "name": name.strip(),
        "country": country.strip(),  # May be empty
        "site_type": site_type.strip(),
        "environment": environment.strip()
    }    

def parse_geometry(wkt, srid):
    geom = GEOSGeometry(wkt, srid=srid)
    return geom

def process_line_dwc(line, line_string, errors, toponims_exist, toponims_to_create, line_counter, problemes, nomFitxer):
    t = toponim_exists(line_string)
    if t is None:
        # [0] - Nom toponim --> Cap comprovacio(comprovar blancs)
        site_name = ''
        # [1] - Tipus toponim --> Buscar toponim per nom TipusToponim
        tt = None
        # # [2] - Aquatic --> Cap comprovacio
        aquatic = 'N'
        # # [3] - Node superior --> Buscar toponim per nom(multiples resultats?)
        pare = None        
        # # [6] - Versio capturada del recurs RecursGeoreferenciacio
        rg = None        
        # # [11] - depth_max_height
        depth_max_height = None
        # # [12] - depth_min_height
        depth_min_height = None
        # [13] - Incertesa de coordenada
        precisioH = None
        precisioh_sec = None
        # # [13] - Incertesa h
        # #precisioZ = None
        # # [14] - Georeferenciador
        georeferenciador = None
        # # [15] - Observacions
        observacions = None
        site_geometry = None
        decimal_latitude = None
        decimal_longitude = None
        coordinate_uncertainty = None
        verbatim_longitude = None
        verbatim_latitude = None

        errorsALinia = False
        errorsLinia = []
        errorsLiniaActual = []

        if is_empty_field(line[FIELD_MAP_DWC['locality']['index']]):
            errorsALinia = True
            errorsLiniaActual.append("Nom de toponim en blanc a la columna {}".format(FIELD_MAP_DWC['locality']['index'] + 1))
            register_error(line_counter, "Nom de toponim en blanc a la columna {}", problemes)
        else:
            nom_unprocessed = line[FIELD_MAP_DWC['locality']['index']].strip()
            name_fields = parse_valid_name(nom_unprocessed)
            if name_fields is None:
                errorsALinia = True
                errorsLiniaActual.append("Nom de toponim no vàlid a la columna {} - el nom de topònim ha de seguir l'esquema: [nom] - (tipus topònim) (Terrestre|Aquàtic) ".format(FIELD_MAP_DWC['locality']['index'] + 1))
                register_error(line_counter, "Nom de toponim no vàlid a la columna {}".format(FIELD_MAP_DWC['locality']['index'] + 1), problemes)
            else:
                site_name = name_fields["name"]
                toponim_type_str = name_fields["site_type"]
                environment = name_fields["environment"]
                if environment in ['Aquàtic', 'aquatic', 'aquàtic']:
                    aquatic = 'S'
                tt = get_model_by_attribute('nom', toponim_type_str, Tipustoponim)
                if tt is None:
                    errorsALinia = True
                    errorsLiniaActual.append("No s'ha trobat el tipus de toponim '" + toponim_type_str + "' a la columna {}".format(FIELD_MAP_DWC['locality']['index'] + 1))
                    register_error(line_counter, "No s'ha trobat el tipus de toponim '" + toponim_type_str + "' a la columna {}".format(FIELD_MAP_DWC['locality']['index'] + 1), problemes)        

        if is_empty_field(line[FIELD_MAP_DWC['higherGeography']['index']]):            
            errorsALinia = True
            errorsLiniaActual.append("Geografies superiors en blanc a la columna {}".format(FIELD_MAP_DWC['higherGeography']['index'] + 1))
            register_error(line_counter, "Geografies superiors en blanc a la columna {}".format(FIELD_MAP_DWC['higherGeography']['index'] + 1), problemes)
        else:
            #check all sites in the chain exist and are hyerarchical
            clean_names = [token.strip() for token in line[FIELD_MAP_DWC['higherGeography']['index']].split("|")]
            model = None
            found = []
            not_found = []
            for name in clean_names:
                # model = get_model_by_attribute('nom', name, Toponim)
                model = get_toponim_nom_estructurat(name)
                if model is not None:
                    found.append("True")
                else:
                    found.append("False")
                    not_found.append(name)
            if all(found):
                pare = model.first()
            else:
                errorsALinia = True
                errorsLiniaActual.append("Geografies superiors no trobades a la columna {0} : {1}".format( FIELD_MAP_DWC['higherGeography']['index'] + 1, ','.join(not_found) ))
                register_error(line_counter, "Geografies superiors en blanc a la columna {0} : {1}".format( FIELD_MAP_DWC['higherGeography']['index'] + 1, ','.join(not_found) ), problemes)
                

        if is_empty_field(line[FIELD_MAP_DWC['georeferenceSources']['index']]):
            errorsALinia = True
            errorsLiniaActual.append("El recurs de georeferenciacio en que es basa el recurs està en blanc a la columna {}".format(FIELD_MAP_DWC['georeferenceSources']['index'] + 1))
            register_error(line_counter, "El recurs de georeferenciacio en que es basa el recurs està en blanc a la columna {}".format(FIELD_MAP_DWC['georeferenceSources']['index'] + 1), problemes)
        else:
            rg = get_model_by_attribute('nom', line[FIELD_MAP_DWC['georeferenceSources']['index']].strip(), Recursgeoref)
            if rg is None:
                errorsALinia = True
                errorsLiniaActual.append("No trobo el recurs de georeferenciació {0} a la columna {1}".format( line[FIELD_MAP_DWC['georeferenceSources']['index']], FIELD_MAP_DWC['georeferenceSources']['index'] + 1))
                register_error(line_counter, "No trobo el recurs de georeferenciació {0} a la columna {1}".format( line[FIELD_MAP_DWC['georeferenceSources']['index']], FIELD_MAP_DWC['georeferenceSources']['index'] + 1), problemes)
        
        verbatim_longitude = line[FIELD_MAP_DWC['verbatimLongitude']['index']]
        verbatim_latitude = line[FIELD_MAP_DWC['verbatimLatitude']['index']]

        if is_empty_field(line[FIELD_MAP_DWC['georeferencedDate']['index']]):
            data = date.today()
        else:
            try:
                #data = datetime.strptime(line[8].strip(), '%d/%m/%Y')
                data = parser.parse(line[FIELD_MAP_DWC['georeferencedDate']['index']].strip())
            except ValueError:
                errorsALinia = True
                errorsLiniaActual.append("Error convertint " + line[FIELD_MAP_DWC['georeferencedDate']['index']] + " a format data a  la columna {}".format(FIELD_MAP_DWC['georeferencedDate']['index'] + 1))
                register_error(line_counter, "Error convertint " + line[FIELD_MAP_DWC['georeferencedDate']['index']] + " a format data a  la columna {}".format(FIELD_MAP_DWC['georeferencedDate']['index'] + 1), problemes)

        
        if is_empty_field(line[FIELD_MAP_DWC['georeferencedBy']['index']]):
            errorsALinia = True
            errorsLiniaActual.append("Georeferenciador en blanc a la columna {}".format(FIELD_MAP_DWC['georeferencedBy']['index'] + 1))
            register_error(line_counter, "Georeferenciador en blanc a la columna {}".format(FIELD_MAP_DWC['georeferencedBy']['index'] + 1), problemes)
        else:
            georeferenciador = get_georeferencer_by_name_simple(line[FIELD_MAP_DWC['georeferencedBy']['index']].strip())
            if georeferenciador is None:
                errorsALinia = True
                errorsLiniaActual.append("No trobo el georeferenciador " + line[FIELD_MAP_DWC['georeferencedBy']['index']] +  ", columna {}".format(FIELD_MAP_DWC['georeferencedBy']['index'] + 1))
                register_error(line_counter, "No trobo el georeferenciador " + line[FIELD_MAP_DWC['georeferencedBy']['index']] +  ", columna {}".format(FIELD_MAP_DWC['georeferencedBy']['index'] + 1), problemes)

        # depth_max_height
        if is_empty_field(line[FIELD_MAP_DWC['maximumDepthInMeters']['index']]):
            depth_max_height = None
        else:
            try:
                float(line[FIELD_MAP_DWC['maximumDepthInMeters']['index']].strip().replace(",", "."))
                depth_max_height = line[FIELD_MAP_DWC['maximumDepthInMeters']['index']].replace(",", ".")
            except ValueError:
                errorsALinia = True
                errorsLiniaActual.append("Error de conversió a l'altitud de profunditat màxima (m) " + line[FIELD_MAP_DWC['maximumDepthInMeters']['index']] +  ", columna {}".format(FIELD_MAP_DWC['maximumDepthInMeters']['index'] + 1))
                register_error(line_counter, "Error de conversió a l'altitud de profunditat màxima (m)" + line[FIELD_MAP_DWC['maximumDepthInMeters']['index']] +  ", columna {}".format(FIELD_MAP_DWC['maximumDepthInMeters']['index'] + 1), problemes)

        # depth_min_height
        if is_empty_field(line[FIELD_MAP_DWC['minimumDepthInMeters']['index']]):
            depth_min_height = None
        else:
            try:
                float(line[FIELD_MAP_DWC['minimumDepthInMeters']['index']].strip().replace(",", "."))
                depth_min_height = line[FIELD_MAP_DWC['minimumDepthInMeters']['index']].replace(",", ".")
            except ValueError:
                errorsALinia = True
                errorsLiniaActual.append("Error de conversió a l'altitud de profunditat mínima (m) " + line[FIELD_MAP_DWC['minimumDepthInMeters']['index']] +  ", columna {}".format(FIELD_MAP_DWC['minimumDepthInMeters']['index'] + 1))
                register_error(line_counter, "Error de conversió a l'altitud de profunditat mínima (m)" + line[FIELD_MAP_DWC['minimumDepthInMeters']['index']] +  ", columna {}".format(FIELD_MAP_DWC['minimumDepthInMeters']['index'] + 1), problemes)
        
        observacions = line[FIELD_MAP_DWC['georeferenceRemarks']['index']]
    
        if not is_empty_field(line[FIELD_MAP_DWC['coordinateUncertaintyInMeters']['index']]):
            try:
                precisioH = float(line[FIELD_MAP_DWC['coordinateUncertaintyInMeters']['index']].strip().replace(",", "."))
            except ValueError:
                errorsALinia = True
                errorsLiniaActual.append("Error de conversió a incertesa de coordenades {0}, columna {1}".format( line[FIELD_MAP_DWC['coordinateUncertaintyInMeters']['index']], FIELD_MAP_DWC['coordinateUncertaintyInMeters']['index'] + 1 ))
                register_error(line_counter, "Error de conversió a incertesa de coordenades {0}, columna {1}".format( line[FIELD_MAP_DWC['coordinateUncertaintyInMeters']['index']], FIELD_MAP_DWC['coordinateUncertaintyInMeters']['index'] + 1 ) , problemes)

        if not is_empty_field(line[FIELD_MAP_DWC['footprintWKT']['index']]):
            if is_empty_field( line[FIELD_MAP_DWC['footprintSRS']['index']]):
                errorsALinia = True
                errorsLiniaActual.append("Hi ha una geometria, però no hi ha sistema de referència definit columna {}".format(FIELD_MAP_DWC['footprintSRS']['index'] + 1))
                register_error(line_counter, "Hi ha una geometria, però no hi ha sistema de referència definit a la columna {}".format(FIELD_MAP_DWC['footprintSRS']['index'] + 1), problemes)
            else:
                srid_text = line[FIELD_MAP_DWC['footprintSRS']['index']]
                srid = srid_text.split(":")[1]
                try:
                    geometria = parse_geometry( line[FIELD_MAP_DWC['footprintWKT']['index']], srid=srid )
                    sec = compute_sec(geometria,max_points_polygon=10000, tolerance=500, sample_size=50, n_nearest=10)
                    decimal_longitude = sec['center_wgs84'].x
                    decimal_latitude = sec['center_wgs84'].y                    
                    precisioh_sec = sec['radius']


                except ValueError:
                    errorsALinia = True
                    errorsLiniaActual.append("Error creant geometria a partir de text, si us plau repassa que no hi hagi errors al WKT, columna {}".format( FIELD_MAP_DWC['footprintWKT']['index'] + 1 ))
                    register_error(line_counter, "Error creant geometria a partir de text, si us plau repassa que no hi hagi errors al WKT, columna {}".format( FIELD_MAP_DWC['footprintWKT']['index'] + 1 ), problemes)
                
        if geometria is not None and geometria.geom_type == 'Point':
            if is_empty_field(line[FIELD_MAP_DWC['coordinateUncertaintyInMeters']['index']]):
                errorsALinia = True
                errorsLiniaActual.append("Incertesa de coordenades en blanc no permesa per geometria de tipus punt, columna {0}".format( FIELD_MAP_DWC['coordinateUncertaintyInMeters']['index'] + 1 ))
                register_error(line_counter, "Incertesa de coordenades en blanc no permesa per geometria de tipus punt, columna {0}".format( FIELD_MAP_DWC['coordinateUncertaintyInMeters']['index'] + 1 ) , problemes)

        if errorsALinia:
            errorsLinia.insert(0, line_counter)
            errorsLinia.append(errorsLiniaActual)
            errors.append(errorsLinia)
        else:
            t = Toponim()
            t.nom = site_name
            t.idtipustoponim = tt
            t.aquatic = aquatic
            t.idpare = pare

            t.nom_fitxer_importacio = nomFitxer
            t.linia_fitxer_importacio = line_string

            tv = Toponimversio()

            tv.numero_versio = 1
            tv.nom = site_name
            tv.datacaptura = data
            
            tv.coordenada_x_origen = verbatim_longitude
            tv.coordenada_y_origen = verbatim_latitude
            tv.altitud_profunditat_maxima = depth_max_height
            tv.altitud_profunditat_minima = depth_min_height
            tv.observacions = observacions

            tv.iduser = georeferenciador            
            tv.precisio_h = precisioH
            if geometria is not None and geometria.geom_type != 'Point':
                tv.precisio_h = precisioh_sec

            tv.idrecursgeoref = rg
            # tv.idtoponim = t    
            #             
            gtv = GeometriaToponimVersio()        
            gtv.geometria = geometria


            toponims_to_create.append({ 'toponim': t, 'versio': tv, 'geometria': gtv })
    else:
        toponims_exist.append(t)
