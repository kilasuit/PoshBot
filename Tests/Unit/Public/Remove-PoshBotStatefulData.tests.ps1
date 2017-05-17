﻿
InModuleScope PoshBot {
    describe 'Remove-PoshBotStatefulData' {
        # Define internal variables
        $poshbotcontext = [pscustomobject]@{
            Plugin = 'TestPlugin'
            ConfigurationDirectory = (Join-Path $env:BHProjectPath Tests)
        }
        $globalfile = Join-Path $poshbotcontext.ConfigurationDirectory "PoshbotGlobal.state"
        $modulefile = Join-Path $poshbotcontext.ConfigurationDirectory "$($poshbotcontext.Plugin).state"
        [pscustomobject]@{
            a = 'g'
            b = $true
        } | Export-Clixml -Path $globalfile
        [pscustomobject]@{
            a = 'm'
            b = $true
        } | Export-Clixml -Path $modulefile

        it 'Removes data as expected' {
            Remove-PoshBotStatefulData -Scope Module -Name a
            Remove-PoshBotStatefulData -Scope Global -Name b

            $m = Import-Clixml -Path $modulefile
            $m.b | Should Be $True
            @($m.psobject.properties).count | Should Be 1

            $g = Import-Clixml -Path $globalfile
            $g.a | Should Be 'g'
            @($g.psobject.properties).count | Should Be 1

            Remove-Item $globalfile -Force
            Remove-Item $modulefile -Force
        }
        Remove-Item $globalfile -Force -ErrorAction SilentlyContinue
        Remove-Item $modulefile -Force -ErrorAction SilentlyContinue
    }
}
