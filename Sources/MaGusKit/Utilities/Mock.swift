//
//  Mock.swift
//  
//
//  Created by Manuel Sánchez on 3/3/20.
//

import Foundation

enum Mock {
    static var matchFileGenerated: String {
          """
          git_url("")

          type("adhoc")
          username("test@test.com")
          app_identifier(["com.example.bundle"])
          git_branch("master")
          """
      }

    static var generatedJSON: String {
        """
        {
          "name": "TestName",
          "targets": {
            "TestName": {
              "type": "application",
              "platform": "iOS",
              "deploymentTarget": "13.0",
              "sources": [
                {
                  "path": "TestName"
                },
                {
                  "path": "SupportingFiles"
                }
              ],
              "scheme": {
                  "gatherCoverageData": true,
                  "testTargets": [
                      {
                          "name": "TestName-Test"
                      }
                  ]
              },
              "settings": {
                "INFOPLIST_FILE": "info.plist",
                "PRODUCT_BUNDLE_IDENTIFIER": "com.example.bundle"
              },
            },
            "TestName-Test": {
              "type": "bundle.unit-test",
              "platform": "iOS",
              "sources": [
                {
                  "path": "TestNameTests"
                }
              ],
              "scheme": {
                  "testTargets": [
                      {
                          "name": "TestName-Test"
                      }
                  ]
              },
            "settings": {
               "PRODUCT_BUNDLE_IDENTIFIER": "com.example.bundle"
            },
            "info": {
                "path": "Testinfo.plist"
              },
              "dependencies": [{
                  "target": "TestName"
              }]
             }
          }
        }
        """
    }
    
    static var fastFileGenerated: String {
        """
        # Constants
        XCODE_WORKSPACE = "TestName.xcworkspace"
        XCODE_PROJECT = "TestName.xcodeproj"
        TARGET = "TestName"
        APP_IDENTIFIER = "com.example.bundle"
        TEAM_ID = "teamTest"
        DERIVED_DATA_FOLDER = "./DerivedData"
        OUTPUT_FOLDER = ENV["RESULTS_DIR"] # Change according to your project

        before_all do
          skip_docs
          xcversion(version: "~> 11.0")
        end

        ########################################
        # Testing stage
        ########################################

        lane :pipeline_unit_testing do
          begin
            scan(
              scheme: "TestName",
              xcargs: "analyze",
              slack_only_on_failure: false,
              code_coverage: true,
              derived_data_path: DERIVED_DATA_FOLDER
            )

          rescue => exception
            on_error(exception)
          end
        end

        lane :pipeline_xcov do
          begin
            xcov(
              workspace: XCODE_WORKSPACE,
              scheme: "TestName",
              minimum_coverage_percentage: 1.0,
              only_project_targets: true,
              slack_message: "Your *code coverage* report",
              slack_username: "CI", # Change according to your configuration
              derived_data_path: DERIVED_DATA_FOLDER,
              output_directory: OUTPUT_FOLDER
            )
          rescue => exception
            on_error(exception)
          end
        end

        #
        ########################################
        # Build stage
        ########################################

        lane :pipeline_build_app do
          begin
            sync_code_signing(
              type: "adhoc",
              app_identifier: APP_IDENTIFIER,
              team_id: TEAM_ID,
              keychain_password: ENV["FL_UNLOCK_KEYCHAIN_PASSWORD"], # Change according to your configuration
              git_branch: "master",
              readonly: is_ci
            )

            if is_ci?
              unlock_keychain
            end

            build_app(
              scheme: "TestName",
              workspace: XCODE_WORKSPACE,
              export_method: "ad-hoc"
            )

          rescue => exception
            on_error(exception)
          end
        end

        lane :pipeline_build_app_production do
          begin
            sync_code_signing(
              type: "appstore",
              app_identifier: "", # Modify according to your project
              team_id: "", # Modify according to your project
              keychain_password: ENV["FL_UNLOCK_KEYCHAIN_PASSWORD"],
              git_branch: "master",
              readonly: is_ci
            )

            if is_ci?
              unlock_keychain
            end

            build_app(
              scheme: "TestName",
              workspace: XCODE_WORKSPACE,
              export_method: "app-store"
            )
          rescue => exception
            on_error(exception)
          end
        end

        lane :pipeline_testflight do
          begin
            upload_to_testflight(
              skip_submission: true,
              username: "test@test.com",
              team_id: "", # Modify according to your project
              app_identifier: "", # Modify according to your project
              ipa: "./output/TestName.ipa"
            )
          rescue => exception
            on_error(exception)
          end
        end

        lane :bump do
          begin

            #Bumping version
            increment_build_number()
            unless ENV["VERSION_BUMP_TYPE"] == "build"
              if ['major', 'minor', 'patch'].include? ENV["VERSION_BUMP_TYPE"]
                increment_version_number(bump_type: ENV["VERSION_BUMP_TYPE"])
              end
            end

            version = get_version_number(xcodeproj: XCODE_PROJECT, target: TARGET)
            buildNumber = get_build_number(xcodeproj: XCODE_PROJECT)

            commit_version_bump(message: ":bookmark: Version #{version}-#{buildNumber} bumped by fastlane.", force: true)
          rescue => exception
            on_error(exception)
          end
        end

        lane :tag do
          begin
            version = get_version_number(xcodeproj: XCODE_PROJECT, target: TARGET)
            buildNumber = get_build_number(xcodeproj: XCODE_PROJECT)
            add_git_tag(build_number: version, force: true, postfix: "-#{buildNumber}", prefix: "v")
          rescue => exception
            on_error(exception)
          end
        end

        def on_error(exception)
          slack(
            message: "🚨 Error occured on iOS Build! 🔥 (<#{ENV["BUILD_URL"]}|See Job>)",
            use_webhook_configured_username_and_icon: true,
            success: false,
            attachment_properties: {
              fields: [
                {
                  title: "Error message: ",
                  value: exception
                }
              ]
            }
          ) if is_ci?
          UI.error exception
          UI.user_error!("🚨 Lane failed!!")
        end
        """
    }
}
