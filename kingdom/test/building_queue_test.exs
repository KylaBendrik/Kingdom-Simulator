defmodule BuildingQueueTest do
  use ExUnit.Case, async: true

  alias Kingdom.BuildingQueue

  test "a new building queue is empty" do
    queue = BuildingQueue.new

    assert length(queue) == 0

  end

  test "adding a project to the queue" do
    queue = BuildingQueue.new
    |> BuildingQueue.add_project(%{ id: 1, name: "House", points_remaining: 20})

    assert length(queue) == 1
  end

  test "adding projects in correct order" do
    queue = BuildingQueue.new
    |> BuildingQueue.add_project(%{ id: 1, name: "House", points_remaining: 20 })
    |> BuildingQueue.add_project(%{ id: 2, name: "House", points_remaining: 20 })

    assert queue |> hd |> Map.get(:id) == 1

  end

  test "applying some points" do
    queue = BuildingQueue.new
    |> BuildingQueue.add_project(%{ id: 1, name: "House", points_remaining: 20 })
    |> BuildingQueue.add_project(%{ id: 2, name: "House", points_remaining: 20 })

    {new_queue, []} = BuildingQueue.apply_points(queue, 5)

    assert new_queue |> hd |> Map.get(:points_remaining) == 15
  end

  test "finishing a building" do
    queue = BuildingQueue.new
    |> BuildingQueue.add_project(%{ id: 1, name: "House", points_remaining: 20 })
    |> BuildingQueue.add_project(%{ id: 2, name: "House", points_remaining: 20 })

    {new_queue, [%{id: 1}]} = BuildingQueue.apply_points(queue, 20)

    assert length(new_queue) == 1
    assert new_queue |> hd |> Map.get(:points_remaining) == 20
  end

  test "more than enough points" do
    queue = BuildingQueue.new
    |> BuildingQueue.add_project(%{ id: 1, name: "House", points_remaining: 20 })
    |> BuildingQueue.add_project(%{ id: 2, name: "House", points_remaining: 20 })

    {new_queue, [%{id: 1}]} = BuildingQueue.apply_points(queue, 25)

    assert new_queue |> hd |> Map.get(:points_remaining) == 15
  end

  test "finishing two buildings" do
    queue = BuildingQueue.new
    |> BuildingQueue.add_project(%{ id: 1, name: "House", points_remaining: 20 })
    |> BuildingQueue.add_project(%{ id: 2, name: "House", points_remaining: 20 })

    {new_queue, [%{id: 1}, %{id: 2}]} = BuildingQueue.apply_points(queue, 45)

    assert length(new_queue) == 0
  end
end
