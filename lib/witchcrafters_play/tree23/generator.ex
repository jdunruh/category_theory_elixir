alias WitchcraftersPlay.Tree23.{Empty, Node2, Node3, Leaf}
use Witchcraft

defimpl TypeClass.Property.Generator, for: WitchcraftersPlay.Tree23.Empty do
  def generate(_), do: Empty.new()
end

defimpl TypeClass.Property.Generator, for: WitchcraftersPlay.Tree23.Leaf do
  def generate(_),
    do: %Leaf{
      key: Enum.random(Enum.to_list(0..20)),
      value: Enum.random(["a", "b", "c", "d", "e"])
    }
end

defimpl TypeClass.Property.Generator, for: WitchcraftersPlay.Tree23.Node2 do
  def generate(_) do
    left_leaf_key = Enum.random(Enum.to_list(0..20))
    left_leaf_value = Enum.random(["a", "b", "c", "d", "e"])
    right_leaf_key = Enum.random(Enum.to_list(21..40))
    right_leaf_value = Enum.random(["a", "b", "c", "d", "e"])

    Node2.new(
      left_leaf_key,
      right_leaf_key,
      Leaf.new(left_leaf_key, left_leaf_value),
      Leaf.new(right_leaf_key, right_leaf_value)
    )
  end
end

defimpl TypeClass.Property.Generator, for: WitchcraftersPlay.Tree23.Node3 do
  def generate(_) do
    left_leaf_key = Enum.random(Enum.to_list(0..20))
    left_leaf_value = Enum.random(["a", "b", "c", "d", "e"])
    middle_leaf_key = Enum.random(Enum.to_list(22..40))
    middle_leaf_value = Enum.random(["a", "b", "c", "d", "e"])
    right_leaf_key = Enum.random(Enum.to_list(42..60))
    right_leaf_value = Enum.random(["a", "b", "c", "d", "e"])

    %Node3{
      left: %Leaf{key: left_leaf_key, value: left_leaf_value},
      middle: %Leaf{key: middle_leaf_key, value: middle_leaf_value},
      right: %Leaf{key: right_leaf_key, value: right_leaf_value},
      lower_key: left_leaf_key,
      upper_key: middle_leaf_key,
      max_right_key: right_leaf_key
    }
  end
end
