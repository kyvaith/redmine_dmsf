# encoding: utf-8
# frozen_string_literal: true
#
# Redmine plugin for Document Management System "Features"
#
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

require File.expand_path('../../test_helper', __FILE__)

class DmsfFilesControllerTest < RedmineDmsf::Test::TestCase 
  
  fixtures :dmsf_folders, :dmsf_files, :dmsf_file_revisions, :dmsf_locks

  def setup
    super
    @request.session[:user_id] = @jsmith.id
  end

  def teardown
    super
    DmsfFile.clear_previews
  end

  def test_show_file_ok
    # Permissions OK
    get :show, params: { id: @file1.id }
    assert_response :success
  end

  def test_show_formatting_html
    Setting.text_formatting = 'HTML'
    get :show, params: { id: @file1.id }
    assert_response :success
    assert_include 'dmsf-description', response.body, 'dmsf-description class not found'
    assert_include 'wiki-edit', response.body, 'wiki-edit class not found'
  end

  def test_show_formatting_textile
    Setting.text_formatting = 'Textile'
    get :show, params: { id: @file1.id }
    assert_response :success
    assert_include 'dmsf-description', response.body, 'dmsf-description class not found'
    assert_include 'wiki-edit', response.body, 'wiki-edit class not found'
  end

  def test_show_file_forbidden
    # Missing permissions
    @role_manager.remove_permission! :view_dmsf_files
    get :show, params: { id: @file1.id }
    assert_response :forbidden
  end

  def test_view_file_ok
    # Permissions OK
    get :view, params: { id: @file1.id }
    assert_response :success
  end

  def test_view_file_forbidden
    # Missing permissions
    @role_manager.remove_permission! :view_dmsf_files
    get :view, params: { id: @file1.id }
    assert_response :forbidden
  end

  def test_view_preview
    get :view, params: { id: @file13.id }
    assert_response :success
    assert_equal 'application/pdf', @response.media_type
    assert @response.body.starts_with?('%PDF')
  end

  def delete_forbidden
    # Missing permissions
    @role_manager.remove_permission! :file_manipulation
    delete :delete, params: { id: @file1, folder_id: @file1.dmsf_folder, commit: false }
    assert_response :forbidden
  end

  def delete_locked
    # Permissions OK but the file is locked
    delete :delete, params: { id: @file2, folder_id: @file2.dmsf_folder, commit: false }
    assert_response :redirect
    assert_include l(:error_file_is_locked), flash[:error]
  end

  def delete_ok
    # Permissions OK and not locked
    delete :delete, params: { id: @file1, folder_id: @file1.dmsf_folder, commit: false }
    assert_redirected_to dmsf_folder_path(id: @file1.project, folder_id: @file1.dmsf_folder)
  end

  def test_delete_in_subfolder
    delete :delete, params: { id: @file4, folder_id: @file4.dmsf_folder, commit: false }
    assert_redirected_to dmsf_folder_path(id: @file4.project, folder_id: @file4.dmsf_folder)
  end

  def test_obsolete_revision_ok
    get :obsolete_revision, params: { id: @file1.last_revision.id }
    assert_redirected_to action: 'show', id: @file1
  end

  def test_obsolete_revision_missing_permissions
    @role_manager.remove_permission! :file_manipulation
    get :obsolete_revision, params: { id: @file1.last_revision.id }
    assert :forbiden
  end

  def test_create_revision
    assert_difference 'DmsfFileRevision.count', +1 do
      post :create_revision,
        params: {
          id: @file1.id,
          version_major: @file1.last_revision.major_version,
          version_minor: @file1.last_revision.minor_version + 1,
          dmsf_file_revision: {
            title: @file1.last_revision.title,
            name: @file1.last_revision.name,
            description: @file1.last_revision.description,
            comment: 'New revision'
          }
      }
    end
    assert_redirected_to dmsf_folder_path(id: @file1.project)
    assert_not_nil @file1.last_revision.digest
  end
  
end