from georef.models import Toponim
from django.db.models import Q
from django.contrib.auth.models import User

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
    name_parts = name.split(' ')
    name_fusioned = ('').join( [u.strip().lower() for u in name_parts] )
    for u in User.objects.all():
        username_parts = u.first_name.strip().lower().split(' ') + u.last_name.strip().lower().split(' ')
        username_fusioned = ('').join( username_parts )
        if name_fusioned == username_fusioned:
            return u
    return None

def is_empty_field(field_value):
    return field_value is None or field_value.strip().lower() == ''