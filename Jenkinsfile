pipeline {
  agent any

  environment {
    AWS_REGION = "ap-south-2"
    ACCOUNT_ID = "442880721659"
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
            credentialsId: 'aws-cred'
          ]
        ]) {
          bat '''
          set ECR_REGISTRY=%ACCOUNT_ID%.dkr.ecr.%AWS_REGION%.amazonaws.com
          aws ecr get-login-password --region %AWS_REGION% ^
          | docker login --username AWS --password-stdin %ECR_REGISTRY%
          '''
        }
      }
    }

    stage('Build & Push Image') {
      steps {
        bat '''
        set ECR_REPO=%ACCOUNT_ID%.dkr.ecr.%AWS_REGION%.amazonaws.com/s3-irsa-app

        cd apps\\s3-app
        docker build -t s3-irsa-app:%BUILD_NUMBER% .
        docker tag s3-irsa-app:%BUILD_NUMBER% %ECR_REPO%:%BUILD_NUMBER%
        docker push %ECR_REPO%:%BUILD_NUMBER%
        '''
      }
    }

    stage('Deploy via Terraform (Same as GitHub Actions)') {
      steps {
        withCredentials([
          [
            $class: 'AmazonWebServicesCredentialsBinding',
            credentialsId: 'aws-cred'
          ]
        ]) {
          bat '''
          cd infra
          terraform init -input=false
          terraform apply -auto-approve ^
            -var="image_tag=%BUILD_NUMBER%"
          '''
        }
      }
    }
  }
}
