contract("FemtoFemtoDB", function(accounts) {
  it("should store information for each account separately", function(done) {
    var target = accounts[2];
    var key = 23;
    var value_0 = 42;
    var value_1 = 43;
    var db;

    FemtoDB.new().
    then(function(result) { db = result }).
    then(function() { return db.put(target, key, value_0, {from: accounts[0]}) }).
    then(function() { return db.put(target, key, value_1, {from: accounts[1]}); }).
    then(function() { return db.put(target, key, value_1, {from: accounts[1]}); }).
    then(function() { return db.get.call(accounts[0], target, key); }).
    then(function(result) {
      assert.equal(result, value_0);
    }).
    then(function() { return db.get.call(accounts[1], target, key); }).
    then(function(result) {
      assert.equal(result, value_1);
      done();
    }).catch(done);
  });

  it("should store information for each target separately", function(done) {
    var target_0 = accounts[2];
    var target_1 = 0;
    var key = 23;
    var value_0 = 42;
    var value_1 = 43;
    var db;

    FemtoDB.new().
    then(function(result) { db = result }).
    then(function() { return db.put(target_0, key, value_0); }).
    then(function() { return db.put(target_1, key, value_1); }).
    then(function() { return db.get.call(accounts[0], target_0, key); }).
    then(function(result) {
      assert.equal(result, value_0);
    }).
    then(function() { return db.get.call(accounts[0], target_1, key); }).
    then(function(result) {
      assert.equal(result, value_1);
      done();
    }).catch(done);
  });

  it("should issue an event on puts", function(done) {
    var target = accounts[2];
    var key = 23;
    var value = 42;

    FemtoDB.new().
      then(function(db) {
        var put_event = db.LogPut({});

        put_event.watch(function(err, result) {
          put_event.stopWatching();
          if (err) { throw err }

          assert.equal(result.args.owner, accounts[0]);
          assert.equal(result.args.target, target);
          assert.equal(result.args.key, key);
          assert.equal(result.args.value, value);
          done();
        });

        db.put(target, key, value, {from: accounts[0]}).catch(done);
      }).catch(done);
  });

  it("should store a unique id on put events", function(done) {
    var target = accounts[2];
    var key = 23;
    var value = 42;

    FemtoDB.new().
      then(function(db) {
        var put_event = db.LogPut({});

        put_event.watch(function(err, result) {
          if (result.args.revisionID < 3) { return; } // skip the first two

          put_event.stopWatching();
          if (err) { throw err }

          assert.equal(result.args.revisionID, 3);
          done();
        });

        db.revisionID().
          then(function(result) {
            assert.equal(result, 0);
          }).
          then(function() { return db.put(target, key, value) }).
          then(function() { return db.revisionID() }).
          then(function(result) {
            assert.equal(result, 1);
          }).
          then(function() { return db.put(target, key, value) }).
          then(function() { return db.revisionID() }).
          then(function(result) {
            assert.equal(result, 2);
          }).
          then(function() { return db.put(target, key, value) }).
          catch(done);
        });
  });
});
