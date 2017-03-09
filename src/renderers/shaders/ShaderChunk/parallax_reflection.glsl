#define MAX_BOUNDING_BOXES 10

uniform vec3 boundingBoxMinMax[MAX_BOUNDING_BOXES * 2 ];

uniform vec3 cubeCameraPos;
uniform vec3 roomDimensions;
uniform int NumBoundingBoxes;

struct Ray {
    vec3 origin;
    vec3 direction;
    vec3 inv_direction;
};

Ray makeRay(in vec3 origin, in vec3 direction) {
    return Ray(origin, direction, vec3(1.0) / direction);
}

bool intersection(const in vec3 bbmin, const in vec3 bbmax, const in Ray r, inout vec3 hitPoint) {
    float tx1 = (bbmin.x - r.origin.x)*r.inv_direction.x;
    float tx2 = (bbmax.x - r.origin.x)*r.inv_direction.x;

    float tmin = min(tx1, tx2);
    float tmax = max(tx1, tx2);

    float ty1 = (bbmin.y - r.origin.y) * r.inv_direction.y;
    float ty2 = (bbmax.y - r.origin.y) * r.inv_direction.y;

    tmin = max(tmin, min(ty1, ty2));
    tmax = min(tmax, max(ty1, ty2));

		float tz1 = (bbmin.z - r.origin.z) * r.inv_direction.z;
    float tz2 = (bbmax.z - r.origin.z) * r.inv_direction.z;

    tmin = max(tmin, min(tz1, tz2));
    tmax = min(tmax, max(tz1, tz2));

    if( tmax >= tmin && tmin > 0.0 ) {
			hitPoint = r.origin + tmin * r.direction;
			return true;
		}
		return false;
}

vec3 getClosestHitPoint (vec3 reflectionDir, vec3 vPositionW) {
    Ray reflectedRay = makeRay(vPositionW, reflectionDir);

    vec3 hitPoint = vec3(100000.0, 100000.0, 100000.0);
    vec3 boundingBoxHitPoint = vec3(100000.0, 100000.0, 100000.0);

    // Intersect reflected ray with all the bounding boxes and find hitPoint.
    for(int i = 0; i < 2 * MAX_BOUNDING_BOXES; i+=2) {
        if( i >= 2 * NumBoundingBoxes )
            continue;
        bool intersects = intersection(boundingBoxMinMax[i], boundingBoxMinMax[i+1], reflectedRay, boundingBoxHitPoint);
        if(intersects) {
            vec3 d1 = boundingBoxHitPoint - vPositionW;
            vec3 d2 = hitPoint - vPositionW;
            hitPoint = length(d1) < length(d2) ? boundingBoxHitPoint : hitPoint;
        }
    }

    // Intersect reflected ray with the room and compare with the hitPoint. This is needed because we need room relfection.
    float roomLength = roomDimensions[0];
    float roomWidth = roomDimensions[1];
    float roomHeight = roomDimensions[2];

    vec3 roomMin = vec3(-roomWidth*0.5, 0.0, -roomLength*0.5);
    vec3 roomMax = vec3(roomWidth*0.5, roomHeight, roomLength*0.5);

    vec3 rbmax = (roomMax - vPositionW) / reflectionDir;
    vec3 rbmin = (roomMin - vPositionW) / reflectionDir;

    vec3 rbminmax = max(rbmin, rbmax);

    float fa = min(min(rbminmax.x, rbminmax.y), rbminmax.z);

    vec3 d1 = hitPoint - vPositionW;
    vec3 roomHitPoint = vPositionW + reflectionDir * fa;
    vec3 d2 = roomHitPoint - vPositionW;
    hitPoint = dot(d1, d1) < dot( d2, d2) ? hitPoint : roomHitPoint;

    return hitPoint;

}
