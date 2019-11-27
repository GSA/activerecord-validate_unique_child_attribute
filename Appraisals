{
  '3.2' => '3.2.22.5',
  '4.0' => '4.0.13',
  '4.1' => '4.1.12',
  '4.2' => '4.2.10',
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
