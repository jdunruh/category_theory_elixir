alias WitchcraftersPlay.Tree23
alias WitchcraftersPlay.Tree23.{Empty, Node2, Node3, Leaf}

import TypeClass

use Witchcraft

definst Witchcraft.Setoid, for: WitchcraftersPlay.Tree23.Empty do
  def equivalent?(_, %Empty{}), do: true
  def equivalent?(_, _), do: false
end

definst Witchcraft.Setoid, for: WitchcraftersPlay.Tree23.Leaf do
  def equivalent?(%Leaf{key: k1, value: v1}, %Leaf{key: k2, value: v2}) do
    Witchcraft.Setoid.equivalent?(k1, k2) && Witchcraft.Setoid.equivalent?(v1, v2)
  end
end

definst Witchcraft.Setoid, for: WitchcraftersPlay.Tree23.Node2 do
  def equivalent?(%Node2{}, %Empty{}), do: false

  def equivalent?(a, b) do
    Tree23.equivalent_tree?(a, b)
  end
end

definst Witchcraft.Setoid, for: WitchcraftersPlay.Tree23.Node3 do
  def equivalent?(%Node3{}, %Empty{}), do: false

  def equivalent?(a, b) do
    Tree23.equivalent_tree?(a, b)
  end
end
