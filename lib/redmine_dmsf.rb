# frozen_string_literal: true

# Redmine plugin for Document Management System "Features"
#
# Copyright © 2011    Vít Jonáš <vit.jonas@gmail.com>
# Copyright © 2012    Daniel Munn <dan.munn@munnster.co.uk>
# Copyright © 2011-23 Karel Pičman <karel.picman@kontron.com>
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

# DMSF libraries

# Validators
require "#{File.dirname(__FILE__)}/../app/validators/dmsf_file_name_validator"
require "#{File.dirname(__FILE__)}/../app/validators/dmsf_max_file_size_validator"
require "#{File.dirname(__FILE__)}/../app/validators/dmsf_workflow_name_validator"
require "#{File.dirname(__FILE__)}/../app/validators/dmsf_url_validator"
require "#{File.dirname(__FILE__)}/../app/validators/dmsf_folder_parent_validator"

# Plugin's patches
require "#{File.dirname(__FILE__)}/redmine_dmsf/patches/formatting_helper_patch"
require "#{File.dirname(__FILE__)}/redmine_dmsf/patches/projects_helper_patch"
require "#{File.dirname(__FILE__)}/redmine_dmsf/patches/project_patch"
require "#{File.dirname(__FILE__)}/redmine_dmsf/patches/user_preference_patch"
require "#{File.dirname(__FILE__)}/redmine_dmsf/patches/user_patch"
require "#{File.dirname(__FILE__)}/redmine_dmsf/patches/issue_patch"
require "#{File.dirname(__FILE__)}/redmine_dmsf/patches/role_patch"
require "#{File.dirname(__FILE__)}/redmine_dmsf/patches/queries_controller_patch"
require "#{File.dirname(__FILE__)}/redmine_dmsf/patches/pdf_patch"
require "#{File.dirname(__FILE__)}/redmine_dmsf/patches/access_control_patch"
require "#{File.dirname(__FILE__)}/redmine_dmsf/patches/search_patch"
require "#{File.dirname(__FILE__)}/redmine_dmsf/patches/search_controller_patch"

# A workaround for obsolete 'alias_method' usage in RedmineUp's plugins
if RedmineDmsf::Plugin.an_obsolete_plugin_present?
  require "#{File.dirname(__FILE__)}/redmine_dmsf/patches/notifiable_ru_patch"
else
  require "#{File.dirname(__FILE__)}/redmine_dmsf/patches/notifiable_patch"
end

if defined?(EasyExtensions)
  require "#{File.dirname(__FILE__)}/redmine_dmsf/patches/easy_crm_case_patch"
  require "#{File.dirname(__FILE__)}/redmine_dmsf/patches/attachable_patch"
  require "#{File.dirname(__FILE__)}/redmine_dmsf/patches/easy_crm_cases_controller_patch.rb"
  require "#{File.dirname(__FILE__)}/redmine_dmsf/patches/xapian_easy_search_helper_patch.rb"
  require "#{File.dirname(__FILE__)}/redmine_dmsf/patches/application_helper_patch.rb"

  # Mappers
  require "#{File.dirname(__FILE__)}/xapian_easy_search/dmsf_file_mapper.rb"
  require "#{File.dirname(__FILE__)}/xapian_easy_search/dmsf_folder_mapper.rb"
end

# Load up classes that make up our WebDAV solution ontop of Dav4rack
require "#{File.dirname(__FILE__)}/dav4rack"
require "#{File.dirname(__FILE__)}/redmine_dmsf/webdav/custom_middleware"
require "#{File.dirname(__FILE__)}/redmine_dmsf/webdav/base_resource"
require "#{File.dirname(__FILE__)}/redmine_dmsf/webdav/dmsf_resource"
require "#{File.dirname(__FILE__)}/redmine_dmsf/webdav/index_resource"
require "#{File.dirname(__FILE__)}/redmine_dmsf/webdav/project_resource"
require "#{File.dirname(__FILE__)}/redmine_dmsf/webdav/resource_proxy"

# Errors
require "#{File.dirname(__FILE__)}/redmine_dmsf/errors/dmsf_access_error"
require "#{File.dirname(__FILE__)}/redmine_dmsf/errors/dmsf_email_max_file_size_error"
require "#{File.dirname(__FILE__)}/redmine_dmsf/errors/dmsf_file_not_found_error"
require "#{File.dirname(__FILE__)}/redmine_dmsf/errors/dmsf_lock_error"
require "#{File.dirname(__FILE__)}/redmine_dmsf/errors/dmsf_zip_max_files_error"

# Hooks
require "#{File.dirname(__FILE__)}/redmine_dmsf/hooks/controllers/search_controller_hooks"
require "#{File.dirname(__FILE__)}/redmine_dmsf/hooks/controllers/issues_controller_hooks"
require "#{File.dirname(__FILE__)}/redmine_dmsf/hooks/views/view_projects_form_hook"
require "#{File.dirname(__FILE__)}/redmine_dmsf/hooks/views/base_view_hooks"
require "#{File.dirname(__FILE__)}/redmine_dmsf/hooks/views/custom_field_view_hooks"
require "#{File.dirname(__FILE__)}/redmine_dmsf/hooks/views/issue_view_hooks"
require "#{File.dirname(__FILE__)}/redmine_dmsf/hooks/views/my_account_view_hooks"
require "#{File.dirname(__FILE__)}/redmine_dmsf/hooks/views/search_view_hooks"
require "#{File.dirname(__FILE__)}/redmine_dmsf/hooks/helpers/issues_helper_hooks"
require "#{File.dirname(__FILE__)}/redmine_dmsf/hooks/helpers/search_helper_hooks"
require "#{File.dirname(__FILE__)}/redmine_dmsf/hooks/helpers/project_helper_hooks"

# Macros
require "#{File.dirname(__FILE__)}/redmine_dmsf/macros"
