require 'async_job'

class SubmissionObserver < ActiveRecord::Observer
  observe VotingApp::Request

  def notify_accepted(notification)
    @notification = Notifier.request_accepted(notification.submission)
    @notification.deliver
  end

  def notify_completed(notification)
    @notification = Notifier.request_completed(notification.submission)
    @notification.deliver
  end

  def notify_created(notification)
    @notification = Notifier.new_request(notification.submission)
    @notification.deliver
  end

  def notify_liked(notification)
  end

  def notify_promoted(notification)
    @notification = Notifier.request_promoted(notification.submission)
    @notification.deliver
  end

  def notify_rejected(notification)
    @notification = Notifier.request_rejected(notification.submission)
    @notification.deliver
  end
end
