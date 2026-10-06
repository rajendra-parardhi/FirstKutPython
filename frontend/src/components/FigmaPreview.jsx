import React from "react";

export function FigmaPreview({ activePage }) {
  if (!activePage) {
    return (
      <div className="text-center p-4">
        <p className="text-[10px] text-gray-500">Waiting for Figma JSON data...</p>
      </div>
    );
  }

  const frames = activePage.children || [];

  return (
    <div className="w-full h-full p-4 overflow-auto flex flex-col gap-4">
      <div className="flex items-center justify-between border-b border-white/5 pb-2">
        <span className="text-[11px] font-semibold text-gray-400">Page Canvas Preview: {activePage.name}</span>
        <span className="text-[10px] bg-[#0ACF83]/10 text-[#0ACF83] px-2 py-0.5 rounded-full">
          {frames.length} frames found
        </span>
      </div>
      
      <div className="flex-1 grid grid-cols-2 gap-4">
        {frames.map((frame) => (
          <div 
            key={frame.id} 
            className="border border-white/10 bg-[#161824] rounded-lg p-3 flex flex-col gap-2 shadow-md relative"
          >
            <div className="flex items-center justify-between">
              <span className="text-xs font-semibold text-white truncate max-w-[120px]">{frame.name}</span>
              <span className="text-[9px] uppercase bg-white/5 text-gray-400 px-1.5 py-0.5 rounded">
                {frame.type}
              </span>
            </div>
            
            {/* Simulated visual representation of frame components */}
            <div className="flex-1 min-h-[100px] bg-[#0f111a] border border-white/5 rounded p-2 flex flex-col gap-1.5 overflow-hidden">
              {frame.children && frame.children.map((child, idx) => (
                <div key={idx} className="flex items-center justify-between bg-white/5 p-1 rounded text-[8px] text-gray-300">
                  <span className="truncate max-w-[100px]">{child.name}</span>
                  <span className="text-[7px] text-[#0ACF83]">{child.type}</span>
                </div>
              ))}
              {(!frame.children || frame.children.length === 0) && (
                <div className="flex-1 flex items-center justify-center text-[9px] text-gray-600 italic">
                  Empty Frame
                </div>
              )}
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}