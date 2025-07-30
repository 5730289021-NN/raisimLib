# OCS2 Integration Examples

This directory contains examples demonstrating compatibility between raisimLib and ocs2 (Optimal Control for Switched Systems).

## Compatibility Notes

- raisimLib version 1.1.8 maintains backward compatibility with ocs2 that supports tag v1.1.01
- Key interfaces for ocs2 integration include:
  - `getMassMatrix()` - for mass matrix computation
  - `getNonlinearities()` - for Coriolis and gravity terms
  - `getGeneralizedCoordinate()` / `setGeneralizedCoordinate()` - for state access
  - `getGeneralizedVelocity()` / `setGeneralizedVelocity()` - for velocity access
  - `getSparseJacobian()` - for Jacobian computation