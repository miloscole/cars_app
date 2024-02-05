module Shared
  module DeleteHelper
    def association_warning_msg(name, objects_name)
      "Deleting #{name} will remove the association with all associated #{objects_name}.

        Are you sure you want to continue?"
    end
  end
end
