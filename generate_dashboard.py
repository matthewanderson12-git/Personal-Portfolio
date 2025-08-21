import csv, json
from collections import defaultdict
from datetime import datetime

# Read sales data
sales = defaultdict(lambda: defaultdict(float))
months = []
with open('data/sales_data.csv') as f:
    reader = csv.DictReader(f)
    for row in reader:
        date = datetime.strptime(row['date'], '%Y-%m-%d')
        month_label = date.strftime('%Y-%m')
        if month_label not in months:
            months.append(month_label)
        product = row['product']
        revenue = float(row['revenue'])
        sales[product][month_label] += revenue

products = sorted(sales.keys())
# Build datasets for Chart.js
chart_datasets = []
colors = ['#e41a1c', '#377eb8', '#4daf4a', '#984ea3']
for i, product in enumerate(products):
    data = [sales[product].get(m, 0) for m in months]
    chart_datasets.append({
        'label': product,
        'data': data,
        'borderColor': colors[i % len(colors)],
        'fill': False
    })

# Write HTML dashboard
html = f"""
<!DOCTYPE html>
<html>
<head>
    <meta charset='utf-8'>
    <title>Sales Dashboard</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
    <h1>Monthly Revenue by Product</h1>
    <canvas id="revenueChart" width="800" height="400"></canvas>
    <script>
        const ctx = document.getElementById('revenueChart').getContext('2d');
        const chart = new Chart(ctx, {{
            type: 'line',
            data: {{
                labels: {json.dumps(months)},
                datasets: {json.dumps(chart_datasets)}
            }},
            options: {{
                responsive: true,
                scales: {{
                    y: {{ beginAtZero: true }}
                }}
            }}
        }});
    </script>
</body>
</html>
"""

with open('dashboard.html', 'w') as f:
    f.write(html)

print('Dashboard generated: dashboard.html')
