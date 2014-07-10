/*******************************************************************************
 ******************************************************************************/

#include "Quaternion.h"

//#include <stdio.h>
#include <math.h>

quat::quat() {*this = quat(0, 0, 0, 1);}
quat::quat(float a, float b, float c, float d)
{
    x = a;
    y = b;
    z = c;
    w = d;
}

void quat::normalize()
{
    float TOLERANCE = .00001;
	// Don't normalize if we don't have to
	float mag2 = w * w + x * x + y * y + z * z;
	if (fabs(mag2) > TOLERANCE && fabs(mag2 - 1.0) > TOLERANCE)
    {
		float mag = sqrt(mag2);
		w /= mag; x /= mag; y /= mag; z /= mag;
	}
}

quat quat::getConjugate()
{
	return quat(-x, -y, -z, w);
}

// Convert from Axis Angle
void quat::fromAxisAngle(vec3 axis, float angle)
{
	angle *= 0.5;
    vec3 vn = axis;
	vn.normalize();
    float sinAngle = sin(angle);
	
    x = (vn.x * sinAngle);
	y = (vn.y * sinAngle);
	z = (vn.z * sinAngle);
	w = cos(angle);
}

// Convert to Axis/Angles
float quat::getAxisAngle(vec3 axis, float angle)
{
	float scale = sqrt(x * x + y * y + z * z);
	axis.x = x / scale;
    axis.y = y / scale;
    axis.z = z / scale;
	angle = acos(w) * 2.0;
    return angle;
}

quat quat::operator * (const quat &rhs)
{
    // the constructor takes its arguments as (x, y, z, w)
	return quat(w * rhs.x + x * rhs.w + y * rhs.z - z * rhs.y,
                 w * rhs.y + y * rhs.w + z * rhs.x - x * rhs.z,
                 w * rhs.z + z * rhs.w + x * rhs.y - y * rhs.x,
                 w * rhs.w - x * rhs.x - y * rhs.y - z * rhs.z);
}

// Multiplying a quaternion q with a vector v applies the q-rotation to v
vec3 quat::operator * (const vec3 &vec)
{
    vec3 v = vec;
    v.normalize();
    quat vecQuat = quat(v.x, v.y, v.z, 0.0);
	quat resQuat = vecQuat * getConjugate();
	resQuat = *this * resQuat;
	return vec3(resQuat.x, resQuat.y, resQuat.z);
}

mat4 quat::toMatrix()
{
    float xx = x * x; float yy = y * y; float zz = z * z;
    return mat4(1-(2*yy + 2*zz), 2*x*y - 2*z*w  , 2*x*z + 2*y*w  , 0.0,
                2*x*y + 2*z*w  , 1-(2*xx + 2*zz), 2*y*z - 2*x*w  , 0.0,
                2*x*z - 2*y*w  , 2*y*z + 2*x*w  , 1-(2*xx + 2*yy), 0.0,
                0.0            , 0.0            , 0.0            , 1.0);
    
//    ¦        2     2                                      ¦
//    ¦ 1 - (2Y  + 2Z )   2XY + 2ZW         2XZ - 2YW       ¦
//    ¦                                                     ¦
//    ¦                          2     2                    ¦
//M = ¦ 2XY - 2ZW         1 - (2X  + 2Z )   2YZ + 2XW       ¦
//    ¦                                                     ¦
//    ¦                                            2     2  ¦
//    ¦ 2XZ + 2YW         2YZ - 2XW         1 - (2X  + 2Y ) ¦
//    ¦                                                     ¦
}

void quat::display()
{
    cout << "quat(" << x << ", " << y << ", " << z << ", " << w << ")";
}



