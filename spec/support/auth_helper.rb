module AuthHelper
  def auth_header
    # sign into auth0 dashboard and get token https://manage.auth0.com/dashboard/us/dev-inz0b2tv/apis/601592bbdafa48003eb05e2b/test
    { "Authorization": "Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IlhWcnB4TkxCU1RfWmxqalZFMnRGUCJ9.eyJpc3MiOiJodHRwczovL2Rldi1pbnowYjJ0di51cy5hdXRoMC5jb20vIiwic3ViIjoiQ3hwQkttZ2p3RzR0TGlaRndjcG1VdFZBblNPa2I4YVJAY2xpZW50cyIsImF1ZCI6Imh0dHBzOi8vbmJqYy1hcHAvYXBpIiwiaWF0IjoxNjE1OTkyMTgwLCJleHAiOjE2MTYwNzg1ODAsImF6cCI6IkN4cEJLbWdqd0c0dExpWkZ3Y3BtVXRWQW5TT2tiOGFSIiwiZ3R5IjoiY2xpZW50LWNyZWRlbnRpYWxzIn0.oJGx5LYUevN7r7ZV1AeQu7OIVmdiqiYPhNxLZhGaoh_LOIdvrquJCj4EAln09E2MzyMYAh3AtyGnIW17DPRrkm22zrd3HugOKNqFQmdnkz9R0Dx2dHyraUJHPDluFuavA8tXxOaLKWI9ADdNzN04PH_Z5XJJ_98_e8pkrWqS88CTuj0FhTddmHOYFxS2zS-T0y4uV41PuTdPOnAJHB3vj02BLRotplruUvDaFMNEcE8gmFCwagiSIMP4dIK3qBY97vvLTUEOQ1qSttDO-psj-kSX3AZlQh2dp8BMZhXaiTBF5pvSXJSSF_XQvjpa_9MNtoEYqzCy04R5rj8-xr_baw"}
  end
end
