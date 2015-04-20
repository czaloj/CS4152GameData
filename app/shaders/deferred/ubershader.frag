#version 130

in vec2 coord;

uniform sampler2D positionMap;
uniform sampler2D normalMap;
uniform sampler2D colorMap;
uniform sampler2D depthMap;
uniform sampler2D ssaoMap;

out vec4 fragColor;

const vec3 lightDir = vec3(1, 1, 1);
const float specularPower = 16.0f;
const vec3 lightColor = vec3(1, 1, 1);

float linearizeDepth(float depth) {
    float near = 0.1; 
    float far = 1000.0; 
    float z = depth * 2.0 - 1.0; // Back to NDC 
    return (2.0 * near) / (far + near - z * (far - near));	
}

void main() {
    vec3 n = normalize(texture(normalMap, coord).xyz);
	float s = texture(normalMap, coord).w;
	vec3 pos = texture(positionMap, coord).xyz;
	vec3 color = texture(colorMap, coord).xyz;
	float depth = texture(depthMap, coord).x;
	float ssao = texture(ssaoMap, coord).x;
	
	vec3 v = -normalize(pos);

	vec3 l = normalize(lightDir);
	vec3 h = normalize(v + l);

	float attenuation = 1; //don't attenuate for directional light
	float ndotl = dot(n, l);
	vec3 diffuse = max(0.0f, ndotl) * color;

	vec3 specular = vec3(0);
	if (ndotl >= 0) specular = pow(max(0.0f, dot(n, h)), specularPower) * vec3(0);

	fragColor = vec4(lightColor * (diffuse + specular) / attenuation, 1);
	//fragColor = vec4(diffuse, 1);
	//fragColor = vec4(n * 0.5 + 0.5, 1);
	//fragColor = vec4(lightColor * (diffuse * ssao + specular) / attenuation, 1);
	//fragColor = vec4(vec3(ssao), 1);
	//fragColor = vec4(color, 1);
	//fragColor = vec4(l, 1);
}