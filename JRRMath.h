/*******************************************************************************
 ******************************************************************************/

#ifndef JRR_MATH
#define JRR_MATH

#include <iostream>

#include "Matrix.h"
#include "Vector.h"
#include "Quaternion.h"

/*******************************************************************************
 * Matrix Operations
 ******************************************************************************/
mat4 ortho(float l, float r, float b, float t, float n, float f);
mat4 ortho(float aspectRatio, float n, float f);
mat4 perspective(float l, float r, float b, float t, float n, float f);
mat4 perspective(float aspectRatio, float fov, float n, float f);
mat4 lookAt(vec3 pos, vec3 look, vec3 up);

mat4 translate(float x, float y, float z);
mat4 translate(vec3 t);
mat4 scale(float x, float y, float z);
mat4 scale(float s);
mat4 rotateX(float degrees);
mat4 rotateY(float degrees);
mat4 rotateZ(float degrees);

/*******************************************************************************
 * Interpolation
 ******************************************************************************/
float lerp(float a, float b, float t);
vec2 lerp(vec2 a, vec2 b, float t);
vec3 lerp(vec3 a, vec3 b, float t);
vec4 lerp(vec4 a, vec4 b, float t);
quat lerp(quat a, quat b, float t);

vec2 nlerp(vec2 a, vec2 b, float t);
vec3 nlerp(vec3 a, vec3 b, float t);
vec4 nlerp(vec4 a, vec4 b, float t);
quat nlerp(quat a, quat b, float t);

vec2 slerp(vec2 a, vec2 b, float t);
vec3 slerp(vec3 a, vec3 b, float t);
vec4 slerp(vec4 a, vec4 b, float t);
quat slerp(quat a, quat b, float t);

/*******************************************************************************
 * Other
 ******************************************************************************/
//I' = I - 2 * dot(N, I) * N;
vec2 reflect(vec2 dir, vec2 normal);
vec3 reflect(vec3 dir, vec3 normal);
vec4 reflect(vec4 dir, vec4 normal);

//template <class T> T clamp(T num, T low, T high);
int clamp(int num, int low, int high);
float clamp(float num, float low, float high);
vec2 clamp(vec2 v, float low, float high);
vec3 clamp(vec3 v, float low, float high);
vec4 clamp(vec4 v, float low, float high);

#endif


