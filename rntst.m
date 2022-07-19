clear all;
addpath(genpath("."));
rehash
rehash toolboxreset
runtests tests/

%% Run specific tests
% runtests("CalculableStructTest","ProcedureName", ["test_properties", "test_fields",...
% "test_add_field", "test_plus_calculable_structs", "test_from_vec", "test_uminus",...
%     "test_minus", "test_times_calculable_struct", "test_rdivide", "test_copy", "test_sum"])
% runtests({'foo/test_first','foo/test_second'})
% % - or -
% runtests("foo","ProcedureName",["test_first" "test_third"])
% runtests("CalculableStructTest","ProcedureName",["test_fields"])
