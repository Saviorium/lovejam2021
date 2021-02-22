
return {
    gridSize = 74, -- pixel per cell
    resources = {
        ironOre = {
            frequency = 0.03,
            threshold = 0.75, -- 0 < threshold <= 1
            multiplier = 1000,
            sprite = "resource_iron",
            color = Resources.ironOre.color
        },
        ice = {
            frequency = 0.09,
            threshold = 0.7,
            multiplier = 1000,
            sprite = "resource_ice",
            color = Resources.ice.color
        }
    }
}