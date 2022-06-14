pipeline {
  agent any

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
    stage('Docker Build and Pushing') {
      steps {
        withDockerRegistry([credentialsId: "docker-hub"]) {
          sh 'docker build -t lu23/numeric-app:""$GIT_COMMIT"" .'
          sh 'docker push lu23/numeric-app:""$GIT_COMMIT""'
        }
      }
    }   
  }
}