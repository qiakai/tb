
{ if ($0 != "") jiparse_after_tokenize(o, $0); }
END{
    Q2_1 = SUBSEP "\"1\""
    obj[ L ] = 1
    obj[ Q2_1 ] = "["

    l = o[ Q2_1 L ]
    for (i=1; i<=l; ++i){
        kp = Q2_1 SUBSEP "\""i"\""
        tasks_l = o[ kp, "\"tasks\"" L ]
        if ( tasks_l <= 10 ) {
            jlist_put(obj, Q2_1, "{" )
            jmerge_force___value(obj, Q2_1 SUBSEP "\""obj[ Q2_1 L] "\"", o, kp)
            continue
        }

        name = o[ kp, "\"name\"" ]
        version = o[ kp, "\"version\"" ]
        description = o[ kp, "\"description\"" ]
        for (j=1; j<=tasks_l; ++j){
            if ( (j % 10) == 1 ) {
                first_id = j
                jlist_put(obj, Q2_1, "{" )
                obj_id = obj[ Q2_1 L]
                obj_kp = Q2_1 SUBSEP "\""obj_id"\""
                jdict_put(obj, obj_kp, "\"name\"", name)
                jdict_put(obj, obj_kp, "\"version\"", version)
                jdict_put(obj, obj_kp, "\"description\"", description)
                jdict_put(obj, obj_kp, "\"tasks\"", "[")
            }

            jlist_put(obj, obj_kp SUBSEP "\"tasks\"", "{")
            jmerge_force___value(obj, obj_kp SUBSEP "\"tasks\"" SUBSEP "\""obj[ obj_kp, "\"tasks\"" L ]"\"", o, kp SUBSEP "\"tasks\"" SUBSEP "\""j"\"")
            if ( (j % 10) == 0 || j == tasks_l ) {
                obj[ obj_kp, "\"name\"" ] = jqu( juq(name) "-" first_id "-" j )
            }
        }
    }

    print jstr(obj)
}