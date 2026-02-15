class NonPlayerCharacter < ApplicationRecord
  include Relatable

  belongs_to :campaign
  has_rich_text :description
  has_rich_text :notes
  has_one_attached :featured_image

  def related_npc_ids
     related(NonPlayerCharacter).map(&:id)
   end

   def related_npc_ids=(ids)
     sync_relations(NonPlayerCharacter, ids)
   end

   def related_location_ids
     related(Location).map(&:id)
   end

   def related_location_ids=(ids)
     sync_relations(Location, ids)
   end

end
