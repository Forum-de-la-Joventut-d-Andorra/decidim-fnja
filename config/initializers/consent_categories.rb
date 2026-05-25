# frozen_string_literal: true

Decidim.configure do |config|
  config.consent_categories = [
    {
      slug: "essential",
      mandatory: true,
      items: [
        {
          type: "cookie",
          name: "_session_id"
        },
        {
          type: "cookie",
          name: Decidim.consent_cookie_name
        },
        {
          type: "cookie",
          name: "remember_user_token"
        }
      ]
    },
    {
      slug: "preferences",
      mandatory: false,
      items: [
        {
          type: "localstorage",
          name: "emojiPicker-recent"
        },
        {
          type: "localstorage",
          name: "graphiql:docExplorerOpen"
        },
        {
          type: "localstorage",
          name: "graphiql:editorFlex"
        },
        {
          type: "localstorage",
          name: "graphiql:historyPaneOpen"
        },
        {
          type: "localstorage",
          name: "graphiql:queries"
        },
        {
          type: "localstorage",
          name: "graphiql:query"
        },
        {
          type: "localstorage",
          name: "graphiql:tabState"
        }
      ]
    }
  ]
end
