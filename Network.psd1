@{
    # Module Metadata
    RootModule         = 'Network.psm1'
    ModuleVersion      = '0.1'
    Author             = 'Brenner, Braden'
    CompanyName        = 'Scrappy Scripters'
    Description        = 'MAC vendor lookup and IP network testing.'

    # Functions to Export
    FunctionsToExport  = @(
        'Get-MACVendor',
        'Get-IPNetwork',
        'Test-IPNetwork'
    )

    # Optional Fields
    CmdletsToExport    = @()        # 
    VariablesToExport  = @()        # 
    AliasesToExport    = @()        # 

    # Compatibility
    PowerShellVersion  = '5.0'
}