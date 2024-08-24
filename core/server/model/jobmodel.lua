Core.Database.GetJobs = function(callback) 
    Core.Database.SelectAll("SELECT * FROM jobs",function(result)
        return callback(result or {})
    end)
end

Core.Database.GetAllJobsRank = function(callback) 
    Core.Database.SelectAll("SELECT * FROM job_ranks",function(result)
        return callback(result or {})
    end)
end