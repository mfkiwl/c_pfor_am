[Mesh]
  [./nepermesh]
    type = FileMeshGenerator
    file = n5-id1.msh
  [../]

  [./x0_modifier]
    type = BoundingBoxNodeSetGenerator
    input = nepermesh
    new_boundary = x0
    top_right = '0.1 1.1 1.1'
    bottom_left = '-0.1 -0.1 -0.1'
  [../]
  [./y0_modifier]
    type = BoundingBoxNodeSetGenerator
    input = x0_modifier
    new_boundary = y0
    top_right = '1.1 0.1 1.1'
    bottom_left = '-0.1 -0.1 -0.1'
  [../]
  [./z0_modifier]
    type = BoundingBoxNodeSetGenerator
    input = y0_modifier
    new_boundary = z0
    top_right = '1.1 1.1 0.1'
    bottom_left = '-0.1 -0.1 -0.1'
  [../]
  [./x1_modifier]
    type = BoundingBoxNodeSetGenerator
    input = z0_modifier
    new_boundary = x1
    top_right = '1.1 1.1 1.1'
    bottom_left = '0.9 -0.1 -0.1'
  [../]
  [./y1_modifier]
    type = BoundingBoxNodeSetGenerator
    input = x1_modifier
    new_boundary = y1
    top_right = '1.1 1.1 1.1'
    bottom_left = '-0.1 0.9 -0.1'
  [../]
[]

[GlobalParams]
  displacements = 'disp_x disp_y disp_z'
[]

[Variables]
  [./disp_x]
    order = FIRST
    family = LAGRANGE
    # Use the initial Condition block underneath the variable
    # for which we want to apply this initial condition
    [./InitialCondition]
      type = ConstantIC
      value = 0.0
    [../]
  [../]

  [./disp_y]
    order = FIRST
    family = LAGRANGE
  [../]

  [./disp_z]
    order = FIRST
    family = LAGRANGE
  [../]
[]

[AuxVariables]
  [./temp]
    order = FIRST
    family = LAGRANGE
    [./InitialCondition]
      type = ConstantIC
      value = 1300.0
    [../]
  [../]

  [./stress_yy]
    order = CONSTANT
    family = MONOMIAL
  [../]

  [./stress_xx]
    order = CONSTANT
    family = MONOMIAL
  [../]

  [./stress_zz]
    order = CONSTANT
    family = MONOMIAL
  [../]

  [./fp_xx]
    order = CONSTANT
    family = MONOMIAL
  [../]

  [./fp_yy]
    order = CONSTANT
    family = MONOMIAL
  [../]

  [./fp_zz]
    order = CONSTANT
    family = MONOMIAL
  [../]

  [./e_zz]
    order = CONSTANT
    family = MONOMIAL
  [../]

  [./e_xx]
    order = CONSTANT
    family = MONOMIAL
  [../]

  [./e_yy]
    order = CONSTANT
    family = MONOMIAL
  [../]

  [./gss]
    order = CONSTANT
    family = MONOMIAL
  [../]

  [./euler1]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./euler2]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./euler3]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./crysrot11]
    order = CONSTANT
    family = MONOMIAL
  [../]

[]

[Functions]
  [./temperature_load]
    type = ParsedFunction
    value = 1300-t*200
  [../]
[]

[UserObjects]
  [./prop_read]
    type = GrainPropertyReadFile
    prop_file_name = 'euler_ang_test.inp'
    # Enter file data as prop#1, prop#2, .., prop#nprop
    nprop = 3
      ngrain = 5
    read_type = indexgrain
  [../]
[]

[Kernels]
  [./TensorMechanics]
    displacements = 'disp_x disp_y disp_z'
    use_displaced_mesh = true
    add_variables = true
  [../]
[]

[AuxKernels]

  [./stress_yy]
    type = RankTwoAux
    variable = stress_yy
    rank_two_tensor = stress
    index_j = 1
    index_i = 1
    execute_on = timestep_end
  [../]  

  [./stress_xx]
    type = RankTwoAux
    variable = stress_xx
    rank_two_tensor = stress
    index_j = 0
    index_i = 0
    execute_on = timestep_end
  [../]

  [./stress_zz]
    type = RankTwoAux
    variable = stress_zz
    rank_two_tensor = stress
    index_j = 2
    index_i = 2
    execute_on = timestep_end
  [../]

 [./fp_xx]
    type = RankTwoAux
    variable = fp_xx
    rank_two_tensor = fp
    index_j = 2
    index_i = 2
    execute_on = timestep_end
  [../]

 [./fp_yy]
    type = RankTwoAux
    variable = fp_yy
    rank_two_tensor = fp
    index_j = 2
    index_i = 2
    execute_on = timestep_end
  [../]

  [./fp_zz]
    type = RankTwoAux
    variable = fp_zz
    rank_two_tensor = fp
    index_j = 2
    index_i = 2
    execute_on = timestep_end
  [../]

  [./e_zz]
    type = RankTwoAux
    variable = e_zz
    rank_two_tensor = lage
    index_j = 2
    index_i = 2
    execute_on = timestep_end
  [../]

  [./e_xx]
    type = RankTwoAux
    variable = e_xx
    rank_two_tensor = lage
    index_j = 0
    index_i = 0
    execute_on = timestep_end
  [../]

  [./e_yy]
    type = RankTwoAux
    variable = e_yy
    rank_two_tensor = lage
    index_j = 1
    index_i = 1
    execute_on = timestep_end
  [../]

  [./tempfuncaux]
    type = FunctionAux
    variable = temp
    function = temperature_load
    block = 'ANY_BLOCK_ID 0'
  [../]

  [./gss]
    type = MaterialStdVectorAux
    variable = gss
    property = gss
    index = 0
    execute_on = timestep_end
  [../]

  [./euler1]
    type = MaterialRealVectorValueAux
    variable = euler1
    property = Euler_angles
    component = 0
    execute_on = timestep_end
  [../]
  [./euler2]
    type = MaterialRealVectorValueAux
    variable = euler2
    property = Euler_angles
    component = 1
    execute_on = timestep_end
  [../]
  [./euler3]
    type = MaterialRealVectorValueAux
    variable = euler3
    property = Euler_angles
    component = 2
    execute_on = timestep_end
  [../]

  [./crysrot11]
    type = RankTwoAux
    variable = crysrot11
    rank_two_tensor = crysrot
    index_j = 0
    index_i = 0
    execute_on = timestep_end
  [../]

