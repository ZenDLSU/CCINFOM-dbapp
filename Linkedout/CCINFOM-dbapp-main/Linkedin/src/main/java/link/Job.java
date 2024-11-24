package link;

public class Job {
    private final int jobID;
    private final String positionName;
    private final int yearsOfExperience;
    private final String education;
    private final String companyName;
    private final String branchDetails;

    // Constructor to initialize the final fields
    public Job(int jobID, String positionName, int yearsOfExperience, String education, 
               String companyName, String branchDetails) {
        this.jobID = jobID;
        this.positionName = positionName;
        this.yearsOfExperience = yearsOfExperience;
        this.education = education;
        this.companyName = companyName;
        this.branchDetails = branchDetails;
    }

    Job(int aInt, String string, int aInt0, String string0) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    public int getJobID() {
        return jobID;
    }

    public String getPositionName() {
        return positionName;
    }

    public int getYearsOfExperience() {
        return yearsOfExperience;
    }

    public String getEducation() {
        return education;
    }

    public String getCompanyName() {
        return companyName;
    }

    public String getBranchDetails() {
        return branchDetails;
    }
}
