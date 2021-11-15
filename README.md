# github-webhook

The servicerepo is a simple web service that listens for organization events to know when a repository has been created. When a repository is created it automates the protection of the master branch. It also notifies the user with an @mention in an issue within the repository that outlines the protections that were added.

<p align="center">
  <a href="#mega-prerequisites">Prerequisites</a> •  
  <a href="#books-resources">Resources</a>
</p>

## :mega: Prerequisites
- A GitHub account
- A ngrok account
- A working installation of Docker
- Some familiarity with coding (preferrably in ruby)
- Some familiarity with git
- Some familiarity with GitHub

## :books: Resources
- [GitHub Account Creation](https://github.com/join)
- [Create an Access Token](https://github.com/settings/tokens/new)
- [Ruby-lang](https://www.ruby-lang.org/en/)
- [Git Cheat Sheet](https://education.github.com/git-cheat-sheet-education.pdf)
- [Docker installation](https://www.docker.com/products/docker-desktop)
- [ngrok](https://dashboard.ngrok.com/get-started/setup)

## :books: References
- [Webhooks With REST](https://github.com/githubsatelliteworkshops/webhooks-with-rest)
- [branchguard](https://github.com/branchguard/branchguard/blob/master/app.rb)