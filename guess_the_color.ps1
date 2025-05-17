<#
  Program Name : guess_the_color.ps1
  Date: 5/16/2025
  Author: Braden Roenfeldt
  Course: CYBER 360
  I, Braden Roenfeldt, affirm that I wrote this script as original work completed by me.
  
#> 

$color = GenerateRandomColor
$correct_guesses=0
$incorrect_guesses=0
$command = ""
$user_input_array=""

#Write-Host $color

#while loop that handles game and menu function
while ($command -ne '6') {
  #Instruction block that takes user input to change game function
  $command=Read-Host @'

Instructions: Guess a color and see if your guess is correct, or type a numbered command listed below.
1. Show valid color list
2. Show guess count
3. Give Hint
4. Show guessed colors
5. Restart
6. Exit
Enter Choice/Guess
'@
#Ifelse statements to handle user input
if ($command -eq $color) {
  Write-Host
  Write-Host 'Correct!'$color' is my favorite color!' -f ([string]$color)
  Write-Host
  $correct_guesses+=1
  $color = GenerateRandomColor
  $user_input_array += $command
  } elseif ($command -eq 1) {   #Prints out valid color options
    Write-Host
    Write-Host 'Below are all the valid color options.'
    Write-Host $SystemColors
    Write-Host
  } elseif ($command -eq 2) {   #Prints out the number of correct and incorrect guesses
    Write-Host
    Write-Host "You have guessed correctly $correct_guesses time(s)."
    Write-Host "You have guessced incorrectly $incorrect_guesses time(s)."
    Write-Host
  } elseif ($command -eq 3) {   #If tree checking the current color and giving the hint based on it
    if ($color -eq 'Black') {
      Write-Host
      Write-Host "The opposite of white."
      Write-Host
    } elseif ($color -eq 'DarkBlue') {
      Write-Host
      Write-Host "A different shade of blue."
      Write-Host
    } elseif ($color -eq 'DarkGreen') {
      Write-Host
      Write-Host "A different shade of green."
      Write-Host
    } elseif ($color -eq 'DarkCyan') {
      Write-Host
      Write-Host "A kind of blue green color."
      Write-Host
    } elseif ($color -eq 'DarkRed') {
      Write-Host
      Write-Host "A different shade of red"
      Write-Host
    } elseif ($color -eq 'DarkMagenta') {
      Write-Host
      Write-Host "A different shade of equal parts red and blue."
      Write-Host
    } elseif ($color -eq 'DarkYellow') {
      Write-Host
      Write-Host "A different shade of yellow"
      Write-Host
    } elseif ($color -eq 'Gray') {
      Write-Host
      Write-Host "In between white and black"
      Write-Host
    } elseif ($color -eq 'DarkGray') {
      Write-Host
      Write-Host "Dark and blurrly lines"
      Write-Host
    } elseif ($color -eq 'Blue') {
      Write-Host
      Write-Host "The sky"
      Write-Host
    } elseif ($color -eq 'Green') {
      Write-Host
      Write-Host "The grass"
      Write-Host
    } elseif ($color -eq 'Cyan') {
      Write-Host
      Write-Host "A blue and green color"
      Write-Host
    } elseif ($color -eq 'Red') {
      Write-Host
      Write-Host "Blood"
      Write-Host
    } elseif ($color -eq 'Magenta') {
      Write-Host
      Write-Host "Equal parts red and blue"
      Write-Host
    } elseif ($color -eq 'Yellow') {
      Write-Host
      Write-Host "Bannanas"
      Write-Host
    } elseif ($color -eq 'White') {
      Write-Host
      Write-Host "The color of printer paper"
      Write-Host
    }
  } elseif ($command -eq 4) {   #Prints out the user's past inputs that are not commands
        Write-Host
        Write-Host 'You have guessed:'$user_input_array
        Write-Host
  } elseif ($command -eq 5) {   #Generates a new color, resets the user input array and prints out message telling the user
    $color = GenerateRandomColor
    $user_input_array = ""
    Write-Host
    Write-Host 'A new color has been generated and your current guess list has been reset!'
    Write-Host
  } elseif ($command -ne 6) {   #Exits the program is 6 is input, else it tracks the input and adds it to the list and increments incorrect_guesses
    Write-Host
    Write-Host 'Incorrect, try again.'
    $user_input_array += " $command "
    $incorrect_guesses += 1
    Write-Host
  }
}

Write-Host
Write-Host "Thanks for Playing!"
Write-Host



function GenerateRandomColor {
  #Generates and returns a random color as a string when called
  $number = Get-Random -Minimum 0 -Maximum 17
  $SystemColors=[System.Enum]::getvalues([System.ConsoleColor])  #Returns an array of all the possible ConsoleColor Values
  $function_color=$SystemColors[$number] #Creates a ConsoleColor object from a string
  return $function_color
}