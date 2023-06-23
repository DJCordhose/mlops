output "gitea_registry" {
  value = {
    gitea_username            = gitea_user.mlops-user.username
    gitea_password            = gitea_user.mlops-user.password
    gitea_repository_name     = gitea_repository.mlops-gitea-repository.name
    gitea_env_repository_name = gitea_repository.environment-repository.name
  }
}