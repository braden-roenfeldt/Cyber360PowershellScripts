$csb=[System.Data.Odbc.OdbcConnectionStringBuilder]::new()
$csb.Driver= 'Microsoft Access Driver (*.mdb)'
$csb.add('dbq','D:\School\Sem8\Advanced Scripting\psfiles\psfiles\data\gems.mdb')
$da=[System.Data.Odbc.OdbcDataAdapter]::new('select * from gem',$csb.ConnectionString)
$ds=[System.Data.DataSet]::new($da)
$da.fill($ds)
$ds.Tables[0]|ft