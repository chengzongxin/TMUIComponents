#
# Be sure to run `pod lib lint TMUIComponents.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'TMUIComponents'
  s.version          = '0.1.0'
  s.summary          = 'A short description of TMUIComponents.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/chengzongxin/TMUIComponents'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'chengzongxin' => 'joe.cheng@corp.to8to.com' }
  s.source           = { :git => 'https://github.com/chengzongxin/TMUIComponents.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  
  s.public_header_files = 'TMUIComponents/Classes/*.h'

  s.dependency 'Masonry'
  s.dependency 'TMUICore'
  s.dependency 'TMUIExtensions'

  #TMUIWidgets 基类控件
  s.subspec 'TMUIWidgets' do |ss|
    #引入TMUIWidgets中所有资源文件
    ss.source_files = 'TMUIComponents/Classes/TMUIWidgets/TMUIWidgets.h'
    # TMUIButton
    ss.subspec 'TMUIButton' do |sss|
      sss.source_files = 'TMUIComponents/Classes/TMUIWidgets/TMUIButton'
    end
    # TMUILabel
    ss.subspec 'TMUILabel' do |sss|
      sss.source_files = 'TMUIComponents/Classes/TMUIWidgets/TMUILabel'
    end
    # TMUITextField
    ss.subspec 'TMUITextField' do |sss|
      sss.source_files = 'TMUIComponents/Classes/TMUIWidgets/TMUITextField'
    end
    # TMUITextView
    ss.subspec 'TMUITextView' do |sss|
      sss.source_files = 'TMUIComponents/Classes/TMUIWidgets/TMUITextView'
    end
    # TMUISlider
    ss.subspec 'TMUISlider' do |sss|
      sss.source_files = 'TMUIComponents/Classes/TMUIWidgets/TMUISlider'
    end
    # TMUISegmentedControl
    ss.subspec 'TMUISegmentedControl' do |sss|
      sss.source_files = 'TMUIComponents/Classes/TMUIWidgets/TMUISegmentedControl'
    end
  end
  
  # TMUIMultipleDelegates
  s.subspec 'TMUIMultipleDelegates' do |ss|
    ss.source_files = 'TMUIComponents/Classes/TMUIMultipleDelegates/*.{h,m}'
  end
  
  s.subspec 'TMContentAlert' do |ss|
    ss.source_files = 'TMUIComponents/Classes/TMContentAlert/*.{h,m}'
  end
  
  s.subspec 'TMContentPicker' do |ss|
    ss.source_files = 'TMUIComponents/Classes/TMContentPicker/*.{h,m}'
    ss.subspec 'TMNormalPicker' do |sss|
      sss.source_files = 'TMUIComponents/Classes/TMContentPicker/TMNormalPicker'
    end
    ss.subspec 'TMDatePicker' do |sss|
      sss.source_files = 'TMUIComponents/Classes/TMContentPicker/TMDatePicker'
    end
    ss.subspec 'TMMultiDataPicker' do |sss|
      sss.source_files = 'TMUIComponents/Classes/TMContentPicker/TMMultiDataPicker'
    end
    ss.subspec 'TMCityPicker' do |sss|
      sss.source_files = 'TMUIComponents/Classes/TMContentPicker/TMCityPicker'
    end
  end
  
  s.subspec 'TMActionSheet' do |ss|
    ss.source_files = 'TMUIComponents/Classes/TMActionSheet/*.{h,m}'
  end
  
  s.subspec 'TMPopoverView' do |ss|
    ss.source_files = 'TMUIComponents/Classes/TMPopoverView/*.{h,m}'
  end
  
  s.subspec 'TMUIMenuView' do |ss|
      ss.source_files = 'TMUIComponents/Classes/TMUIMenuView/*.{h,m}'
  end
  
  s.subspec 'TMSearchController' do |ss|
    ss.source_files = 'TMUIComponents/Classes/TMSearchController/*.{h,m}'
    ss.subspec 'Private' do |sss|
      sss.private_header_files = 'TMUIComponents/Classes/TMSearchController/Private/*.{h}'
      sss.source_files = 'TMUIComponents/Classes/TMSearchController/Private/*.{h,m}'
    end
    ss.subspec 'Extensions' do |sss|
      sss.source_files = 'TMUIComponents/Classes/TMSearchController/Extensions/*.{h,m}'
    end
    # TMSearchUIAssets 后续不要随便修改名字，pod库内相关图片数据读取的Bundle名是固定写死为TMSearchUIAssets.bundle
    ss.resource_bundles = {
      'TMSearchUIAssets' => ['TMUIComponents/Classes/TMSearchController/Resource/*.png']
    }
  end
  
  # TMUICellHeightCache
  s.subspec 'TMUICellHeightCache' do |ss|
    ss.source_files = 'TMUIComponents/Classes/TMUICellHeightCache/*.{h,m}'
  end
  
  # TMUIBadge
  s.subspec 'TMUIBadge' do |ss|
    ss.source_files = 'TMUIComponents/Classes/TMUIBadge/*.{h,m}'
  end

  # TMUIPageViewController 项目中的 THKPageContentViewController封装抽取
  s.subspec 'TMUIPageViewController' do |ss|
    ss.source_files = 'TMUIComponents/Classes/TMUIPageViewController/*.{h,m}'
  end

  s.subspec 'TMUIToast' do |ss|
    ss.source_files = 'TMUIComponents/Classes/TMUIToast/*.{h,m}'
    # TMUIToastUIAssets 后续不要随便修改名字，pod库内相关图片数据读取的Bundle名是固定写死为TMUIToastUIAssets.bundle
    ss.resource_bundles = {
      'TMUIToastUIAssets' => ['TMUIComponents/Classes/TMUIToast/Resource/*']
    }
  end

  s.subspec 'TMUIExpandLabel' do |ss|
    ss.source_files = 'TMUIComponents/Classes/TMUIExpandLabel/*.{h,m}'
  end

  s.subspec 'TMUIFloatLayoutView' do |ss|
    ss.source_files = 'TMUIComponents/Classes/TMUIFloatLayoutView/*.{h,m}'
  end

  s.subspec 'TMUIFloatImagesView' do |ss|
    ss.source_files = 'TMUIComponents/Classes/TMUIFloatImagesView/*.{h,m}'
  end

  s.subspec 'TMUITimer' do |ss|
    ss.source_files = 'TMUIComponents/Classes/TMUITimer/*.{h,m}'
  end

  s.subspec 'TMUICycleView' do |ss|
    ss.source_files = 'TMUIComponents/Classes/TMUICycleView/*.{h,m}'
  end

  s.subspec 'TMUISegmentView' do |ss|
    ss.source_files = 'TMUIComponents/Classes/TMUISegmentView/*.{h,m}'
  end

  s.subspec 'TMUISearchBar' do |ss|
    ss.source_files = 'TMUIComponents/Classes/TMUISearchBar/*.{h,m}'
    ss.resource_bundles = {
      'TMUISearchBarUIAssets' => ['TMUIComponents/Classes/TMUISearchBar/Resource/*']
    }
  end

  s.subspec 'TMUIFilterView' do |ss|
    ss.source_files = 'TMUIComponents/Classes/TMUIFilterView/*.{h,m}'
  end

  s.subspec 'TMUIPickerView' do |ss|
    ss.source_files = 'TMUIComponents/Classes/TMUIPickerView/*.{h,m}'
  end

  s.subspec 'TMUIAppearance' do |ss|
    ss.source_files = 'TMUIComponents/Classes/TMUIAppearance/*.{h,m}'
  end

  s.subspec 'TMUIPopupContainerView' do |ss|
    ss.source_files = 'TMUIComponents/Classes/TMUIPopupContainerView/*.{h,m}'
  end

  s.subspec 'TMUINavigationBar' do |ss|
    ss.source_files = 'TMUIComponents/Classes/TMUINavigationBar/*.{h,m}'
    ss.resource_bundles = {
        'TMUINavigationBarUIAssets' => ['TMUIComponents/Classes/TMUINavigationBar/Resource/*']
      }
  end


    s.subspec 'TMUITableView' do |ss|
      ss.source_files = 'TMUIComponents/Classes/TMUITableView/*.{h,m}'
    end


    s.subspec 'TMShowBigImageController' do |ss|
      ss.source_files = 'TMUIComponents/Classes/TMShowBigImageController/*.{h,m}'
    end

    s.subspec 'TMUIModalPresentationViewController' do |ss|
      ss.source_files = 'TMUIComponents/Classes/TMUIModalPresentationViewController/*.{h,m}'
    end
    
    
    ######################## begin 以下组件在项目中暂不使用，先屏蔽，只在Demo中打开 ########################

#    s.subspec 'TMUITheme' do |ss|
#      ss.source_files = 'TMUIComponents/Classes/TMUITheme/*.{h,m}'
#    end

     ########################  end 以上组件只在demo中打开  ########################
end
