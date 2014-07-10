/*******************************************************************************
 ******************************************************************************/

#ifndef JRR_QUATERNION
#define JRR_QUATERNION

#include <iostream>

#include "Matrix.h"
#include "Vector.h"

/*******************************************************************************
 * http://www.cs.princeton.edu/~gewang/projects/darth/stuff/quat_faq.html#Q47
 ******************************************************************************/
class quat
{
public:
    
    float x, y, z, w;
    
    quat();
    quat(float a, float b, float c, float d);
    
    void normalize();
    quat getConjugate();
    void fromAxisAngle(vec3 axis, float angle);
    float getAxisAngle(vec3 axis, float angle);
    mat4 toMatrix();
    void display();
    
    quat operator * (const quat &rhs);
    vec3 operator * (const vec3 &v);
    
};

#endif
