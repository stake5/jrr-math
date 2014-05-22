/*******************************************************************************
 *
 ******************************************************************************/

#ifndef JRR_MATRIX
#define JRR_MATRIX

#include <iostream>
using std::ostream;

class vec3;
class vec4;

class mat3
{
public:
    float values[9];
    
    mat3();
    mat3(float a, float b, float c,
         float d, float e, float f,
         float g, float h, float i);
    mat3 transpose();
    vec3 operator * (const vec3 &v);
};
ostream& operator << (ostream& os, const mat3& m);

class mat4
{
public:
    float values[16];
    
    mat4();
    mat4(float a, float b, float c, float d,
         float e, float f, float g, float h,
         float i, float j, float k, float l,
         float m, float n, float o, float p);
    mat4 transpose();
    mat3 toMat3();
    mat4 operator * (const mat4 &right);
    vec4 operator * (const vec4 &v);
};
ostream& operator << (ostream& os, const mat4& m);

#endif
