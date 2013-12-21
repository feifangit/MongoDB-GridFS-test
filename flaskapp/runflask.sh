#!/bin/bash
gunicorn -c gunicorncfg.py flaskapp:app