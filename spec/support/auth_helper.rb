module AuthHelper
  def auth_header
    # sign into auth0 dashboard and get token https://manage.auth0.com/dashboard/us/dev-inz0b2tv/apis/601592bbdafa48003eb05e2b/test
    { "Authorization": "Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IlhWcnB4TkxCU1RfWmxqalZFMnRGUCJ9.eyJpc3MiOiJodHRwczovL2Rldi1pbnowYjJ0di51cy5hdXRoMC5jb20vIiwic3ViIjoidlRFUW5SODlqczllNEVPQndGVFNsRzZrZVduSnJ1ZjJAY2xpZW50cyIsImF1ZCI6Imh0dHBzOi8vbmJqYy1hcHAvYXBpIiwiaWF0IjoxNjE1Nzc3NTA2LCJleHAiOjE2MTU4NjM5MDYsImF6cCI6InZURVFuUjg5anM5ZTRFT0J3RlRTbEc2a2VXbkpydWYyIiwiZ3R5IjoiY2xpZW50LWNyZWRlbnRpYWxzIn0.ro6gzZZF756nwRoP4dH8sZiGamqoEw10mNXUOjvafqDfvuNjRd5WfNv_3UJVghXLXxdn900lWb3gPvdcz0ff-06orrsj7C3DMqAnO-j8aNtodyP2Jk3IJs80D-rAOhTNoc7Kv05_DhVoww6BBwL8GOFB0sNBik0YzVSvR7KtIwSLDOU0ZqIeUz4bb-bOE5OGUg_WPFPMwrNuzcwDaE_GagMHJGZmR6_KxvL2r7_r-skO6sM2UkYNHxdMbqs9V4bb1LM7hMoJOgpIFoPFUFeKs2nZF0ufMlJvQKb4pS94Hy1xmuHf5qZy7glKCCsOlcK5RnO29Nx9yIEt26wAnBEZZg"}
  end
end