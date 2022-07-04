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

  stage("lint"){
    dockerImage.inside {
      sh "bundle exec rubocop"
    }
  }

  stage("test"){
    dockerImage.inside {
      sh "bundle exec rspec"
    }
  }

  stage("push to ECR") {
    docker.withRegistry(dockerRegistryUrl, ecrCredentialId) {
      image_tag = false
      if (env.BRANCH_NAME == "main") {
        image_tag = "latest"
      }
      if (env.CHANGE_BRANCH ==~ /^v\d+((.\d+){0,2}(-[0-9A-Za-z-]+(\.[0-9A-Za-z-]+)*)?)?$/) {
        image_tag = env.CHANGE_BRANCH
      }
      if (image_tag) {
        echo "pushing to registry ${ecrRepoName}:${image_tag}"
        sh "docker buildx create --use"
        sh "docker buildx build --push --tag='${dockerRegistryDomain}/${ecrRepoName}:${image_tag}' --platform=linux/amd64,linux/arm64 ."
      }
    }
  }
}
