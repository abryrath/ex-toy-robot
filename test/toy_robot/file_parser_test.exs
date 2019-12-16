defmodule ToyRobot.FileParserTest do
  use ExUnit.Case

  test "split_directives" do
    contents = """
PLACE X,Y,F
MOVE
LEFT
RIGHT
REPORT
"""
    result = ToyRobot.FileParser.split_directives(contents)
    assert Enum.count(result) == 5
  end

  test "place transform" do
    assert {:place, %{x: 1, y: 2, dir: 0}} == ToyRobot.FileParser.transform("place 1,2, 0")
  end

  test "move transform" do
    assert {:move, %{}} == ToyRobot.FileParser.transform("move ")
  end

  test "left transform" do
    assert {:left, %{}} == ToyRobot.FileParser.transform("left")
  end

  test "right transform" do
    assert {:right, %{}} == ToyRobot.FileParser.transform("right")
  end

  test "report transform" do
    assert {:report, %{}} == ToyRobot.FileParser.transform("report")
  end

  test "parse directives" do
    commands = [
      "PLACE 1, 1, 3",
      "MOVE",
      "LEFT"]

    expected =  [{:place, %{:x => 1, :y => 1, :dir => 3}}, {:move, %{}}, {:left, %{}}]
    assert expected == ToyRobot.FileParser.parse_directives(commands)
  end
end
