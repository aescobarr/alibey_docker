var refreshDigitizedGeometry = function(){
    var geometry = djangoRef.Map.editableLayers.toGeoJSON();
    var json_string = JSON.stringify(geometry);
    $('#geometria').val( json_string );
};

var get_capawms_ids = function(){
    var retVal = new Array();
    $('.hidden-capawms-id-value').each(function(index,value){
        retVal.push($(this).text());
    });
    return retVal;
};

var capawms_li_element_template = '<li class="tagit-choice ui-widget-content ui-state-default ui-corner-all tagit-choice-editable"><span class="tagit-label">###label</span><span class="hidden-capawms-id-value">###id</span><a class="tagit-close close-capawms"><span class="text-icon">x</span><span class="ui-icon ui-icon-close"></span></a></li>';

$(document).ready(function() {

    var connectwms = function(url){
        $('#wms_connect').prop('disabled', true);
        $('#wms_connect').addClass("asyncload");
        $.ajax({
            url: _wms_metadata_url,
            data: 'url=' + encodeURI(url),
            method: 'GET',
            beforeSend: function(xhr, settings) {
                if (!csrfSafeMethod(settings.type)) {
                    var csrftoken = getCookie('csrftoken');
                    xhr.setRequestHeader('X-CSRFToken', csrftoken);
                }
            },
            success: function( data, textStatus, jqXHR ) {
                $('#layersWms').empty();
                resultat = data.detail;
                for(var i = 0; i < resultat.length; i++){
                    $('#layersWms').append('<option data-id='+resultat[i].id+' data-xmin='+resultat[i].minx+' data-xmax='+resultat[i].maxx+' data-ymin='+resultat[i].miny+' data-ymax='+resultat[i].maxy+' value='+resultat[i].name+'>' + resultat[i].title + '</option>');
                }
                $('#wms_connect').prop('disabled', false);
                $('#wms_connect').removeClass("asyncload");
            },
            error: function(jqXHR, textStatus, errorThrown){
                toastr.error('Error connectant a servei wms:' + jqXHR.responseJSON.detail);
                $('#wms_connect').prop('disabled', false);
                $('#wms_connect').removeClass("asyncload");
            }
        });
    }

    var uploadFile = function () {
        let fileInput = $('#fileInput')[0];

        if (fileInput.files.length === 0) {
            alert("Please select a file.");
            return;
        }

        let file = fileInput.files[0];
        let formData = new FormData();
        formData.append("file", file);        

        $.ajax({
            url: _ajax_upload_url,  // Make sure this variable is defined
            type: "POST",
            data: formData,
            processData: false,  // Prevent jQuery from processing the data
            contentType: false,  // Prevent jQuery from setting content type
            beforeSend: function(xhr, settings) {
                if (!csrfSafeMethod(settings.type)) {
                    var csrftoken = getCookie('csrftoken');
                    xhr.setRequestHeader('X-CSRFToken', csrftoken);
                }
            },            
            xhr: function () {
                let xhr = new window.XMLHttpRequest();
                xhr.upload.addEventListener("progress", function (event) {
                    if (event.lengthComputable) {
                        let percent = (event.loaded / event.total) * 100;
                        $("#progress-bar").css("width", percent + "%").text(Math.round(percent) + "%");
                        $("#progress-container").show();
                    }
                }, false);
                return xhr;
            },
            success: function (response) {
                if (response.success) {
                    $("#message").html(`<p>File uploaded successfully: <a href="${response.file_url}" target="_blank">${response.file_url}</a></p>`);
                    let path = response.file_path;
                    importa_shapefile(path);
                } else {
                    $("#message").html("<p>Upload failed!</p>");
                }
            },
            error: function () {
                $("#message").html("<p>An error occurred while uploading.</p>");
            }
        });
    };

    var importa_shapefile = function(filepath){
        $.ajax({
            url: _import_shapefile_url,
            data: 'path=' + encodeURI(filepath),
            method: 'GET',
            beforeSend: function(xhr, settings) {
                if (!csrfSafeMethod(settings.type)) {
                    var csrftoken = getCookie('csrftoken');
                    xhr.setRequestHeader('X-CSRFToken', csrftoken);
                }
            },
            success: function( data, textStatus, jqXHR ) {
                djangoRef_map.editableLayers.clearLayers();
                var geoJson = JSON.parse(data.detail);
                var geoJSONLayer = L.geoJson(geoJson);
                geoJSONLayer.eachLayer(
                    function(l){
                        djangoRef_map.editableLayers.addLayer(l);
                    }
                );
                refreshDigitizedGeometry();
                djangoRef_map.editableLayers.bringToFront();
                if(djangoRef_map.editableLayers.getBounds().isValid()){
                    djangoRef_map.map.fitBounds(djangoRef_map.editableLayers.getBounds());
                }
                toastr.success('Importació amb èxit!');
            },
            error: function(jqXHR, textStatus, errorThrown){
                toastr.error('Error important fitxer:' + jqXHR.responseJSON.detail);
            }
        });
    };    

    var toponims_b_recurs =  {
        name: 'toponims_b_recurs',
        layer : L.tileLayer.wms(
            wms_url,
            {
                layers: 'mzoologia:toponimsbasatsenrecurs',
                format: 'image/png',
                transparent: true,
                CQL_FILTER: 'TRUE=TRUE'
            }
        )
    };

    var overlay_list = [];
    overlay_list.push(toponims_b_recurs);

    var overlays_control_config = [
        {
            groupName: 'Toponims',
            expanded: true,
            layers: {
                'Topònims basats en recurs': toponims_b_recurs.layer
            }
        }
    ];

    map_options = {
        editable:true,
        show_centroid_after_edit: false,
        show_coordinates: false,
        overlays: overlay_list,
        overlays_control_config: overlays_control_config,
        wms_url: wms_url
    };

    map_options.state = {
        overlays: [toponims_b_recurs.name],
        base: 'djangoRef.Map.roads',
        view:{ center:new L.LatLng(40.58, -3.25),zoom:2}
    };

    djangoRef_map = new djangoRef.Map.createMap(map_options);

    djangoRef_map.map.on(L.Draw.Event.CREATED, function (e) {
        refreshDigitizedGeometry();
    });

    djangoRef_map.map.on(L.Draw.Event.EDITED, function (e) {
        refreshDigitizedGeometry();
    });

    djangoRef_map.map.on(L.Draw.Event.DELETED, function (e) {
        refreshDigitizedGeometry();
    });

    /*var geoJSONLayer = L.geoJson(geometries_json);
    geoJSONLayer.eachLayer(
        function(l){
            djangoRef_map.editableLayers.addLayer(l);
        }
    );

    refreshDigitizedGeometry();
    djangoRef_map.editableLayers.bringToFront();
    if(djangoRef_map.editableLayers.getBounds().isValid()){
        djangoRef_map.map.fitBounds(djangoRef_map.editableLayers.getBounds());
    }*/

    $('#wms_connect').click(function(){
        var url = $('#id_base_url_wms').val();
        connectwms(url);
    });

    $('#wms_add').click(function(){
        var selected = $('#layersWms').find(":selected");
        var id = selected.attr('data-id');
        var ids = get_capawms_ids();
        if(ids.indexOf(id) == -1){
            var new_template = capawms_li_element_template.replace('###label',selected.text());
            new_template = new_template.replace('###id',id);
            $('#taulacapes').append(new_template);
        }
        $('#capeswms').val(get_capawms_ids());
    });

    $(document).on('click','a.close-capawms',function(){
        var a = $(this);
        var li = a.parent();
        var ul = li.parent();
        li.remove();
        $('#capeswms').val(get_capawms_ids());
    });

    var url = $('#id_base_url_wms').val();
    if(url != '' && url != null){
        connectwms(url);
    }

    $('#fileInput').on('change',function(e){
        uploadFile();        
    });

});