-- Crear una GUI para mostrar resultados de depuración
local function createDebugWindow()
    local player = game.Players.LocalPlayer

    -- Crear el ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "DebugWindow"
    screenGui.Parent = player:WaitForChild("PlayerGui")

    -- Crear el marco de la ventana
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0.4, 0, 0.4, 0)
    frame.Position = UDim2.new(0.3, 0, 0.3, 0)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    frame.BackgroundTransparency = 0.8
    frame.BorderSizePixel = 2
    frame.BorderColor3 = Color3.fromRGB(255, 255, 255)
    frame.Draggable = true  -- Permite mover la ventana
    frame.Visible = false  -- Inicialmente oculto
    frame.Parent = screenGui

    -- Crear el título de la ventana
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 0.1, 0)
    titleLabel.Position = UDim2.new(0, 0, 0, 0)
    titleLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.Text = "Resultados de Depuración"
    titleLabel.TextSize = 24
    titleLabel.TextStrokeTransparency = 0.5
    titleLabel.Parent = frame

    -- Crear el área de texto para mostrar los resultados
    local textBox = Instance.new("TextBox")
    textBox.Size = UDim2.new(1, -20, 1, -20)
    textBox.Position = UDim2.new(0, 10, 0, 10)
    textBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    textBox.TextWrapped = true
    textBox.TextSize = 14
    textBox.TextYAlignment = Enum.TextYAlignment.Top
    textBox.MultiLine = true
    textBox.Text = ""
    textBox.TextStrokeTransparency = 0.5
    textBox.ClearTextOnFocus = false
    textBox.Parent = frame

    -- Crear una barra de desplazamiento
    local scrollBar = Instance.new("ScrollingFrame")
    scrollBar.Size = UDim2.new(1, 0, 1, 0)
    scrollBar.Position = UDim2.new(0, 0, 0, 0)
    scrollBar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    scrollBar.BackgroundTransparency = 1
    scrollBar.ScrollBarThickness = 8
    scrollBar.Parent = frame

    -- Configurar el TextBox dentro del ScrollingFrame
    textBox.Size = UDim2.new(1, -20, 1, -20)
    textBox.Position = UDim2.new(0, 10, 0, 10)
    textBox.Parent = scrollBar

    return frame, textBox
end

-- Crear la ventana de depuración
local debugFrame, debugTextBox = createDebugWindow()

-- Función para agregar texto a la ventana de depuración
local function printToDebug(text)
    debugTextBox.Text = debugTextBox.Text .. "\n" .. text
end

-- Función para recorrer objetos y mostrar scripts en el workspace
local function dumpWorkspaceScripts()
    local function traverse(object, indent)
        indent = indent or ""  -- Establecer la indentación inicial

        -- Imprimir el nombre del objeto actual
        printToDebug(indent .. "Explorando objeto: " .. object.Name)

        -- Recorrer los hijos del objeto
        for _, child in ipairs(object:GetChildren()) do
            -- Imprimir información de depuración sobre el hijo
            printToDebug(indent .. "  Encontrado hijo: " .. child.Name .. " (Tipo: " .. child.ClassName .. ")")

            -- Si el hijo es un script, imprimir su contenido
            if child:IsA("Script") then
                printToDebug(indent .. "    Script encontrado en: " .. object.Name)
                printToDebug(indent .. "    Contenido del script: " .. child.Source)  -- Imprime el contenido del script
            end

            -- Llamada recursiva para explorar los hijos del hijo
            traverse(child, indent .. "  ")
        end
    end

    -- Comenzar la búsqueda desde el workspace
    printToDebug("Iniciando la exploración del workspace...")
    traverse(game.Workspace)
    printToDebug("Exploración completa.")
end

dumpWorkspaceScripts()  -- Ejecuta la función

-- Función para manejar la entrada del teclado
local function onKeyPress(input)
    if input.KeyCode == Enum.KeyCode.LeftControl then
        debugFrame.Visible = not debugFrame.Visible  -- Alternar visibilidad
    end
end

-- Conectar la función de entrada de teclado
game:GetService("UserInputService").InputBegan:Connect(onKeyPress)

