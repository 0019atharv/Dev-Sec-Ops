pipeline {
    
    agent any
    environment{
        SONAR_HOME = tool "Sonar"
    }
    stages {
        
        stage("Code"){
            steps{
                git url: "https://github.com/krishnaacharyaa/wanderlust.git" , branch: "master"
                echo "Code Cloned Successfully"
            }
        }
        stage('Build Docker Image') {
            steps {
                sh 'docker build -t devops-batch-6:latest .'
            }
        }

        stage("SonarQube Analysis"){
            steps{
               withSonarQubeEnv("Sonar"){
                   sh "$SONAR_HOME/bin/sonar-scanner -Dsonar.projectName=devops -Dsonar.projectKey=devops -X"
               }
            }
        }
        stage("OWASP"){
            steps{
                dependencyCheck additionalArguments: '--scan ./', odcInstallation: 'dc'
                dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
            }
        }
        
        stage("SonarQube Quality Gates"){
            steps{
               timeout(time: 1, unit: "MINUTES"){
                   waitForQualityGate abortPipeline: false
               }
            }
        }
        
        stage("Trivy"){
            steps{
                sh "trivy fs --format table -o trivy-fs-report.html ."
                
            }
        }
        stage("Push to Private Docker Hub Repo"){
            steps{
                withCredentials([usernamePassword(credentialsId:"DockerHubCreds",passwordVariable:"dockerPass",usernameVariable:"dockerUser")]){
                sh "docker login -u ${env.dockerUser} -p ${env.dockerPass}"
                sh "docker tag devops-batch-6:latest ${env.dockerUser}/devops-batch-6:latest"
                sh "docker push ${env.dockerUser}/devops-batch-6:latest"
                }
                
            }
        }
        stage("Deploy"){
            steps{
                sh "docker-compose up -d"
                echo "App Deployed Successfully"
            }
        }
    }
}
