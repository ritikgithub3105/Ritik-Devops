#!/bin/bash

# Inputs: Repo URL and Days for which report should be generated
repo_url=$1
days=$2

# Set the output file name with current date and days
output_file="commit_report_$(date +%Y%m%d)_${days}_days.csv"
# Clone the repository
git clone "$repo_url" temp_repo
cd temp_repo || exit 1

# Prepare CSV output file in the parent directory (outside of temp_repo)
echo "Commit ID,Author Name,Author Email,Commit Message,Changed Files" > "../$output_file"

# Get the commit details and read line by line
git log --since="$days days ago" --pretty=format:"%H|%an|%ae|%s" | while IFS= read -r commit; do
    commit_id=$(echo "$commit" | cut -d'|' -f1)
    author_name=$(echo "$commit" | cut -d'|' -f2)
    author_email=$(echo "$commit" | cut -d'|' -f3)
    commit_message=$(echo "$commit" | cut -d'|' -f4)
    
    # Get the changed files
    changed_files=$(git show --pretty="" --name-only "$commit_id" | paste -sd "," -)

    # Append commit details to the CSV file (outside temp_repo)
    echo "$commit_id,$author_name,$author_email,\"$commit_message\",$changed_files" >> "../$output_file"
done

# Clean up
cd ..
rm -rf temp_repo

echo "CSV report generated: $output_file"
