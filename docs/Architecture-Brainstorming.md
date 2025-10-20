# WebView Components Architecture - Brainstorming Notes

**Date:** October 20, 2025  
**Topic:** ECharts Integration, Image Streaming, and Component Architecture

---

## Table of Contents
1. [ECharts vs Other Charting Libraries](#echarts-vs-other-charting-libraries)
2. [Chart Type Options](#chart-type-options)
3. [Real-Time Data Updates](#real-time-data-updates)
4. [Image Streaming from IMAQ](#image-streaming-from-imaq)
5. [Component Architecture](#component-architecture)
6. [Communication Patterns](#communication-patterns)

---

## ECharts vs Other Charting Libraries

### Performance Comparison (10 Hz, 100K points)

| Library | Real-time 10Hz | 100K Points | WebGL Support | Bundle Size | Verdict |
|---------|---------------|-------------|---------------|-------------|---------|
| **Plotly** | ⚠️ Struggles | ✅ Yes (WebGL) | ✅ Yes | ❌ ~3MB | Good for large static, poor for high-freq |
| **Chart.js** | ❌ Poor | ❌ No | ❌ No | ✅ ~200KB | Not suitable |
| **ECharts** | ✅ Excellent | ✅ Yes | ⚠️ Partial | ✅ ~900KB | **Best for requirements** |

### Why ECharts is the Winner

**Strengths:**
- ✅ Built-in data sampling (LTTB algorithm)
- ✅ Progressive rendering
- ✅ Incremental updates via `appendData()`
- ✅ Stream mode optimized for real-time
- ✅ Large data mode for 100K+ points
- ✅ Handles 10-30 Hz sustained
- ✅ Reasonable bundle size

**Key Features:**
```javascript
series: [{
  type: 'line',
  large: true,              // Enable large data mode
  largeThreshold: 2000,     // Threshold
  sampling: 'lttb',         // Smart downsampling
  progressive: 5000,        // Chunk rendering
  animation: false          // Performance
}]
```

---

## Chart Type Options

### Line Chart
```javascript
series: [{
  type: 'line',
  smooth: true,              // Curved lines
  areaStyle: {},             // Fill area
  lineStyle: { width: 2 },
  symbol: 'circle',          // Data point markers
  symbolSize: 4,
  step: false,               // Step line: 'start', 'middle', 'end'
  stack: 'Total',            // Stacking
  sampling: 'lttb'           // Performance
}]
```

**Best for:** Time series, trends, continuous data

---

### Scatter Chart
```javascript
series: [{
  type: 'scatter',
  data: [[x1, y1], [x2, y2]],  // [x,y] pairs
  symbolSize: 10,              // Or function for bubble charts
  large: true,                 // Critical for 100K+ points
  largeThreshold: 2000,
  itemStyle: {
    color: '#5470c6',
    opacity: 0.8
  }
}]
```

**Best for:** Correlation analysis, distributions, large datasets (100K+)

---

### Bar Chart
```javascript
series: [{
  type: 'bar',
  barWidth: '40%',
  barGap: '30%',              // Gap between series
  itemStyle: {
    borderRadius: [5, 5, 0, 0]  // Rounded tops
  },
  showBackground: true,
  stack: 'Total'              // Stacked bars
}]
```

**Best for:** Category comparison, not suitable for high-frequency updates

---

### Multiple Chart Types

**Decision:** Limit to one chart type per instance for visual clarity.

**Multiple series of same type is OK:**
```javascript
series: [
  { name: 'Sensor 1', type: 'line', data: [...] },
  { name: 'Sensor 2', type: 'line', data: [...] },
  { name: 'Sensor 3', type: 'line', data: [...] }
]
```

---

## Real-Time Data Updates

### `setOption()` vs `appendData()`

#### setOption() - Full Update
```javascript
myChart.setOption({
  xAxis: { data: ['A', 'B', 'C', 'D'] },
  series: [{ data: [10, 20, 30, 40] }]
});
```

**Characteristics:**
- ⚠️ Slower - recalculates entire dataset
- ✅ Full control - can update anything
- ✅ Flexible - title, legend, axes, series
- **Max frequency:** ~5 Hz
- **Use for:** Initial setup, configuration changes

---

#### appendData() - Incremental Update ⭐ RECOMMENDED
```javascript
myChart.appendData({
  seriesIndex: 0,
  data: [[newX, newY]]  // Just the new point
});
```

**Characteristics:**
- ✅ Very fast - only processes new data
- ✅ Low memory - only sends new points
- ✅ Optimized for streaming
- **Max frequency:** 10-30 Hz
- **Use for:** Real-time data acquisition

**Requirements:**
- ✅ X-axis must be 'value' or 'time' (not 'category')
- ✅ Data format must be [x, y] pairs
- ✅ Enable large data mode

```javascript
xAxis: { type: 'value' },  // Required
series: [{
  data: [[0, 10], [1, 20]],  // [x,y] format required
  large: true,
  largeThreshold: 2000
}]
```

---

## Image Streaming from IMAQ

### Architecture: SharedBuffer Approach ⭐ OPTIMAL

```
LabVIEW IMAQ → Flatten RGB → SharedBuffer → JavaScript → Canvas
```

### Why SharedBuffer?

**Performance:**
| Method | Speed | Max FPS | Overhead |
|--------|-------|---------|----------|
| **SharedBuffer** | ⭐⭐⭐⭐⭐ | 60+ FPS | Zero-copy |
| Base64 String | ⭐⭐ | ~10 FPS | Encoding |
| Data URI | ⭐ | ~5 FPS | Very slow |

**Advantages:**
- ✅ Zero-copy transfer
- ✅ No serialization overhead
- ✅ Binary data stays binary
- ✅ 60+ FPS with 1080p images
- ✅ Low latency
- ✅ Efficient memory usage

---

### Message Format

```json
{
  "type": "imageFrame",
  "bufferId": "unique-buffer-id",
  "width": 640,
  "height": 480,
  "format": "RGB",
  "stride": 1920
}
```

### Supported Formats
- **RGB (24-bit)**: R, G, B (3 bytes/pixel)
- **BGR (24-bit)**: B, G, R (3 bytes/pixel, Windows DIB)
- **RGBA (32-bit)**: R, G, B, A (4 bytes/pixel)
- **Grayscale (8-bit)**: Single channel (1 byte/pixel)

---

### JavaScript Implementation

```javascript
async function displayImageFromSharedBuffer(msg) {
  const { bufferId, width, height, format, stride } = msg;
  
  // Get SharedBuffer
  const sharedBuffer = chrome.webview.sharedbufferreceived.getBuffer(bufferId);
  const arrayBuffer = sharedBuffer.slice(0);
  
  // Release immediately
  chrome.webview.releaseBuffer(bufferId);
  
  // Convert to ImageData
  const imageData = createRGBImageData(arrayBuffer, width, height, stride);
  
  // Draw to canvas
  ctx.putImageData(imageData, 0, 0);
}
```

---

### Performance Optimizations

#### 1. ImageBitmap API (Easy Win)
```javascript
const bitmap = await createImageBitmap(imageData);
ctx.drawImage(bitmap, 0, 0);
bitmap.close();
```
**Benefit:** 10-30% faster than `putImageData()`

#### 2. OffscreenCanvas + Worker (Maximum Performance)
```javascript
// Main thread
const offscreen = canvas.transferControlToOffscreen();
worker.postMessage({ canvas: offscreen }, [offscreen]);

// Worker processes images off main thread
```
**Benefit:** UI stays responsive, >60 FPS possible

#### 3. Double Buffering
Use two SharedBuffers alternating to prevent tearing.

---

### Typical Performance

| Resolution | RGB Size | Expected FPS |
|------------|----------|--------------|
| 640x480    | 900 KB   | 60 FPS |
| 1280x720   | 2.6 MB   | 45 FPS |
| 1920x1080  | 6.2 MB   | 30 FPS |
| 3840x2160  | 24.8 MB  | 15 FPS |

---

## Component Architecture

### LVOOP Design with Interfaces

```
IContainer.lvclass (Interface)
├── LoadComponent(componentHTML)
├── PostMessage(data)
├── RegisterCallback(eventName, callbackVI)
└── GetSize() → width, height

WebView.lvclass (implements IContainer)
├── Single component display
├── Direct HTML load
└── Full viewport

GridStackWebView.lvclass (implements IContainer)
├── Multi-component dashboard
├── GridStack.js integration
├── AddWidget(componentHTML, x, y, w, h)
└── RemoveWidget(widgetId)
```

---

### Component Classes

```
ECharts.lvclass
├── GetHTML() → Returns HTML string
├── Update(data) → Post to container
└── Container Reference (IContainer)

IMAQ.lvclass
├── GetHTML() → Returns HTML string
├── SendFrame(imageData) → SharedBuffer
└── Container Reference (IContainer)

JSONEditor.lvclass
├── GetHTML() → Returns HTML string
├── LoadJSON(json, schema)
└── Container Reference (IContainer)
```

---

### Deployment Flexibility

**Single Component:**
```labview
container := WebView.Init()
chart := ECharts.Init(container)
chart.LoadIntoContainer()
chart.Update(data)
```

**Dashboard with Multiple Components:**
```labview
container := GridStackWebView.Init()
chart1 := ECharts.Init(container)
chart2 := ECharts.Init(container)
imaq := IMAQ.Init(container)

container.AddWidget(chart1, x:0, y:0, w:6, h:4)
container.AddWidget(chart2, x:6, y:0, w:6, h:4)
container.AddWidget(imaq, x:0, y:4, w:12, h:6)
```

**Key Benefit:** Same component code works in both containers!

---

### JavaScript Base Component

```javascript
class BaseComponent {
  constructor(containerId) {
    this.containerId = containerId;
    this.container = null;
  }
  
  init() {
    this.container = document.getElementById(this.containerId);
  }
  
  destroy() { }
  resize(width, height) { }
  
  onMessage(data) { }  // Override
  
  postToLabVIEW(type, data) {
    window.chrome.webview.postMessage({ type, data });
  }
  
  getGridStackConfig() {
    return { minWidth: 2, minHeight: 2 };
  }
}
```

**Child Components:**
```javascript
class EChartsComponent extends BaseComponent {
  init() {
    super.init();
    this.chart = echarts.init(this.container);
  }
  
  onMessage(data) {
    if (data.type === 'setOption') {
      this.chart.setOption(data.option);
    }
  }
}

class IMAQComponent extends BaseComponent { ... }
class JSONEditorComponent extends BaseComponent { ... }
```

**Benefits:**
- ✅ Consistent API across components
- ✅ Code reuse (lifecycle, messaging)
- ✅ Easy to add new component types
- ✅ GridStack integration built-in
- ✅ Automatic resize handling

---

### GridStack Integration

**Automatic Wrapping:**
```javascript
function addWidget(componentHTML, x, y, w, h) {
  // GridStackWebView wraps component HTML
  const wrapped = `
    <div class="grid-stack-item-content">
      ${componentHTML}  // Pure component HTML
    </div>
  `;
  
  grid.addWidget(wrapped, { x, y, w, h });
}
```

**Component stays pure:**
- ✅ No GridStack knowledge in component
- ✅ Works in WebView OR GridStackWebView
- ✅ Wrapping logic isolated in container

---

## Communication Patterns

### PostMessage vs ExecuteScriptAsync

#### PostMessage ✅ RECOMMENDED (99% of cases)

```labview
// LabVIEW
message = { type: "updateChart", data: {...} }
PostWebMessage(JSON.stringify(message))
```

```javascript
// JavaScript
window.chrome.webview.addEventListener('message', (event) => {
  const msg = event.data;
  switch(msg.type) {
    case 'updateChart': updateChart(msg.data); break;
  }
});
```

**Advantages:**
- ✅ Type-safe JSON
- ✅ Asynchronous, non-blocking
- ✅ Bidirectional communication
- ✅ Event-driven pattern
- ✅ Secure (no code injection)
- ✅ Debuggable in DevTools
- ✅ 3-5x faster than ExecuteScript

---

#### ExecuteScriptAsync ⚠️ USE SPARINGLY

```labview
// Only for debugging/initialization
ExecuteScriptAsync("console.log('test')")
```

**When to use:**
- ✅ Quick debugging
- ✅ One-time initialization
- ✅ Simple queries

**Never use for:**
- ❌ Passing complex data
- ❌ Regular communication
- ❌ User-generated content (injection risk)

---

### Message Routing Pattern

```javascript
// Central message router
window.chrome.webview.addEventListener('message', (event) => {
  const { componentId, type, data } = event.data;
  
  // Route to specific component
  const component = ComponentRegistry.get(componentId);
  if (component) {
    component.onMessage({ type, data });
  }
});
```

**LabVIEW usage:**
```labview
GridStackWebView.PostMessage("chart-1", { type: "update", data: {...} })
GridStackWebView.PostMessage("imaq-1", { type: "imageFrame", ... })
```

---

## Library Bundling Strategy

### Development vs Production

**Development (CDN):**
```html
<script src="https://cdn.jsdelivr.net/npm/echarts@5.4.3/dist/echarts.min.js"></script>
```
- ✅ Fast iteration
- ✅ No build step
- ✅ Browser caching

**Production (Bundled):**
```html
<script src="echarts-lib/echarts.min.js"></script>
```
- ✅ Works offline
- ✅ Single file distribution
- ✅ No external dependencies

---

### Build Options

#### Option 1: Manual Inline (Simple)
Download files, reference locally.

#### Option 2: Vite Build (Professional)
```bash
npm run build  # Creates single bundled HTML
```

**Use Vite if:**
- Multiple components in one file
- Want optimization/minification
- Building complex dashboard

**Skip Vite if:**
- Single HTML file is simple enough
- LabVIEW developers don't need Node.js

---

## Summary: Key Decisions

### ✅ Confirmed Choices

1. **Charting Library:** ECharts
   - Handles 10 Hz updates with 100K points
   - Best performance for real-time streaming

2. **Image Streaming:** SharedBuffer
   - Zero-copy, 60 FPS capable
   - Supports RGB, BGR, RGBA, Grayscale

3. **Architecture:** LVOOP with IContainer interface
   - Components work in WebView or GridStackWebView
   - Maximum flexibility

4. **Component Design:** JavaScript base class
   - Consistent API
   - GridStack integration built-in
   - Easy extensibility

5. **Communication:** PostMessage primary
   - Type-safe, secure, fast
   - ExecuteScriptAsync only for debug

6. **Chart Types:** Single type per instance
   - Visual clarity
   - Multiple series of same type allowed

7. **Updates:** Use `appendData()` for real-time
   - 10-30 Hz capable
   - Low overhead

---

## Next Steps

1. Create BaseComponent.js
2. Implement EChartsComponent with appendData()
3. Implement IMAQComponent with SharedBuffer
4. Create GridStackWebView.lvclass
5. Build component registry
6. Test performance with 100K points at 10 Hz
7. Test image streaming at various resolutions

---

**End of Brainstorming Notes**
