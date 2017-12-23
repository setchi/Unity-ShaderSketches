using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class Menu : MonoBehaviour
{
    [SerializeField]
    Shader[] shaders;
    [SerializeField]
    GameObject container;
    [SerializeField]
    GameObject menuRoot;
    [SerializeField]
    GameObject itemPrefab;
    [SerializeField]
    Image sketch;
    [SerializeField]
    Toggle toggle;

    // Use this for initialization
    void Start()
    {
        for (int i = 0; i < shaders.Length; i++)
        {
            var item = Instantiate(itemPrefab);
            item.transform.SetParent(container.transform);
            item.transform.localScale = Vector3.one;

            var material = CreateMaterial(shaders[i]);
            var button = item.GetComponent<Button>();
            button.transform.GetChild(0).GetComponent<Image>().material = material;
            button.onClick.AddListener(() => ShowSketch(material));

            if (i == 0) ShowSketch(material);
        }

        toggle.onValueChanged.AddListener(SetListVisible);
        SetListVisible(true);
    }

    Material CreateMaterial(Shader shader)
    {
        var material = new Material(shader);
        material.hideFlags = HideFlags.DontSave;
        return material;
    }

    void ShowSketch(Material material)
    {
        sketch.material = material;
    }

    void SetListVisible(bool show)
    {
        menuRoot.gameObject.SetActive(show);
    }
}