
#Requires -Version 5.1
Set-StrictMode -Version 'Latest'

& (Join-Path -Path $PSScriptRoot -ChildPath 'Initialize-Test.ps1' -Resolve)

function GivenModuleLoaded
{
    Import-Module -Name (Join-Path -Path $PSScriptRoot -ChildPath '..\NoOp\NoOp.psd1' -Resolve)
    Get-Module -Name 'NoOp' | Add-Member -MemberType NoteProperty -Name 'NotReloaded' -Value $true
}

function GivenModuleNotLoaded
{
    Remove-Module -Name 'NoOp' -Force -ErrorAction Ignore
}

function Init
{

}

function ThenModuleLoaded
{
    $module = Get-Module -Name 'NoOp'
    $module | Should -Not -BeNullOrEmpty
    $module | Get-Member -Name 'NotReloaded' | Should -BeNullOrEmpty
}

function WhenImporting
{
    $script:importedAt = Get-Date
    Start-Sleep -Milliseconds 1
    & (Join-Path -Path $PSScriptRoot -ChildPath '..\NoOp\Import-NoOp.ps1' -Resolve)
}

Describe 'Import-NoOp.when module not loaded' {
    It 'should import the module' {
        Init
        GivenModuleNotLoaded
        WhenImporting
        ThenModuleLoaded
    }
}

Describe 'Import-NoOp.when module loaded' {
    It 'should re-import the module' {
        Init
        GivenModuleLoaded
        WhenImporting
        ThenModuleLoaded
    }
}
