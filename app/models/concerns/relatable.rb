module Relatable
  extend ActiveSupport::Concern
  included do
    has_many :source_relations, as: :source, class_name: "Relation", dependent: :destroy
    has_many :target_relations, as: :target, class_name: "Relation", dependent: :destroy
  end

  def related_records
    Relation.where(source: self).or(Relation.where(target: self))
  end

  def related(type = nil)
     records = related_records.includes(:source, :target).map do |r|
       r.source == self ? r.target : r.source
     end
     type ? records.select { |r| r.is_a?(type) } : records
  end

  private

  def sync_relations(model_class, ids)
    ids = ids.reject(&:blank?).map(&:to_i)
    current_ids = related(model_class).map(&:id)

    to_remove = current_ids - ids
    to_remove.each do |id|
      target = model_class.find(id)
      related_records.where(source: self, target: target)
        .or(related_records.where(source: target, target: self))
        .destroy_all
    end

    to_add = ids - current_ids
    to_add.each do |id|
      Relation.create(source: self, target: model_class.find(id))
    end
  end
end
