pipeline {
  agent any

  environment {
    SQB_TOKEN = 'sqb-token'
  }

  stages {
    stage('Build Artifact - Maven') {
      steps {
        sh "mvn clean package -DskipTests=true"
        archive 'target/*.jar'
      }
    }
    stage('Unit Tests - JUnit and Jacoco') {
      steps {
        sh "mvn test"
      }
      post {
        always {
          junit 'target/surefire-reports/*.xml'
          jacoco execPattern: 'target/jacoco.exec'
        }
      }
    }
    stage('Mutation Tests - PIT') {
      steps {
        sh "mvn org.pitest:pitest-maven:mutationCoverage"
      }
      post {
        always {
          pitmutation mutationStatsFile: '**/target/pit-reports/**/mutations.xml'
        }
      }
    }

    stage('Sonarqube - SAST') {
      steps {
        sh "mvn sonar:sonar -Dsonar.projectKey=numeric-application -Dsonar.host.url=http://devsecops-deep.westeurope.cloudapp.azure.com:9000 -Dsonar.login=${SQB_TOKEN}"
      }
    }
    stage('Docker Build and Pushing') {
      steps {
        withDockerRegistry([credentialsId: "docker-hub", url: ""]) {
          sh 'docker build -t lu23/numeric-app:""$GIT_COMMIT"" .'
          sh 'docker push lu23/numeric-app:""$GIT_COMMIT""'
        }
      }
    }
    stage('Kubernetes Deployment - Dev') {
      steps {
        withKubeConfig([credentialsId: 'kubeconfig']) {
          sh "sed -i 's#replace#lu23/numeric-app:$GIT_COMMIT#g' k8s_deployment_service.yaml"
          sh "kubectl apply -f k8s_deployment_service.yaml"
        }
      }
    }  
  }
}