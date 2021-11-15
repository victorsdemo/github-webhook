class WebhooksController < ApplicationController
  WEBHOOK_HEADERS = %w[HTTP_USER_AGENT CONTENT_TYPE HTTP_X_GITHUB_EVENT HTTP_X_GITHUB_DELIVERY HTTP_X_HUB_SIGNATURE]

  #before_action :verify_signature!

  def create
    puts "Webhook successfully received!!!"
    WEBHOOK_HEADERS.each do |header|
      puts "#{header}: #{request.headers[header]}"
    end
    event = JSON.parse(params[:payload])
    type = request.headers["HTTP_X_GITHUB_EVENT"]
    case type
    when "repository"
      repository_handler(event)
    when "ping"
      render(status: 202, json: "ping received")
    else
      error("Unsupported event type: #{type}")
    end
  end

  private

  def error(msg)
    text = "Webhook invalid: #{msg}"
    puts text
    render(status: 422, json: text)
  end

  def octokit
    Octokit::Client.new(access_token: ENV["GITHUB_PERSONAL_ACCESS_TOKEN"])
  end

  def repository_handler(event)
    if event["action"] == 'created'
      repo = event["repository"]["full_name"]
      protect_master_branch(repo)
    else
      error("Unsupported event action")
    end
  end

  # Protect the default branch on new repositories
  def protect_master_branch(repo)
    options = {
      # This header is necessary for beta access to the branch_protection API
      # See https://docs.github.com/en/rest/reference/repos#branches
      # https://docs.github.com/en/rest/reference/repos#get-branch-protection
      accept: 'application/vnd.github.v3+json',
      # Require at least two approving reviews on a pull request before merging
      required_pull_request_reviews: { required_approving_review_count: 2 },
      # Enforce all configured restrictions for administrators
      enforce_admins: true
    }
    octokit.branch_protection(repo, "main", options)
    issue = octokit.create_issue(
      repo,
      "Master branch protected",
      "he master branch has been protected on this repo per https://docs.github.com/en/rest/reference/repos#get-branch-protection"
    )
    octokit.close_issue(repo, issue["number"])
  end

  def verify_signature!
    secret = ENV["GITHUB_WEBHOOK_SECRET"]

    signature = 'sha1='
    signature += OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), secret, request.body.read)

    unless Rack::Utils.secure_compare(signature, request.env['HTTP_X_HUB_SIGNATURE'])
      guid = request.headers["HTTP_X_GITHUB_DELIVERY"]
      error("unable to verify payload for #{guid}")
    end
  end
end
