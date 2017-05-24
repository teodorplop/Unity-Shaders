using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class Effects : MonoBehaviour {
	public Material effectMaterial;
	public AnimationCurve animationCurve;
	public float transitionTime;

	private Material _material;
	void Start() {
		_material = Instantiate(effectMaterial);
	}
	void OnDestroy() {
		if (UnityEditor.EditorApplication.isPlaying) {
			Destroy(_material);
		}
	}

	void OnRenderImage(RenderTexture source, RenderTexture destination) {
		if (UnityEditor.EditorApplication.isPlaying) {
			Graphics.Blit(source, destination, _material);
		} else {
			Graphics.Blit(source, destination, effectMaterial);
		}
	}

	private float _progress;
	void Update() {
		if (UnityEditor.EditorApplication.isPlaying) {
			_progress += Time.deltaTime / transitionTime;
			_material.SetFloat("_Progress", animationCurve.Evaluate(_progress));
		}
	}
}
