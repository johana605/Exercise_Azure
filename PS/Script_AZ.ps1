# Conectarse a Azure
Connect-AzAccount

# Especifica el nombre de tu suscripción de Azure
$subscriptionName = "efa43193-61b3-42cf-a087-6681f44edf7c"

# Selecciona la suscripción activa
Set-AzContext -SubscriptionName $subscriptionName

# Especifica el nombre del grupo de recursos
$resourceGroupName = "rgworkmil"


# Obtén los recursos en el grupo de recursos
$resources = Get-AzResource -ResourceGroupName $resourceGroupName

# Define las propiedades principales que deseas mostrar en la tabla
$propertiesToShow = "Name", "ResourceType", "Location", "Tags"

# Construye una lista personalizada de propiedades para cada recurso
$resourceList = foreach ($resource in $resources) {
    $resourceData = [ordered]@{}
    foreach ($property in $propertiesToShow) {
        $resourceData[$property] = $resource.PsObject.Properties | Where-Object {$_.Name -eq $property} | Select-Object -ExpandProperty Value
    }
    [PSCustomObject]$resourceData
}

# Imprime la tabla de recursos
Write-Output "Recursos en el grupo de recursos '$resourceGroupName':"
$resourceList | Format-Table -AutoSize

# Selecciona un recurso para obtener detalles de configuración
$selectedResource = $resources | Select-Object -First 1

# Obtiene detalles detallados del recurso seleccionado
$resourceDetails = Get-AzResource -ResourceId $selectedResource.ResourceId | ConvertTo-Json -Depth 10

# Imprime los detalles detallados del recurso seleccionado
Write-Output "Detalles del recurso seleccionado:"
Write-Output $resourceDetails

# Añade tags a los recursos
$tags = @{
    Tag_proy1 = "creacion_proy1"
    Tag_proy2 = "creacion_proy2"
}

# Añade los tags a los recursos
$resources | ForEach-Object {
    $resourceId = $_.ResourceId
    Set-AzResource -ResourceId $resourceId -Tag $tags
}

# Verifica si los tags se han establecido correctamente en los recursos
$tagVerification = $resources | ForEach-Object {
    $resourceId = $_.ResourceId
    $tags = (Get-AzResource -ResourceId $resourceId).Tags
    $isSet = $tags.ContainsKey("Tag1") -and $tags.ContainsKey("Tag2")
    [PSCustomObject]@{
        ResourceId = $resourceId
        TagsSet = $isSet
    }
}

# Imprime los resultados de la verificación de tags
Write-Output "Verificación de tags en los recursos:"
$tagVerification | Format-Table -AutoSize