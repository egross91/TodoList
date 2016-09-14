# TodoList

A sample Bluemix application that implements a TodoList iOS application that uses a Kitura web server and Cloudant database.

## Getting Started

There are two ways you can compile and provision TodoList on Bluemix. Method 1 uses the IBM Cloud Tools for Swift application. Using <a href="https://ibm-cloud-tools.mybluemix.net/" target="_blank">IBM Cloud Tools for Swift</a> is the easiest and quickest path to get TodoList up and running. Method 2 is manual, does not leverage this tool, and, therefore, takes longer but you get to understand exactly the steps that are happening behind the scenes.

## Method 1: IBM Cloud Tools for Swift

Once you have the IBM Cloud Tools for Swift application installed for Mac, you can open it to get started. On the screen for creating a new project, you will find the option to create a TodoList Project.

## Method 2: Manual configuration and deployment

1. Get an account for [Bluemix](https://new-console.ng.bluemix.net/?direct=classic)

2. Download and install the [Cloud Foundry tools](https://new-console.ng.bluemix.net/docs/starters/install_cli.html):

    ```
    cf login
    bluemix api https://api.ng.bluemix.net
    bluemix login -u username -o org_name -s space_name
    ```

    Be sure to change the directory to the Kitura-TodoList directory where the manifest.yml file is located.

3. Run `cf push`   

    ***Note** This step could take a few minutes

    ```
    1 of 1 instances running 

    App started
    ```

4. Create the Cloudant backend and attach it to your instance.

    ```
    cf create-service cloudantNoSQLDB Shared database_name
    cf bind-service Kitura-TodoList database_name
    cf restage
    ```
5. On the Bluemix console, click on the service created in step 4. Click on the green button titled `Launch`

6. Click on `Create Database` near the top right of the page after launching. Name the database whatever (repo is currently set to expect database name to be `todo`)

7. Create a design file.

  Example design file:
  
  ```json
  {
  "_id": "_design/tododb",
  "views" : {
    "all_todos" : {
      "map" : "function(doc) { if (doc.type == 'todo') { emit(doc._id, [doc._id, doc.user, doc.title, doc.completed, doc.order]); }}"
    },
    "user_todos": {
         "map": "function(doc) { if (doc.type == 'todo') { emit(doc.user, [doc._id, doc.user, doc.title, doc.completed, doc.order]); }}"
    },
    "total_todos": {
      "map" : "function(doc) { if (doc.type == 'todo') { emit(doc.id, 1); }}",
      "reduce" : "_count"
    }
  }
  }
  ```

8. Go back to the service's main page and click on `Service Credentials` which can be found directly under the service name.

9. Click on the blue button `Add New Credential` and add a new credential.

10. Push design to Bluemix using 
  ```
  curl -u "'bluemixServiceUserName':'bluemixServicePassword'" -X PUT 'bluemixServiceURL'/todolist/_design/'databaseName' --data-binary @'designFileName'
  ```
  
  - 'bluemixServiceUserName', 'bluemixServicePassword', and 'bluemixServiceURL' come from the credential made in step 9
  - 'databaseName' comes from the database made in step 6
  - 'designFileName' comes from the design file made in step 7

## Running the iOS app

Once Cloudant is running on Bluemix, you can launch the iOS application and start adding/deleting items. 



