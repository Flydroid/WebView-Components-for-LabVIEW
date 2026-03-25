# WebView Components for LabVIEW

A set of LabVIEW components built on the WebView2 control that embed interactive web-based UI elements directly into LabVIEW front panels. Each component wraps an HTML/JavaScript library and communicates with LabVIEW via a bidirectional WebView message channel.

---

## Examples

Ready-to-run example VIs are located in the `Examples/` folder:

| VI | Description |
|---|---|
| `JSON Editor.vi` | Demonstrates the JSONEditor component — loads a sample JSON, handles edit and node-selection events |
| `Tabulator.vi` | Demonstrates the Tabulator component — loads sample data into the table |

---

## Components

### JSONEditor

Embeds the [JSONEditor](https://github.com/josdejong/jsoneditor) library, providing an interactive JSON tree/text editor inside a LabVIEW panel.

**Methods:**

| VI | Description |
|---|---|
| `Load JSON.vi` | Loads a JSON string into the editor |
| `Set Editor Mode.vi` | Switches between editor modes: Tree, View, Form, Code, Text |

**Events** (via `Event Handler.vi`):

| Event | Data | Trigger |
|---|---|---|
| `JSON Updated` | JSON string | User edits the JSON content |
| `Selected Node Path` | Path string | User selects a node in the tree |

---

### Tabulator

Embeds the [Tabulator.js](https://tabulator.info) library (v6.2.5), providing an interactive data table inside a LabVIEW panel.

**Methods:**

| VI | Description |
|---|---|
| `Load Data.vi` | Loads a JSON array of objects into the table |
