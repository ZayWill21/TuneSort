resource "aws_amplify_app" "amplify" {
  name = "TuneSort-App-${var.env}"
  repository = "https://github.com/ZayWill21/TuneSort.git"
}