require './helper.rb'

feature 'ADMIN USER - KPI Builder - creating ,editing and deleting KPI:', type: :feature, js: true, :order => :defined do

  # describe "As Admin user i'm creating an AD scope KPI and validating it has been added to KPIs table", :order => :defined do
  #   it "create and verify successfull creation of an KPI" do
  #     Percy::Capybara.initialize_build
  #     visit root_path
  #     user_login('admin_user')
  #     find("[ui-sref='kpis']").click
  #     click_button 'add_kpi'
  #     $ad_name = Array.new(10){[*'0'..'9', *'a'..'z', *'A'..'Z'].sample}.join
  #     fill_in('kpiName', with: $ad_name)
  #     fill_in('kpiName', with: "")
  #
  #     if page.has_css?(".ng-invalid-required[ng-model='kpi.name']")
  #       puts "Pass - There is a validation for a Name of KPI"
  #       fill_in('kpiName', with: $ad_name)
  #     else
  #       puts "FAILED - There is no validation for Name of KPI"
  #     end
  #     choose 'scopeRadioAds'
  #     metrics_scope = ["LTSpend", "LTRevenue", "LTA2C", "LTSales"]
  #     metric_time = ["NOW", "MINUS_X_HOURS", "MINUS_Y_HOURS"]
  #     operators = ["+", "-", "*", "/"]
  #     $ad_kpi_formula = "AD.#{metrics_scope.sample}.#{metric_time.sample} #{operators.sample} AD.#{metrics_scope.sample}.#{metric_time.sample} #{operators.sample} AD.#{metrics_scope.sample}.#{metric_time.sample}"
  #     fill_in('kpiFormula', with: $ad_kpi_formula)
  #     click_button 'saveKpi'
  #     expect(page).to have_content("Created KPI successfully.")
  #     Percy::Capybara.finalize_build
  #   end
  #
  #   it "verify if KPI is on the main KPI's list" do
  #     visit root_path
  #     find("[ui-sref='kpis']").click
  #     expect(page).to have_content($ad_kpi_formula)
  #   end
  #
  # end

  # describe "As Admin user i'm creating a very long KPI within AD scope and validating it has been added to KPIs table, then edit and delete it", type: :feature, :order => :defined do

    it "creating long KPI" do
      visit root_path
      user_login('admin_user')
      find("[ui-sref='kpis']").click
      click_button 'add_kpi'
      fill_in('kpiName', with: "very_long_kpi")
      $long_kpi_string = "((iferror(AD.LTRevenue.MINUS_X_HOURS / AD.LTA2C.MINUS_X_HOURS , 0) * min(5,AD.LTSales.MINUS_X_HOURS/AD.AD_SET.CAMPAIGN.ACCOUNT.minConv))+(iferror(AD.AD_SET.LTRevenue.MINUS_X_HOURS / AD.AD_SET.LTA2C.MINUS_X_HOURS,0)*((1-(min(1,AD.LTSales.MINUS_X_HOURS/AD.AD_SET.CAMPAIGN.ACCOUNT.minConv)))*min(1,AD.AD_SET.LTSales.MINUS_X_HOURS/AD.AD_SET.CAMPAIGN.ACCOUNT.minConv))) +(iferror(AD.AD_SET.CAMPAIGN.LTRevenue.MINUS_X_HOURS / AD.AD_SET.CAMPAIGN.LTA2C.MINUS_X_HOURS,0)*((1-(min(1,AD.LTSales.MINUS_X_HOURS/AD.AD_SET.CAMPAIGN.ACCOUNT.minConv))-((1-(min(1,AD.LTSales.MINUS_X_HOURS/AD.AD_SET.CAMPAIGN.ACCOUNT.minConv)))*min(1,AD.AD_SET.LTSales.MINUS_X_HOURS/AD.AD_SET.CAMPAIGN.ACCOUNT.minConv)))* min(1,AD.AD_SET.CAMPAIGN.LTSales.MINUS_X_HOURS/AD.AD_SET.CAMPAIGN.ACCOUNT.minConv))) +(iferror(AD.AD_SET.CAMPAIGN.ACCOUNT.LTRevenue.MINUS_X_HOURS / AD.AD_SET.CAMPAIGN.ACCOUNT.LTA2C.MINUS_X_HOURS,0))*(((1-(min(1,AD.LTSales.MINUS_X_HOURS/AD.AD_SET.CAMPAIGN.ACCOUNT.minConv))-((1-(min(1,AD.LTSales.MINUS_X_HOURS/AD.AD_SET.CAMPAIGN.ACCOUNT.minConv)))*min(1,AD.AD_SET.LTSales.MINUS_X_HOURS/AD.AD_SET.CAMPAIGN.ACCOUNT.minConv)))* min(1,AD.AD_SET.CAMPAIGN.LTSales.MINUS_X_HOURS/AD.AD_SET.CAMPAIGN.ACCOUNT.minConv)-((1-(min(1,AD.LTSales.MINUS_X_HOURS/AD.AD_SET.CAMPAIGN.ACCOUNT.minConv))-((1-(min(1,AD.LTSales.MINUS_X_HOURS/AD.AD_SET.CAMPAIGN.ACCOUNT.minConv)))*min(1,AD.AD_SET.LTSales.MINUS_X_HOURS/AD.AD_SET.CAMPAIGN.ACCOUNT.minConv)))* min(1,AD.AD_SET.CAMPAIGN.LTSales.MINUS_X_HOURS/AD.AD_SET.CAMPAIGN.ACCOUNT.minConv)))*min(1,AD.AD_SET.CAMPAIGN.ACCOUNT.LTSales.MINUS_X_HOURS/AD.AD_SET.CAMPAIGN.ACCOUNT.minConv)))*AD.LTA2C.MINUS_X_HOURS*AD.AD_SET.CAMPAIGN.ACCOUNT.scSplit+((1-AD.AD_SET.CAMPAIGN.ACCOUNT.scSplit)*AD.LTRevenue.MINUS_X_HOURS)	"
      fill_in('kpiFormula', with: $long_kpi_string)
      choose 'scopeRadioAds'
      click_button 'saveKpi'
      page.should have_content("Created KPI successfully.")
      page.should have_content($long_kpi_string)
      Percy::Capybara.snapshot(page, name: 'kpi_new')
    end

    it "edit long KPI" do
      visit root_path
      user_login('admin_user')
      find("[ui-sref='kpis']").click
      page.find('span', :text => "very_long_kpi").first(:xpath,"../..").find(".action-edit-kpi").click
      expect(page).to have_selector(".page-header", :text => "Edit KPI")
      fill_in('kpiFormula', with: "#{$long_kpi_string} + 1")
      click_button 'saveKpi'
      expect(page).to have_content("KPI editing has been completed successfully")
      Percy::Capybara.snapshot(page, name: 'kpi_edit')
    end

    it "delete long KPI" do
      visit root_path
      user_login('admin_user')
      find("[ui-sref='kpis']").click
      page.find('span', :text => "very_long_kpi").first(:xpath,"../..").find(".action-delete-kpi").click
      click_button 'OK'
      expect(page).to have_content("Kpi has been successfully removed")
      Percy::Capybara.snapshot(page, name: 'kpi_delete')
    end

  # end

