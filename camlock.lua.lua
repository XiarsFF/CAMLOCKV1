local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local camlockActive = false
local prediction = 0.240
local UserInputService = game:GetService("UserInputService")

-- Función del Camlock
local function camlock(target)
    local camera = game.Workspace.CurrentCamera
    while camlockActive and target do
        camera.CFrame = CFrame.new(camera.CFrame.Position, target.Position + target.Velocity * prediction)
        wait() 
    end
end

-- Función para activar o desactivar el Camlock
local function toggleCamlock()
    camlockActive = not camlockActive
    if camlockActive then
        local target = mouse.Target
        if target and target.Parent:FindFirstChild("Humanoid") then
            camlock(target)
        else
            warn("No se encontró un objetivo válido para el Camlock.")
            camlockActive = false
        end
    end
end

-- Función para ajustar la predicción
local function adjustPrediction(newPrediction)
    prediction = tonumber(newPrediction) or prediction
    print("Nueva predicción ajustada a: ", prediction)
end

-- Crear UI
local ui = Instance.new("ScreenGui", player.PlayerGui)

-- Función para estilizar botones
local function styleButton(button, backgroundColor, textColor, borderColor)
    button.BackgroundColor3 = backgroundColor
    button.TextColor3 = textColor
    button.BorderSizePixel = 2
    button.BorderColor3 = borderColor
    button.Font = Enum.Font.GothamBold
    button.TextSize = 18
    button.TextStrokeTransparency = 0.7
    button.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    button.BackgroundTransparency = 0.4
end

-- Botón para activar/desactivar Camlock
local camlockButton = Instance.new("TextButton", ui)
camlockButton.Size = UDim2.new(0, 120, 0, 50)
camlockButton.Position = UDim2.new(0.5, -160, 0.9, 0)
camlockButton.AnchorPoint = Vector2.new(0.5, 0)
camlockButton.Text = "Toggle Camlock"
camlockButton.TextScaled = true
styleButton(camlockButton, Color3.fromRGB(0, 102, 204), Color3.fromRGB(255, 255, 255), Color3.fromRGB(0, 153, 255))

-- Botón para ajustar la predicción
local predictionButton = Instance.new("TextButton", ui)
predictionButton.Size = UDim2.new(0, 120, 0, 50)
predictionButton.Position = UDim2.new(0.5, 40, 0.9, 0)
predictionButton.AnchorPoint = Vector2.new(0.5, 0)
predictionButton.Text = "Set Prediction"
predictionButton.TextScaled = true
styleButton(predictionButton, Color3.fromRGB(0, 153, 255), Color3.fromRGB(255, 255, 255), Color3.fromRGB(0, 102, 204))

-- Botón para activar/desactivar la configuración de predicción
local togglePredictionConfigButton = Instance.new("TextButton", ui)
togglePredictionConfigButton.Size = UDim2.new(0, 200, 0, 50)
togglePredictionConfigButton.Position = UDim2.new(0.5, -100, 0.8, 0)
togglePredictionConfigButton.AnchorPoint = Vector2.new(0.5, 0)
togglePredictionConfigButton.Text = "Show Prediction Config"
togglePredictionConfigButton.TextScaled = true
styleButton(togglePredictionConfigButton, Color3.fromRGB(0, 128, 255), Color3.fromRGB(255, 255, 255), Color3.fromRGB(0, 102, 204))

-- Crear un TextBox para ingresar la nueva predicción
local predictionBox = Instance.new("TextBox", ui)
predictionBox.Size = UDim2.new(0, 200, 0, 50)
predictionBox.Position = UDim2.new(0.5, -100, 0.7, 0)
predictionBox.AnchorPoint = Vector2.new(0.5, 0)
predictionBox.Text = tostring(prediction)
predictionBox.PlaceholderText = "Enter Prediction Value"
predictionBox.Visible = false
predictionBox.Font = Enum.Font.Gotham
predictionBox.TextSize = 18
predictionBox.TextColor3 = Color3.fromRGB(255, 255, 255)
predictionBox.BackgroundColor3 = Color3.fromRGB(0, 0, 128)
predictionBox.BorderSizePixel = 2
predictionBox.BorderColor3 = Color3.fromRGB(0, 102, 204)
predictionBox.TextStrokeTransparency = 0.7
predictionBox.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)

-- Función para hacer arrastrables los botones
local function makeDraggable(uiElement)
    local dragging = false
    local dragInput, mousePos, framePos

    local function update(input)
        local delta = input.Position - mousePos
        uiElement.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
    end

    uiElement.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            mousePos = input.Position
            framePos = uiElement.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            update(input)
        end
    end)
end

-- Hacer que los botones sean arrastrables
makeDraggable(camlockButton)
makeDraggable(predictionButton)
makeDraggable(predictionBox)
makeDraggable(togglePredictionConfigButton)

-- Conectar los eventos de los botones
camlockButton.MouseButton1Click:Connect(toggleCamlock)

predictionButton.MouseButton1Click:Connect(function()
    predictionBox.Visible = true
end)

predictionBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        adjustPrediction(predictionBox.Text)
    end
    predictionBox.Visible = false
end)

togglePredictionConfigButton.MouseButton1Click:Connect(function()
    if predictionBox.Visible then
        predictionBox.Visible = false
        togglePredictionConfigButton.Text = "Show Prediction Config"
    else
        predictionBox.Visible = true
        togglePredictionConfigButton.Text = "Hide Prediction Config"
    end
end)
