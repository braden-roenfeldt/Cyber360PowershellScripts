Class Circle{
    static $pi = 3.1415927
    [double]$Diameter=5.5
    [string]$color="Blue"

    Circle(){}
    Circle([string]$color){
        $this.color=$color
        $this.Diameter=5.5
    }
    Circle([double]$Diameter){
        #store the value passed to the contructor
        $this.Diameter=$Diameter
        $this.color="Blue"
    }

    static[double]Area([double]$Diameter) {
        return ([Circle]::Pi*[math]::pow($Diameter/2,2))
    }
    [double]Area(){
        return [Circle]::Area($this.Diameter)
    }

    static[double]Circumfrence([double]$Diameter) {
        return [Circle]::Pi * $Diameter
    }
    [double]Circumfrence(){
        return [Circle]::pi * $this.Diameter
    }

    static[string]Color([string]$Color) {
        return [Circle]::Color
    }
    [string]GetColor(){
        return $this.color
    }
}

#$c1=[circle]::new() 
#$c1.Diameter=8 
#$c1.Area()
#$c1.Circumfrence()
#$c2 = [circle]::new() 
#$c2.Color.GetType()
#$c3=[circle]::new(12) 
#$c3  

#$c4=[circle]::new()
#$c4

$c5=[circle]::new()
$c5