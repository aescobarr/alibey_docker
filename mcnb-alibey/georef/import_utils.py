from georef.models import Toponim

class NumberOfColumnsException(Exception):
    pass


class EmptyFileException(Exception):
    pass


def toponim_exists(line):
    try:
        return Toponim.objects.get(linia_fitxer_importacio=line)
    except Toponim.DoesNotExist:
        return None