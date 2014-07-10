/*******************************************************************************
 ******************************************************************************/

#include "JRRMath.h"

#include "Matrix.h"

mat4 perspective(float l, float r, float b, float t, float n, float f)
{
    return mat4((2*n)/(r-l), 0.0,          (r+l)/(r-l), 0.0,
                0.0,         (2*n)/(t-b),  (t+b)/(t-b), 0.0,
                0.0,         0.0,         -(f+n)/(f-n), -(2*f*n)/(f-n),
                0.0,         0.0,         -1.0,         0.0);
}

mat4 perspective(float aspect, float fovY, float zNear, float zFar)
{
    float fH = float(tan(fovY / 360 * M_PI) * zNear);
    float fW = float(fH * aspect);
    return perspective(-fW, fW, -fH, fH, zNear, zFar);
}

mat4 ortho(float l, float r, float b, float t, float n, float f)
{
    return mat4((2.0/(r-l)), 0.0        , 0.0         , -((r+l)/(r-l)),
                0.0        , (2.0/(t-b)), 0.0         , -((t+b)/(t-b)),
                0.0        , 0.0        , (-2.0/(f-n)), -((f+n)/(f-n)),
                0.0        , 0.0        , 0.0         , 1.0);
}

mat4 ortho(float aspectRatio, float n, float f)
{
    float l, r, b, t;
    if (aspectRatio <= 1)
    {
        l = -1; r = 1;
        t = 1/aspectRatio;
        b = -t;
    }
    else
    {
        r = aspectRatio;
        l = -r;
        b = -1; t = 1;
    }
    return ortho(l, r, t, b, n, f);
}

mat4 lookAt(vec3 pos, vec3 look, vec3 up)
{
    vec3 z = pos - look;
    z.normalize();
    vec3 x = z.cross(up);
    x.normalize();
    vec3 y = x.cross(z);
    return (mat4(x.x, x.y, x.z, 0.0, // i
                 y.x, y.y, y.z, 0.0, // j
                 z.x, z.y, z.z, 0.0, // k
                 0.0, 0.0, 0.0, 1.0) *
            translate(-pos.x, -pos.y, -pos.z));
}

mat4 translate(float x, float y, float z)
{
    return mat4(1.0, 0.0, 0.0, x,
                0.0, 1.0, 0.0, y,
                0.0, 0.0, 1.0, z,
                0.0, 0.0, 0.0, 1.0);
}
mat4 translate(vec3 t) {return translate(t.x, t.y, t.z);}

mat4 scale(float x, float y, float z)
{
    return mat4(x  , 0.0, 0.0, 0.0,
                0.0, y  , 0.0, 0.0,
                0.0, 0.0, z  , 0.0,
                0.0, 0.0, 0.0, 1.0);
}
mat4 scale(float s) {return scale(s, s, s);}

// t+center  *  rotate  *  scale  *  t-center
// parentMatrix * childMatrix
// roll -> pitch -> yaw (z -> x -> y)
// mat multiply ->  yaw * pitch * roll (y * x * z)
mat4 rotateX(float degrees) // pitch
{
    float cosA = cos((M_PI / 180.0) * degrees);
    float sinA = sin((M_PI / 180.0) * degrees);
    return mat4(1.0, 0.0 ,  0.0 , 0.0,
                0.0, cosA, -sinA, 0.0,
                0.0, sinA,  cosA, 0.0,
                0.0, 0.0 ,  0.0 , 1.0);
}

mat4 rotateY(float degrees) // yaw
{
    float cosA = cos((M_PI / 180.0) * degrees);
    float sinA = sin((M_PI / 180.0) * degrees);
    return mat4(cosA , 0.0, sinA, 0.0,
                0.0  , 1.0, 0.0 , 0.0,
                -sinA, 0.0, cosA, 0.0,
                0.0  , 0.0, 0.0 , 1.0);
}

mat4 rotateZ(float degrees) // roll
{
    float cosA = cos((M_PI / 180.0) * degrees);
    float sinA = sin((M_PI / 180.0) * degrees);
    return mat4(cosA,-sinA, 0.0, 0.0,
                sinA, cosA, 0.0, 0.0,
                0.0 , 0.0 , 1.0, 0.0,
                0.0 , 0.0 , 0.0, 1.0);
}








float lerp(float a, float b, float t) {return (a + ((b - a) * t));}
vec2 lerp(vec2 a, vec2 b, float t) {return a + ((b - a) * t);}
vec3 lerp(vec3 a, vec3 b, float t) {return a + ((b - a) * t);}
vec4 lerp(vec4 a, vec4 b, float t) {return a + ((b - a) * t);}
quat lerp(quat a, quat b, float t)
{
    float iT = 1.0 - t;
    float x = a.x * iT + b.x * t;
    float y = a.y * iT + b.y * t;
    float z = a.z * iT + b.z * t;
    float w = a.w * iT + b.w * t;
    return quat(x, y, z, w);
}

vec2 nlerp(vec2 a, vec2 b, float t)
{
    vec2 c = lerp(a, b, t);
    c.normalize();
    return c;
}
vec3 nlerp(vec3 a, vec3 b, float t)
{
    vec3 c = lerp(a, b, t);
    c.normalize();
    return c;
}
vec4 nlerp(vec4 a, vec4 b, float t)
{
    vec4 c = lerp(a, b, t);
    c.normalize();
    return c;
}
quat nlerp(quat a, quat b, float t)
{
    quat q = lerp(a, b, t);
    q.normalize();
    return q;
}