[]

[BCs]
  [./z_bot]
    type = DirichletBC
    variable = disp_z
    boundary = z0
    value = 0.0
  [../]

  [./y0_bot]
    type = DirichletBC
    variable = disp_y
    boundary = y0
    value = 0.0
  [../]

  [./x0_bot]
    type = DirichletBC
    variable = disp_x
    boundary = x0
    value = 0.0
  [../]

  [./x1_bot]
    type = DirichletBC
    variable = disp_x
    boundary = x1
    value = 0.0
  [../]

  [./y1_bot]
    type = DirichletBC
    variable = disp_y
    boundary = y1
    value = 0.0
  [../]
[]
 
[Postprocessors]
  [./stress_yy]
    type = ElementAverageValue
    variable = stress_yy
    block = 'ANY_BLOCK_ID 0'
  [../]

  [./stress_xx]
    type = ElementAverageValue
    variable = stress_xx
    block = 'ANY_BLOCK_ID 0'
  [../]

  [./stress_zz]
    type = ElementAverageValue
    variable = stress_zz
    block = 'ANY_BLOCK_ID 0'
  [../]

   [./fp_xx]
    type = ElementAverageValue
    variable = fp_xx
    block = 'ANY_BLOCK_ID 0'
  [../]

  [./fp_yy]
    type = ElementAverageValue
    variable = fp_yy
    block = 'ANY_BLOCK_ID 0'
  [../]

  [./fp_zz]
    type = ElementAverageValue
    variable = fp_zz
    block = 'ANY_BLOCK_ID 0'
  [../]

  [./e_zz]
    type = ElementAverageValue
    variable = e_zz
    block = 'ANY_BLOCK_ID 0'
  [../]

  [./e_xx]
    type = ElementAverageValue
    variable = e_xx
    block = 'ANY_BLOCK_ID 0'
  [../]
  [./e_yy]
    type = ElementAverageValue
    variable = e_yy
    block = 'ANY_BLOCK_ID 0'
  [../]

  [./gss]
    type = ElementAverageValue
    variable = gss
    block = 'ANY_BLOCK_ID 0'
  [../]
  [./temperature]
    type = AverageNodalVariableValue
    variable = temp
    block = 'ANY_BLOCK_ID 0'
  [../]
[]


[Materials]
  [./crysp]
    type = FiniteStrainCrystalPlasticityThermal
    gtol = 1e-2
    slip_sys_file_name = input_slip_sys.txt # no need to normalize vectors
    nss = 12 #Number of slip systems
    num_slip_sys_flowrate_props = 2 #Number of flow rate properties in a slip system
    flowprops = '1 4 0.001 0.1 5 8 0.001 0.1 9 12 0.001 0.1' # slip rate equations parameters 
    hprops = '1.0 541.5 60.8 109.8 2.5' # hardening properties
    gprops = '1 4 60.8 5 8 60.8 9 12 60.8' # initial values of slip system resistances (start_slip_sys, end_slip_sys, value)
    tan_mod_type = exact
    thermal_expansion = '17e-6'
    reference_temperature = '1300'
    temp = temp
  [../]
  [./elasticity_tensor]
    type = ComputeElasticityTensorCPGrain
    C_ijkl = '1.684e5 1.214e5 1.214e5 1.684e5 1.214e5 1.684e5 0.754e5 0.754e5 0.754e5'
    fill_method = symmetric9
    read_prop_user_object = prop_read
  [../]
  [./strain]
    type = ComputeFiniteStrain
    displacements = 'disp_x disp_y disp_z'
  [../]
[]

[Preconditioning]
  active = 'smp'
  [./smp]
    type = SMP
    full = true
  [../]
[]

[Executioner]

  type = Transient
  solve_type = 'PJFNK'
  petsc_options = '-snes_ksp_ew'
  petsc_options_iname = '-pc_type -pc_hypre_type -ksp_gmres_restart'
  petsc_options_value = 'hypre    boomeramg          31'
  line_search = 'none'
  l_max_its = 50
  nl_max_its = 50
  nl_rel_tol = 1e-8
  nl_abs_tol = 1e-6
  l_tol = 1e-8

  start_time = 0.0
  end_time = 0.2
  dt = 0.2
  dtmin = 0.1
[]

[Outputs]
  csv = true
  [./out]
    type = Exodus
  [../]
[]
