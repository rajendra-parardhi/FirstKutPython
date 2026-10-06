export function collectPages(documentNode) {
  if (!documentNode || !documentNode.children) return [];
  // CANVAS nodes represent the individual pages inside a Figma file
  return documentNode.children.filter(node => node.type === "CANVAS");
}

export function createPageLevelJson(pageNode) {
  if (!pageNode) return null;

  // Recursive cleaning function to trim Figma properties and decrease payload size for the LLM
  const cleanNode = (node) => {
    if (!node) return null;
    const cleaned = {
      id: node.id,
      name: node.name,
      type: node.type,
      bbox: node.absoluteBoundingBox || node.boundingBox,
    };
    
    if (node.fills) {
      cleaned.fills = node.fills.map(f => ({
        type: f.type,
        color: f.color,
        imageRef: f.imageRef,
        src: f.src
      }));
    }
    
    if (node.characters) cleaned.text = node.characters;
    
    if (node.style) {
      cleaned.style = {
        fontSize: node.style.fontSize,
        fontWeight: node.style.fontWeight,
        textAlign: node.style.textAlignHorizontal
      };
    }
    
    if (node.children) {
      cleaned.children = node.children.map(cleanNode).filter(Boolean);
    }
    return cleaned;
  };

  return cleanNode(pageNode);
}

export function generateCodeForPage(pageNode, { format, componentName }) {
  const children = pageNode.children || [];
  
  if (format === "html") {
    let css = `
      .figma-container {
        position: relative;
        width: 100%;
        min-height: 100vh;
        background-color: #0f111a;
        color: #ffffff;
        padding: 40px;
        box-sizing: border-box;
      }
      .element-card {
        margin-bottom: 20px; 
        padding: 24px; 
        background: #161824; 
        border-radius: 8px;
        border: 1px solid #2a2e45;
      }
      .element-title {
        font-size: 16px;
        font-weight: 600;
        margin-bottom: 8px;
        color: #f97316;
      }
      .element-text {
        font-size: 14px;
        color: #8892b0;
      }
    `;
    
    let html = `<div class="figma-container">\n`;
    html += `  <h1 style="margin-bottom: 30px;">Compiled from Figma: ${componentName}</h1>\n`;
    
    children.forEach(child => {
      html += `  <div class="element-card">\n`;
      html += `    <div class="element-title">${child.name} (${child.type})</div>\n`;
      if (child.characters) {
        html += `    <div class="element-text">${child.characters}</div>\n`;
      }
      if (child.fills && child.fills.some(f => f.src)) {
        const imageFill = child.fills.find(f => f.src);
        html += `    <img src="${imageFill.src}" alt="${child.name}" style="max-width: 100%; height: auto; border-radius: 4px; margin-top: 12px;" />\n`;
      }
      html += `  </div>\n`;
    });
    html += `</div>`;
    
    return `<!DOCTYPE html>\n<html>\n<head>\n<meta charset="utf-8">\n<title>${componentName}</title>\n<style>\n${css}\n</style>\n</head>\n<body>\n${html}\n</body>\n</html>`;
  } else if (format === "flutter") {
    return `import 'package:flutter/material.dart';\n\nclass ${componentName} extends StatelessWidget {\n  const ${componentName}({Key? key}) : super(key: key);\n\n  @override\n  Widget build(BuildContext context) {\n    return Scaffold(\n      backgroundColor: const Color(0xFF0F111A),\n      appBar: AppBar(\n        title: const Text('Figma Compiled: ${componentName}'),\n        backgroundColor: const Color(0xFF161824),\n      ),\n      body: ListView(\n        padding: const EdgeInsets.all(24.0),\n        children: [\n          ${children.map(c => `_buildComponentCard('${c.name}', '${c.type}')`).join(',\n          ')}\n        ],\n      ),\n    );\n  }\n\n  Widget _buildComponentCard(String name, String type) {\n    return Card(\n      color: const Color(0xFF161824),\n      margin: const EdgeInsets.only(bottom: 16.0),\n      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),\n      child: ListTile(\n        title: Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),\n        subtitle: Text(type, style: const TextStyle(color: Color(0xFF8892B0))),\n      ),\n    );\n  }\n}`;
  } else {
    return `import React from 'react';\n\nexport default function ${componentName}() {\n  return (\n    <div className="min-h-screen bg-[#0f111a] text-white p-8">\n      <header className="mb-8 border-b border-gray-800 pb-4">\n        <h1 className="text-2xl font-bold">${componentName}</h1>\n        <p className="text-sm text-gray-400">Component compiled from Figma Layout JSON</p>\n      </header>\n      \n      <div className="grid gap-6">\n        ${children.map(c => `<div className="p-6 bg-[#161824] border border-[#2a2e45] rounded-lg">\n          <h3 className="text-lg font-semibold text-orange-500 mb-2">${c.name}</h3>\n          <span className="inline-block text-xs bg-gray-800 text-gray-400 px-2 py-0.5 rounded mb-4">${c.type}</span>\n          ${c.characters ? `<p className="text-sm text-gray-300">${c.characters}</p>` : ""}\n        </div>`).join('\n        ')}\n      </div>\n    </div>\n  );\n}`;
  }
}