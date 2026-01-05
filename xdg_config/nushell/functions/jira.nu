export def get [path] {
    let config_file = try {
        $env.JIRA_CONFIG_FILE
    } catch {
        $"($env.HOME)/.config/.jira/.config.yml"
    }

    let config = $config_file | open
    let login = $config.login
    let server = $config.server

    let token = $"($login):($env.JIRA_API_TOKEN)" | encode base64
    let headers = [ Authorization $"Basic ($token)"]

    http get --headers $headers $"($server)/($path)"
}

export def "fields list" [] {
    get rest/api/3/field | sort-by id
}

# https://developer.atlassian.com/cloud/jira/platform/rest/v3/api-group-issue-fields/#api-rest-api-3-field-search-get
export def "fields search" [--id: string] {
    let query = [
        {key: "id", value: $id}
    ]
    | where { |x| $x.value | is-not-empty }
    | url build-query

    get rest/api/3/field/search?($query)
}

export def "fields get" [id] {
    get rest/api/3/field/($id)/option
}

export def "custom-field get" [id] {
    get rest/api/3/customFieldOption/($id)
}

export def "issue editmeta" [issue_key] {
    get rest/api/2/issue/($issue_key)/editmeta
}
