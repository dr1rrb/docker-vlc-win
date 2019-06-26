using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading;
using System.Threading.Tasks;
using HtmlAgilityPack;

namespace Crawler.Client.VideoLan
{
	public class VideoLanApi : IDisposable
	{
		private readonly Regex _version = new Regex(@"[0-9]+\.[0-9]+\.[0-9]+(\.[0-9]+)?");
		private readonly HttpClient _client;

		public VideoLanApi()
		{
			_client = new HttpClient();
		}

		public async Task<string> GetLatestVersion(CancellationToken ct)
		{
			using (var response = await _client.GetAsync("https://download.videolan.org/pub/videolan/vlc/", ct))
			{
				var html = await response.EnsureSuccessStatusCode().Content.ReadAsStreamAsync();
				var doc = new HtmlDocument();
				doc.Load(html);

				return doc
					.DocumentNode
					.SelectNodes("//a")
					.Select(node => _version.Match(node.InnerText))
					.Where(match => match.Success)
					.Select(match => match.Value)
					.OrderBy(version => version)
					.LastOrDefault();
			}
		}

		/// <inheritdoc />
		public void Dispose()
			=> _client.Dispose();
	}
}
