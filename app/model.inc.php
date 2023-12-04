<?php

  //Abrir conexion a la base de datos
  function connect($db)
  {
    $oracleDsn = "(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST={$oracleDbHost})(PORT={$oracleDbPort}))(CONNECT_DATA=(SERVICE_NAME={$oracleDbServiceName})))";
    $conn = oci_connect($oracleDbUsername, $oracleDbPassword, $oracleDsn);
    return $conn;
  }


 //Obtener parametros para updates
 function getParams($input)
 {
    $filterParams = [];
    foreach($input as $param => $value)
    {
            $filterParams[] = "$param=:$param";
    }
    return implode(", ", $filterParams);
	}

  //Asociar todos los parametros a un sql
	function bindAllValues($statement, $params)
  {
		foreach($params as $param => $value)
    {
				$statement->bindValue(':'.$param, $value);
		}
		return $statement;
   }
 ?>