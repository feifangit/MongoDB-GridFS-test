import multiprocessing
import gevent

bind = "0.0.0.0:5000"
workers = multiprocessing.cpu_count()*2+1
worker_class="gevent"
daemon=False