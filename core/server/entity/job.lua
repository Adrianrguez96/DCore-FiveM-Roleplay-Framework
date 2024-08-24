Job = function(jobData) 

    local this = {}

    this.id = jobData.id
    this.hash = jobData.hash
    this.name = jobData.name
    this.jobAccount = jobData.jobAccount
    this.uniqueJob = jobData.uniqueJob

    this.jobRank = {}

    -- Add job rank
    this.AddRank = function (rank)
        this.jobRank[#this.jobRank + 1] = rank
    end

    -- Get job ranks
    this.GetRanks = function()
        return this.jobRank
    end

    -- Send the job data Entity
    this.JobClientEntity = function()
        return {
            id = this.id,
            hash = this.hash,
            name = this.name,
            jobAccount = this.jobAccount,
            uniqueJob = this.uniqueJob,
            ranks = this.jobRank
        }
    end
    
    return this

end