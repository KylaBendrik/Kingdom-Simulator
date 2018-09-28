defmodule Kingdom.BuildingQueue do
  def new(), do: []

  def add_project(queue, project), do: queue ++ [project]

  def apply_points([], _points), do: {[], []}

  def apply_points([first | rest], points) do
    original_points = first[:points_remaining]

    if points >= original_points do
      {new_queue, finished_buildings} = apply_points(rest, points - original_points)
      {new_queue, [first | finished_buildings]}
    else
      new_project = %{first | points_remaining: original_points - points}

      {[new_project | rest], []}
    end
  end

end
