function JsonMenu.Action.WriteActionResult {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [PSCustomObject]
        $InputObject
    )
    process {
        $ActionContext.ActionResult = $InputObject
    }
}