#   describe "As Admin user i'm creating an ADSET scope KPI and validating it has been added to KPIs table", :order => :defined do
#     it "create and verify successfull creation of an KPI" do
#       visit root_path
#       user_login('admin_user')
#       find("[ui-sref='kpis']").click
#       click_button 'add_kpi'
#       $ad_set_name = Array.new(10){[*'0'..'9', *'a'..'z', *'A'..'Z'].sample}.join
#       fill_in('kpiName', with: $ad_set_name)
#       fill_in('kpiName', with: "")
#
#       if page.has_css?(".ng-invalid-required[ng-model='kpi.name']")
#         puts "Pass - There is a validation for a Name of KPI"
#         fill_in('kpiName', with: $ad_set_name)
#       else
#         puts "FAILED - There is no validation for Name of KPI"
#       end
#
#       choose 'scopeRadioAdsets'
#       metrics_scope = ["LTSpend", "LTRevenue", "LTA2C", "LTSales", "LastXSpend", "YesterdaySpend", "TodaySpend", "TodayRevenue", "DailyBudget"]
#       metric_time = ["NOW", "MINUS_X_HOURS", "MINUS_Y_HOURS"]
#       operators = ["+", "-", "*", "/"]
#       $ad_set_kpi_formula = "AD_SET.#{metrics_scope.sample}.#{metric_time.sample} #{operators.sample} (AD_SET.#{metrics_scope.sample}.#{metric_time.sample} #{operators.sample} AD_SET.#{metrics_scope.sample}.#{metric_time.sample}) #{operators.sample} AD_SET.#{metrics_scope.sample}.#{metric_time.sample}"
#       fill_in('kpiFormula', with: $ad_set_kpi_formula)
#       # fill_in('kpiFormula', with: "(max(AD_SET.DailyBudget.NOW, 10) + pow(AD_SET.DailyBudget.NOW,2)) / (sum(AD_SET.ADS,'LTRevenue','MINUS_Y_HOURS' ) + sum(AD_SET.ADS,'LTRevenue','NOW'))")
#       click_button 'saveKpi'
#       expect(page).to have_content("Created KPI successfully.")
#     end
#
#     it "verify if KPI is on the main KPI's list" do
#       visit root_path
#       find("[ui-sref='kpis']").click
#       expect(page).to have_content($ad_set_kpi_formula)
#     end
#   end
#
#   describe "As Admin user i'm creating an CAMPAIGN scope KPI and validating it has been added to KPIs table", :order => :defined do
#     it "create and verify successfull creation of an KPI" do
#       visit root_path
#       user_login('admin_user')
#       find("[ui-sref='kpis']").click
#       click_button 'add_kpi'
#       $campaign_name = Array.new(10){[*'0'..'9', *'a'..'z', *'A'..'Z'].sample}.join
#       fill_in('kpiName', with: $campaign_name)
#       fill_in('kpiName', with: "")
#
#       if page.has_css?(".ng-invalid-required[ng-model='kpi.name']")
#         puts "Pass - There is a validation for a Name of KPI"
#         fill_in('kpiName', with: $campaign_name)
#       else
#         puts "FAILED - There is no validation for Name of KPI"
#       end
#
#       choose 'scopeRadioCampaign'
#       metrics_scope = ["LTSpend", "LTRevenue", "LTA2C", "LTSales", "FBSpendLastX", "GASalesLastX", "FBRevLastX", "GAShippingLastX", "GARevenueLastX"]
#       metric_time = ["NOW", "MINUS_X_HOURS", "MINUS_Y_HOURS"]
#       operators = ["+", "-", "*", "/"]
#       $campaign_kpi_formula = "CAMPAIGN.#{metrics_scope.sample}.#{metric_time.sample} #{operators.sample} (CAMPAIGN.#{metrics_scope.sample}.#{metric_time.sample} #{operators.sample} CAMPAIGN.#{metrics_scope.sample}.#{metric_time.sample}) #{operators.sample} CAMPAIGN.#{metrics_scope.sample}.#{metric_time.sample}"
#       fill_in('kpiFormula', with: $campaign_kpi_formula)
#       click_button 'saveKpi'
#       expect(page).to have_content("Created KPI successfully.")
#     end
#
#     it "verify if KPI is on the main KPI's list" do
#       visit root_path
#       find("[ui-sref='kpis']").click
#       expect(page).to have_content($campaign_kpi_formula)
#     end
#   end
#
#   describe "As Admin user i'm creating an ACCOUNT scope KPI and validating it has been added to KPIs table", :order => :defined do
#     it "create and verify successfull creation of an KPI" do
#       visit root_path
#       user_login('admin_user')
#       find("[ui-sref='kpis']").click
#       click_button 'add_kpi'
#       $account_name = Array.new(10){[*'0'..'9', *'a'..'z', *'A'..'Z'].sample}.join
#       fill_in('kpiName', with: $account_name)
#       fill_in('kpiName', with: "")
#
#       if page.has_css?(".ng-invalid-required[ng-model='kpi.name']")
#         puts "Pass - There is a validation for a Name of KPI"
#         fill_in('kpiName', with: $account_name)
#       else
#         puts "FAILED - There is no validation for Name of KPI"
#       end
#
#       choose 'scopeRadioAccount'
#       metrics_scope = ["LTSpend", "LTRevenue", "LTA2C", "LTSales", "GASalesLastX", "GARevenueLastX", "GAShippingLastX", "GANotSetRevLastX"]
#       metrics_scope_accout = ["minConv", "roasGoal", "scSplit", "cfCap", "adMinSpend", "adSetMinSpend", "adSetMinIncSpend", "incMult", "decMult", "const1", "const2", "const3", "const4", "const5"]
#       metric_time = ["NOW", "MINUS_X_HOURS", "MINUS_Y_HOURS"]
#       operators = ["+", "-", "*", "/"]
#       $account_kpi_formula = "ACCOUNT.#{metrics_scope_accout.sample} #{operators.sample} ACCOUNT.#{metrics_scope.sample}.#{metric_time.sample} #{operators.sample} (ACCOUNT.#{metrics_scope.sample}.#{metric_time.sample} #{operators.sample} ACCOUNT.#{metrics_scope.sample}.#{metric_time.sample}) #{operators.sample} ACCOUNT.#{metrics_scope.sample}.#{metric_time.sample}"
#       fill_in('kpiFormula', with: $account_kpi_formula)
#       click_button 'saveKpi'
#       expect(page).to have_content("Created KPI successfully.")
#     end
#
#     it "verify if KPI is on the main KPI's list" do
#       visit root_path
#       find("[ui-sref='kpis']").click
#       expect(page).to have_content($account_kpi_formula)
#     end
#   end
#
#   scenario "As Admin user i'm creating an AD scope KPI and, and verify all validations in new KPI screen" do
#     visit root_path
#     user_login('admin_user')
#     find("[ui-sref='kpis']").click
#     click_button 'add_kpi'
#
#     # describe "single name input" do
#       fill_in('kpiName', with: "testname")
#       fill_in('kpiName', with: "")
#       click_button 'saveKpi'
#       expect(page).to have_selector("#kpiName.ng-invalid-required")
#     # end
#
#     # describe "name with 2 words" do
#       fill_in('kpiName', with: "testname 2words")
#       expect(page).to have_selector("#kpiName.ng-invalid-pattern")
#       fill_in('kpiName', with: "testname")
#     # end
#
#     # describe "radio button - scope " do
#       click_button 'saveKpi'
#       expect(page).to have_selector(".ng-invalid-required[value='AD']")
#       choose 'scopeRadioAds'
#     # end
#
#     # describe "formula" do
#       expect(page).to have_selector("#kpiFormula.ng-invalid-required")
#     # end
#
#     # describe "formula" do
#       find("#showAvailableMetrics").click
#       expect(page).to have_content("Available Metrics")
#       expect(page).to have_content("FBTotalSpendLastX:")
#       expect(page).to have_content("FBRevLastX:")
#       expect(page).to have_selector(".modal-open")
#       find(".close-wrapper").click
#     # end
#   end
#
#   scenario "As Admin user i'm creating a new AD scope KPI and, and click on Back Button to return to main KPI screen" do
#     visit root_path
#     user_login('admin_user')
#     find("[ui-sref='kpis']").click
#     click_button 'add_kpi'
#     click_button 'Back'
#     expect(page).to have_selector(".page-header", :text => "KPI Builder")
#   end
#
#   describe "As Admin user i'm deleting from main table all KPIs the system has been created (AD, AD_SET, CAMPAIGN, ACCOUNT)", :order => :defined do
#     it "delete AD KPI" do
#       visit root_path
#       user_login('admin_user')
#       find("[ui-sref='kpis']").click
#       page.find('span', :text => $ad_name).first(:xpath,"../..").find(".action-delete-kpi").click
#       click_button 'OK'
#       expect(page).to have_content("Kpi has been successfully removed")
#     end
#
#     it "AD KPI removed from table" do
#       visit root_path
#       find("[ui-sref='kpis']").click
#       sleep 1
#       page.should have_no_content($ad_name)
#     end
#
#     it "delete AD_SET KPI" do
#       visit root_path
#       user_login('admin_user')
#       find("[ui-sref='kpis']").click
#       page.find('span', :text => $ad_set_name).first(:xpath,"../..").find(".action-delete-kpi").click
#       click_button 'OK'
#       expect(page).to have_content("Kpi has been successfully removed")
#     end
#
#     it "AD_SET KPI removed from table" do
#       visit root_path
#       find("[ui-sref='kpis']").click
#       sleep 1
#       page.should have_no_content($ad_set_name)
#     end
#
#     it "delete CAMPAIGN KPI" do
#       visit root_path
#       user_login('admin_user')
#       find("[ui-sref='kpis']").click
#       page.find('span', :text => $campaign_name).first(:xpath,"../..").find(".action-delete-kpi").click
#       click_button 'OK'
#       expect(page).to have_content("Kpi has been successfully removed")
#     end
#
#     it "CAMPAIGN KPI removed from table" do
#       visit root_path
#       find("[ui-sref='kpis']").click
#       sleep 1
#       page.should have_no_content($campaign_name)
#     end
#
#     it "delete ACCOUNT KPI" do
#       visit root_path
#       user_login('admin_user')
#       find("[ui-sref='kpis']").click
#       page.find('span', :text => $account_name).first(:xpath,"../..").find(".action-delete-kpi").click
#       click_button 'OK'
#       expect(page).to have_content("Kpi has been successfully removed")
#     end
#
#     it "ACCOUNT KPI removed from table" do
#       visit root_path
#       find("[ui-sref='kpis']").click
#       sleep 1
#       page.should have_no_content($account_name)
#     end
#   end
#
#
# end
#
#
# feature 'EDITOR USER - KPI Builder - creating ,editing and deleting KPI:', js: true, :order => :defined do
#
#   describe "As Editor user i'm creating an AD scope KPI and validating it has been added to KPIs table", :order => :defined do
#     it "create and verify successfull creation of an KPI" do
#       visit root_path
#       user_login('editor_user')
#       find("[ui-sref='kpis']").click
#       click_button 'add_kpi'
#       $ad_name = Array.new(10){[*'0'..'9', *'a'..'z', *'A'..'Z'].sample}.join
#       fill_in('kpiName', with: $ad_name)
#       fill_in('kpiName', with: "")
#
#       if page.has_css?(".ng-invalid-required[ng-model='kpi.name']")
#         puts "Pass - There is a validation for a Name of KPI"
#         fill_in('kpiName', with: $ad_name)
#       else
#         puts "FAILED - There is no validation for Name of KPI"
#       end
#       choose 'scopeRadioAds'
#       metrics_scope = ["LTSpend", "LTRevenue", "LTA2C", "LTSales"]
#       metric_time = ["NOW", "MINUS_X_HOURS", "MINUS_Y_HOURS"]
#       operators = ["+", "-", "*", "/"]
#       $ad_kpi_formula = "AD.#{metrics_scope.sample}.#{metric_time.sample} #{operators.sample} AD.#{metrics_scope.sample}.#{metric_time.sample} #{operators.sample} AD.#{metrics_scope.sample}.#{metric_time.sample}"
#       fill_in('kpiFormula', with: $ad_kpi_formula)
#       click_button 'saveKpi'
#       expect(page).to have_content("Created KPI successfully.")
#     end
#
#     it "verify if KPI is on the main KPI's list" do
#       visit root_path
#       find("[ui-sref='kpis']").click
#       expect(page).to have_content($ad_kpi_formula)
#     end
#
#   end
#
#   describe "As Editor user i'm creating a very long KPI within AD scope and validating it has been added to KPIs table, then edit and delete it", :order => :defined do
#
#     it "creating long KPI" do
#       visit root_path
#       user_login('editor_user')
#       find("[ui-sref='kpis']").click
#       click_button 'add_kpi'
#       fill_in('kpiName', with: "very_long_kpi")
#       $long_kpi_string = "((iferror(AD.LTRevenue.MINUS_X_HOURS / AD.LTA2C.MINUS_X_HOURS , 0) * min(5,AD.LTSales.MINUS_X_HOURS/AD.AD_SET.CAMPAIGN.ACCOUNT.minConv))+(iferror(AD.AD_SET.LTRevenue.MINUS_X_HOURS / AD.AD_SET.LTA2C.MINUS_X_HOURS,0)*((1-(min(1,AD.LTSales.MINUS_X_HOURS/AD.AD_SET.CAMPAIGN.ACCOUNT.minConv)))*min(1,AD.AD_SET.LTSales.MINUS_X_HOURS/AD.AD_SET.CAMPAIGN.ACCOUNT.minConv))) +(iferror(AD.AD_SET.CAMPAIGN.LTRevenue.MINUS_X_HOURS / AD.AD_SET.CAMPAIGN.LTA2C.MINUS_X_HOURS,0)*((1-(min(1,AD.LTSales.MINUS_X_HOURS/AD.AD_SET.CAMPAIGN.ACCOUNT.minConv))-((1-(min(1,AD.LTSales.MINUS_X_HOURS/AD.AD_SET.CAMPAIGN.ACCOUNT.minConv)))*min(1,AD.AD_SET.LTSales.MINUS_X_HOURS/AD.AD_SET.CAMPAIGN.ACCOUNT.minConv)))* min(1,AD.AD_SET.CAMPAIGN.LTSales.MINUS_X_HOURS/AD.AD_SET.CAMPAIGN.ACCOUNT.minConv))) +(iferror(AD.AD_SET.CAMPAIGN.ACCOUNT.LTRevenue.MINUS_X_HOURS / AD.AD_SET.CAMPAIGN.ACCOUNT.LTA2C.MINUS_X_HOURS,0))*(((1-(min(1,AD.LTSales.MINUS_X_HOURS/AD.AD_SET.CAMPAIGN.ACCOUNT.minConv))-((1-(min(1,AD.LTSales.MINUS_X_HOURS/AD.AD_SET.CAMPAIGN.ACCOUNT.minConv)))*min(1,AD.AD_SET.LTSales.MINUS_X_HOURS/AD.AD_SET.CAMPAIGN.ACCOUNT.minConv)))* min(1,AD.AD_SET.CAMPAIGN.LTSales.MINUS_X_HOURS/AD.AD_SET.CAMPAIGN.ACCOUNT.minConv)-((1-(min(1,AD.LTSales.MINUS_X_HOURS/AD.AD_SET.CAMPAIGN.ACCOUNT.minConv))-((1-(min(1,AD.LTSales.MINUS_X_HOURS/AD.AD_SET.CAMPAIGN.ACCOUNT.minConv)))*min(1,AD.AD_SET.LTSales.MINUS_X_HOURS/AD.AD_SET.CAMPAIGN.ACCOUNT.minConv)))* min(1,AD.AD_SET.CAMPAIGN.LTSales.MINUS_X_HOURS/AD.AD_SET.CAMPAIGN.ACCOUNT.minConv)))*min(1,AD.AD_SET.CAMPAIGN.ACCOUNT.LTSales.MINUS_X_HOURS/AD.AD_SET.CAMPAIGN.ACCOUNT.minConv)))*AD.LTA2C.MINUS_X_HOURS*AD.AD_SET.CAMPAIGN.ACCOUNT.scSplit+((1-AD.AD_SET.CAMPAIGN.ACCOUNT.scSplit)*AD.LTRevenue.MINUS_X_HOURS)	"
#       fill_in('kpiFormula', with: $long_kpi_string)
#       choose 'scopeRadioAds'
#       click_button 'saveKpi'
#       page.should have_content("Created KPI successfully.")
#       page.should have_content($long_kpi_string)
#     end
#
#     it "edit long KPI" do
#       visit root_path
#       user_login('editor_user')
#       find("[ui-sref='kpis']").click
#       page.find('span', :text => "very_long_kpi").first(:xpath,"../..").find(".action-edit-kpi").click
#       expect(page).to have_selector(".page-header", :text => "Edit KPI")
#       fill_in('kpiFormula', with: "#{$long_kpi_string} + 1")
#       click_button 'saveKpi'
#       expect(page).to have_content("KPI editing has been completed successfully")
#     end
#
#     it "delete long KPI" do
#       visit root_path
#       user_login('editor_user')
#       find("[ui-sref='kpis']").click
#       page.find('span', :text => "very_long_kpi").first(:xpath,"../..").find(".action-delete-kpi").click
#       click_button 'OK'
#       expect(page).to have_content("Kpi has been successfully removed")
#     end
#
#   end
#
#   describe "As Editor user i'm creating an ADSET scope KPI and validating it has been added to KPIs table", :order => :defined do
#     it "create and verify successfull creation of an KPI" do
#       visit root_path
#       user_login('editor_user')
#       find("[ui-sref='kpis']").click
#       click_button 'add_kpi'
#       $ad_set_name = Array.new(10){[*'0'..'9', *'a'..'z', *'A'..'Z'].sample}.join
#       fill_in('kpiName', with: $ad_set_name)
#       fill_in('kpiName', with: "")
#
#       if page.has_css?(".ng-invalid-required[ng-model='kpi.name']")
#         puts "Pass - There is a validation for a Name of KPI"
#         fill_in('kpiName', with: $ad_set_name)
#       else
#         puts "FAILED - There is no validation for Name of KPI"
#       end
#
#       choose 'scopeRadioAdsets'
#       metrics_scope = ["LTSpend", "LTRevenue", "LTA2C", "LTSales", "LastXSpend", "YesterdaySpend", "TodaySpend", "TodayRevenue", "DailyBudget"]
#       metric_time = ["NOW", "MINUS_X_HOURS", "MINUS_Y_HOURS"]
#       operators = ["+", "-", "*", "/"]
#       $ad_set_kpi_formula = "AD_SET.#{metrics_scope.sample}.#{metric_time.sample} #{operators.sample} (AD_SET.#{metrics_scope.sample}.#{metric_time.sample} #{operators.sample} AD_SET.#{metrics_scope.sample}.#{metric_time.sample}) #{operators.sample} AD_SET.#{metrics_scope.sample}.#{metric_time.sample}"
#       fill_in('kpiFormula', with: $ad_set_kpi_formula)
#       # fill_in('kpiFormula', with: "(max(AD_SET.DailyBudget.NOW, 10) + pow(AD_SET.DailyBudget.NOW,2)) / (sum(AD_SET.ADS,'LTRevenue','MINUS_Y_HOURS' ) + sum(AD_SET.ADS,'LTRevenue','NOW'))")
#       click_button 'saveKpi'
#       expect(page).to have_content("Created KPI successfully.")
#     end
#
#     it "verify if KPI is on the main KPI's list" do
#       visit root_path
#       find("[ui-sref='kpis']").click
#       expect(page).to have_content($ad_set_kpi_formula)
#     end
#   end
#
#   describe "As Editor user i'm creating an CAMPAIGN scope KPI and validating it has been added to KPIs table", :order => :defined do
#     it "create and verify successfull creation of an KPI" do
#       visit root_path
#       user_login('editor_user')
#       find("[ui-sref='kpis']").click
#       click_button 'add_kpi'
#       $campaign_name = Array.new(10){[*'0'..'9', *'a'..'z', *'A'..'Z'].sample}.join
#       fill_in('kpiName', with: $campaign_name)
#       fill_in('kpiName', with: "")
#
#       if page.has_css?(".ng-invalid-required[ng-model='kpi.name']")
#         puts "Pass - There is a validation for a Name of KPI"
#         fill_in('kpiName', with: $campaign_name)
#       else
#         puts "FAILED - There is no validation for Name of KPI"
#       end
#
#       choose 'scopeRadioCampaign'
#       metrics_scope = ["LTSpend", "LTRevenue", "LTA2C", "LTSales", "FBSpendLastX", "GASalesLastX", "FBRevLastX", "GAShippingLastX", "GARevenueLastX"]
#       metric_time = ["NOW", "MINUS_X_HOURS", "MINUS_Y_HOURS"]
#       operators = ["+", "-", "*", "/"]
#       $campaign_kpi_formula = "CAMPAIGN.#{metrics_scope.sample}.#{metric_time.sample} #{operators.sample} (CAMPAIGN.#{metrics_scope.sample}.#{metric_time.sample} #{operators.sample} CAMPAIGN.#{metrics_scope.sample}.#{metric_time.sample}) #{operators.sample} CAMPAIGN.#{metrics_scope.sample}.#{metric_time.sample}"
#       fill_in('kpiFormula', with: $campaign_kpi_formula)
#       click_button 'saveKpi'
#       expect(page).to have_content("Created KPI successfully.")
#     end
#
#     it "verify if KPI is on the main KPI's list" do
#       visit root_path
#       find("[ui-sref='kpis']").click
#       expect(page).to have_content($campaign_kpi_formula)
#     end
#   end
#
#   describe "As Editor user i'm creating an ACCOUNT scope KPI and validating it has been added to KPIs table", :order => :defined do
#     it "create and verify successfull creation of an KPI" do
#       visit root_path
#       user_login('editor_user')
#       find("[ui-sref='kpis']").click
#       click_button 'add_kpi'
#       $account_name = Array.new(10){[*'0'..'9', *'a'..'z', *'A'..'Z'].sample}.join
#       fill_in('kpiName', with: $account_name)
#       fill_in('kpiName', with: "")
#
#       if page.has_css?(".ng-invalid-required[ng-model='kpi.name']")
#         puts "Pass - There is a validation for a Name of KPI"
#         fill_in('kpiName', with: $account_name)
#       else
#         puts "FAILED - There is no validation for Name of KPI"
#       end
#
#       choose 'scopeRadioAccount'
#       metrics_scope = ["LTSpend", "LTRevenue", "LTA2C", "LTSales", "GASalesLastX", "GARevenueLastX", "GAShippingLastX", "GANotSetRevLastX"]
#       metrics_scope_accout = ["minConv", "roasGoal", "scSplit", "cfCap", "adMinSpend", "adSetMinSpend", "adSetMinIncSpend", "incMult", "decMult", "const1", "const2", "const3", "const4", "const5"]
#       metric_time = ["NOW", "MINUS_X_HOURS", "MINUS_Y_HOURS"]
#       operators = ["+", "-", "*", "/"]
#       $account_kpi_formula = "ACCOUNT.#{metrics_scope_accout.sample} #{operators.sample} ACCOUNT.#{metrics_scope.sample}.#{metric_time.sample} #{operators.sample} (ACCOUNT.#{metrics_scope.sample}.#{metric_time.sample} #{operators.sample} ACCOUNT.#{metrics_scope.sample}.#{metric_time.sample}) #{operators.sample} ACCOUNT.#{metrics_scope.sample}.#{metric_time.sample}"
#       fill_in('kpiFormula', with: $account_kpi_formula)
#       click_button 'saveKpi'
#       expect(page).to have_content("Created KPI successfully.")
#     end
#
#     it "verify if KPI is on the main KPI's list" do
#       visit root_path
#       find("[ui-sref='kpis']").click
#       expect(page).to have_content($account_kpi_formula)
#     end
#   end
#
#   scenario "As Editor user i'm creating an AD scope KPI and, and verify all validations in new KPI screen" do
#     visit root_path
#     user_login('editor_user')
#     find("[ui-sref='kpis']").click
#     click_button 'add_kpi'
#
#     # describe "single name input" do
#       fill_in('kpiName', with: "testname")
#       fill_in('kpiName', with: "")
#       click_button 'saveKpi'
#       expect(page).to have_selector("#kpiName.ng-invalid-required")
#     # end
#
#     # describe "name with 2 words" do
#       fill_in('kpiName', with: "testname 2words")
#       expect(page).to have_selector("#kpiName.ng-invalid-pattern")
#       fill_in('kpiName', with: "testname")
#     # end
#
#     # describe "radio button - scope " do
#       click_button 'saveKpi'
#       expect(page).to have_selector(".ng-invalid-required[value='AD']")
#       choose 'scopeRadioAds'
#     # end
#
#     # describe "formula" do
#       expect(page).to have_selector("#kpiFormula.ng-invalid-required")
#     # end
#
#     # describe "formula" do
#       find("#showAvailableMetrics").click
#       expect(page).to have_content("Available Metrics")
#       expect(page).to have_content("FBTotalSpendLastX:")
#       expect(page).to have_content("FBRevLastX:")
#       expect(page).to have_selector(".modal-open")
#       find(".close-wrapper").click
#     # end
#   end
#
#   scenario "As Editor user i'm creating a new AD scope KPI and, and click on Back Button to return to main KPI screen" do
#     visit root_path
#     user_login('editor_user')
#     find("[ui-sref='kpis']").click
#     click_button 'add_kpi'
#     click_button 'Back'
#     expect(page).to have_selector(".page-header", :text => "KPI Builder")
#   end
#
#   describe "As Editor user i'm deleting from main table all KPIs the system has been created (AD, AD_SET, CAMPAIGN, ACCOUNT)", :order => :defined do
#     it "delete AD KPI" do
#       visit root_path
#       user_login('editor_user')
#       find("[ui-sref='kpis']").click
#       page.find('span', :text => $ad_name).first(:xpath,"../..").find(".action-delete-kpi").click
#       click_button 'OK'
#       expect(page).to have_content("Kpi has been successfully removed")
#     end
#
#     it "AD KPI removed from table" do
#       visit root_path
#       find("[ui-sref='kpis']").click
#       sleep 1
#       page.should have_no_content($ad_name)
#     end
#
#     it "delete AD_SET KPI" do
#       visit root_path
#       user_login('editor_user')
#       find("[ui-sref='kpis']").click
#       page.find('span', :text => $ad_set_name).first(:xpath,"../..").find(".action-delete-kpi").click
#       click_button 'OK'
#       expect(page).to have_content("Kpi has been successfully removed")
#     end
#
#     it "AD_SET KPI removed from table" do
#       visit root_path
#       find("[ui-sref='kpis']").click
#       sleep 1
#       page.should have_no_content($ad_set_name)
#     end
#
#     it "delete CAMPAIGN KPI" do
#       visit root_path
#       user_login('editor_user')
#       find("[ui-sref='kpis']").click
#       page.find('span', :text => $campaign_name).first(:xpath,"../..").find(".action-delete-kpi").click
#       click_button 'OK'
#       expect(page).to have_content("Kpi has been successfully removed")
#     end
#
#     it "CAMPAIGN KPI removed from table" do
#       visit root_path
#       find("[ui-sref='kpis']").click
#       sleep 1
#       page.should have_no_content($campaign_name)
#     end
#
#     it "delete ACCOUNT KPI" do
#       visit root_path
#       user_login('editor_user')
#       find("[ui-sref='kpis']").click
#       page.find('span', :text => $account_name).first(:xpath,"../..").find(".action-delete-kpi").click
#       click_button 'OK'
#       expect(page).to have_content("Kpi has been successfully removed")
#     end
#
#     it "ACCOUNT KPI removed from table" do
#       visit root_path
#       find("[ui-sref='kpis']").click
#       sleep 1
#       page.should have_no_content($account_name)
#     end
#   end
#
#
# end
#
# feature 'VIEWER USER - KPI Builder - verify all is disabled for viewer user', js: true, :order => :defined do
#
#   describe "As Viewer user i can't change anything in KPIs screen - all is disabled", :order => :defined do
#     it "edit is disabled" do
#       visit root_path
#       user_login('viewer_user')
#       find("[ui-sref='kpis']").click
#       expect(page).to have_selector(".fa-pencil.disabled.action-edit-kpi")
#     end
#
#     it "delete is disabled" do
#       visit root_path
#       user_login('viewer_user')
#       find("[ui-sref='kpis']").click
#       expect(page).to have_selector(".action-delete-kpi.fa-trash-o.disabled")
#     end
#
#     it "New KPI button is disabled" do
#       visit root_path
#       user_login('viewer_user')
#       find("[ui-sref='kpis']").click
#       expect(page).to have_selector("button.disabled.btn-new-kpi")
#     end
#   end
end
