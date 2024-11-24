package link;

import java.util.Date;

public class JobApplication {
    private int jobId;
    private String positionName;
    private String status;
    private Date postingDate;
    private Date expiryDate;

    // Constructor
    public JobApplication(int jobId, String positionName, String status, Date postingDate, Date expiryDate) {
        this.jobId = jobId;
        this.positionName = positionName;
        this.status = status;
        this.postingDate = postingDate;
        this.expiryDate = expiryDate;
    }

    // Getters and Setters
    public int getJobId() {
        return jobId;
    }

    public void setJobId(int jobId) {
        this.jobId = jobId;
    }

    public String getPositionName() {
        return positionName;
    }

    public void setPositionName(String positionName) {
        this.positionName = positionName;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Date getPostingDate() {
        return postingDate;
    }

    public void setPostingDate(Date postingDate) {
        this.postingDate = postingDate;
    }

    public Date getExpiryDate() {
        return expiryDate;
    }

    public void setExpiryDate(Date expiryDate) {
        this.expiryDate = expiryDate;
    }

    @Override
    public String toString() {
        return "JobApplication{" +
                "jobId=" + jobId +
                ", positionName='" + positionName + '\'' +
                ", status='" + status + '\'' +
                ", postingDate=" + postingDate +
                ", expiryDate=" + expiryDate +
                '}';
    }
}
