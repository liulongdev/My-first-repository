# 替换workspace的名字
myworkspace="maxiaoding.xcodeproj.xcworkspace" 
# 替换scheme的名字
myscheme="maxiaoding" 
# 输出方式 xcode/pmd/html
reportType="xcode"

# [自定义report](http://docs.oclint.org/en/stable/howto/selectreporters.html) 如：
nowReportType="-report-type html -o oclint_result.html"

# 自定义排除警告的目录，将目录字符串加到数组里面，结果中将不会含有Pods文件夹下文件编译警告
#exclude_files=("test_js" "Pods")


xcodebuild -workspace $myworkspace -scheme $myscheme clean&&
xcodebuild -workspace $myworkspace -scheme $myscheme \
-configuration Debug \
| xcpretty -r json-compilation-database -o compile_commands.json&&
oclint-json-compilation-database -e Pods -- \
-report-type html -o oclint_result.html \
-rc LONG_LINE=200 \
-max-priority-1=100000 \
-max-priority-2=100000 \
-max-priority-3=100000; \
rm compile_commands.json;
if [ -f ./oclint_result.html ]; then echo '-----分析完毕-----'
else echo "-----分析失败-----"; fi
