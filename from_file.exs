file = System.argv() |> List.first()

directives = ToyRobot.FileParser.get_directives(file)

# IO.inspect(directives)
directives
|> Enum.each(fn {dir, opts} ->
  IO.inspect {dir, opts}
  result = ToyRobot.Table.handle_directive(ToyRobot.Table, {dir, opts})
  IO.inspect result
end)

ToyRobot.Table.report(ToyRobot.Table)
