'''
Flask app: fetch file from MongoDB GridFS
'''
 # pylint: disable=C0103,E0611
from flask import Flask
from werkzeug import Response
from pymongo import MongoClient
import gridfs

app = Flask(__name__)
db = MongoClient().test1
fs = gridfs.GridFS(db)

@app.route("/getfile/<string:filename>/")
def fetch_gridfs_file(filename):
    '''aaa'''
    stream = fs.get(filename)
    return Response(stream, 
        mimetype=stream.content_type, 
        direct_passthrough=True)

if __name__ == "__main__":
    app.run(debug=False)
