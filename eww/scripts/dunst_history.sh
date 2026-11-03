#!/bin/bash
dunstctl history | jq -c '[.data[] | .[] | {id: .id.data, app: .appname.data, summary: .summary.data, body: .body.data}]'
