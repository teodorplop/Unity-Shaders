using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class ReplacementShaderEffect : MonoBehaviour {
	public Color overDrawColor;
	public Shader replacementShader;

	void OnValidate() {
		Shader.SetGlobalColor("_OverDrawColor", overDrawColor);
	}

	void OnEnable() {
		if (replacementShader != null) {
			GetComponent<Camera>().SetReplacementShader(replacementShader, "");
		}
	}
	void OnDisable() {
		GetComponent<Camera>().ResetReplacementShader();
	}
}
