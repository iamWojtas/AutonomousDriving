length = 3;
x = sym('x', [length, 1]);
equations = sym('something', [length, 1]);
syms p
for runIdx = 1:length
    equations(runIdx) = x(runIdx) - p == 0;
end
answers_correct_dynamic = solve(equations);
