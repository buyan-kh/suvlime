interface LineChartProps {
  series: number[];
  placebo: number[];
  width?: number;
  height?: number;
}

export function LineChart({ series, placebo, width = 480, height = 220 }: LineChartProps) {
  const min = Math.min(...series, ...placebo);
  const max = 0;
  const padX = 36;
  const padY = 24;
  const w = width - padX * 2;
  const h = height - padY * 2;
  const len = series.length;
  const sx = (i: number) => padX + (i / (len - 1)) * w;
  const sy = (v: number) => padY + ((v - max) / (min - max)) * h;
  const path = (arr: number[]) =>
    arr.map((v, i) => `${i === 0 ? "M" : "L"} ${sx(i).toFixed(1)} ${sy(v).toFixed(1)}`).join(" ");
  const area = (arr: number[]) =>
    `${path(arr)} L ${sx(len - 1).toFixed(1)} ${padY + h} L ${padX} ${padY + h} Z`;

  const ticks: number[] = [];
  for (let v = 0; v >= min; v -= 5) ticks.push(v);

  return (
    <svg className="va-chart-svg" viewBox={`0 0 ${width} ${height}`} preserveAspectRatio="none">
      {ticks.map((t) => (
        <g key={t}>
          <line
            x1={padX}
            x2={width - padX}
            y1={sy(t)}
            y2={sy(t)}
            stroke="rgba(31,26,20,0.08)"
            strokeDasharray={t === 0 ? "0" : "2 4"}
          />
          <text
            x={padX - 8}
            y={sy(t) + 3}
            textAnchor="end"
            fontFamily="JetBrains Mono, monospace"
            fontSize="9"
            fill="rgba(31,26,20,0.5)"
          >
            {t}%
          </text>
        </g>
      ))}
      <defs>
        <linearGradient id="va-grad" x1="0" x2="0" y1="0" y2="1">
          <stop offset="0%" stopColor="#C2624A" stopOpacity="0.18" />
          <stop offset="100%" stopColor="#C2624A" stopOpacity="0" />
        </linearGradient>
      </defs>
      <path d={area(series)} fill="url(#va-grad)" />
      <path d={path(placebo)} fill="none" stroke="#7A6F61" strokeWidth="1.5" strokeDasharray="3 3" />
      <path d={path(series)} fill="none" stroke="#C2624A" strokeWidth="2.5" strokeLinejoin="round" strokeLinecap="round" />
      <circle cx={sx(len - 1)} cy={sy(series[len - 1])} r="4" fill="#C2624A" />
      <text
        x={sx(len - 1) - 6}
        y={sy(series[len - 1]) - 10}
        textAnchor="end"
        fontFamily="Instrument Serif, serif"
        fontSize="14"
        fill="#9B4A36"
        fontWeight="500"
      >
        {series[len - 1]}%
      </text>
    </svg>
  );
}
