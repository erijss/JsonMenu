##################################################################
## PS Script to create a custom WPF content menu for a tray app ##
##################################################################

# Add assemblies
[System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms')    | out-null
[System.Reflection.Assembly]::LoadWithPartialName('presentationframework')   | out-null
[System.Reflection.Assembly]::LoadWithPartialName('System.Drawing')    | out-null

# Create a WinForms application context
$appContext = New-Object System.Windows.Forms.ApplicationContext

$icon = "D:\Code\JsonMenu\JsonMenu\JsonMenuLogo.ico"

# Create a notify icon
$script:TrayIcon = New-Object System.Windows.Forms.NotifyIcon
$TrayIcon.Icon = $icon
$TrayIcon.Text = "My Cool App"

# Function to create the context menu
function CreateContextMenu {
    # Define the window in XAML
    [xml]$Xaml = @"
    <Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" Title="ContextMenu" SizeToContent="WidthAndHeight" WindowStyle="None" AllowsTransparency="True" Topmost="True" BorderBrush="White" BorderThickness="0.6">
	<Window.Resources>
		<Style x:Key="MainMenuitem" TargetType="MenuItem">
			<Setter Property="Height" Value="35"/>
			<Setter Property="Width" Value="250"/>
			<Setter Property="Foreground" Value="WhiteSmoke"/>
			<Setter Property="Template">
				<Setter.Value>
					<ControlTemplate TargetType="{x:Type MenuItem}">
						<Border x:Name="Border" Padding="35,10,10,5" BorderThickness="0" Margin="2,0,2,0">
							<ContentPresenter ContentSource="Header" x:Name="HeaderHost" RecognizesAccessKey="True"/>
						</Border>
						<ControlTemplate.Triggers>
							<Trigger Property="IsHighlighted" Value="true">
								<Setter Property="Background" TargetName="Border" Value="#4C4C4C"/>
							</Trigger>
						</ControlTemplate.Triggers>
					</ControlTemplate>
				</Setter.Value>
			</Setter>
		</Style>
		<Style x:Key="SubMenuitem" TargetType="MenuItem">
			<Setter Property="Height" Value="35"/>
			<Setter Property="Width" Value="200"/>
			<Setter Property="Foreground" Value="WhiteSmoke"/>
			<Setter Property="Template">
				<Setter.Value>
					<ControlTemplate TargetType="{x:Type MenuItem}">
						<Border x:Name="Border" Padding="35,10,10,5" BorderThickness="0" Margin="2,0,2,0">
							<ContentPresenter ContentSource="Header" x:Name="HeaderHost" RecognizesAccessKey="True"/>
						</Border>
						<ControlTemplate.Triggers>
							<Trigger Property="IsHighlighted" Value="true">
								<Setter Property="Background" TargetName="Border" Value="#4C4C4C"/>
							</Trigger>
						</ControlTemplate.Triggers>
					</ControlTemplate>
				</Setter.Value>
			</Setter>
		</Style>
		<Style x:Key="SubMenuParentitem" TargetType="MenuItem">
			<Setter Property="Height" Value="35"/>
			<Setter Property="Width" Value="250"/>
			<Setter Property="Foreground" Value="WhiteSmoke"/>
			<Setter Property="Template">
				<Setter.Value>
					<ControlTemplate TargetType="{x:Type MenuItem}">
						<Border x:Name="Border" Padding="35,10,10,5" BorderThickness="0" Margin="2,0,2,0">
							<Grid VerticalAlignment="Center">
								<Grid.ColumnDefinitions>
									<ColumnDefinition Width="Auto"/>
									<ColumnDefinition Width="Auto"/>
								</Grid.ColumnDefinitions>
								<ContentPresenter ContentSource="Header" x:Name="HeaderHost" RecognizesAccessKey="True"/>
								<Path Name="SelectedArrow" Data="M 0 12 L 6 6 L 0 0" Stroke="White" Margin="190,0,0,0"/>
							</Grid>
						</Border>
						<ControlTemplate.Triggers>
							<Trigger Property="IsHighlighted" Value="true">
								<Setter Property="Background" TargetName="Border" Value="#4C4C4C"/>
							</Trigger>
						</ControlTemplate.Triggers>
					</ControlTemplate>
				</Setter.Value>
			</Setter>
		</Style>
		<Style x:Key="Popup" TargetType="{x:Type Popup}">
			<Setter Property="IsOpen" Value="True"/>
			<Style.Triggers>
				<MultiDataTrigger>
					<MultiDataTrigger.Conditions>
						<Condition Binding="{Binding RelativeSource={RelativeSource Self},Path=PlacementTarget.IsMouseOver}" Value="False"/>
						<Condition Binding="{Binding RelativeSource={RelativeSource Self},Path=IsMouseOver}" Value="False"/>
					</MultiDataTrigger.Conditions>
					<Setter Property="IsOpen" Value="False"/>
				</MultiDataTrigger>
			</Style.Triggers>
		</Style>
	</Window.Resources>
	<StackPanel Background="#333333">
		<Line Margin="3"/>
		<MenuItem Name="Open" Header="Open My Cool App" FontWeight="Bold" Style="{StaticResource MainMenuitem}"/>
		<Separator Width="240" Height="0.5"/>
		<MenuItem Name="Options" Header="Options" Style="{StaticResource SubMenuParentitem}"/>
		<MenuItem Name="Exit" Header="Exit" Style="{StaticResource MainMenuitem}"/>
		<Line Margin="3"/>
		<Popup Name="Popup" PopupAnimation="Fade" Focusable="True" Placement="Left" PlacementTarget="{Binding ElementName=Options}" Style="{StaticResource Popup}" HorizontalOffset="5">
			<Border Background="#333333" BorderBrush="White" BorderThickness="0.9">
				<StackPanel>
					<Line Margin="3"/>
					<MenuItem Name="ChangeColour" Header="Change Colour" Style="{StaticResource SubMenuitem}"/>
					<MenuItem Name="ChangeSize" Header="Change Size" Style="{StaticResource SubMenuitem}"/>
					<Line Margin="3"/>
				</StackPanel>
			</Border>
		</Popup>
	</StackPanel>
</Window>
"@

    # Create the Windows and elements
    $global:CM = @{}
    $CM.ContextMenu = [Windows.Markup.XamlReader]::Load((New-Object –TypeName System.Xml.XmlNodeReader –ArgumentList $xaml))
    $xaml.SelectNodes("//*[@*[contains(translate(name(.),'n','N'),'Name')]]") |
    ForEach-Object –Process {
        $CM.$($_.Name) = $CM.ContextMenu.FindName($_.Name)
    }

    # Move the menu window to the correct location by the mouse cursor
    $CM.ContextMenu.Add_Loaded({
            [System.Drawing.Point]$point = [System.Windows.Forms.Control]::MousePosition
            $MousePosition = [System.Windows.Point]::new($point.X, $point.Y)
            $Transform = [System.Windows.PresentationSource]::FromVisual($this).CompositionTarget.TransformFromDevice
            $Mouse = $Transform.transform($MousePosition)
            $CM.ContextMenu.Top = ($Mouse.Y – $This.ActualHeight)
            $CM.ContextMenu.Left = ($Mouse.X – $This.ActualWidth)
        })

    # Don't leave the menu window open if the mouse leaves it
    $CM.ContextMenu.Add_MouseLeave({
            If ($CM.Popup.IsMouseOver -ne $true) {
                $this.Close()
            }
        })

    # Open the app
    $CM.Open.Add_Click({
            Start-Process Notepad
        })

    # Change colour option
    $CM.ChangeColour.Add_Click({
            $Colour = "Green", "Blue", "Red", "Orange", "Brown" | Get-Random
            $This.Foreground = $Colour
        })

    # Change size option
    $CM.ChangeSize.Add_Click({
            $Size = "6", "8", "10", "12", "14" | Get-Random
            $This.FontSize = $Size
        })

    # Clean up on exit
    $CM.Exit.Add_Click({
            $CM.ContextMenu.Close()
            $TrayIcon.Dispose()
            $appContext.ExitThread()
            $appContext.Dispose()
        })

    # Display the menu
    $CM.ContextMenu.ShowDialog()

}

# Open content menu on icon right-click
$TrayIcon.Add_MouseDown({
        If ($_.Button -eq [System.Windows.Forms.MouseButtons]::Right) {
            If ($CM.ContextMenu) {
                $CM.ContextMenu.Close()
            }
            CreateContextMenu
        }
    })


$TrayIcon.Visible = $true

[void][System.Windows.Forms.Application]::Run($appContext)