vec2 slerp(vec2 a, vec2 b, float t)
{
    float dot = a.dot(b);
    dot = clamp(dot, -1.0, 1.0);
    float theta = acosf(dot) * t;
    vec2 relativeVec = b - a * dot;
    relativeVec.normalize();
    return ((a * cosf(theta)) + (relativeVec * sinf(theta)));
}
vec3 slerp(vec3 a, vec3 b, float t)
{
    float dot = a.dot(b);
    dot = clamp(dot, -1.0, 1.0);
    float theta = acosf(dot) * t;
    vec3 relativeVec = b - a * dot;
    relativeVec.normalize();
    return ((a * cosf(theta)) + (relativeVec * sinf(theta)));
}
vec4 slerp(vec4 a, vec4 b, float t)
{
    float dot = a.dot(b);
    dot = clamp(dot, -1.0, 1.0);
    float theta = acosf(dot) * t;
    vec4 relativeVec = b - a * dot;
    relativeVec.normalize();
    return ((a * cosf(theta)) + (relativeVec * sinf(theta)));
}
quat slerp(quat a, quat b, float t)
{
    return quat();
// http://www.gamedev.net/topic/314719-slerp-tutorial/
//    float to1[4];
//    float omega, cosom, sinom, scale0, scale1;
//    cosom = a.x * b.x + a.y * b.y + a.z * b.z + a.w * b.w;
//    if (cosom < 0.0)
//    {
//        cosom = -cosom;
//        to1[0] = -b.x;
//        to1[1] = -b.y;
//        to1[3] = -b.w;
//    }
//    else
//    {
//        to1[0] = b.x;
//        to1[1] = b.y;
//        to1[2] = b.z;
//        to1[3] = b.w;
//    }
//    if ((1.0 - cosom) > DELTA )
//    {
//        // standard case (slerp)
//        omega = acos(cosom);
//        sinom = sin(omega);
//        scale0 = sin((1.0 - t) * omega) / sinom;
//        scale1 = sin(t * omega) / sinom;
//    } else {
//        // "from" and "to" quaternions are very close
//        //  ... so we can do a linear interpolation
//        scale0 = 1.0 - t;
//        scale1 = t;
//    }
//    // calculate final values
//    res->x = scale0 * from->x + scale1 * to1[0];
//    res->y = scale0 * from->y + scale1 * to1[1];
//    res->z = scale0 * from->z + scale1 * to1[2];
//    res->w = scale0 * from->w + scale1 * to1[3];
}

//quat slerp(QUAT * from, QUAT * to, float t, QUAT * res)
//{
//    float           to1[4];
//    double        omega, cosom, sinom, scale0, scale1;
//    // calc cosine
//    cosom = from->x * to->x + from->y * to->y + from->z * to->z
//    + from->w * to->w;
//    // adjust signs (if necessary)
//    if ( cosom <0.0 ){ cosom = -cosom; to1[0] = - to->x;
//        to1[1] = - to->y;
//        to1[2] = - to->z;
//        to1[3] = - to->w;
//    } else  {
//        to1[0] = to->x;
//        to1[1] = to->y;
//        to1[2] = to->z;
//        to1[3] = to->w;
//    }
//    // calculate coefficients
//    if ( (1.0 - cosom) > DELTA ) {
//        // standard case (slerp)
//        omega = acos(cosom);
//        sinom = sin(omega);
//        scale0 = sin((1.0 - t) * omega) / sinom;
//        scale1 = sin(t * omega) / sinom;
//    } else {
//        // "from" and "to" quaternions are very close
//        //  ... so we can do a linear interpolation
//        scale0 = 1.0 - t;
//        scale1 = t;
//    }
//    // calculate final values
//    res->x = scale0 * from->x + scale1 * to1[0];
//    res->y = scale0 * from->y + scale1 * to1[1];
//    res->z = scale0 * from->z + scale1 * to1[2];
//    res->w = scale0 * from->w + scale1 * to1[3];
//}







//I' = I - 2 * dot(N, I) * N;
vec2 reflect(vec2 dir, vec2 normal) {return dir - (normal * 2 * normal.dot(dir));}
vec3 reflect(vec3 dir, vec3 normal) {return dir - (normal * 2 * normal.dot(dir));}
vec4 reflect(vec4 dir, vec4 normal) {return dir - (normal * 2 * normal.dot(dir));}

//template <class T>
//T clamp(T num, T low, T high)
//{
//    if      (num < low)  return low;
//    else if (num > high) return high;
//    else                 return num;
//}
int clamp(int num, int low, int high)
{
    if      (num < low)  return low;
    else if (num > high) return high;
    else                 return num;
}

float clamp(float num, float low, float high)
{
    if      (num < low)  return low;
    else if (num > high) return high;
    else                 return num;
}
vec2 clamp(vec2 v, float low, float high)
{
    return vec2(clamp(v.x, low, high),
                clamp(v.y, low, high));
}
vec3 clamp(vec3 v, float low, float high)
{
    return vec3(clamp(v.x, low, high),
                clamp(v.y, low, high),
                clamp(v.z, low, high));
}
vec4 clamp(vec4 v, float low, float high)
{
    return vec4(clamp(v.x, low, high),
                clamp(v.y, low, high),
                clamp(v.z, low, high),
                clamp(v.w, low, high));
}


