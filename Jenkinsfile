pipeline {
  agent any

  environment {
    AWS_REGION = "ap-south-1"
    ACCOUNT_ID = "442880721659"
    ECR_REPO   = "${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/s3-app"
    IMAGE_TAG  = "${BUILD_NUMBER}"
  }

  stages {

    stage('Checkout Code') {
      steps {
        git branch: 'main',
            url: 'https://github.com/nenavathsrinu/eks-prod-cicd-working.git'
      }
    }

    stage('ECR Login') {
      steps {
        sh '''
          aws ecr get-login-password --region $AWS_REGION \
          | docker login --username AWS --password-stdin $ECR_REPO
        '''
      }
    }

    stage('Build Docker Image') {
      steps {
        sh '''
          cd apps/s3-app
          docker build -t s3-app:$IMAGE_TAG .
          docker tag s3-app:$IMAGE_TAG $ECR_REPO:$IMAGE_TAG
        '''
      }
    }

    stage('Push Image to ECR') {
      steps {
        sh '''
          docker push $ECR_REPO:$IMAGE_TAG
        '''
      }
    }

    stage('Deploy to EKS') {
      steps {
        sh '''
          cd apps/s3-app
          sed -i "s|IMAGE_TAG|$IMAGE_TAG|g" k8s/deployment.yaml
          kubectl apply -f k8s/
        '''
      }
    }
  }
}
