using UnityEngine;

namespace Es.WaveformProvider.Sample
{
	/// <summary>
	/// Generate waveform with mouse input.
	/// </summary>
	public class MouseWaveInput : MonoBehaviour
	{
		public HandTracking handtracking;
		

		[SerializeField]
		private Texture2D waveform;

		[SerializeField, Range(0f, 1f)]
		private float waveScale = 0.05f;

		[SerializeField, Range(0f, 1f)]
		private float strength = 0.1f;

		private Ray ray;

		private void Awake()
		{
			if(GameObject.Find("Manager"))
				handtracking=GameObject.Find("Manager").GetComponent<HandTracking>();
		}
		private void Update()
		{
			//공간인 경우 손에 콜라이더 붙일 것이므로 상관없음
			//Mouse입력 값이 있으면 || 손의 입력값이 있으면
			if (Input.GetMouseButton(0))
			{
				ray = Camera.main.ScreenPointToRay(Input.mousePosition);
			}
			else
				ray = Camera.main.ScreenPointToRay(GetFingerPoint(8));
			MoveWave();
			
		}

		private Vector2 GetFingerPoint(int index)
		{
			return handtracking.handPoints[index].transform.position*(handtracking.adjuster+50);
		}

		private void MoveWave()
		{
			RaycastHit hitInfo;
			int layerMask= LayerMask.GetMask("Water");
			if (Physics.Raycast(ray, out hitInfo, Mathf.Infinity, layerMask))
			{
				//파동 만들기
				var waveObject = hitInfo.transform.GetComponent<WaveConductor>();
				if (waveObject != null)
					waveObject.Input(waveform, hitInfo, waveScale, strength);
			}
		}		
	}
}