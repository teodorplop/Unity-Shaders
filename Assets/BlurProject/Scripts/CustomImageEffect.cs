using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class CustomImageEffect : MonoBehaviour {
	public Material effectMaterial;
	[Range(0, 10)]
	public int iterations;
	[Range(0, 4)]
	public int downRes;

	void OnRenderImage(RenderTexture source, RenderTexture destination) {
		int width = source.width >> downRes, height = source.height >> downRes;

		RenderTexture rt = RenderTexture.GetTemporary(width, height);
		Graphics.Blit(source, rt);

		for (int i = 0; i < iterations; ++i) {
			RenderTexture rt2 = RenderTexture.GetTemporary(width, height);
			Graphics.Blit(rt, rt2, effectMaterial);
			RenderTexture.ReleaseTemporary(rt);
			rt = rt2;
		}

		Graphics.Blit(rt, destination);
		RenderTexture.ReleaseTemporary(rt);
	}
}
