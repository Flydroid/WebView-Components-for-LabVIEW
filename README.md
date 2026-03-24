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

**Initialization:**

Place a `WebView` control on your front panel, then call `Component.JSONEditor_Init.vi`, passing in the control reference and a LabVIEW User Event refnum obtained from `Get JSONEditor Events.vi`.

**Methods:**

| VI | Description |
|---|---|
| `Load JSON.vi` | Loads a JSON string into the editor |
| `Set Editor Mode.vi` | Switches between editor modes: Tree, View, Form, Code, Text |

**Events** (via `Event Handler.vi`):

Register the User Event from `Get JSONEditor Events.vi` in a LabVIEW Event Structure. The following events are generated:

| Event | Data | Trigger |
|---|---|---|
| `JSON Updated` | JSON string | User edits the JSON content |
| `Selected Node Path` | Path string | User selects a node in the tree |

**Typical usage:**
1. Call `Get JSONEditor Events.vi` to create the event refnum
2. Call `Component.JSONEditor_Init.vi` with the WebView control reference and event refnum
3. Call `Event Handler.vi` in a parallel loop to pump incoming WebView messages into LabVIEW events
4. Handle events in your main Event Structure
5. Call `Load JSON.vi` to populate the editor
6. Call `Destroy.vi` on shutdown

---

### Tabulator

Embeds the [Tabulator.js](https://tabulator.info) library (v6.2.5), providing an interactive data table inside a LabVIEW panel.

**Initialization:**

Place a `WebView` control on your front panel, then call `Component.Tabulator_Init.vi`, passing in the control reference.

**Methods:**

| VI | Description |
|---|---|
| `Load Data.vi` | Loads a JSON array of objects into the table |

**Typical usage:**
1. Call `Component.Tabulator_Init.vi` with the WebView control reference
2. Call `Load Data.vi` with your JSON data array
3. Call `Destroy.vi` on shutdown