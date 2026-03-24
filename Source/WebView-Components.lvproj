<?xml version='1.0' encoding='UTF-8'?>
<Project Type="Project" LVVersion="20008000">
	<Property Name="NI.LV.All.SaveVersion" Type="Str">20.0</Property>
	<Property Name="NI.LV.All.SourceOnly" Type="Bool">true</Property>
	<Property Name="NI.Project.Description" Type="Str"></Property>
	<Item Name="My Computer" Type="My Computer">
		<Property Name="NI.SortType" Type="Int">3</Property>
		<Property Name="server.app.propertiesEnabled" Type="Bool">true</Property>
		<Property Name="server.control.propertiesEnabled" Type="Bool">true</Property>
		<Property Name="server.tcp.enabled" Type="Bool">false</Property>
		<Property Name="server.tcp.port" Type="Int">0</Property>
		<Property Name="server.tcp.serviceName" Type="Str">My Computer/VI Server</Property>
		<Property Name="server.tcp.serviceName.default" Type="Str">My Computer/VI Server</Property>
		<Property Name="server.vi.callsEnabled" Type="Bool">true</Property>
		<Property Name="server.vi.propertiesEnabled" Type="Bool">true</Property>
		<Property Name="specify.custom.address" Type="Bool">false</Property>
		<Item Name="Examples" Type="Folder">
			<Item Name="Tabulator.vi" Type="VI" URL="../../Examples/Tabulator.vi"/>
			<Item Name="JSON Editor.vi" Type="VI" URL="../../Examples/JSON Editor.vi"/>
		</Item>
		<Item Name="Source" Type="Folder">
			<Item Name="Component.lvclass" Type="LVClass" URL="../Component_class/Component.lvclass"/>
			<Item Name="Component.Tabulator.lvclass" Type="LVClass" URL="../Component.Tabulator_class/Component.Tabulator.lvclass"/>
			<Item Name="Component.JSONEditor.lvclass" Type="LVClass" URL="../Component.JSONEditor_class/Component.JSONEditor.lvclass"/>
		</Item>
		<Item Name="Test Set Column.vi" Type="VI" URL="../Component.Tabulator_class/Test Set Column.vi"/>
		<Item Name="Dependencies" Type="Dependencies"/>
		<Item Name="Build Specifications" Type="Build"/>
	</Item>
</Project>
