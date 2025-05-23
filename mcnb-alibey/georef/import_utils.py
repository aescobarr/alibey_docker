from georef.models import Toponim, Pais, Tipustoponim
from django.db.models import Q
from django.contrib.auth.models import User
import operator, functools

class NumberOfColumnsException(Exception):
    pass


class EmptyFileException(Exception):
    pass


def get_model_by_attribute(attribute_name, attribute_value, model_name):
    try:
        filter_clause = Q(**{ attribute_name + '__iexact' : attribute_value } )
        return model_name.objects.get(filter_clause)
    except model_name.DoesNotExist:
        return None


def toponim_exists(line):
    try:
        return Toponim.objects.get(linia_fitxer_importacio=line)
    except Toponim.DoesNotExist:
        return None
    
def get_georeferencer_by_name_simple(name):
    name_parts = name.split(', ')
    name_fusioned = ('').join( [u.strip().lower() for u in name_parts] )
    for u in User.objects.all():
        username_parts = u.last_name.strip().lower().split(' ') + u.first_name.strip().lower().split(' ')
        username_fusioned = ('').join( username_parts )
        if name_fusioned == username_fusioned:
            return u
    return None

def is_empty_field(field_value):
    return field_value is None or field_value.strip().lower() == ''

def find_all(a_str, sub):
    start = 0
    while True:
        start = a_str.find(sub, start)
        if start == -1: return
        yield start
        start += len(sub) # use start += 1 to find overlapping matches


def get_toponim_nom_estructurat(nom_toponim):
    if nom_toponim != '':
        if 'terrestre' in nom_toponim.lower() or 'aquàtic' in nom_toponim.lower():
            filter_clause = []
            sep_character_apparitions = [i for i in find_all(nom_toponim,'-')]
            if len(sep_character_apparitions) > 1:
                last_index_sep = sep_character_apparitions[-1]
                nom_info_addicional = []
                nom_info_addicional.append(nom_toponim[:last_index_sep].strip())
                nom_info_addicional.append(nom_toponim[(last_index_sep + 1):].strip())
            else:
                nom_info_addicional = nom_toponim.split('-')
            nom = nom_info_addicional[0].strip()
            info_addicional = nom_info_addicional[1].strip().split('(')
            pais = info_addicional[0].strip().lower()
            tipusToponim = info_addicional[1].replace(")", "").strip().lower()
            aquatic = info_addicional[2].replace(")", "").strip().lower() != 'terrestre'
            aquatic_string = ''
            if aquatic == True:
                aquatic_string = 'S'
            else:
                aquatic_string = 'N'
            p = get_model_by_attribute('nom', pais, Pais)
            tt = get_model_by_attribute('nom', tipusToponim, Tipustoponim)
            if p is not None:
                filter_clause.append( Q(**{ 'idpais' : p } ) )
            if tt is not None:
                filter_clause.append(Q(**{ 'idtipustoponim' : tt } ) )
            filter_clause.append(Q(**{ 'aquatic' : aquatic_string } ) )
            filter_clause.append(Q(**{'nom': nom}))
            return Toponim.objects.filter(functools.reduce(operator.and_, filter_clause))
        else:
            return Toponim.objects.filter(nom__icontains=nom_toponim)
    return None