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
			<Item Name="Web Browser.vi" Type="VI" URL="../../Examples/Web Browser.vi"/>
		</Item>
		<Item Name="Source" Type="Folder">
			<Item Name="WebView.lvclass" Type="LVClass" URL="../WebView_class/WebView.lvclass"/>
			<Item Name="WebView.Tabulator.lvclass" Type="LVClass" URL="../WebView.Tabulator_class/WebView.Tabulator.lvclass"/>
			<Item Name="Component.lvclass" Type="LVClass" URL="../Component_class/Component.lvclass"/>
			<Item Name="Component.JSONEditor.lvclass" Type="LVClass" URL="../Component.JSONEditor_class/Component.JSONEditor.lvclass"/>
		</Item>
		<Item Name="Message Types--enum.ctl" Type="VI" URL="../WebView.Tabulator_class/Message Types--enum.ctl"/>
		<Item Name="Parse JSON Schema.vi" Type="VI" URL="../../JSON Schema to Cluster Generator/Parse JSON Schema.vi"/>
		<Item Name="types--enum.ctl" Type="VI" URL="../../JSON Schema to Cluster Generator/types--enum.ctl"/>
		<Item Name="Parse JSON Schema Recursive.vi" Type="VI" URL="../../JSON Schema to Cluster Generator/Parse JSON Schema Recursive.vi"/>
		<Item Name="Dependencies" Type="Dependencies"/>
		<Item Name="Build Specifications" Type="Build"/>
	</Item>
</Project>
