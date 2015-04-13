class API < Grape::API
  mount V22::ScoreViewer
  mount V22::Developer
  mount V22::Native
end
