pipeline {
  agent any

  environment {
    AWS_REGION  = "ap-south-2"
    ACCOUNT_ID  = "442880721659"
    ECR_REGISTRY = "%ACCOUNT_ID%.dkr.ecr.%AWS_REGION%.amazonaws.com"
    ECR_REPO     = "%ECR_REGISTRY%/s3-app"
  }

  stages {

    stage('Checkout') {
      steps {
        git branch: 'main',
            url: 'https://github.com/nenavathsrinu/eks-prod-cicd-working.git'
      }
    }

    stage('ECR Login') {
      steps {
        withCredentials([
          [
            $class: 'AmazonWebServicesCredentialsBinding',
            credentialsId: 'aws-cred'   // make sure this ID exists
          ]
        ]) {
          bat '''
          echo AWS_REGION=%AWS_REGION%
          echo ACCOUNT_ID=%ACCOUNT_ID%

          aws sts get-caller-identity

          aws ecr get-login-password --region %AWS_REGION% ^
          | docker login --username AWS --password-stdin %ECR_REGISTRY%
          '''
        }
      }
    }

    stage('Build Image') {
      steps {
        bat '''
        cd apps\\s3-app
        docker build -t s3-app:%BUILD_NUMBER% .
        docker tag s3-app:%BUILD_NUMBER% %ECR_REPO%:%BUILD_NUMBER%
        '''
      }
    }

    stage('Push Image') {
      steps {
        bat '''
        docker push %ECR_REPO%:%BUILD_NUMBER%
        '''
      }
    }

    stage('Deploy to EKS') {
      steps {
        bat '''
        cd apps\\s3-app
        powershell -Command "(Get-Content k8s\\deployment.yaml) -replace 'IMAGE_TAG','%BUILD_NUMBER%' | Set-Content k8s\\deployment.yaml"
        kubectl apply -f k8s\\
        '''
      }
    }
  }
}
