# frozen_string_literal: true

require "rails"
require "decidim/core"

module Decidim
  module ExtraUserFields
    # This is the engine that runs on the public interface of extra_user_fields.
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::ExtraUserFields

      routes do
        # Add engine routes here
        # resources :extra_user_fields
        # root to: "extra_user_fields#index"
      end

      initializer "decidim_extra_user_fields.assets" do |app|
        app.config.assets.precompile += %w[decidim_extra_user_fields_manifest.js decidim_extra_user_fields_manifest.css]
      end

      initializer "decidim_extra_user_fields.registration_additions" do
        Decidim::RegistrationForm.class_eval do
          include ExtraUserFields::FormsDefinitions
        end

        Decidim::AccountForm.class_eval do
          include ExtraUserFields::FormsDefinitions
        end

        Decidim::CreateRegistration.class_eval do
          prepend ExtraUserFields::CommandsOverrides
        end

        Decidim::UpdateAccount.class_eval do
          prepend ExtraUserFields::CommandsOverrides
        end
      end
    end
  end
end