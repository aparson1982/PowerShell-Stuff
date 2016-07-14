<#
    Author:  Robert Parson
    Date:  7/20/15
#>

function OnApplicationLoad
{

	return $true #return true for success or false for failure

}

function OnApplicationExit
{
	$script:ExitCode = 0 #Set the exit code for the Packager
}



function Call-AdamSystemForm2_psf {

	[void][reflection.assembly]::Load('mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')

	[void][reflection.assembly]::Load('System, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')

	[void][reflection.assembly]::Load('System.Windows.Forms, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')

	[void][reflection.assembly]::Load('System.Data, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')

	[void][reflection.assembly]::Load('System.Drawing, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a')

	[void][reflection.assembly]::Load('System.Xml, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')

	[void][reflection.assembly]::Load('System.DirectoryServices, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a')

	[void][reflection.assembly]::Load('System.Core, Version=3.5.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')

	[void][reflection.assembly]::Load('System.ServiceProcess, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a')

	

	[System.Windows.Forms.Application]::EnableVisualStyles()

	$formAdam = New-Object 'System.Windows.Forms.Form'

	$button1 = New-Object 'System.Windows.Forms.Button'

	$User = New-Object 'System.Windows.Forms.Button'

	$Computer = New-Object 'System.Windows.Forms.Button'

	$computername = New-Object 'System.Windows.Forms.TextBox'

	$username = New-Object 'System.Windows.Forms.TextBox'

	$InitialFormWindowState = New-Object 'System.Windows.Forms.FormWindowState'


	function OnApplicationLoad

	{

		return $true #return true for success or false for failure

	}

	
	function OnApplicationExit

	{

		$script:ExitCode = 0 

	}


	$formAdam_Load = {}

	function Load-ComboBox

	{

		Param (

			[ValidateNotNull()]

			[Parameter(Mandatory = $true, ValueFromPipeline=$True, ValueFromPipelinebyPropertyName=$True)]

			[System.Windows.Forms.ComboBox]$ComboBox,

			[ValidateNotNull()]

			[Parameter(Mandatory = $true)]

			$Items,

			[Parameter(Mandatory = $false)]

			[string]$DisplayMember,

			[switch]$Append
            

		)

		

		if (-not $Append)

		{

			$ComboBox.Items.Clear()

		}

		

		if ($Items -is [Object[]])

		{

			$ComboBox.Items.AddRange($Items)

		}

		elseif ($Items -is [Array])

		{

			$ComboBox.BeginUpdate()

			foreach ($obj in $Items)

			{

				$ComboBox.Items.Add($obj)

			}

			$ComboBox.EndUpdate()

		}

		else

		{

			$ComboBox.Items.Add($Items)

		}

		

		$ComboBox.DisplayMember = $DisplayMember

	}

	#endregion

	

	$picturebox2_Click={

		#TODO: Place custom script here

	}

	

	$linklabel1_LinkClicked=[System.Windows.Forms.LinkLabelLinkClickedEventHandler]{


	}

#############################Button Clicks

    $User_Click={

                $results = @()

        if((!$computername.text) -and (!$username.text))
            {
                "Enter Something"
            }
        elseif(!$computername.text)
            {
                $results += Get-AssociatedComputers $username.text
                $results += Get-Aduser $username.text -Properties LockedOut
            }

        else
            {
               $results += Get-ComputerInformation $computername.text -Network
               $results += Get-Software $computername.text
               $results += Get-LogonUser $computername.text
            }


             $processes = @($results)
		    $counter = 0
		    foreach ($process in $processes)
			{
				Write-Progress -Activity "Processing...  " -Status $process -PercentComplete (($counter / $processes.count)*100); $counter ++
				Start-Sleep 2
			}
                
                $results | Out-file C:\Users\raparson\Downloads\results.txt 
                return Invoke-Item C:\Users\raparson\Downloads\results.txt

                    }
    
############################Button Clicks


	$Computer_Click={

        

            $results = @()

        if((!$computername.text) -and (!$username.text))
            {
                "Enter Something"
            }
        elseif(!$computername.text)
            {
                $results += Get-AssociatedComputers $username.text
            }

        else
            {
               $results += Get-ComputerInformation $computername.text -Platform -Resources
               $results += Get-Software $computername.text
               $results += Get-LogonUser $computername.text
             }
             
             $processes = @($results)
		    $counter = 0
		    foreach ($process in $processes)
			{
				Write-Progress -Activity "Processing...  " -Status $process -PercentComplete (($counter / $processes.count)*100); $counter ++
				Start-Sleep 2
			}
            
              $results | Out-file C:\Users\raparson\Downloads\results.txt 
              return Invoke-Item C:\Users\raparson\Downloads\results.txt

		        
            }

############################  Button Clicks

        $button1_click={

        $results = @()

        ##Counter
            
        ##counter

                            

            if((!$computername.text) -and (!$username.text))
            {
                "Enter Something"
            }
            elseif(!$computername.text)
            {
                $results += Get-AssociatedComputers $username.text
            }

            else
            {
               $results += Get-ComputerInformation $computername.text -Network
               $results += Get-LogonUser $computername.text
            }

            $processes = @($results)
		    $counter = 0
		    foreach ($process in $processes)
			{
				Write-Progress -Activity "Processing...  " -Status $process -PercentComplete (($counter / $processes.count)*100); $counter ++
				Start-Sleep 2
			}
             
           $results | Out-file C:\Users\raparson\Downloads\results.txt
           return Invoke-Item C:\Users\raparson\Downloads\results.txt

            
		        
                         }

############################## Button Clicks	

##############################Progress Bar

#################################Progress Bar

	$Form_StateCorrection_Load=

	{

		#Correct the initial state of the form to prevent the .Net maximized form issue

		$formAdam.WindowState = $InitialFormWindowState

	}

	

	$Form_Cleanup_FormClosed=

	{

		#Remove all event handlers from the controls

		try

		{

			$button1.remove_Click($button1_click)

			#$button1.remove_MouseClick($Network_Click)

			$User.remove_Click($User_Click)

			#$User.remove_MouseClick($User_Click)

			$Computer.remove_Click($Computer_Click)

			#$Computer.remove_MouseClick($Computer_MouseClick)

			$formAdam.remove_Load($formAdam_Load)

			$formAdam.remove_Load($Form_StateCorrection_Load)

			$formAdam.remove_FormClosed($Form_Cleanup_FormClosed)

		}

		catch [Exception]

		{ }

	}

	

	$formAdam.SuspendLayout()

	#

	# formAdam

	#

	$formAdam.Controls.Add($button1)

	$formAdam.Controls.Add($User)

	$formAdam.Controls.Add($Computer)

	$formAdam.Controls.Add($computername)

	$formAdam.Controls.Add($username)

	#region Binary Data

	$formAdam.BackgroundImage = [System.Convert]::FromBase64String()  #binary data removed

	#endregion

	$formAdam.BackgroundImageLayout = 'Zoom'

	$formAdam.ClientSize = '966, 539'

	$formAdam.ForeColor = 'MenuHighlight'

	$formAdam.Name = "formAdam"

	$formAdam.Text = "Adam"

	$formAdam.add_Load($formAdam_Load)

	#

	# button1

	#
    $networkbut = $button1

	$button1.BackColor = 'Transparent'

	$button1.Cursor = "Hand"

	$button1.FlatAppearance.BorderSize = 0

	$button1.FlatStyle = 'Flat'

	#region Binary Data

	$button1.Image = [System.Convert]::FromBase64String() #binary data removed

	#endregion

	$button1.Location = '480, 218'

	$button1.Name = "button1"

	$button1.Size = '90, 90'

	$button1.TabIndex = 5

	$button1.UseVisualStyleBackColor = $False

	$button1.add_Click({$button1_click})

	#$button1.add_MouseClick({$networkbut_click})

	#

	# User

	#

	$User.BackColor = 'Transparent'

	#region Binary Data

	$User.BackgroundImage = [System.Convert]::FromBase64String() #binary data removed

	#endregion

	$User.BackgroundImageLayout = 'Center'

	$User.Cursor = "Hand"

	$User.FlatAppearance.BorderSize = 0

	$User.FlatStyle = 'Flat'

	$User.ForeColor = 'Transparent'

	$User.Location = '775, 222'

	$User.Name = "User"

	$User.Size = '29, 83'

	$User.TabIndex = 4

	$User.UseVisualStyleBackColor = $False

	$User.add_Click($User_Click)

	#$User.add_MouseClick($User_Click)

	#

	# Computer

	#

	$Computer.BackColor = 'Transparent'

	#region Binary Data

	$Computer.BackgroundImage = [System.Convert]::FromBase64String()  #binary data removed

	#endregion

	$Computer.BackgroundImageLayout = 'Center'

	$Computer.Cursor = "Hand"

	$Computer.FlatAppearance.BorderSize = 0

	$Computer.FlatStyle = 'Flat'

	$Computer.ForeColor = 'Transparent'

	$Computer.Location = '630, 222'

	$Computer.Name = "Computer"

	$Computer.Size = '68, 83'

	$Computer.TabIndex = 3

	$Computer.TextImageRelation = 'ImageAboveText'

	$Computer.UseVisualStyleBackColor = $False

	$Computer.add_Click($Computer_Click)

	#$Computer.add_MouseClick($Computer_MouseClick)

	#

	# computername

	#

	$computername.AcceptsReturn = $True

	$computername.AcceptsTab = $True

	$computername.BackColor = 'InactiveBorder'

	$computername.Font = "Microsoft Sans Serif, 10.25pt"

	$computername.Location = '264, 337'

	$computername.Name = "computername"

	$computername.Size = '162, 23'

	$computername.TabIndex = 2

	$computername.Tag = "$pcname"

	$computername.Text = ""

	#

	# username

	#

	$username.AcceptsReturn = $True

	$username.AcceptsTab = $True

	$username.BackColor = 'InactiveBorder'

	$username.Font = "Microsoft Sans Serif, 10.25pt"

	$username.Location = '264, 266'

	$username.Name = "username"

	$username.Size = '162, 23'

	$username.TabIndex = 1

	$username.Tag = "$username"

	$username.Text = ""

	$formAdam.ResumeLayout()

	#endregion Generated Form Code

	#Save the initial state of the form

	$InitialFormWindowState = $formAdam.WindowState

	#Init the OnLoad event to correct the initial state of the form

	$formAdam.add_Load($Form_StateCorrection_Load)

	#Clean up the control events

	$formAdam.add_FormClosed($Form_Cleanup_FormClosed)

	#Show the Form

	return $formAdam.ShowDialog()
    
    

} #End Function



#Call OnApplicationLoad to initialize

if((OnApplicationLoad) -eq $true)

{

	#Call the form

	Call-AdamSystemForm2_psf | Out-Null

	#Perform cleanup

	OnApplicationExit

}

