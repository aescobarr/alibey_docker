function initdb(db){
    db.schema.createTable('tipustoponim', table => {
        table.string('id');
        table.string('nom');
    });

    // db('tipustoponim').insert({ id: '1', nom: 'first' });

    db.schema.createTable('toponims_api', table => {
        table.string('id');
        table.string('nomtoponim');
        table.string('nom');
        table.boolean('aquatic');
        table.string('tipus');
        table.string('idtipus');
        table.date('datacaptura');
        table.float('coordenadaxcentroide');
	    table.float('coordenadaycentroide');
	    table.float('incertesa');
    });
}

module.exports = {
  initdb: initdb
}