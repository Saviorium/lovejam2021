
return {
    gridSize = 74, -- pixel per cell
    resources = {
        ironOre = {
            frequency = 0.06,
            threshold = 0.95, -- 0 < threshold <= 1
            multiplier = 3000,
            sprite = "resource_iron",
            color = Resources.ironOre.color
        },
        ice = {
            frequency = 0.04,
            threshold = 0.9,
            multiplier = 3000,
            sprite = "resource_ice",
            color = Resources.ice.color
        }
    }
}