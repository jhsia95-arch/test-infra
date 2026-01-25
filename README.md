
# To trigger the pipeline
add a trailing "#" in any of the terraform file

git add .

git commit -m "update"

git push

This is will trigger the pipeline provisioned the neccessary resource. More details of what will be provisioned is covered in the documentation

# Values to take note
Take note of the arn of secrets manager that was provisioned together with the RDS in the output step "Get RDS secrets arn"

Update the arn value in test-app/helm/appcharts/templates/externalsecrets.yaml

        DATABASE_URL: >- # to update with dbname connection details

          postgresql://dbadmin:{{.password}}@<connection details>:5432/postgresdb

  dataFrom: # to update with secrets manager arn

    - extract:

        key: <rds_arn> #to update with secrets arn after terraform provisioned the db