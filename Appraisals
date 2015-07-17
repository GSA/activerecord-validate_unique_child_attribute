{
  '3.2' => '3.2.14',
  '4.0' => '4.0.13',
  '4.1' => '4.1.12',
  '4.2' => '4.2.3'
}.each do |name, version|
  appraise "ar-#{name}" do
    gem 'activerecord', "= #{version}"
    gem 'activemodel', "= #{version}"
    gem 'activesupport', "= #{version}"
  end
end
