{
  '5.0' => '5.0.0.1',
  '5.1' => '5.1.4',
  '5.2' => '5.2.3'
}.each do |name, version|
  appraise "ar-#{name}" do
    gem 'activerecord', "= #{version}"
    gem 'activemodel', "= #{version}"
    gem 'activesupport', "= #{version}"
  end
end
