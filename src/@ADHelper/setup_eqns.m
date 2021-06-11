function [eqns] = setup_eqns(obj)
  % User-Defined function of model equations
  %
  % Returns:
  %   : [eqns]
  %
  %   - **eqns** (matrix): derivative values from vertically stacked equations
  %
  % Note:
  %   - See :ref:`pert_setup` for more details.
  %
  % Warning:
  %   The expected output is the derivative matrix, :red:`NOT` the dual number. Hence, one would likely need to call :code:`getderivs` function of the `MATLABAutoDiff <https://github.com/sehyoun/MATLABAutoDiff>`_ toolbox. For example
  %
  %   .. code-block:: matlab
  %
  %     eqns = [eqn1; eqn2; eqn3];
  %     eqns = getderivs(eqns);
  %
  %   See :ref:`tutorial_pert_helper` for more details.
  %
  % Todo:
  %   - Consider changing syntax so that user would not have to call :code:`getderivs`
  %

end
