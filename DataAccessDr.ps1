$csb = [System.Data.Odbc.OdbcConnectionStringBuilder]::new() 
$csb.Driver = 'Microsoft Access Driver (*.mdb)' 
$csb.Add('dbq','D:\School\Sem8\Advanced Scripting\psfiles\psfiles\data\gems.mdb') 
$con = [System.Data.Odbc.OdbcConnection]::new($csb.ConnectionString) 
$cmd = [System.Data.Odbc.OdbcCommand]::new('select * from gem', $con) 
$con.Open() 
$reader = $cmd.ExecuteReader() 
while ($reader.Read()) { 
    Write-host $reader['Mineral'] $reader['hardness'] 
} 
$reader.Close() 
$con.Close() 