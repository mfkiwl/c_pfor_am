// Nicolo Grilli
// Daijun Hu 
// National University of Singapore
// 21 Ottobre 2020

#pragma once

#include "FiniteStrainCrystalPlasticity.h"

/**
 * FiniteStrainCrystalPlasticityDislo uses the multiplicative decomposition of deformation gradient
 * and solves the PK2 stress residual equation at the intermediate configuration to evolve the material state.
 * The internal variables are updated using an interative predictor-corrector algorithm.
 * Backward Euler integration rule is used for the rate equations.
 * Temperature dependence of the CRSS.
 * Dislocation based model.
 * Calculation of the dislocation velocity depending on resolved shear stress
 */
class FiniteStrainCrystalPlasticityDislo : public FiniteStrainCrystalPlasticity
{
public:
  static InputParameters validParams();

  FiniteStrainCrystalPlasticityDislo(const InputParameters & parameters);

protected:
  /**
   * This function calculates stress residual.
   */
  virtual void calcResidual( RankTwoTensor &resid );
  
  /**
  * This function updates the slip increments.
  * And derivative of slip w.r.t. resolved shear stress.
  */
  virtual void getSlipIncrements();
  
  /**
  * This function
  * stores the dislocation velocity value
  * to couple with dislocation transport
  */
  virtual void getDisloVelocity();

  /**
  * This function
  * stores the dislocation velocity direction
  * to couple with dislocation transport
  */
  virtual void OutputSlipDirection();

  const VariableValue & _temp;
  const Real _thermal_expansion;
  const Real _reference_temperature;

  const Real _dCRSS_dT_A;
  const Real _dCRSS_dT_B;
  const Real _dCRSS_dT_C;
  const Real _dislo_mobility;
  
  // critical resolved shear stress
  // exponentially decreased with temperature
  std::vector<Real> _gssT;
  
  // Rotated slip direction to couple with dislocation transport
  // to indicate dislocation velocity direction for all slip systems
  MaterialProperty<std::vector<Real>> & _slip_direction;
  
  // Slip increment for output
  MaterialProperty<std::vector<Real>> & _slip_incr_out;
  
  // Dislocation velocity
  MaterialProperty<std::vector<Real>> & _dislo_velocity;

};


