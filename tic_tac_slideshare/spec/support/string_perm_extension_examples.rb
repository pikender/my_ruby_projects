shared_examples "my_string_permutation" do
  it "should show unique permutations of 'abc'" do
    res = "abc".perm
    res.should have(6).items
    ["abc", "acb", "bac", "bca", "cab", "cba"].each do |perm_val|
      res.should include(perm_val)
    end
  end
end
