# OCS2 Compatibility Guide for RaiSim

## Overview

RaiSim version 1.1.8 maintains full backward compatibility with ocs2 (Optimal Control for Switched Systems) which supports RaiSim tag v1.1.01.

## Compatibility Status

- **RaiSim Version**: 1.1.8
- **OCS2 Supported Version**: v1.1.01  
- **Status**: ✅ Compatible

## Key Interfaces for OCS2 Integration

The following RaiSim interfaces are essential for ocs2 integration and remain stable across versions:

### 1. Articulated System Interface

```cpp
#include "raisim/World.hpp"

// Create world and robot
raisim::World world;
auto robot = world.addArticulatedSystem("robot.urdf");
```

### 2. State Access

```cpp
// Get dimensions
int nq = robot->getGeneralizedCoordinateDim();  // Configuration space dimension
int nv = robot->getDOF();                       // Velocity space dimension

// State setting/getting
robot->setGeneralizedCoordinate(q);  // Set configuration
robot->setGeneralizedVelocity(qd);   // Set velocity
const auto& q = robot->getGeneralizedCoordinate();   // Get configuration
const auto& qd = robot->getGeneralizedVelocity();    // Get velocity
```

### 3. Dynamics Computation

```cpp
// Mass matrix (required for optimal control)
robot->updateKinematics();
const auto& M = robot->getMassMatrix();

// Nonlinearities (Coriolis + gravity terms)
Eigen::Vector3d gravity = {0, 0, -9.81};
const auto& h = robot->getNonlinearities(gravity);
```

### 4. Jacobian Computation

```cpp
// For end-effector control
raisim::SparseJacobian jaco;
jaco.resize(nv);
Eigen::Vector3d point = {0, 0, 0};
robot->getSparseJacobian(bodyIdx, point, jaco);
```

### 5. Control Input Application

```cpp
// Apply control torques
Eigen::VectorXd tau(nv);
tau.setZero();
robot->setGeneralizedForce(tau);

// Integrate forward
world.integrate();
```

## API Stability Guarantees

The following interfaces are guaranteed to remain stable for ocs2 compatibility:

- ✅ `getGeneralizedCoordinate()` / `setGeneralizedCoordinate()`
- ✅ `getGeneralizedVelocity()` / `setGeneralizedVelocity()`  
- ✅ `getMassMatrix()`
- ✅ `getNonlinearities()`
- ✅ `getSparseJacobian()`
- ✅ `setGeneralizedForce()`
- ✅ `integrate()`

## Version Compatibility Matrix

| RaiSim Version | OCS2 Support Status | Notes |
|----------------|-------------------|-------|
| v1.1.01        | ✅ Fully Supported | Original supported version |
| v1.1.8         | ✅ Fully Compatible | Backward compatible with v1.1.01 |

## Testing Compatibility

To verify compatibility between your ocs2 setup and RaiSim, run the provided compatibility test:

```bash
cd build/examples
./ocs2_compatibility_test
```

This test verifies all essential interfaces that ocs2 requires from RaiSim.

## CMake Integration

For CMake-based ocs2 projects, use the standard RaiSim find_package:

```cmake
find_package(raisim CONFIG REQUIRED)
target_link_libraries(your_target raisim::raisim)
```

The RaiSim CMake configuration automatically handles version compatibility.

## Notes

- All interfaces used by ocs2 remain binary compatible across minor version updates
- The dynamics computation performance has been maintained or improved
- Memory layout and calling conventions are preserved for ocs2 integration