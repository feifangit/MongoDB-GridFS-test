'''
Write different size files to MongoDB, run on MongoDB server
'''
 # pylint: disable=C0103,E0611
import gridfs
from pymongo import MongoClient

db = MongoClient().test1
fs = gridfs.GridFS(db)

testFiles = {"1k": 1, "100k": 100, "1m":1024, "100m": 102400}

# generate test files
for fn, fsize in testFiles.items():
    with open(fn, "wb") as f:
        for i in xrange(fsize):
            f.write("x"*1024)

# write to GridFS
for fn in testFiles.keys():
    record = fs.put(file(fn), filename=fn, _id=fn)  # _id for pymongo API access
    print record
