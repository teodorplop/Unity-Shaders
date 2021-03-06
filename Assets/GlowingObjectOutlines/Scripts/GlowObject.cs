﻿using UnityEngine;
using System.Collections.Generic;

namespace SFX.Glow {
    public class GlowObject : MonoBehaviour {
        private List<Material> materials;
        [SerializeField]
        private Color glowColor = Color.black;
        [SerializeField]
        private float lerpFactor = 10.0f;

        private Color currentColor, targetColor;

        private void Awake() {
            materials = new List<Material>();
            foreach (Renderer renderer in GetComponentsInChildren<Renderer>()) {
                materials.AddRange(renderer.materials);
            }
        }

        private void OnMouseEnter() {
            targetColor = glowColor;
            enabled = true;
        }

        private void OnMouseExit() {
            targetColor = Color.black;
            enabled = true;
        }

        void Update() {
            currentColor = Color.Lerp(currentColor, targetColor, Time.deltaTime * lerpFactor);

            for (int i = 0; i < materials.Count; ++i) {
                materials[i].SetColor("_GlowColor", currentColor);
            }

            if (currentColor.Equals(targetColor)) {
                enabled = false;
            }
        }
    }
}
