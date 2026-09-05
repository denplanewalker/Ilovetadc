local httpService = game:GetService('HttpService')
local SaveManager = {} do
	SaveManager.Folder = 'LinoriaLibSettings'
	SaveManager.Ignore = {}
	SaveManager.Parser = {
		Toggle = {
			Save = function(idx, object) 
				return { type = 'Toggle', idx = idx, value = object.Value } 
			end,
			Load = function(idx, data)
				if Toggles[idx] then 
					Toggles[idx]:SetValue(data.value)
				end
			end,
		},

		Slider = {
			Save = function(idx, object)
				return { type = 'Slider', idx = idx, value = object.Value }
			end,
			Load = function(idx, data)
				if Options[idx] then 
					Options[idx]:SetValue(data.value)
				end
			end,
		},

		Dropdown = {
			Save = function(idx, object)
				return { type = 'Dropdown', idx = idx, value = object.Value, multi = object.Multi }
			end,
			Load = function(idx, data)
				if Options[idx] then 
					Options[idx]:SetValue(data.value)
				end
			end,
		},

		ColorPicker = {
			Save = function(idx, object)
				return { 
					type = 'ColorPicker', 
					idx = idx, 
					value = object.Value:ToHex(), 
					transparency = object.Transparency 
				}
			end,
			Load = function(idx, data)
				if Options[idx] then 
					Options[idx]:SetValueRGB(Color3.fromHex(data.value or "FFFFFF"), data.transparency or 0)
				end
			end,
		},

		KeyPicker = {
			Save = function(idx, object) 
				return { 
					type = 'KeyPicker', 
					idx = idx, 
					key = object.Value or "None",
					mode = object.Mode or "Toggle",
					toggled = object.Toggled or false,
					syncToggleState = object.SyncToggleState or false
				} 
			end,
			Load = function(idx, data)
				if Options[idx] then 
					if Options[idx].SetValue then
						if type(Options[idx].SetValue) == "function" then
							Options[idx]:SetValue({ data.key, data.mode })
						else
							Options[idx].Value = data.key
							Options[idx].Mode = data.mode
						end
					end
					if data.toggled ~= nil and Options[idx].Toggled ~= nil then
						Options[idx].Toggled = data.toggled
					end
					if Options[idx].Update then
						Options[idx]:Update()
					end
					if Options[idx].Display then
						Options[idx]:Display()
					end
				end
			end,
		},

		Keybind = {
			Save = function(idx, object)
				return { 
					type = 'Keybind', 
					idx = idx, 
					key = object.Value or "None",
					mode = object.Mode or "Toggle",
					toggled = object.Toggled or false,
					syncToggleState = object.SyncToggleState or false
				} 
			end,
			Load = function(idx, data)
				if Options[idx] then 
					if Options[idx].SetValue then
						if type(Options[idx].SetValue) == "function" then
							Options[idx]:SetValue({ data.key, data.mode })
						else
							Options[idx].Value = data.key
							Options[idx].Mode = data.mode
						end
					end
					if data.toggled ~= nil and Options[idx].Toggled ~= nil then
						Options[idx].Toggled = data.toggled
					end
					if Options[idx].Update then
						Options[idx]:Update()
					end
					if Options[idx].Display then
						Options[idx]:Display()
					end
				end
			end,
		},

		Input = {
			Save = function(idx, object)
				return { type = 'Input', idx = idx, text = object.Value }
			end,
			Load = function(idx, data)
				if Options[idx] and type(data.text) == 'string' then
					Options[idx]:SetValue(data.text)
				end
			end,
		},

		Theme = {
			Save = function()
				local colors = {}
				for _, name in ipairs({"FontColor", "MainColor", "BackgroundColor", "AccentColor", "OutlineColor", "RiskColor"}) do
					if Library[name] then
						colors[name] = Library[name]:ToHex()
					end
				end
				return { type = 'Theme', colors = colors }
			end,
			Load = function(data)
				if not data.colors then return end
				for name, hex in pairs(data.colors) do
					if Library[name] then
						Library[name] = Color3.fromHex(hex)
					end
				end
				Library:UpdateColorsUsingRegistry()
			end,
		}
	}

	function SaveManager:SetIgnoreIndexes(list)
		for _, key in next, list do
			self.Ignore[key] = true
		end
	end

	function SaveManager:SetFolder(folder)
		self.Folder = folder
		self:BuildFolderTree()
	end

	function SaveManager:Save(name)
		if not name or name:gsub("%s+", "") == "" then
			return false, "no config name"
		end

		local fullPath = self.Folder .. '/settings/' .. name .. '.json'

		local data = { objects = {}, theme = nil }

		for idx, toggle in next, Toggles do
			if self.Ignore[idx] then continue end
			table.insert(data.objects, self.Parser.Toggle.Save(idx, toggle))
		end

		for idx, option in next, Options do
			if self.Ignore[idx] then continue end
			
			local parser = nil
			
			if option.Type == 'KeyPicker' then
				parser = self.Parser.KeyPicker
			elseif option.Type == 'Keybind' then
				parser = self.Parser.Keybind
			else
				parser = self.Parser[option.Type]
			end
			
			if parser and parser.Save then
				table.insert(data.objects, parser.Save(idx, option))
			end
		end

		data.theme = self.Parser.Theme.Save()

		local success, encoded = pcall(httpService.JSONEncode, httpService, data)
		if not success then return false, 'encode failed' end

		writefile(fullPath, encoded)
		return true
	end

	function SaveManager:Load(name)
		if not name then return false, 'no config selected' end

		local file = self.Folder .. '/settings/' .. name .. '.json'
		if not isfile(file) then return false, 'file not found' end

		local success, decoded = pcall(httpService.JSONDecode, httpService, readfile(file))
		if not success then return false, 'decode failed' end

		for _, obj in next, decoded.objects or {} do
			local parser = nil
			
			if obj.type == 'KeyPicker' then
				parser = self.Parser.KeyPicker
			elseif obj.type == 'Keybind' then
				parser = self.Parser.Keybind
			else
				parser = self.Parser[obj.type]
			end
			
			if parser and parser.Load then
				task.spawn(parser.Load, obj.idx, obj)
			end
		end

		if decoded.theme then
			self.Parser.Theme.Load(decoded.theme)
		end

		return true
	end

	function SaveManager:IgnoreThemeSettings()
		self:SetIgnoreIndexes({ 
			"BackgroundColor", "MainColor", "AccentColor", "OutlineColor", "FontColor", "RiskColor",
			"ThemeManager_ThemeList", "ThemeManager_CustomThemeList", "ThemeManager_CustomThemeName"
		})
	end

	function SaveManager:BuildFolderTree()
		local paths = { self.Folder, self.Folder .. '/themes', self.Folder .. '/settings' }
		for _, path in ipairs(paths) do
			if not isfolder(path) then makefolder(path) end
		end
	end

	function SaveManager:RefreshConfigList()
		local list = listfiles(self.Folder .. '/settings')
		local out = {}
		for _, file in ipairs(list) do
			if file:sub(-5) == '.json' then
				local name = file:match("([^/\\]+)%.json$")
				if name then table.insert(out, name) end
			end
		end
		return out
	end

	function SaveManager:SetLibrary(library)
		self.Library = library
		library.SaveManager = self
	end

	function SaveManager:LoadAutoloadConfig()
		local path = self.Folder .. '/settings/autoload.txt'
		if isfile(path) then
			local name = readfile(path):gsub("%s+", "")
			if name ~= "" then
				local success, err = self:Load(name)
				if success then
					self.Library:Notify('Auto-loaded config: ' .. name, 4)
				else
					self.Library:Notify('Failed to auto-load: ' .. err, 4)
				end
			end
		end
	end

	function SaveManager:BuildConfigSection(tab)
		assert(self.Library, 'Library not set')

		local section = tab:AddRightGroupbox('Configs')

		section:AddInput('SaveManager_ConfigName', { Text = 'Config Name' })
		section:AddDropdown('SaveManager_ConfigList', { 
			Text = 'Config List', 
			Values = self:RefreshConfigList(), 
			AllowNull = true 
		})

		section:AddDivider()

		section:AddButton('Create Config', function()
			local name = Options.SaveManager_ConfigName.Value
			if name:gsub("%s+", "") == "" then
				return self.Library:Notify('Config name cannot be empty', 2)
			end

			local success, err = self:Save(name)
			if success then
				self.Library:Notify('Created config: ' .. name, 3)
				Options.SaveManager_ConfigList:SetValues(self:RefreshConfigList())
			else
				self.Library:Notify('Failed to save: ' .. err, 3)
			end
		end):AddButton('Load Config', function()
			local name = Options.SaveManager_ConfigList.Value
			if not name then return end

			local success, err = self:Load(name)
			if success then
				self.Library:Notify('Loaded: ' .. name, 3)
			else
				self.Library:Notify('Load failed: ' .. err, 3)
			end
		end)

		section:AddButton('Overwrite Config', function()
			local name = Options.SaveManager_ConfigList.Value
			if not name then return end
			local success, err = self:Save(name)
			if success then
				self.Library:Notify('Overwrote: ' .. name, 3)
			else
				self.Library:Notify('Overwrite failed: ' .. err, 3)
			end
		end)

		section:AddButton('Refresh List', function()
			Options.SaveManager_ConfigList:SetValues(self:RefreshConfigList())
		end)

		section:AddButton('Set as Autoload', function()
			local name = Options.SaveManager_ConfigList.Value
			if not name then return end
			writefile(self.Folder .. '/settings/autoload.txt', name)
			self.Library:Notify('Set ' .. name .. ' as autoload', 3)
		end)

		SaveManager.AutoloadLabel = section:AddLabel('Autoload: none', true)

		if isfile(self.Folder .. '/settings/autoload.txt') then
			local name = readfile(self.Folder .. '/settings/autoload.txt')
			SaveManager.AutoloadLabel:SetText('Autoload: ' .. name)
		end

		SaveManager:SetIgnoreIndexes({ 'SaveManager_ConfigList', 'SaveManager_ConfigName' })
	end

	SaveManager:BuildFolderTree()
end

return SaveManager
