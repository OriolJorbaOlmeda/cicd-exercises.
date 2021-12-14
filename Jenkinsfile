pipeline {
    agent any
    
    stages {
        stage('Clonning') {
            steps {
                git 'https://github.com/OriolJorbaOlmeda/CI-CD-project'
            }
        }
        stage('Build') {
            steps {
                echo "sh 'virtualenv venv && . venv/bin/activate && pip install -r requirements.txt'"
            }
        }
        stage('Test') {
            steps {
                echo "sh 'pytest test.py'"
            }
        }
        stage('Creating Dockerfile') {
            steps {
                echo "sh'docker build -t flask-app:latest .'"
            }
        }
        stage('Exposing Dockerfile') {
            steps {
                echo "sh 'docker run -d -p 5000:5000 flask-app'"
            }
        }
        stage('Pulling Docker Image') {
            steps {
                echo "sh 'docker tag flask-oriol oriol8/flask-app:flask-oriol'"
                echo "sh 'docker push oriol8/flask-app'"
            }
        }
        stage('Creating Kuberentes Deployment') {
            steps {
                echo "sh 'kubectl apply -f deploy.yaml'"
            }
        }
        stage('Creating Kuberentes Service') {
            steps {
                echo "sh 'kubectl apply -f service.yaml'"
            }
        }
        
    }
}
