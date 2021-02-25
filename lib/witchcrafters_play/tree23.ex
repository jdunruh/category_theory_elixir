defmodule WitchcraftersPlay.Tree23 do
  @moduledoc false

  import Algae
  use Witchcraft, except: [to_list: 1]
  alias WitchcraftersPlay.Tree23.{Empty, Node1, Node2, Node3, Node4, Leaf}

  defsum do
    defdata(Empty :: none())

    defdata Node1 do
      key :: any()
      node :: Tree23.t() \\ Empty.new()
    end

    defdata Node2 do
      lower_key :: any()
      max_right_key :: any()
      left :: Tree23.t() \\ Empty.new()
      right :: Tree23.t() \\ Empty.new()
    end

    defdata Node3 do
      lower_key :: any()
      upper_key :: any()
      max_right_key :: any()
      left :: Tree23.t() \\ Empty.new()
      middle :: Tree23.t() \\ Empty.new()
      right :: Tree23.t() \\ Empty.new()
    end

    defdata Node4 do
      lower_key :: any()
      middle_key :: any()
      upper_key :: any()
      max_right_key :: any()
      left :: Tree23.t() \\ Empty.new()
      lower_middle :: Tree23.t() \\ Empty.new()
      upper_middle :: Tree23.t() \\ Empty.new()
      right :: Tree23.t() \\ Empty.new()
    end

    defdata Leaf do
      key :: any()
      value :: any()
    end

  end

  #  @spec insert(t(), any()) :: t()

  def struct_put_in(struct, [key|[]], value) do
    Map.put(struct, key, value)
  end

  def struct_put_in(struct, [key|keys], new_value) do
    Map.put(struct, key, struct_put_in(Map.get(struct, key), keys, new_value))
  end

  def insert(%Empty{}, orderable, value), do: Leaf.new(orderable, value)

  def insert(tree = %Leaf{key: leaf_key, value: _value}, orderable, val) do
    case compare(orderable, leaf_key) do
      :equal -> %{tree | value: val }
      :greater -> Node2.new(leaf_key, orderable, tree, Leaf.new(orderable, val))
      :lesser -> Node2.new(orderable, leaf_key, Leaf.new(orderable, val), tree)
    end
  end

  def insert(tree = %Node2{lower_key: lower_key, max_right_key: max_right_key, left: %Leaf{} = left, right: %Leaf{} = right}, orderable, value) do
    case {compare(orderable, lower_key), compare(orderable, max_right_key)} do
      {:equal, _} -> struct_put_in(tree, [:left, :value], value)
      {_, :equal} -> struct_put_in(tree, [:right, :value], value)
      {:lesser, _} -> Node3.new(orderable, lower_key, right.key, Leaf.new(orderable, value), left, right)
      {_, :greater} -> Node3.new(lower_key, max_right_key, orderable, left, right, Leaf.new(orderable,value))
      _ -> Node3.new(lower_key, orderable, right.key, left, Leaf.new(orderable, value), right)
    end
  end

  def insert(tree = %Node3{lower_key: lower_key, upper_key: upper_key, max_right_key: max_right_key, left: %Leaf{} = left, middle: %Leaf{} = middle,
                           right: %Leaf{} = right}, orderable, value) do
    case {compare(orderable, lower_key), compare(orderable, upper_key)} do
      {:equal, _} -> struct_put_in(tree, [:left, :value], value)
      {_, :equal} -> struct_put_in(tree, [:middle, :value], value)
      {:lesser, _} -> Node4.new(orderable, lower_key, upper_key, max_right_key, Leaf.new(orderable, value), left, middle, right)
      {:greater, :lesser} -> Node4.new(lower_key, orderable, upper_key, max_right_key, left, Leaf.new(orderable, value), middle, right)
      {_, :greater} -> case compare(orderable, right.key) do
                         :equal -> struct_put_in(tree, [:right, :value], value)
                         :greater -> Node4.new(lower_key, upper_key, max_right_key,  orderable, left, middle, right, Leaf.new(orderable, value))
                         :lesser -> Node4.new(lower_key, upper_key, orderable, max_right_key, left, middle, Leaf.new(orderable, value), right)
                       end
    end
  end

  def insert(tree = %Node2{lower_key: lower_key, max_right_key: max_right_key,  left: left, right: right}, orderable, value) do
    case compare(orderable, lower_key) do
      :lesser -> case new_node = insert(left, orderable, value) do
        %Node4{lower_key: lk, middle_key: mk, upper_key: uk, max_right_key: mrk, left: l,
          lower_middle: lm, upper_middle: um, right: r} ->
                     Node3.new(mk, mrk, max_right_key, Node2.new(lk, mk, l, lm), Node2.new(uk, mrk, um, r),
                       right)
                     _ -> Map.put(tree, :left, new_node)

                 end
      :equal -> Map.put(tree, :left, insert(left, orderable, value))
      :greater -> case new_node = insert(right, orderable, value) do
          %Node4{lower_key: lk, middle_key: mk, upper_key: uk, max_right_key: mrk, left: l,
            lower_middle: lm, upper_middle: um, right: r} ->
            Node3.new(lower_key, mk, mrk, left, Node2.new(lk, mk, l, lm), Node2.new(uk, mrk, um, r))
          _ -> Map.put(tree, :right,  new_node) |> Map.put(:max_right_key, new_node.max_right_key)
          end
    end
  end

  def insert(
        tree = %Node3{lower_key: lower_key, upper_key: upper_key, max_right_key: max_right_key, left: left, middle: middle, right: right},
        orderable,
        value
      ) do
    case {compare(orderable, lower_key), compare(orderable, upper_key)} do
      {:lesser, _} -> case new_node = insert(left, orderable, value) do
                        %Node4{lower_key: lk, middle_key: mk, upper_key: uk, max_right_key: mrk, left: l,
                          lower_middle: lm, upper_middle: um, right: r} ->
                          Node4.new(mk, mrk, upper_key, max_right_key, Node2.new(lk, mk, l, lm), Node2.new(uk, mrk, um, r), middle, right)
                        _ -> %{tree | left: new_node}
               end
      {:equal, _} -> %{tree | left: insert(left, orderable, value)}
      {:greater, :lesser} -> case new_node = insert(middle, orderable, value) do
                               %Node4{lower_key: lk, middle_key: mk, upper_key: uk, max_right_key: mrk, left: l,
                                 lower_middle: lm, upper_middle: um, right: r} ->
                                 Node4.new(lower_key, mk, upper_key, max_right_key, left, Node2.new(lk, mk, l, lm), Node2.new(uk, mrk, um, r), right)
                              _ -> %{tree | middle: new_node}
                               end
      {:greater, :equal} -> %{tree | right: insert(middle, orderable, value)}
      {:greater, :greater} -> case new_node = insert(right, orderable, value) do
                                %Node4{lower_key: lk, middle_key: mk, upper_key: uk, max_right_key: mrk, left: l,
                                  lower_middle: lm, upper_middle: um, right: r} ->
                                  Node4.new(lower_key, upper_key, mk, mrk, left, middle, Node2.new(lk, mk, l, lm), Node2.new(uk, mrk, um, r))
                                _ -> %{tree | right: new_node, max_right_key: new_node.max_right_key }
                              end
    end
  end

  def put(tree, key, value) do
    case new_tree = insert(tree, key, value) do
       %Node4{left: l, lower_middle: lm, upper_middle: um, right: r, middle_key: mk, lower_key: lk, upper_key: uk, max_right_key: mrk} ->
         Node2.new(mk, mrk, Node2.new(lk, mk, l, lm), Node2.new(uk, mrk, um, r))
      _ -> new_tree
    end
  end

  def to_list(%Empty{}) do
    []
  end

  def to_list(%Leaf{key: key, value: val}) do
    [{key, val}]
  end

  def to_list(%Node3{left: left, middle: middle, right: right}) do
    to_list(left) ++ to_list(middle) ++ to_list(right)
  end

  def to_list(%Node2{left: left, right: right}) do
    to_list(left) ++ to_list(right)
  end

  def to_list(tree) do
    IO.inspect("to_list default value - should not happen")
    IO.inspect(tree)
  end

  def get(%Empty{}, _), do: nil

  def get(%Leaf{key: leaf_key, value: value}, key) when leaf_key == key, do: value

  def get(%Leaf{key: leaf_key, value: _value}, key) when leaf_key != key, do: nil

  def get(%Node2{lower_key: lower_key, max_right_key: max_right_key, right: right, left: left}, key) do
    case {compare(key, lower_key), compare(key, max_right_key)} do
      {:lesser, _} -> get(left, key)
      {:equal, _} -> get(left, key)
      {_, :equal} -> get(right, key)
      {_, :greater} -> nil
      {_, :lesser} -> get(right, key)
    end
  end

  def get(%Node3{lower_key: lower_key, upper_key: upper_key,
                 max_right_key: max_right_key, right: right, middle: middle, left: left}, key) do
    case {compare(key, lower_key), compare(key, upper_key), compare(key, max_right_key)} do
      {:lesser, _, _} -> get(left, key)
      {:equal, _, _} -> get(left, key)
      {_, :equal, _} -> get(middle, key)
      {_, :lesser, _} -> get(middle, key)
      {_, _, :equal} -> get(right, key)
      {_, _, :greater} -> nil
      {_, _, :lesser} -> get(right, key)
    end
  end

  def descent_direction(%Node3{lower_key: lower_key, upper_key: upper_key, max_right_key: max_right_key}, key) do
    case {compare(key, lower_key), compare(key, upper_key), compare(key, max_right_key)} do
      {:lesser, _, _} -> :left
      {:equal, _, _} -> :left
      {_, :lesser, _} -> :middle
      {_, :equal, _} -> :middle
      _ -> :right
    end
  end

  def rebalance_delete_3(%Node1{} = left, %Node2{} = middle, right) do
    Node2.new(middle.max_right_key, right.max_right_key, Node3.new(left.key, middle.lower_key, middle.max_right_key, left.node, middle.left, middle.right), right)
  end

  def rebalance_delete_3(%Node1{} = left, %Node3{} = middle, right) do
    Node3.new(middle.lower_key, middle.max_right_key, right.max_right_key ,Node2.new(left.key, middle.lower_key, left.node, middle.left),
      Node2.new(middle.upper_key, middle.max_right_key,middle.middle, middle.right), right)
  end

  def rebalance_delete_3(left, %Node2{} = middle, %Node1{} = right) do
    Node2.new(left.max_right_key, right.key, left, Node3.new(middle.lower_key, middle.max_right_key, right.key, middle.left, middle.right, right.node))
  end

  def rebalance_delete_3(left, %Node3{} = middle, %Node1{} = right) do
    Node3.new(left.max_right_key, middle.upper_key, right.key, left, Node2.new(middle.lower_key, middle.upper_key, middle.left, middle.middle),
      Node2.new(middle.max_right_key, right.key, middle.right, right.node))
  end

  def rebalance_delete_3(%Node2{} = left, %Node1{} = middle, right) do
    Node2.new(middle.key, right.max_right_key, Node3.new(left.lower_key, left.max_right_key, middle.key, left.left, left.right, middle.node), right)
  end

  def rebalance_delete_3(%Node3{} = left, %Node1{} = middle, right) do
    Node3.new(left.upper_key, middle.key, right.max_right_key ,Node2.new(left.lower_key, left.upper_key, left.left, left.middle), Node2.new(left.max_right_key, middle.key,left.right, middle.node), right)
  end

  def delete_prime(%Empty{}, _) do
    %Empty{}
  end

  def delete_prime(tree = %Leaf{key: key, value: _}, delete_key) do
    if(compare(key, delete_key) == :equal) do
      %Empty{}
    else
      tree
    end
  end

  def delete_prime(tree = %Node2{left: %Leaf{} = left, right: %Leaf{} = right, lower_key: lk, max_right_key: mrk}, delete_key) do
    cond do
      compare(delete_key, lk) == :equal ->
        Node1.new(mrk, right)
      compare(delete_key, mrk) == :equal ->
        Node1.new(lk, left)
      true  -> tree
    end
  end

  def delete_prime(tree = %Node3{left: %Leaf{} = left, middle: %Leaf{} = middle, right: %Leaf{} = right, lower_key: lk, upper_key: uk, max_right_key: mrk}, delete_key) do
    cond do
      compare(delete_key, lk) == :equal -> Node2.new(uk, mrk, middle, right)
      compare(delete_key, uk) == :equal -> Node2.new(lk, mrk, left, right)
      compare(delete_key, mrk) == :equal -> Node2.new(lk, uk, left, middle)
      true -> tree
    end
  end

  def delete_prime(tree = %Node2{left: left, right: right, lower_key: lower_key, max_right_key: _}, delete_key) do
    key_comparison = compare(delete_key, lower_key)
    if key_comparison == :lesser || key_comparison == :equal do
      case returned_node = delete_prime(left, delete_key) do
        %Node1{key: key, node: node} -> case right  do
                                          %Node3{left: l, middle: m, right: r, lower_key: lk, upper_key: uk, max_right_key: mrk} ->
                                            Node2.new(lk, mrk, Node2.new(key, lk, node, l), Node2.new(uk, mrk, m, r))
                                          %Node2{left: l, right: r, lower_key: lk, max_right_key: mrk} ->
                                             Node1.new(mrk, Node3.new(key, lk, mrk, node, l, r))
                                        end
          _ -> %{tree | left: returned_node, lower_key: returned_node.max_right_key}
      end
    else
      case returned_node = delete_prime(right, delete_key) do
        %Node1{key: key, node: node} -> case left do
                                           %Node3{left: l, middle: m, right: r, lower_key: lk, upper_key: uk, max_right_key: mrk} ->
                                              Node2.new(uk, node.key, Node2.new(lk, uk, l, m), Node2.new(mrk, node.key, r, node))
                                           %Node2{left: l, right: r, lower_key: lk, max_right_key: mrk} ->
                                              Node1.new(key, Node3.new(lk, mrk, key, l, r, node))
                                        end
        _ -> %{tree | right: returned_node, max_right_key: returned_node.max_right_key}
      end
    end
  end

  def delete_prime(tree = %Node3{left: left, middle:  middle, right: right}, delete_key) do
    direction = descent_direction(tree, delete_key)
    new_node = delete_prime(Map.get(tree, direction), delete_key)
    case direction do
      :left -> case new_node do
                 %Node1{} -> rebalance_delete_3(new_node, middle, right)
                 _ -> %{tree | left: new_node, lower_key: new_node.max_right_key}
               end
      :middle -> case new_node do
                   %Node1{} -> rebalance_delete_3(left, new_node, right)
                 _ -> %{tree | middle: new_node, upper_key: new_node.max_right_key}
                 end
      :right -> case new_node  do
                  %Node1{} -> rebalance_delete_3(left, middle, new_node)
                  _ -> %{tree | right: new_node, max_right_key: new_node.max_right_key}
                end
    end
  end
end
