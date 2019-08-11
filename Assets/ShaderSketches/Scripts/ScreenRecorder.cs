using UnityEngine;

public class ScreenRecorder : MonoBehaviour
{
    [SerializeField] int framerate = 30;
    [SerializeField] int superSize = default;
    [SerializeField] bool autoRecord = default;

    int frameCount;
    bool recording;

    void Start()
    {
        if (autoRecord)
            StartRecording();
    }

    void StartRecording()
    {
        System.IO.Directory.CreateDirectory("Capture");
        Time.captureFramerate = framerate;
        frameCount = -1;
        recording = true;
    }

    void Update()
    {
        if (recording)
        {
            if (frameCount > 0)
            {
                var name = "Capture/frame" + frameCount.ToString("0000") + ".png";
                ScreenCapture.CaptureScreenshot(name, superSize);
            }

            frameCount++;

            if (frameCount > 0 && frameCount % 60 == 0)
            {
                Debug.Log((frameCount / 60).ToString() + " seconds elapsed.");
            }
        }
    }

    void OnGUI()
    {
        if (!recording && GUI.Button(new Rect(0, 0, 200, 50), "Start Recording"))
        {
            StartRecording();
            Debug.Log("Click Game View to stop recording.");
        }
    }
}
