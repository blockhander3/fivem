local mysql = false

function init()
  MySQL.Async.fetchAll('SELECT * FROM `blckhndr_properties`', {}, function(res)

  end)
end

MySQL.ready(function()
    mysql = true
    init()
end)
