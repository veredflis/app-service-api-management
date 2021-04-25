# App Service, GitHub Actions, and API Management

#token- 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

> How to deploy a frontend and backend with GitHub Action to Azure App Service, and front the backend with API Management.

## Overview

This sample shows how a developer can use GitHub Actions to set up a flexible and extensible Continuous Delivery pipeline to Azure App Service. This project has a static Vue.js frontend that communicates to a Spring Boot backend. Once these are deployed on App Service, you will set up API Management (APIM) to front the backend. Once APIM is up, you can set up API throttling, security, and more.

## Prerequisites

Before doing this tutorial, you should have the following tools installed on your machine.

1. Java 8
1. Maven
1. NPM
1. VS Code
1. Azure CLI

You will also need an Azure Subscription to create the App Service and API Management resources.

## Local set up

Before deploying to Azure, you will run the app locally to test it and get familiar.

1. Fork this repository, clone it locally, and move into the project directory.

    ```shell
    git clone https://github.com/<your-user-name>/app-service-api-management.git
    cd app-service-api-management
    ```

    **Note**: you must create your own fork of this repository so you can later configure the GitHub Actions workflows. Simply cloning this repository will not be sufficient.

1. Run the Spring Boot backend.

    ```shell
    cd backend
    mvn spring-boot:run
    ```

    This will start the backend on port 8080. Open a browser to [http://localhost:8080/tags](http://localhost:8080/tags). You should see the following JSON.

    ```json
    { "todo": "TODO" }
    ```

1. Open another terminal, and move to the `frontend/` directory to start the Vue.js frontend.

    ```bash
    npm run serve
    ```

    This will start the Webpack local development server on port `8088`. Open a browser to [http://localhost:8088](http://localhost8088) and you should see the following page.

## Create the App Service resources

Run the Azure CLI commands below to create resource group and an App Service Plan. The App Service Plan defines the compute resources available for the web apps to compute.

```bash
az group create --name apim-demo --location westus
az appservice plan create --name apim-demo-plan --resource-group apim-demo --sku B1 --is-linux
```

Next, create the Java 8 and PHP 7.3 web apps on the App Service Plan. In the commands below, replace the placeholder names (the text within the carets `<...>`) and run them. The first is a Java 8 web app to run the backend, and the next is a PHP web app to host the static Vue.js frontend.

```bash
az webapp create --name <your-backend-app-name> --runtime '"JAVA|8-jre8"' --plan apim-demo-plan --resource-group apim-demo

az webapp create --name <your-frontend-app-name> --runtime '"PHP|7.3"' --plan apim-demo-plan --resource-group apim-demo
```

## Set up Continuous Delivery

There are two YAML files under `.github/workflows/`. The first file, [`deploy-backend.yaml`](.github/workflows/deploy-backend.yaml), builds and deploys the Spring Boot backend onto our Java 8 web app. The second file, [`deploy-frontend.yaml`](.github/workflows/deploy-frontend.yaml), builds the Vue.js frontend and deploys it onto the PHP webapp to be served as static assets.

Open the two files and notice that they follow a common pattern of checking out the repository to the build VM, setting up the build tool (either Maven or NPM), building the application, and deploying it to App Service using the [`azure/webapps-deploy` action](https://github.com/azure/webapps-deploy). These workflows will only be executed when there is a push to the master branch in the respective directories.

### Prepare the workflow files

To prepare these workflow files, you need to get the deployment credentials for the two webapps created in the previous section then set them as secrets in your GitHub repository.

1. Open the [Azure Portal](https://portal.azure.com/) and navigate to each of your webapps. In the **Overview** blade, click **Get publish profile**. This will download an XML document with the deployment credentials for your webapp.

    ![Get deployment credentials](img/get-publish-profile.png)

1. Open your fork of this repository on GitHub. Navigate to **Settings** > **Secrets** and click **Add a new secret**. Create two secrets: `BACKEND_PUBLISH_PROFILE` and `FRONTEND_PUBLISH_PROFILE`. For each of these secrets, paste the contents of the XML document into the input box.

1. Open [`deploy-backend.yaml`](.github/workflows/deploy-backend.yaml) and replace `"<your-app-name>"` with your Java 8 web app's name.

1. Open [`deploy-frontend.yaml`](.github/workflows/deploy-frontend.yaml) and replace `"<your-app-name>"` with your PHP web app's name.

### Test the workflows

The deployment workflows will only execute if there is a change made in `frontend/` and `backend/` directories. Make a small change to any of the files in these directories and save your changes.

Finally, commit and push your changes to the master branch of your repository. You can see the progress of the workflows by opening your fork of the repository on GitHub and clicking the **Actions** tab.

### Connect the apps

Next, open [`config.js`](frontend/src/common/config.js) and replace line 1 with your Java 8 web apps's URL. Commit and push your changes to the master branch.

```js
export const API_URL = "http://<your-backend-webapp-name>.azurewebsites.net";
```

## Set up API Management
