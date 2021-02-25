defmodule WitchcraftersPlayTest do
  alias WitchcraftersPlay.Tree23
  import Algae
  use ExUnitProperties
  use  WitchcraftersPlay.TreeCase

  # helper function tests
  test "put_in for nested structs" do
    assert Tree23.struct_put_in(%Tree23.Node2{lower_key: 3, max_right_key: 4, left: %Tree23.Leaf{key: 3, value: %{a: 1, b: 2}},
                                       right: %Tree23.Leaf{key: 4, value: "xyzzy"}}, [:left, :value], "Now is the time") ==
      %Tree23.Node2{lower_key: 3, max_right_key: 4, left: %Tree23.Leaf{key: 3, value: "Now is the time"},
                    right: %Tree23.Leaf{key: 4, value: "xyzzy"}}
  end

  # Empty tree tests

  test "creates an empty tree" do
    assert Tree23.Empty.new() == %Tree23.Empty{}
  end

  test "inserts an element into an empty tree" do
    assert Tree23.insert(%Tree23.Empty{}, 3, %{a: 1, b: 2}) == %Tree23.Leaf{key: 3, value: %{a: 1, b: 2}}
  end

  # Leaf node tests

  test "inserts an element on the right for a tree consisting of a single leaf" do
    assert Tree23.insert(%Tree23.Leaf{key: 3, value: %{a: 1, b: 2}}, 4, "xyzzy") ==
      %Tree23.Node2{lower_key: 3, max_right_key: 4, left: %Tree23.Leaf{key: 3, value: %{a: 1, b: 2}}, right: %Tree23.Leaf{key: 4, value: "xyzzy"}}
  end

  test "inserts an element on the left for a tree consisting of a single leaf" do
    assert Tree23.insert(%Tree23.Leaf{key: 3, value: %{a: 1, b: 2}}, 2, "xyzzy") ==
      %Tree23.Node2{
        left: %Tree23.Leaf{key: 2, value: "xyzzy"},
        lower_key: 2,
        right: %Tree23.Leaf{key: 3, value: %{a: 1, b: 2}},
        max_right_key: 3
      }
  end
  test "updates an element in a tree consisting of a single leaf" do
    assert Tree23.insert(%Tree23.Leaf{key: 3, value: %{a: 1, b: 2}}, 3, "xyzzy") ==
      %Tree23.Leaf{key: 3, value: "xyzzy"}
  end

  # Two child node with leaves as children tests (base case)

  test "left insert for two node" do
    assert Tree23.insert(%Tree23.Node2{
          left: %Tree23.Leaf{key: 2, value: "xyzzy"},
          lower_key: 2,
          right: %Tree23.Leaf{key: 3, value: %{a: 1, b: 2}},
          max_right_key: 3
      },
      1, "abcd") ==
      %Tree23.Node3{
        left: %Tree23.Leaf{key: 1, value: "abcd"},
        middle: %Tree23.Leaf{key: 2, value: "xyzzy"},
        lower_key: 1,
        right: %Tree23.Leaf{key: 3, value: %{a: 1, b: 2}},
        upper_key: 2,
        max_right_key: 3
      }
  end

  test "right insert for two node" do
    assert Tree23.insert(%Tree23.Node2{
          left: %Tree23.Leaf{key: 2, value: "xyzzy"},
          lower_key: 2,
          right: %Tree23.Leaf{key: 3, value: %{a: 1, b: 2}},
          max_right_key: 3
      },
      4, "abcd") ==
      %Tree23.Node3{
        left: %Tree23.Leaf{key: 2, value: "xyzzy"},
        middle: %Tree23.Leaf{key: 3, value: %{a: 1, b: 2}},
        lower_key: 2,
        right: %Tree23.Leaf{key: 4, value: "abcd"},
        upper_key: 3,
        max_right_key: 4
      }
  end

  test "middle insert for two node" do
    assert Tree23.insert(%Tree23.Node2{
          left: %Tree23.Leaf{key: 1, value: "xyzzy"},
          lower_key: 1,
          right: %Tree23.Leaf{key: 3, value: %{a: 1, b: 2}},
          max_right_key: 3
},
      2, "abcd") ==
      %Tree23.Node3{
        left: %Tree23.Leaf{key: 1, value: "xyzzy"},
        middle: %Tree23.Leaf{key: 2, value: "abcd"},
        lower_key: 1,
        right: %Tree23.Leaf{key: 3, value: %{a: 1, b: 2}},
        upper_key: 2,
        max_right_key: 3
      }
  end

  test "right node value update" do
   assert Tree23.insert(%Tree23.Node2{
          left: %Tree23.Leaf{key: 1, value: "xyzzy"},
          lower_key: 1,
          right: %Tree23.Leaf{key: 3, value: %{a: 1, b: 2}},
          max_right_key: 3
},
     3, "abcd") ==
      %Tree23.Node2{
            left: %Tree23.Leaf{key: 1, value: "xyzzy"},
            lower_key: 1,
            right: %Tree23.Leaf{key: 3, value: "abcd"},
            max_right_key: 3
}
  end

        test "left node value update" do
          assert Tree23.insert(%Tree23.Node2{
                left: %Tree23.Leaf{key: 1, value: "xyzzy"},
                lower_key: 1,
                right: %Tree23.Leaf{key: 3, value: %{a: 1, b: 2}},
                max_right_key: 3
},
            1, "abcd") ==
            %Tree23.Node2{
                  left: %Tree23.Leaf{key: 1, value: "abcd"},
                  lower_key: 1,
                  right: %Tree23.Leaf{key: 3, value: %{a: 1, b: 2}},
                  max_right_key: 3
}
  end

  # Three child nodes with leaves (base case)
        test "left node insert for 3 node" do
          assert Tree23.insert(%Tree23.Node3{
                left: %Tree23.Leaf{key: 2, value: "xyzzy"},
                middle: %Tree23.Leaf{key: 4, value: "abcd"},
                lower_key: 2,
                right: %Tree23.Leaf{key: 6, value: %{a: 1, b: 2}},
                upper_key: 4,
                max_right_key: 6
},
            1, "Now is the time") ==
            %Tree23.Node4{
              left: %Tree23.Leaf{key: 1, value: "Now is the time"},
              lower_middle: %Tree23.Leaf{key: 2, value: "xyzzy"},
              upper_middle: %Tree23.Leaf{key: 4, value: "abcd"},
              lower_key: 1,
              right: %Tree23.Leaf{key: 6, value: %{a: 1, b: 2}},
              upper_key: 4,
              middle_key: 2,
              max_right_key: 6
            }
        end

        test "lower middle node insert for 3 node" do
          assert Tree23.insert(%Tree23.Node3{
                left: %Tree23.Leaf{key: 2, value: "xyzzy"},
                middle: %Tree23.Leaf{key: 4, value: "abcd"},
                lower_key: 2,
                right: %Tree23.Leaf{key: 6, value: %{a: 1, b: 2}},
                upper_key: 4,
                max_right_key: 6
},
            3, "Now is the time") ==
            %Tree23.Node4{
              left: %Tree23.Leaf{key: 2, value: "xyzzy"},
              lower_middle: %Tree23.Leaf{key: 3, value: "Now is the time"},
              upper_middle: %Tree23.Leaf{key: 4, value: "abcd"},
              lower_key: 2,
              right: %Tree23.Leaf{key: 6, value: %{a: 1, b: 2}},
              upper_key: 4,
              middle_key: 3,
              max_right_key: 6
            }
        end

        test "upper middle node insert for 3 node" do
          assert Tree23.insert(%Tree23.Node3{
                left: %Tree23.Leaf{key: 2, value: "xyzzy"},
                middle: %Tree23.Leaf{key: 4, value: "abcd"},
                lower_key: 2,
                right: %Tree23.Leaf{key: 6, value: %{a: 1, b: 2}},
                upper_key: 4,
                max_right_key: 6
},
            5, "Now is the time") ==
            %Tree23.Node4{
              left: %Tree23.Leaf{key: 2, value: "xyzzy"},
              lower_middle: %Tree23.Leaf{key: 4, value: "abcd"},
              upper_middle: %Tree23.Leaf{key: 5, value: "Now is the time"},
              lower_key: 2,
              right: %Tree23.Leaf{key: 6, value: %{a: 1, b: 2}},
              upper_key: 5,
              middle_key: 4,
              max_right_key: 6
            }
        end

        test "upper node insert for 3 node" do
          assert Tree23.insert(%Tree23.Node3{
                left: %Tree23.Leaf{key: 2, value: "xyzzy"},
                middle: %Tree23.Leaf{key: 4, value: "abcd"},
                lower_key: 2,
                right: %Tree23.Leaf{key: 6, value: %{a: 1, b: 2}},
                upper_key: 4,
                max_right_key: 6
},
            7, "Now is the time") ==
            %Tree23.Node4{
              left: %Tree23.Leaf{key: 2, value: "xyzzy"},
              lower_middle: %Tree23.Leaf{key: 4, value: "abcd"},
              upper_middle: %Tree23.Leaf{key: 6, value: %{a: 1, b: 2}},
              lower_key: 2,
              right: %Tree23.Leaf{key: 7, value: "Now is the time"},
              upper_key: 6,
              middle_key: 4,
              max_right_key: 7
            }
        end

        test "left node update for 3 node" do
          assert Tree23.insert(%Tree23.Node3{
                left: %Tree23.Leaf{key: 2, value: "xyzzy"},
                middle: %Tree23.Leaf{key: 4, value: "abcd"},
                lower_key: 2,
                right: %Tree23.Leaf{key: 6, value: %{a: 1, b: 2}},
                upper_key: 4,
                max_right_key: 6
},
            2, "Now is the time") ==
            %Tree23.Node3{
              left: %Tree23.Leaf{key: 2, value: "Now is the time"},
              middle: %Tree23.Leaf{key: 4, value: "abcd"},
              lower_key: 2,
              right: %Tree23.Leaf{key: 6, value: %{a: 1, b: 2}},
              upper_key: 4,
              max_right_key: 6
            }
        end

        test "middle node update for 3 node" do
          assert Tree23.insert(%Tree23.Node3{
                left: %Tree23.Leaf{key: 2, value: "xyzzy"},
                middle: %Tree23.Leaf{key: 4, value: "abcd"},
                lower_key: 2,
                right: %Tree23.Leaf{key: 6, value: %{a: 1, b: 2}},
                upper_key: 4,
                max_right_key: 6
},
            4, "Now is the time") ==
            %Tree23.Node3{
              left: %Tree23.Leaf{key: 2, value: "xyzzy"},
              middle: %Tree23.Leaf{key: 4, value: "Now is the time"},
              lower_key: 2,
              right: %Tree23.Leaf{key: 6, value: %{a: 1, b: 2}},
              upper_key: 4,
              max_right_key: 6
            }
        end

        test "right node update for 3 node" do
          assert Tree23.insert(%Tree23.Node3{
                left: %Tree23.Leaf{key: 2, value: "xyzzy"},
                middle: %Tree23.Leaf{key: 4, value: "abcd"},
                lower_key: 2,
                right: %Tree23.Leaf{key: 6, value: %{a: 1, b: 2}},
                upper_key: 4,
                max_right_key: 6
},
            6, "Now is the time") ==
            %Tree23.Node3{
              left: %Tree23.Leaf{key: 2, value: "xyzzy"},
              middle: %Tree23.Leaf{key: 4, value: "abcd"},
              lower_key: 2,
              right: %Tree23.Leaf{key: 6, value: "Now is the time"},
              upper_key: 4,
              max_right_key: 6
            }
        end

        # 2 node recursive case tests
        test "Left child updated, but not to a 4 node" do
          assert Tree23.insert(%Tree23.Node2{
                left: %Tree23.Node2{left: %Tree23.Leaf{key: 6, value: "a"},
                                    right: %Tree23.Leaf{key: 8, value: "b"},
                                   lower_key: 6, max_right_key: 8},
                right: %Tree23.Node2{left: %Tree23.Leaf{key: 10, value: "c"},
                                     right: %Tree23.Leaf{key: 12, value: "d"},
                                     lower_key: 10, max_right_key: 12},
                lower_key: 8, max_right_key: 12}, 11, "e") ==
            %Tree23.Node2{
                  left: %Tree23.Node2{left: %Tree23.Leaf{key: 6, value: "a"},
                                      right: %Tree23.Leaf{key: 8, value: "b"},
                                      lower_key: 6, max_right_key: 8},
                  right: %Tree23.Node3{left: %Tree23.Leaf{key: 10, value: "c"},
                                       right: %Tree23.Leaf{key: 12, value: "d"},
                                       middle: %Tree23.Leaf{key: 11, value: "e"},
                                       lower_key: 10, upper_key: 11, max_right_key: 12},
                  lower_key: 8, max_right_key: 12}
        end

        test "Right child updated, but not to a 4 node" do
          assert Tree23.insert(%Tree23.Node2{
                left: %Tree23.Node2{left: %Tree23.Leaf{key: 6, value: "a"},
                                    right: %Tree23.Leaf{key: 8, value: "b"},
                                   lower_key: 6, max_right_key: 8},
                right: %Tree23.Node2{left: %Tree23.Leaf{key: 10, value: "c"},
                                     right: %Tree23.Leaf{key: 12, value: "d"},
                                     lower_key: 10, max_right_key: 12},
                lower_key: 8, max_right_key: 12}, 14, "e") ==
            %Tree23.Node2{
                  left: %Tree23.Node2{left: %Tree23.Leaf{key: 6, value: "a"},
                                      right: %Tree23.Leaf{key: 8, value: "b"},
                                      lower_key: 6, max_right_key: 8},
                  right: %Tree23.Node3{left: %Tree23.Leaf{key: 10, value: "c"},
                                       middle: %Tree23.Leaf{key: 12, value: "d"},
                                       right: %Tree23.Leaf{key: 14, value: "e"},
                                       lower_key: 10, upper_key: 12, max_right_key: 14},
                  lower_key: 8, max_right_key: 14}
        end

                test "Left child updated, to a 4 node" do
          assert Tree23.insert(%Tree23.Node2{
                left: %Tree23.Node3{left: %Tree23.Leaf{key: 6, value: "a"},
                                    middle: %Tree23.Leaf{key: 7, value: "f"},
                                    right: %Tree23.Leaf{key: 8, value: "b"},
                                   lower_key: 6, upper_key: 7, max_right_key: 8},
                right: %Tree23.Node2{left: %Tree23.Leaf{key: 10, value: "c"},
                                     right: %Tree23.Leaf{key: 12, value: "d"},
                                     lower_key: 10, max_right_key: 12},
                lower_key: 8, max_right_key: 12},5, "e") ==
            %Tree23.Node3{
                  left: %Tree23.Node2{left: %Tree23.Leaf{key: 5, value: "e"},
                                      right: %Tree23.Leaf{key: 6, value: "a"},
                                      lower_key: 5, max_right_key: 6},
                  middle: %Tree23.Node2{left: %Tree23.Leaf{key: 7, value: "f"},
                                        right: %Tree23.Leaf{key: 8, value: "b"},
                                        lower_key: 7, max_right_key: 8},
                  right: %Tree23.Node2{left: %Tree23.Leaf{key: 10, value: "c"},
                                       right: %Tree23.Leaf{key: 12, value: "d"},
                                       lower_key: 10,  max_right_key: 12},
                  lower_key: 6, upper_key: 8, max_right_key: 12}
        end

        test "Right child updated, to a 4 node" do
          assert Tree23.insert(%Tree23.Node2{
                left: %Tree23.Node2{left: %Tree23.Leaf{key: 6, value: "a"},
                                    right: %Tree23.Leaf{key: 8, value: "b"},
                                   lower_key: 6, max_right_key: 8},
                right: %Tree23.Node3{left: %Tree23.Leaf{key: 10, value: "c"},
                                     middle: %Tree23.Leaf{key: 12, value: "d"},
                                     right: %Tree23.Leaf{key: 14, value: "f"},
                                     lower_key: 10, upper_key: 12, max_right_key: 14},
                lower_key: 8, max_right_key: 12}, 16, "e") ==
            %Tree23.Node3{
                  left: %Tree23.Node2{left: %Tree23.Leaf{key: 6, value: "a"},
                                      right: %Tree23.Leaf{key: 8, value: "b"},
                                      lower_key: 6, max_right_key: 8},
                  middle: %Tree23.Node2{left: %Tree23.Leaf{key: 10, value: "c"},
                                        right: %Tree23.Leaf{key: 12, value: "d"},
                                        lower_key: 10, max_right_key: 12},
                  right: %Tree23.Node2{left: %Tree23.Leaf{key: 14, value: "f"},
                                       right: %Tree23.Leaf{key: 16, value: "e"},
                                       lower_key: 14, max_right_key: 16},
                  lower_key: 8, upper_key: 12, max_right_key: 16}
                end

        # 3 node recursive case
        test "left branch updated, but not to a 4 node" do
          assert Tree23.insert(%Tree23.Node3{
                left: %Tree23.Node2{left: %Tree23.Leaf{key: 2, value: "a"},
                                    right: %Tree23.Leaf{key: 4, value: "b"},
                                    lower_key: 2, max_right_key: 4},
                middle: %Tree23.Node2{left: %Tree23.Leaf{key: 8, value: "c"},
                                      right: %Tree23.Leaf{key: 10, value: "d"},
                                      lower_key: 8, max_right_key: 10},
                right: %Tree23.Node2{left: %Tree23.Leaf{key: 14, value: "e"},
                                     right: %Tree23.Leaf{key: 16, value: "f"},
                                     lower_key: 14, max_right_key: 16},
                lower_key: 4, upper_key: 10, max_right_key: 16}, 1, "g") ==
            %Tree23.Node3{
                  left: %Tree23.Node3{left: %Tree23.Leaf{key: 1, value: "g"},
                                      middle: %Tree23.Leaf{key: 2, value: "a"},
                                      right: %Tree23.Leaf{key: 4, value: "b"},
                                      lower_key: 1, upper_key: 2, max_right_key: 4},
                  middle: %Tree23.Node2{left: %Tree23.Leaf{key: 8, value: "c"},
                                        right: %Tree23.Leaf{key: 10, value: "d"},
                                        lower_key: 8, max_right_key: 10},
                  right: %Tree23.Node2{left: %Tree23.Leaf{key: 14, value: "e"},
                                       right: %Tree23.Leaf{key: 16, value: "f"},
                                       lower_key: 14, max_right_key: 16},
                  lower_key: 4, upper_key: 10, max_right_key: 16}
        end

        test "middle branch updated, but not to a 4 node" do
          assert Tree23.insert(%Tree23.Node3{
                left: %Tree23.Node2{left: %Tree23.Leaf{key: 2, value: "a"},
                                    right: %Tree23.Leaf{key: 4, value: "b"},
                                    lower_key: 2, max_right_key: 4},
                middle: %Tree23.Node2{left: %Tree23.Leaf{key: 8, value: "c"},
                                      right: %Tree23.Leaf{key: 10, value: "d"},
                                      lower_key: 8, max_right_key: 10},
                right: %Tree23.Node2{left: %Tree23.Leaf{key: 14, value: "e"},
                                     right: %Tree23.Leaf{key: 16, value: "f"},
                                     lower_key: 14, max_right_key: 16},
                lower_key: 4, upper_key: 10, max_right_key: 16}, 9, "g") ==
            %Tree23.Node3{
                  left: %Tree23.Node2{left: %Tree23.Leaf{key: 2, value: "a"},
                                      right: %Tree23.Leaf{key: 4, value: "b"},
                                      lower_key: 2, max_right_key: 4},
                  middle: %Tree23.Node3{left: %Tree23.Leaf{key: 8, value: "c"},
                                        middle: %Tree23.Leaf{key: 9, value: "g"},
                                        right: %Tree23.Leaf{key: 10, value: "d"},
                                        lower_key: 8, upper_key: 9, max_right_key: 10},
                  right: %Tree23.Node2{left: %Tree23.Leaf{key: 14, value: "e"},
                                       right: %Tree23.Leaf{key: 16, value: "f"},
                                       lower_key: 14, max_right_key: 16},
                  lower_key: 4, upper_key: 10, max_right_key: 16}
        end

        test "right branch updated, but not to a 4 node" do
          assert Tree23.insert(%Tree23.Node3{
                left: %Tree23.Node2{left: %Tree23.Leaf{key: 2, value: "a"},
                                    right: %Tree23.Leaf{key: 4, value: "b"},
                                    lower_key: 2, max_right_key: 4},
                middle: %Tree23.Node2{left: %Tree23.Leaf{key: 8, value: "c"},
                                      right: %Tree23.Leaf{key: 10, value: "d"},
                                      lower_key: 8, max_right_key: 10},
                right: %Tree23.Node2{left: %Tree23.Leaf{key: 14, value: "e"},
                                     right: %Tree23.Leaf{key: 16, value: "f"},
                                     lower_key: 14, max_right_key: 16},
                lower_key: 4, upper_key: 10, max_right_key: 16}, 18, "g") ==
            %Tree23.Node3{
                  left: %Tree23.Node2{left: %Tree23.Leaf{key: 2, value: "a"},
                                      right: %Tree23.Leaf{key: 4, value: "b"},
                                      lower_key: 2, max_right_key: 4},
                  middle: %Tree23.Node2{left: %Tree23.Leaf{key: 8, value: "c"},
                                        right: %Tree23.Leaf{key: 10, value: "d"},
                                        lower_key: 8, max_right_key: 10},
                  right: %Tree23.Node3{left: %Tree23.Leaf{key: 14, value: "e"},
                                       middle: %Tree23.Leaf{key: 16, value: "f"},
                                       right: %Tree23.Leaf{key: 18, value: "g"},
                                       lower_key: 14, upper_key: 16, max_right_key: 18},
                  lower_key: 4, upper_key: 10, max_right_key: 18}
        end

        test "left branch updated, to a 4 node" do
          assert Tree23.insert(%Tree23.Node3{
                left: %Tree23.Node3{left: %Tree23.Leaf{key: 1, value: "z"},
                                    middle: %Tree23.Leaf{key: 2, value: "a"},
                                    right: %Tree23.Leaf{key: 4, value: "b"},
                                    lower_key: 1, upper_key: 2, max_right_key: 4},
                middle: %Tree23.Node2{left: %Tree23.Leaf{key: 8, value: "c"},
                                      right: %Tree23.Leaf{key: 10, value: "d"},
                                      lower_key: 8, max_right_key: 10},
                right: %Tree23.Node2{left: %Tree23.Leaf{key: 14, value: "e"},
                                     right: %Tree23.Leaf{key: 16, value: "f"},
                                     lower_key: 14, max_right_key: 16},
                lower_key: 4, upper_key: 10, max_right_key: 16}, 3, "g") ==
            %Tree23.Node4{
                  left: %Tree23.Node2{left: %Tree23.Leaf{key: 1, value: "z"},
                                      right: %Tree23.Leaf{key: 2, value: "a"},
                                      lower_key: 1, max_right_key: 2},
                  lower_middle: %Tree23.Node2{
                                      left: %Tree23.Leaf{key: 3, value: "g"},
                                      right: %Tree23.Leaf{key: 4, value: "b"},
                                      lower_key: 3, max_right_key: 4},
                  upper_middle: %Tree23.Node2{left: %Tree23.Leaf{key: 8, value: "c"},
                                        right: %Tree23.Leaf{key: 10, value: "d"},
                                        lower_key: 8, max_right_key: 10},
                  right: %Tree23.Node2{left: %Tree23.Leaf{key: 14, value: "e"},
                                       right: %Tree23.Leaf{key: 16, value: "f"},
                                       lower_key: 14, max_right_key: 16},
                  lower_key: 2, middle_key: 4 ,upper_key: 10, max_right_key: 16}
        end

        test "Root node put where insert call returns Node2 or Node3" do
          assert Tree23.put(%Tree23.Node2{left: %Tree23.Leaf{key: 2, value: "a"},
                                          right: %Tree23.Leaf{key: 4, value: "b"},
                                          lower_key: 2, max_right_key: 4}, 3, "c") ==
            %Tree23.Node3{left: %Tree23.Leaf{key: 2, value: "a"},
                                     middle: %Tree23.Leaf{key: 3, value: "c"},
                                     right: %Tree23.Leaf{key: 4, value: "b"},
                                     lower_key: 2, upper_key: 3, max_right_key: 4}
        end

        test "Root node put where insert call returns Node4" do
          assert Tree23.put(%Tree23.Node3{left: %Tree23.Leaf{key: 2, value: "a"},
                                          middle: %Tree23.Leaf{key: 3, value: "c"},
                                          right: %Tree23.Leaf{key: 4, value: "b"},
                                          lower_key: 2, upper_key: 3, max_right_key: 4}, 5, "d") ==
            %Tree23.Node2{left: %Tree23.Node2{left: %Tree23.Leaf{key: 2, value: "a"},
                                              right: %Tree23.Leaf{key: 3, value: "c"}, lower_key: 2, max_right_key: 3},
                          right: %Tree23.Node2{left: %Tree23.Leaf{key: 4, value: "b"},
                                               right: %Tree23.Leaf{key: 5, value: "d"}, lower_key: 4, max_right_key: 5},
                          lower_key: 3, max_right_key: 5}
        end

        test "to_list for empty tree" do
          assert Tree23.to_list(%Tree23.Empty{}) == []
        end

        test "to_list for a 2 Node" do
          assert Tree23.to_list(%Tree23.Node2{left: %Tree23.Leaf{key: 1, value: "a"},
                                       right: %Tree23.Leaf{key: 2, value: "b"}, lower_key: 1, max_right_key: 2}) == [{1, "a"}, {2, "b"}]
        end

        test "to_list for a 3 Node" do
          assert Tree23.to_list(%Tree23.Node3{left: %Tree23.Leaf{key: 1, value: "a"},
                                       middle: %Tree23.Leaf{key: 2, value: "b"},
                                       right: %Tree23.Leaf{key: 3, value: "c"}, lower_key: 1, upper_key: 2, max_right_key: 3}) == [{1, "a"}, {2, "b"}, {3, "c"}]
        end

        test "Tree keys are correct" do
          assert WitchcraftersPlay.TreeCase.check_tree_keys(%Tree23.Node2{left: %Tree23.Node2{left: %Tree23.Leaf{key: 2, value: "a"},
                                                                   right: %Tree23.Leaf{key: 3, value: "c"}, lower_key: 2, max_right_key: 3},
                                               right: %Tree23.Node2{left: %Tree23.Leaf{key: 4, value: "b"},
                                                                    right: %Tree23.Leaf{key: 5, value: "d"}, lower_key: 4, max_right_key: 5},
                                               lower_key: 3, max_right_key: 5}) == {:ok, 5}
        end

        property "2-3 trees are properly formed" do
          check all vals <-
          StreamData.uniq_list_of(StreamData.tuple({StreamData.integer(-100..100), StreamData.string(:ascii)}), min_length: 10, uniq_fun: &elem(&1, 0))
            do
            tree = Enum.reduce(vals, %Tree23.Empty{}, fn el, acc -> Tree23.put(acc, elem(el, 0), elem(el,1)) end)
            map = Enum.reduce(vals, %{}, fn el, acc -> Map.put(acc, elem(el, 0), elem(el, 1)) end)
            map_as_list = Enum.sort(Enum.to_list(map), &(elem(&1,0)) < elem(&2, 0))


            assert(Tree23.to_list(tree) == map_as_list)
          end
        end

        test "get on an empty tree returns nil" do
          assert Tree23.get(%Tree23.Empty{}, :c) == nil
        end

        test "get on a Leaf with the wrong key returns nil" do
          assert Tree23.get(%Tree23.Leaf{key: :a, value: 5}, :b) == nil
        end

        test "get on a Leaf with the right key returns the value" do
          assert Tree23.get(%Tree23.Leaf{key: :a, value: 5}, :a) == 5
        end

        test "get values from a 2 node" do
          assert Tree23.get(%Tree23.Node2{left: %Tree23.Leaf{key: 5, value: "a"},
                                          right: %Tree23.Leaf{key: 7, value: "b"},
                                          lower_key: 5, max_right_key: 7}, 5) == "a"
          assert Tree23.get(%Tree23.Node2{left: %Tree23.Leaf{key: 5, value: "a"},
                                          right: %Tree23.Leaf{key: 7, value: "b"},
                                          lower_key: 5, max_right_key: 7}, 6) == nil
          assert Tree23.get(%Tree23.Node2{left: %Tree23.Leaf{key: 5, value: "a"},
                                          right: %Tree23.Leaf{key: 7, value: "b"},
                                          lower_key: 5, max_right_key: 7}, 3) == nil
          assert Tree23.get(%Tree23.Node2{left: %Tree23.Leaf{key: 5, value: "a"},
                                          right: %Tree23.Leaf{key: 7, value: "b"},
                                          lower_key: 5, max_right_key: 7}, 7) == "b"
          assert Tree23.get(%Tree23.Node2{left: %Tree23.Leaf{key: 5, value: "a"},
                                          right: %Tree23.Leaf{key: 7, value: "b"},
                                          lower_key: 5, max_right_key: 7}, 9) == nil
        end

        test "get values from a 3 node" do
          assert Tree23.get(%Tree23.Node3{left: %Tree23.Leaf{key: 5, value: "a"},
                                           middle: %Tree23.Leaf{key: 7, value: "b"},
                                           right: %Tree23.Leaf{key: 9, value: "c"},
                                           lower_key: 5, upper_key: 7, max_right_key: 9}, 3) == nil
          assert Tree23.get(%Tree23.Node3{left: %Tree23.Leaf{key: 5, value: "a"},
                                           middle: %Tree23.Leaf{key: 7, value: "b"},
                                           right: %Tree23.Leaf{key: 9, value: "c"},
                                           lower_key: 5, upper_key: 7, max_right_key: 9}, 5) == "a"
          assert Tree23.get(%Tree23.Node3{left: %Tree23.Leaf{key: 5, value: "a"},
                                           middle: %Tree23.Leaf{key: 7, value: "b"},
                                           right: %Tree23.Leaf{key: 9, value: "c"},
                                           lower_key: 5, upper_key: 7, max_right_key: 9}, 6) == nil
          assert Tree23.get(%Tree23.Node3{left: %Tree23.Leaf{key: 5, value: "a"},
                                           middle: %Tree23.Leaf{key: 7, value: "b"},
                                           right: %Tree23.Leaf{key: 9, value: "c"},
                                           lower_key: 5, upper_key: 7, max_right_key: 9}, 7) == "b"
          assert Tree23.get(%Tree23.Node3{left: %Tree23.Leaf{key: 5, value: "a"},
                                           middle: %Tree23.Leaf{key: 7, value: "b"},
                                           right: %Tree23.Leaf{key: 9, value: "c"},
                                           lower_key: 5, upper_key: 7, max_right_key: 9}, 8) == nil
          assert Tree23.get(%Tree23.Node3{left: %Tree23.Leaf{key: 5, value: "a"},
                                           middle: %Tree23.Leaf{key: 7, value: "b"},
                                           right: %Tree23.Leaf{key: 9, value: "c"},
                                           lower_key: 5, upper_key: 7, max_right_key: 9}, 9) == "c"
          assert Tree23.get(%Tree23.Node3{left: %Tree23.Leaf{key: 5, value: "a"},
                                           middle: %Tree23.Leaf{key: 7, value: "b"},
                                           right: %Tree23.Leaf{key: 9, value: "c"},
                                           lower_key: 5, upper_key: 7, max_right_key: 9}, 10) == nil
        end

        # test mget - version of get that returns a Maybe
        test "mget on an empty tree returns nil" do
          assert Tree23.mget(%Tree23.Empty{}, :c) == %Algae.Maybe.Nothing{}
        end

        test "mget on a Leaf with the wrong key returns nil" do
          assert Tree23.mget(%Tree23.Leaf{key: :a, value: 5}, :b) == %Algae.Maybe.Nothing{}
        end

        test "mget on a Leaf with the right key returns the value" do
          assert Tree23.mget(%Tree23.Leaf{key: :a, value: 5}, :a) == %Algae.Maybe.Just{just: 5}
        end

        test "mget values from a 2 node" do
          assert Tree23.mget(%Tree23.Node2{left: %Tree23.Leaf{key: 5, value: "a"},
                                          right: %Tree23.Leaf{key: 7, value: "b"},
                                          lower_key: 5, max_right_key: 7}, 5) == %Algae.Maybe.Just{just: "a"}
          assert Tree23.mget(%Tree23.Node2{left: %Tree23.Leaf{key: 5, value: "a"},
                                          right: %Tree23.Leaf{key: 7, value: "b"},
                                           lower_key: 5, max_right_key: 7}, 6) == %Algae.Maybe.Nothing{}
          assert Tree23.mget(%Tree23.Node2{left: %Tree23.Leaf{key: 5, value: "a"},
                                          right: %Tree23.Leaf{key: 7, value: "b"},
                                           lower_key: 5, max_right_key: 7}, 3) == %Algae.Maybe.Nothing{}
          assert Tree23.mget(%Tree23.Node2{left: %Tree23.Leaf{key: 5, value: "a"},
                                          right: %Tree23.Leaf{key: 7, value: "b"},
                                          lower_key: 5, max_right_key: 7}, 7) == %Algae.Maybe.Just{just: "b"}
          assert Tree23.mget(%Tree23.Node2{left: %Tree23.Leaf{key: 5, value: "a"},
                                          right: %Tree23.Leaf{key: 7, value: "b"},
                                           lower_key: 5, max_right_key: 7}, 9) == %Algae.Maybe.Nothing{}
        end

        test "mget values from a 3 node" do
          assert Tree23.mget(%Tree23.Node3{left: %Tree23.Leaf{key: 5, value: "a"},
                                           middle: %Tree23.Leaf{key: 7, value: "b"},
                                           right: %Tree23.Leaf{key: 9, value: "c"},
                                           lower_key: 5, upper_key: 7, max_right_key: 9}, 3) == %Algae.Maybe.Nothing{}
          assert Tree23.mget(%Tree23.Node3{left: %Tree23.Leaf{key: 5, value: "a"},
                                           middle: %Tree23.Leaf{key: 7, value: "b"},
                                           right: %Tree23.Leaf{key: 9, value: "c"},
                                           lower_key: 5, upper_key: 7, max_right_key: 9}, 5) == %Algae.Maybe.Just{just: "a"}
          assert Tree23.mget(%Tree23.Node3{left: %Tree23.Leaf{key: 5, value: "a"},
                                           middle: %Tree23.Leaf{key: 7, value: "b"},
                                           right: %Tree23.Leaf{key: 9, value: "c"},
                                           lower_key: 5, upper_key: 7, max_right_key: 9}, 6) == %Algae.Maybe.Nothing{}
          assert Tree23.mget(%Tree23.Node3{left: %Tree23.Leaf{key: 5, value: "a"},
                                           middle: %Tree23.Leaf{key: 7, value: "b"},
                                           right: %Tree23.Leaf{key: 9, value: "c"},
                                           lower_key: 5, upper_key: 7, max_right_key: 9}, 7) == %Algae.Maybe.Just{just: "b"}
          assert Tree23.mget(%Tree23.Node3{left: %Tree23.Leaf{key: 5, value: "a"},
                                           middle: %Tree23.Leaf{key: 7, value: "b"},
                                           right: %Tree23.Leaf{key: 9, value: "c"},
                                           lower_key: 5, upper_key: 7, max_right_key: 9}, 8) == %Algae.Maybe.Nothing{}
          assert Tree23.mget(%Tree23.Node3{left: %Tree23.Leaf{key: 5, value: "a"},
                                           middle: %Tree23.Leaf{key: 7, value: "b"},
                                           right: %Tree23.Leaf{key: 9, value: "c"},
                                           lower_key: 5, upper_key: 7, max_right_key: 9}, 9) == %Algae.Maybe.Just{just: "c"}
          assert Tree23.mget(%Tree23.Node3{left: %Tree23.Leaf{key: 5, value: "a"},
                                           middle: %Tree23.Leaf{key: 7, value: "b"},
                                           right: %Tree23.Leaf{key: 9, value: "c"},
                                           lower_key: 5, upper_key: 7, max_right_key: 9}, 10) == %Algae.Maybe.Nothing{}
        end

        test "deleting from an empty tree returns an empty tree" do
          assert Tree23.delete_prime(%Tree23.Empty{}, :xyz) == %Tree23.Empty{}
        end

        test "deleting a key not in a leaf returns the original tree" do
          assert Tree23.delete_prime(%Tree23.Leaf{key: 3, value: 5}, 6) == %Tree23.Leaf{key: 3, value: 5}
        end

        test "deleting the key from a leaf returns empty" do
          assert Tree23.delete_prime(%Tree23.Leaf{key: 3, value: 5}, 3) == %Tree23.Empty{}
        end

        test "deleting a leaf child from a 2 node returns a 1 node" do
          assert Tree23.delete_prime(%Tree23.Node2{left: %Tree23.Leaf{key: 3, value: 5},
                                             right: %Tree23.Leaf{key: 6, value: 2},
                                             lower_key: 3, max_right_key: 6}, 3) ==
            %Tree23.Node1{node: %Tree23.Leaf{key: 6, value: 2}, key: 6}
          assert Tree23.delete_prime(%Tree23.Node2{left: %Tree23.Leaf{key: 3, value: 5},
                                             right: %Tree23.Leaf{key: 6, value: 2},
                                             lower_key: 3, max_right_key: 6}, 6) ==
            %Tree23.Node1{node: %Tree23.Leaf{key: 3, value: 5}, key: 3}
        end

        test "deleting a leaf child from a 3 node returns a 2 node" do
          assert Tree23.delete_prime(%Tree23.Node3{left: %Tree23.Leaf{key: 3, value: 5},
                                             middle: %Tree23.Leaf{key: 5, value: 7},
                                             right: %Tree23.Leaf{key: 6, value: 2},
                                             lower_key: 3, upper_key: 5, max_right_key: 6}, 3) ==
            %Tree23.Node2{left: %Tree23.Leaf{key: 5, value: 7},
                          right: %Tree23.Leaf{key: 6, value: 2},
                          lower_key: 5, max_right_key: 6}
          assert Tree23.delete_prime(%Tree23.Node3{left: %Tree23.Leaf{key: 3, value: 5},
                                             middle: %Tree23.Leaf{key: 5, value: 7},
                                             right: %Tree23.Leaf{key: 6, value: 2},
                                             lower_key: 3, upper_key: 5, max_right_key: 6}, 5) ==
            %Tree23.Node2{left: %Tree23.Leaf{key: 3, value: 5},
                          right: %Tree23.Leaf{key: 6, value: 2},
                          lower_key: 3, max_right_key: 6}
          assert Tree23.delete_prime(%Tree23.Node3{left: %Tree23.Leaf{key: 3, value: 5},
                                             middle: %Tree23.Leaf{key: 5, value: 7},
                                             right: %Tree23.Leaf{key: 6, value: 2},
                                             lower_key: 3, upper_key: 5, max_right_key: 6}, 6) ==
            %Tree23.Node2{left: %Tree23.Leaf{key: 3, value: 5},
                          right: %Tree23.Leaf{key: 5, value: 7},
                          lower_key: 3, max_right_key: 5}
        end

        test "deleting from the left side of a 2 node, node1 comes in upward phase, 2 node to right" do
          assert Tree23.delete_prime(%Tree23.Node2{left: %Tree23.Node2{left: %Tree23.Leaf{key: 2, value: "a"},
                                                                right: %Tree23.Leaf{key: 4, value: "b"}, lower_key: 2, max_right_key: 4},
                                            right: %Tree23.Node2{left: %Tree23.Leaf{key: 6, value: "c"},
                                                                 right: %Tree23.Leaf{key: 8, value: "d"}, lower_key: 6, max_right_key: 8}, lower_key: 6 ,max_right_key: 8}, 2) ==
            %Tree23.Node1{key: 8, node: %Tree23.Node3{left: %Tree23.Leaf{key: 4, value: "b"},
                                                      middle: %Tree23.Leaf{key: 6, value: "c"},
                                                      right: %Tree23.Leaf{key: 8, value: "d"}, lower_key: 4, upper_key: 6, max_right_key: 8}}
        end

        test "deleting from the right side of a 2 node, node1 comes in upward phase, 2 node to left" do
          assert Tree23.delete_prime(%Tree23.Node2{left: %Tree23.Node2{left: %Tree23.Leaf{key: 2, value: "a"},
                                                                 right: %Tree23.Leaf{key: 4, value: "b"}, lower_key: 2, max_right_key: 4},
                                             right: %Tree23.Node2{left: %Tree23.Leaf{key: 6, value: "c"},
                                                                  right: %Tree23.Leaf{key: 8, value: "d"}, lower_key: 6, max_right_key: 8}, lower_key: 6 ,max_right_key: 8}, 8) ==
            %Tree23.Node1{key: 6, node: %Tree23.Node3{left: %Tree23.Leaf{key: 2, value: "a"},
                                                      middle: %Tree23.Leaf{key: 4, value: "b"},
                                                      right: %Tree23.Leaf{key: 6, value: "c"}, lower_key: 2, upper_key: 4, max_right_key: 6}}
        end

        test "deleting from the left side of a 2 node, other than node1 comes in upward phase, node 2 to right" do
          assert Tree23.delete_prime(%Tree23.Node2{left: %Tree23.Node3{left: %Tree23.Leaf{key: 2, value: "a"},
                                                                 middle: %Tree23.Leaf{key: 4, value: "b"},
                                                                 right: %Tree23.Leaf{key: 5, value: "f"}, lower_key: 2, upper_key: 4, max_right_key: 5},
                                             right: %Tree23.Node2{left: %Tree23.Leaf{key: 6, value: "c"},
                                                                  right: %Tree23.Leaf{key: 8, value: "d"}, lower_key: 6, max_right_key: 8}, lower_key: 6 ,max_right_key: 8}, 5) ==
            %Tree23.Node2{left: %Tree23.Node2{left: %Tree23.Leaf{key: 2, value: "a"},
                                              right: %Tree23.Leaf{key: 4, value: "b"}, lower_key: 2, max_right_key: 4},
                          right: %Tree23.Node2{left: %Tree23.Leaf{key: 6, value: "c"},
                                               right: %Tree23.Leaf{key: 8, value: "d"}, lower_key: 6, max_right_key: 8}, lower_key: 4 ,max_right_key: 8}
        end

        test "deleting from the right side of a 2 node, other than node1 comes in upward phase, node 2 to left" do
          assert Tree23.delete_prime(%Tree23.Node2{left: %Tree23.Node2{left: %Tree23.Leaf{key: 2, value: "a"},
                                                                 right: %Tree23.Leaf{key: 4, value: "b"}, lower_key: 2, max_right_key: 4},
                                             right: %Tree23.Node3{left: %Tree23.Leaf{key: 6, value: "c"},
                                                                  middle: %Tree23.Leaf{key: 8, value: "d"},
                                                                  right: %Tree23.Leaf{key: 9, value: "f"}, lower_key: 6, upper_key: 8, max_right_key: 9}, lower_key: 4 ,max_right_key: 9}, 9) ==
            %Tree23.Node2{left: %Tree23.Node2{left: %Tree23.Leaf{key: 2, value: "a"},
                                              right: %Tree23.Leaf{key: 4, value: "b"}, lower_key: 2, max_right_key: 4},
                          right: %Tree23.Node2{left: %Tree23.Leaf{key: 6, value: "c"},
                                               right: %Tree23.Leaf{key: 8, value: "d"}, lower_key: 6, max_right_key: 8}, lower_key: 4 ,max_right_key: 8}
        end

        test "deleting from the left side of a 2 node, node1 comes in upward phase, 3 node to right" do
          assert Tree23.delete_prime(%Tree23.Node2{left: %Tree23.Node2{left: %Tree23.Leaf{key: 2, value: "a"},
                                                                 right: %Tree23.Leaf{key: 4, value: "b"}, lower_key: 2, max_right_key: 4},
                                             right: %Tree23.Node3{left: %Tree23.Leaf{key: 6, value: "c"},
                                                                  middle: %Tree23.Leaf{key: 8, value: "d"},
                                                                  right: %Tree23.Leaf{key: 9, value: "f"}, lower_key: 6, upper_key: 8, max_right_key: 9}, lower_key: 4 ,max_right_key: 9}, 2) ==
            %Tree23.Node2{left: %Tree23.Node2{left: %Tree23.Leaf{key: 4, value: "b"},
                                              right: %Tree23.Leaf{key: 6, value: "c"}, lower_key: 4, max_right_key: 6},
                          right: %Tree23.Node2{left: %Tree23.Leaf{key: 8, value: "d"},
                                               right: %Tree23.Leaf{key: 9, value: "f"}, lower_key: 8, max_right_key: 9}, lower_key: 6, max_right_key: 9}
        end

        test "deleting from the right side of a 2 node, node1 comes in upward phase, 3 node to left" do
          assert Tree23.delete_prime(%Tree23.Node2{left: %Tree23.Node3{left: %Tree23.Leaf{key: 2, value: "a"},
                                                                 middle: %Tree23.Leaf{key: 4, value: "b"},
                                                                 right: %Tree23.Leaf{key: 5, value: "f"}, lower_key: 2, upper_key: 4, max_right_key: 5},
                                             right: %Tree23.Node2{left: %Tree23.Leaf{key: 6, value: "c"},
                                                                  right: %Tree23.Leaf{key: 8, value: "d"}, lower_key: 6, max_right_key: 8}, lower_key: 6 ,max_right_key: 8}, 8) ==
            %Tree23.Node2{left: %Tree23.Node2{left: %Tree23.Leaf{key: 2, value: "a"},
                                              right: %Tree23.Leaf{key: 4, value: "b"}, lower_key: 2, max_right_key: 4},
                          right: %Tree23.Node2{left: %Tree23.Leaf{key: 5, value: "f"},
                                               right: %Tree23.Leaf{key: 6, value: "c"}, lower_key: 5, max_right_key: 6}, lower_key: 4,  max_right_key: 6}
        end

        test "delete with 1 node to left of 2 node in upward phase" do
          assert Tree23.delete_prime(%Tree23.Node3{left: %Tree23.Node2{left: %Tree23.Leaf{key: 1, value: "a"}, right: %Tree23.Leaf{key: 3, value: "b"}, lower_key: 1, max_right_key: 3},
                                             middle: %Tree23.Node2{left: %Tree23.Leaf{key: 5, value: "c"}, right: %Tree23.Leaf{key: 7, value: "d"}, lower_key: 5, max_right_key: 7},
                                             right: %Tree23.Node2{left: %Tree23.Leaf{key: 9, value: "e"}, right: %Tree23.Leaf{key: 11, value: "f"}, lower_key: 9, max_right_key: 11},
                                             lower_key: 3, upper_key: 7, max_right_key: 11}, 1) ==
            %Tree23.Node2{left: %Tree23.Node3{left: %Tree23.Leaf{key: 3, value: "b"},
                                              middle: %Tree23.Leaf{key: 5, value: "c"},
                                              right: %Tree23.Leaf{key: 7, value: "d"}, lower_key: 3, upper_key: 5, max_right_key: 7},
                          right: %Tree23.Node2{left: %Tree23.Leaf{key: 9, value: "e"}, right: %Tree23.Leaf{key: 11, value: "f"}, lower_key: 9, max_right_key: 11},
                                              lower_key: 7, max_right_key: 11}
        end

        test "delete with 2 node to left of 1 node in upward phase" do
          assert Tree23.delete_prime(%Tree23.Node3{left: %Tree23.Node2{left: %Tree23.Leaf{key: 1, value: "a"}, right: %Tree23.Leaf{key: 3, value: "b"}, lower_key: 1, max_right_key: 3},
                                             middle: %Tree23.Node2{left: %Tree23.Leaf{key: 5, value: "c"}, right: %Tree23.Leaf{key: 7, value: "d"}, lower_key: 5, max_right_key: 7},
                                             right: %Tree23.Node2{left: %Tree23.Leaf{key: 9, value: "e"}, right: %Tree23.Leaf{key: 11, value: "f"}, lower_key: 9, max_right_key: 11},
                                             lower_key: 3, upper_key: 7, max_right_key: 11}, 5) ==
            %Tree23.Node2{left: %Tree23.Node3{left: %Tree23.Leaf{key: 1, value: "a"},
                                              middle: %Tree23.Leaf{key: 3, value: "b"},
                                              right: %Tree23.Leaf{key: 7, value: "d"}, lower_key: 1, upper_key: 3, max_right_key: 7},
                          right: %Tree23.Node2{left: %Tree23.Leaf{key: 9, value: "e"}, right: %Tree23.Leaf{key: 11, value: "f"}, lower_key: 9, max_right_key: 11},
                                              lower_key: 7, max_right_key: 11}
        end

        test "delete with 2 node to left of 1 node in upward phase, 1 node on right" do
          assert Tree23.delete_prime(%Tree23.Node3{left: %Tree23.Node2{left: %Tree23.Leaf{key: 1, value: "a"}, right: %Tree23.Leaf{key: 3, value: "b"}, lower_key: 1, max_right_key: 3},
                                             middle: %Tree23.Node2{left: %Tree23.Leaf{key: 5, value: "c"}, right: %Tree23.Leaf{key: 7, value: "d"}, lower_key: 5, max_right_key: 7},
                                             right: %Tree23.Node2{left: %Tree23.Leaf{key: 9, value: "e"}, right: %Tree23.Leaf{key: 11, value: "f"}, lower_key: 9, max_right_key: 11},
                                             lower_key: 3, upper_key: 7, max_right_key: 11}, 11) ==
             %Tree23.Node2{left: %Tree23.Node2{left: %Tree23.Leaf{key: 1, value: "a"}, right: %Tree23.Leaf{key: 3, value: "b"}, lower_key: 1, max_right_key: 3},
                           right: %Tree23.Node3{left: %Tree23.Leaf{key: 5, value: "c"}, middle: %Tree23.Leaf{key: 7, value: "d"}, right: %Tree23.Leaf{key: 9, value: "e"},
                                                lower_key: 5, upper_key: 7, max_right_key: 9},
                           lower_key: 3, max_right_key: 9}
        end

        test "delete with 3 node to left of 1 node in upward phase, 1 node on right" do
          assert Tree23.delete_prime(%Tree23.Node3{left: %Tree23.Node2{left: %Tree23.Leaf{key: 1, value: "a"}, right: %Tree23.Leaf{key: 3, value: "b"}, lower_key: 1, max_right_key: 3},
                                             middle: %Tree23.Node3{left: %Tree23.Leaf{key: 5, value: "c"},
                                                                   middle: %Tree23.Leaf{key: 6, value: "g"},
                                                                   right: %Tree23.Leaf{key: 7, value: "d"}, lower_key: 5, upper_key: 6, max_right_key: 7},
                                             right: %Tree23.Node2{left: %Tree23.Leaf{key: 9, value: "e"}, right: %Tree23.Leaf{key: 11, value: "f"}, lower_key: 9, max_right_key: 11},
                                             lower_key: 3, upper_key: 7, max_right_key: 11}, 11) ==
            %Tree23.Node3{left: %Tree23.Node2{left: %Tree23.Leaf{key: 1, value: "a"}, right: %Tree23.Leaf{key: 3, value: "b"}, lower_key: 1, max_right_key: 3},
                          middle: %Tree23.Node2{left: %Tree23.Leaf{key: 5, value: "c"}, right: %Tree23.Leaf{key: 6, value: "g"}, lower_key: 5, max_right_key: 6},
                           right: %Tree23.Node2{left: %Tree23.Leaf{key: 7, value: "d"}, right: %Tree23.Leaf{key: 9, value: "e"}, lower_key: 7, max_right_key: 9},
                           lower_key: 3, upper_key: 6, max_right_key: 9}
        end

        test "delete with 3 node to right of 1 node in upward phase, 1 node on left" do
          assert Tree23.delete_prime(%Tree23.Node3{left: %Tree23.Node2{left: %Tree23.Leaf{key: 1, value: "a"}, right: %Tree23.Leaf{key: 3, value: "b"}, lower_key: 1, max_right_key: 3},
                                             middle: %Tree23.Node3{left: %Tree23.Leaf{key: 5, value: "c"},
                                                                   middle: %Tree23.Leaf{key: 6, value: "g"},
                                                                   right: %Tree23.Leaf{key: 7, value: "d"}, lower_key: 5, upper_key: 6, max_right_key: 7},
                                             right: %Tree23.Node2{left: %Tree23.Leaf{key: 9, value: "e"}, right: %Tree23.Leaf{key: 11, value: "f"}, lower_key: 9, max_right_key: 11},
                                             lower_key: 3, upper_key: 7, max_right_key: 11}, 3) ==
            %Tree23.Node3{left: %Tree23.Node2{left: %Tree23.Leaf{key: 1, value: "a"}, right: %Tree23.Leaf{key: 5, value: "c"}, lower_key: 1, max_right_key: 5},
                          middle: %Tree23.Node2{left: %Tree23.Leaf{key: 6, value: "g"}, right: %Tree23.Leaf{key: 7, value: "d"}, lower_key: 6, max_right_key: 7},
                           right: %Tree23.Node2{left: %Tree23.Leaf{key: 9, value: "e"}, right: %Tree23.Leaf{key: 11, value: "f"}, lower_key: 9, max_right_key: 11},
                           lower_key: 5, upper_key: 7, max_right_key: 11}
        end

        test "delete with 3 node to left of 1 node in upward phase, 1 node in middle" do
          assert Tree23.delete_prime(%Tree23.Node3{left: %Tree23.Node3{left: %Tree23.Leaf{key: 1, value: "a"}, middle: %Tree23.Leaf{key: 2, value: "g"},
                                                                 right: %Tree23.Leaf{key: 3, value: "b"}, lower_key: 1, upper_key: 2, max_right_key: 3},
                                             middle: %Tree23.Node2{left: %Tree23.Leaf{key: 5, value: "c"},
                                                                   right: %Tree23.Leaf{key: 7, value: "d"}, lower_key: 5, max_right_key: 7},
                                             right: %Tree23.Node2{left: %Tree23.Leaf{key: 9, value: "e"}, right: %Tree23.Leaf{key: 11, value: "f"}, lower_key: 9, max_right_key: 11},
                                             lower_key: 3, upper_key: 7, max_right_key: 11}, 7) ==
            %Tree23.Node3{left: %Tree23.Node2{left: %Tree23.Leaf{key: 1, value: "a"}, right: %Tree23.Leaf{key: 2, value: "g"}, lower_key: 1, max_right_key: 2},
                          middle: %Tree23.Node2{left: %Tree23.Leaf{key: 3, value: "b"}, right: %Tree23.Leaf{key: 5, value: "c"}, lower_key: 3, max_right_key: 5},
                           right: %Tree23.Node2{left: %Tree23.Leaf{key: 9, value: "e"}, right: %Tree23.Leaf{key: 11, value: "f"}, lower_key: 9, max_right_key: 11},
                           lower_key: 2, upper_key: 5, max_right_key: 11}
        end

        test "delete with 3 node in middle" do
          assert Tree23.delete_prime(%Tree23.Node3{left: %Tree23.Node3{left: %Tree23.Leaf{key: 1, value: "a"}, middle: %Tree23.Leaf{key: 2, value: "g"},
                                                                 right: %Tree23.Leaf{key: 3, value: "b"}, lower_key: 1, upper_key: 2, max_right_key: 3},
                                             middle: %Tree23.Node3{left: %Tree23.Leaf{key: 5, value: "c"}, middle: %Tree23.Leaf{key: 6, value: "h"},
                                                                   right: %Tree23.Leaf{key: 7, value: "d"}, lower_key: 5, upper_key: 6, max_right_key: 7},
                                             right: %Tree23.Node3{left: %Tree23.Leaf{key: 9, value: "e"}, middle: %Tree23.Leaf{key: 10, value: "i"},
                                                                  right: %Tree23.Leaf{key: 11, value: "f"}, lower_key: 9, upper_key: 10, max_right_key: 11},
                                             lower_key: 3, upper_key: 7, max_right_key: 11}, 7) ==
            %Tree23.Node3{left: %Tree23.Node3{left: %Tree23.Leaf{key: 1, value: "a"}, middle: %Tree23.Leaf{key: 2, value: "g"},
                                              right: %Tree23.Leaf{key: 3, value: "b"}, lower_key: 1, upper_key: 2, max_right_key: 3},
                          middle: %Tree23.Node2{left: %Tree23.Leaf{key: 5, value: "c"}, right: %Tree23.Leaf{key: 6, value: "h"},
                                                lower_key: 5,  max_right_key: 6},
                          right: %Tree23.Node3{left: %Tree23.Leaf{key: 9, value: "e"}, middle: %Tree23.Leaf{key: 10, value: "i"},
                                               right: %Tree23.Leaf{key: 11, value: "f"}, lower_key: 9, upper_key: 10, max_right_key: 11},
                          lower_key: 3, upper_key: 6, max_right_key: 11}
        end

        test "delete with 3 node on the left" do
          assert Tree23.delete_prime(%Tree23.Node3{left: %Tree23.Node3{left: %Tree23.Leaf{key: 1, value: "a"}, middle: %Tree23.Leaf{key: 2, value: "g"},
                                                                 right: %Tree23.Leaf{key: 3, value: "b"}, lower_key: 1, upper_key: 2, max_right_key: 3},
                                             middle: %Tree23.Node3{left: %Tree23.Leaf{key: 5, value: "c"}, middle: %Tree23.Leaf{key: 6, value: "h"},
                                                                   right: %Tree23.Leaf{key: 7, value: "d"}, lower_key: 5, upper_key: 6, max_right_key: 7},
                                             right: %Tree23.Node3{left: %Tree23.Leaf{key: 9, value: "e"}, middle: %Tree23.Leaf{key: 10, value: "i"},
                                                                  right: %Tree23.Leaf{key: 11, value: "f"}, lower_key: 9, upper_key: 10, max_right_key: 11},
                                             lower_key: 3, upper_key: 7, max_right_key: 11}, 3) ==
            %Tree23.Node3{left: %Tree23.Node2{left: %Tree23.Leaf{key: 1, value: "a"}, right: %Tree23.Leaf{key: 2, value: "g"},
                                              lower_key: 1, max_right_key: 2},
                          middle: %Tree23.Node3{left: %Tree23.Leaf{key: 5, value: "c"}, middle: %Tree23.Leaf{key: 6, value: "h"},
                                                right: %Tree23.Leaf{key: 7, value: "d"}, lower_key: 5, upper_key: 6, max_right_key: 7},
                          right: %Tree23.Node3{left: %Tree23.Leaf{key: 9, value: "e"}, middle: %Tree23.Leaf{key: 10, value: "i"},
                                               right: %Tree23.Leaf{key: 11, value: "f"}, lower_key: 9, upper_key: 10, max_right_key: 11},
                          lower_key: 2, upper_key: 7, max_right_key: 11}
        end

        test "delete with 3 node on the right" do
          assert Tree23.delete_prime(%Tree23.Node3{left: %Tree23.Node3{left: %Tree23.Leaf{key: 1, value: "a"}, middle: %Tree23.Leaf{key: 2, value: "g"},
                                                                 right: %Tree23.Leaf{key: 3, value: "b"}, lower_key: 1, upper_key: 2, max_right_key: 3},
                                             middle: %Tree23.Node3{left: %Tree23.Leaf{key: 5, value: "c"}, middle: %Tree23.Leaf{key: 6, value: "h"},
                                                                   right: %Tree23.Leaf{key: 7, value: "d"}, lower_key: 5, upper_key: 6, max_right_key: 7},
                                             right: %Tree23.Node3{left: %Tree23.Leaf{key: 9, value: "e"}, middle: %Tree23.Leaf{key: 10, value: "i"},
                                                                  right: %Tree23.Leaf{key: 11, value: "f"}, lower_key: 9, upper_key: 10, max_right_key: 11},
                                             lower_key: 3, upper_key: 7, max_right_key: 11}, 11) ==
            %Tree23.Node3{left: %Tree23.Node3{left: %Tree23.Leaf{key: 1, value: "a"}, middle: %Tree23.Leaf{key: 2, value: "g"},
                                                                  right: %Tree23.Leaf{key: 3, value: "b"}, lower_key: 1, upper_key: 2, max_right_key: 3},
                          middle: %Tree23.Node3{left: %Tree23.Leaf{key: 5, value: "c"}, middle: %Tree23.Leaf{key: 6, value: "h"},
                                                right: %Tree23.Leaf{key: 7, value: "d"}, lower_key: 5, upper_key: 6, max_right_key: 7},
                          right: %Tree23.Node2{left: %Tree23.Leaf{key: 9, value: "e"}, right: %Tree23.Leaf{key: 10, value: "i"},
                                               lower_key: 9, max_right_key: 10},
                          lower_key: 3, upper_key: 7, max_right_key: 10}
        end

        test "root delete 2 node, node1 comes in upward phase" do
          assert Tree23.delete(%Tree23.Node2{left: %Tree23.Node2{left: %Tree23.Leaf{key: 2, value: "a"},
                                                                       right: %Tree23.Leaf{key: 4, value: "b"}, lower_key: 2, max_right_key: 4},
                                                   right: %Tree23.Node2{left: %Tree23.Leaf{key: 6, value: "c"},
                                                                        right: %Tree23.Leaf{key: 8, value: "d"}, lower_key: 6, max_right_key: 8}, lower_key: 6 ,max_right_key: 8}, 8) ==
            %Tree23.Node3{left: %Tree23.Leaf{key: 2, value: "a"},
                          middle: %Tree23.Leaf{key: 4, value: "b"},
                          right: %Tree23.Leaf{key: 6, value: "c"}, lower_key: 2, upper_key: 4, max_right_key: 6}
        end

        test "root delete with 3 node, other than node1 in upward phase" do
          assert Tree23.delete(%Tree23.Node3{left: %Tree23.Node3{left: %Tree23.Leaf{key: 1, value: "a"}, middle: %Tree23.Leaf{key: 2, value: "g"},
                                                                 right: %Tree23.Leaf{key: 3, value: "b"}, lower_key: 1, upper_key: 2, max_right_key: 3},
                                             middle: %Tree23.Node3{left: %Tree23.Leaf{key: 5, value: "c"}, middle: %Tree23.Leaf{key: 6, value: "h"},
                                                                   right: %Tree23.Leaf{key: 7, value: "d"}, lower_key: 5, upper_key: 6, max_right_key: 7},
                                             right: %Tree23.Node3{left: %Tree23.Leaf{key: 9, value: "e"}, middle: %Tree23.Leaf{key: 10, value: "i"},
                                                                  right: %Tree23.Leaf{key: 11, value: "f"}, lower_key: 9, upper_key: 10, max_right_key: 11},
                                             lower_key: 3, upper_key: 7, max_right_key: 11}, 11) ==
            %Tree23.Node3{left: %Tree23.Node3{left: %Tree23.Leaf{key: 1, value: "a"}, middle: %Tree23.Leaf{key: 2, value: "g"},
                                                                  right: %Tree23.Leaf{key: 3, value: "b"}, lower_key: 1, upper_key: 2, max_right_key: 3},
                          middle: %Tree23.Node3{left: %Tree23.Leaf{key: 5, value: "c"}, middle: %Tree23.Leaf{key: 6, value: "h"},
                                                right: %Tree23.Leaf{key: 7, value: "d"}, lower_key: 5, upper_key: 6, max_right_key: 7},
                          right: %Tree23.Node2{left: %Tree23.Leaf{key: 9, value: "e"}, right: %Tree23.Leaf{key: 10, value: "i"},
                                               lower_key: 9, max_right_key: 10},
                          lower_key: 3, upper_key: 7, max_right_key: 10}
        end


end
