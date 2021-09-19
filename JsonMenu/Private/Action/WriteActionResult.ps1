function JsonMenu.Action.WriteActionResult {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline)]
        [TypeName]
        $InputObject
    )
    process {
        $ActionContext.ActionResult = $InputObject
    }
}
