component displayname="Base bean" accessorts="true" {
    
    public any function init() {
        var metaData = getMetaData( this );
        var properties = [];
        var i = 0;
        var key = '';
        var setvalue = '';
        
        if ( structKeyExists( metaData, 'properties' ) ) {
            properties = metaData.properties;
        }
        
        for ( i = 1; i <= arrayLen( properties ); i++ ) {
            property = properties[ i ].name;
            propertyType = '';
            
            if ( structKeyExists( properties[ i ], 'type' ) ) {
                propertyType = properties[ i ].type;
            }
            
            if ( isDefined('this.set#property#') ) {
                if ( structKeyExists( arguments, property ) ) {
                    setvalue = arguments[ property ];
                } else if ( structKeyExists( properties[ i ], 'default' ) ) {
                    setvalue = properties[ i ]['default'];
                } else {
                    switch( propertyType ) {
                        case 'numeric':
                            setvalue = 0;
                            break;
                        case 'boolean':
                            setvalue = false;
                            break;
                        case 'array':
                            setvalue = arrayNew( 1 );
                            break;
                        case 'struct':
                            setvalue = structNew();
                            break;
                        case 'query':
                            setvalue = queryNew('');
                            break;
                        case 'string':
                            setvalue = '';
                            break;
                        default:
                            setvalue = createObject( 'component', propertyType ).init();
                    }
                }
                evaluate('this.set#property#( setvalue )');
            }
        }
        
        return this;
    }
    
    private void function convertJSONToSelf( required string dataInJSON ) {
        convertStructToSelf( deserializeJSON( dataInJSON ) );
    }
    
    private void function convertStructToSelf( required struct dataInStruct ) {
        var dataKeys = listToArray( structKeyList( dataInStruct ) );
        var properties = getMetaData( this ).properties;
        var i = 0;
        var key = '';
        
        for ( i = 1; i <= arrayLen( dataKeys ); i++ ) {
            key = dataKeys[ i ];
            if ( isDefined('this.set#key#') ) {
                evaluate('this.set#key#( dataInStruct[ key ] )');
            }
        }
    }
    
    private void function convertQueryToSelf( required query dataInQuery ) {
        var dataKeys = listToArray( dataInQuery.columnList );
        var properties = getMetaData( this ).properties;
        var i = 0;
        var key = '';
        
        for ( i = 1; i <= arrayLen( dataKeys ); i++ ) {
            key = dataKeys[ i ];
            if ( isDefined('this.set#key#') ) {
                evaluate('this.set#key#( dataInQuery[ key ][ 1 ] )');
            }
        }
    }
    
    public string function show( required string property, string wrapBefore='', string wrapAfter='' ) {
        var ret = '';
        
        if ( structKeyExists( variables, property ) ) {
            ret = variables[ property ];
            
            if ( isNumeric( ret ) ) {
                if ( val( ret ) ) {
                    ret = wrapBefore & ret & wrapAfter;
                } else {
                    ret = '';
                }
            } else if ( isBoolean( ret ) ) {
                if ( ret ) {
                    ret = wrapBefore & yesNoFormat( ret ) & wrapAfter;
                } else {
                    ret = '';
                }
            } else if ( len( ret ) ) {
                ret = wrapBefore & ret & wrapAfter;
            } else {
                ret = '';
            }
        }
        
        return ret;
    }
    
}