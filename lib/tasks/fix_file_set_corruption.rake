namespace :scholars_archive do
  desc "Correct corrupted ordered_members and ordered_member_ids for file_sets"
  task fix_file_set_corruption: :environment do
    datetime_today = Time.now.strftime("%Y%m%d%H%M%S") # "20171021125903"
    Rails.logger.info "Processing bulk changes for file_sets"

    ::FileSet.find_each do |file_set|
    rescue Ldp::Gone, ActiveFedora::ModelMismatch, ActiveFedora::ObjectNotFoundError => e
      Rails.logger.warn e
      failed_arr << hit["id"]
      failed_item += 1
    end
  end
end
