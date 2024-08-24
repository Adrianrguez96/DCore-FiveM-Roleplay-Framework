JobController = function (PlayerController)
    local this = {}

    this.pController = PlayerController

    this.Jobs = {}

    this.InitJobs = function(jobs)
        for _,job in pairs(jobs) do
            this.Jobs[job.hash] = Job(job)
        end

        this.InitJobsRanks()
    end

    -- Init job ranks
    this.InitJobsRanks = function(job)
        Core.Database.GetAllJobsRank(function(ranks)
            for _,rank in pairs(ranks) do
                local job = this.GetJob(rank.jobHash)
                job.AddRank(rank)
            end
        end)
    end

    -- Get job by hash name 
    this.GetJob = function (hashName)
        return this.Jobs[hashName] or nil
    end

    this.GetAllJobs = function()
        local jobs = {}
        for _,job in pairs(this.Jobs) do
            local dataJob = job.JobClientEntity()
            if dataJob.uniqueJob == 1 then
                jobs[#jobs + 1] = job.JobClientEntity()
            end
        end
        return jobs
    end

    return this
end