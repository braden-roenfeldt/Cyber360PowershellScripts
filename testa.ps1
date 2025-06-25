Class Circle{
    static $pi = 3.1415927
    [double]$Diameter = 5.5
    [string]$color = "Blue"
    
    # Fixed parameterless constructor
    Circle(){
    }
    
    Circle([string]$color){
        $this.color = $color
        $this.Diameter = 5.5  # Set default diameter
    }
      
    # Fixed Color method - just return the instance color
    [string]GetColor(){
        return $this.color
    }
}

# Test the fixed class
$c5 = [Circle]::new()
$c5
"Color: " + $c5.color
"Diameter: " + $c5.Diameter