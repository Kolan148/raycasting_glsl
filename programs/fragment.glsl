#version 330 core

uniform vec2 u_resolution;
uniform float x;
uniform float y;
uniform float z;
uniform float a1;
uniform float a2;
//uniform vec2 u_mouse;
//uniform float u_time;

float mod(float n){
    if(n < 0.0){return -n;}
    return n;
}

bool bv(vec3 v1, vec3 v2){
    return v1.x>v2.x&&v1.y>v2.y&&v1.z>v2.z;
}

bool pfCube(vec3 point, float s){
    return mod(point.x)<s && mod(point.y)<s && mod(point.z)<s;
}
bool pfSphere(vec3 point, float r){
    return point.x*point.x+point.y*point.y+point.z*point.z<r;
}
bool pfTetrahedron(vec3 point, float s){
    return mod(point.x)+mod(point.y)+mod(point.z)<s;
}
bool pfTorus(vec3 point, float R, float r2){
    return 2.0*(R-sqrt(point.x+point.y))+point.z<r2;
}
bool pfGround(vec3 point, float h){
    return -point.y<=h;
}
// bool pfCylinder(vec3 point, float r, float q){
//     vec3 cost = r * normalize(point);
//     return dot(q - point, point) > 0.0 && bv(normalize(cross(q-point, point)), cost);
// }


vec3 getLight(vec3 p, vec3 rd, vec3 color) {
    vec3 lightPos = vec3(10.0, 55.0, -20.0);
    vec3 L = normalize(lightPos - p);
    vec3 N = normalize(p);
    vec3 V = -rd;
    vec3 R = reflect(-L, N);

    vec3 specColor = vec3(0.5);
    vec3 specular = specColor * pow(clamp(dot(R, V), 0.0, 1.0), 10.0);
    vec3 diffuse = color * clamp(dot(L, N), 0.0, 1.0);
    vec3 ambient = color * 0.05;
    vec3 fresnel = 0.25 * color * pow(1.0 + dot(rd, N), 3.0);

    return diffuse + ambient + specular + fresnel;
}

vec3 getColor(float n){
    vec3 m;
    int x = int(n);
    if(x == 1){m = vec3(0.9, 0.0, 0.0);}
    if(x == 2){m = vec3(0.35);}
    if(x == 3){m = vec3(0.7, 0.8, 0.9);}
    return m;
}


vec2 sumObj(vec2 obj1, vec2 obj2){
    vec2 res = vec2(float(obj1.x==1.0||obj2.x==1.0), 0);
    if(res.x==obj1.x){res.y=obj1.y;}
    else{res.y=obj2.y;}
    return res;
}

vec2 map(vec3 point){
    vec2 cube = vec2(float(pfCube(point+vec3(1.5, 0, 0), 1.0)), 1.0);
    vec2 sphere = vec2(float(pfSphere(point-vec3(1.5, 0, 0), 1.25)), 3.0);
    vec2 ground = vec2(float(pfGround(point, -1.0)), 2.0);
    vec2 res;
    res = sumObj(cube, sphere);
    res = sumObj(res, ground);
    return res;
}

vec3 castPoint(vec3 ro, vec3 rd){
    for(int t=0;t<80;t++){
        vec3 point = ro+vec3(t)*rd;
	vec2 obj=map(point);
        if(obj.x==1.0){return vec3(getLight(point, rd, getColor(obj.y)));}
    }
    return vec3(0.2, 0.3, 0.7);
}

void main() {
    vec3 ro = vec3(x, -y, -5+z);
    vec3 rd = vec3(a1, -a2, 1);
    vec2 st = gl_FragCoord.xy/u_resolution.xy;
    st -= vec2(.5);
    st.x *= u_resolution.x/u_resolution.y;
    rd.xy -= st;
    //rd.z += cos(u_time*0.5);
    vec3 color = vec3(0.);
    //if(mod(st.x)+mod(st.y)<0.5){color=vec3(1.0);}
    color = castPoint(ro, rd);
    gl_FragColor = vec4(color,1.0);
}
