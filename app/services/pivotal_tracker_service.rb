# TODO: This needs some specs bad..
class PivotalTrackerService
  def initialize(token, project_id, name)
    @name = name
    @project_id = project_id

    PivotalService.set_token(token)
  end

  def active_stories(dates)
    recent_activities = PivotalService.activity(@project_id, 0, 1000)

    users_recent_activities =
      recent_activities.select do |activity|
        activity[:message] =~ /#{@name}/ &&
          activity[:message] =~ /completed task|started|finished/ &&
          dates.include?(DateTime.parse(activity[:occurred_at]).to_date)
      end

    users_recent_activities.map do |activity|
      activity[:primary_resources].map { |x| {
        date: DateTime.parse(activity[:occurred_at]).to_date,
        id: x[:id], name: x[:name] } }
    end \
    .flatten \
    .uniq
  end
end