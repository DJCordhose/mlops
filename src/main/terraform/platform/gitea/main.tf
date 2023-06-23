resource "gitea_user" "mlops-user" {
  username             = "mlops-user"
  login_name           = "mlops-user"
  password             = "Password1234!"
  email                = "mlops-user@user.dev"
  must_change_password = false
}

resource "gitea_repository" "mlops-gitea-repository" {
  username     = gitea_user.mlops-user.username
  name         = "mlops-gitea-repository"
  private      = false
  issue_labels = "Default"
  license      = "MIT"
}

resource "gitea_repository" "environment-repository" {
  username     = gitea_user.mlops-user.username
  name         = "environment-repository"
  private      = false
  issue_labels = "Default"
  license      = "MIT"
}

locals {
  basic_auth = base64encode("${gitea_user.mlops-user.username}:${gitea_user.mlops-user.password}")
}

resource "null_resource" "create-push-webhomlops" {
  provisioner "local-exec" {
    command = <<EOF
      printf "\nCreating a Webhomlops for the Push Trigger in Gitea: \n"
      curl -d '{"type": "gitea", "config": { "url": "http://el-ci-listener.cicd.svc.cluster.local:8080", "content_type": "json"}, "events": ["push"], "active": true}' \
        -H "Content-Type: application/json" \
        -H "authorization: Basic ${local.basic_auth}" \
        -X POST http://localhost:30030/api/v1/repos/${gitea_user.mlops-user.username}/${gitea_repository.mlops-gitea-repository.name}/homlopss
    EOF
  }
}