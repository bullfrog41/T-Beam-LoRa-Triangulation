$(python3 << 'EOFPYTHON'
import json
with open('/tmp/chunk_0.json') as f:
    data = json.load(f)
    print(data['INDEX.md'])
EOFPYTHON
)