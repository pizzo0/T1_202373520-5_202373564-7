CREATE OR REPLACE FUNCTION crear_usuario(
	p_rut VARCHAR(12),
	p_nombre VARCHAR(255),
	p_email VARCHAR(255),
	p_nombre_topico TEXT[]
) RETURNS VOID AS $$
DECLARE
	v_id_topico INT;
	v_topico VARCHAR(100);
BEGIN
	-- se verifica el formato del rut
	IF p_rut !~ '^\d{1,2}\.\d{3}\.\d{3}-[\dK]$' THEN
        RAISE EXCEPTION 'rut % no esta bien escrito (mal formato)', p_rut;
    END IF;

	-- se inserta el usuario
	INSERT INTO Usuarios(rut,nombre,email)
	VALUES (p_rut,p_nombre,p_email)
	ON CONFLICT (rut) DO NOTHING;

	FOREACH v_topico IN ARRAY p_nombre_topicos LOOP
		-- obtenemos la id del topico
		SELECT id INTO v_id_topico FROM Topicos WHERE nombre = p_nombre_topico;
		-- si el topico no existe se levanta una excepcion
		IF v_id_topico IS NULL THEN
			RAISE EXCEPTION 'Topico % no existe!', p_nombre_topico;
		END IF;
	
		-- finalmente se inserta la especialidad/topico
		INSERT INTO Usuarios_Especialidades(rut_usuario, id_topico)
		VALUES (p_rut, v_id_topico)
		ON CONFLICT DO NOTHING;
	END LOOP;
END;
$$ LANGUAGE plpgsql;