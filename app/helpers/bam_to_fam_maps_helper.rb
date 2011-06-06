module BamToFamMapsHelper
  def feature_hierarchy(feature)
    hierarchy = []
    for ba in feature.functional_work_unit.business_area.ancestors
      hierarchy << ba.name
    end
    hierarchy << feature.functional_work_unit.business_area.name
    hierarchy << feature.functional_work_unit.name
    hierarchy.join(" >> ")
  end
end

