#!/usr/bin/env groovy

dockerRegistryDomain = '979633842206.dkr.ecr.eu-west-1.amazonaws.com'
dockerRegistryUrl = "https://${dockerRegistryDomain}"
ecrCredentialId = 'ecr:eu-west-1:cita-devops'

dockerImage = null
app = "image-resizer"

node("docker && awsaccess") {
  
  cleanWs()

  stage("build") {
    checkout scm

    dockerTag = "${env.BRANCH_NAME}_${getSha()}"
    currentBuild.displayName = "${env.BUILD_NUMBER}: ${dockerTag}"

    withDockerRegistry(registry: [credentialsId: 'docker_hub']) {
      dockerImage = docker.build("${app}:${dockerTag}")
    }
  }

  stage("test"){
    dockerImage.inside {
      sh "bundle exec rspec"
    }
  }

  stage("push to ECR") {
    docker.withRegistry(dockerRegistryUrl, ecrCredentialId) {
      dockerImage.push()
      dockerImage.push("latest")
      sh "docker rmi ${app}:${dockerTag} -f || true"
    }
  }
}
