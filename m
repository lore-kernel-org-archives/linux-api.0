From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/8] kernfs: Add API to generate relative
	kernfs path
Date: Mon, 30 Nov 2015 10:11:47 -0500
Message-ID: <20151130151147.GG3535@mtj.duckdns.org>
References: <1447703505-29672-1-git-send-email-serge@hallyn.com>
 <1447703505-29672-2-git-send-email-serge@hallyn.com>
 <20151124161630.GL17033@mtj.duckdns.org>
 <20151127052511.GA25490@mail.hallyn.com>
Reply-To: LXC development mailing-list <lxc-devel-cunTk1MwBs9qMoObBWhMNEqPaTDuhLve2LY78lusg7I@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <lxc-devel-bounces-cunTk1MwBs9qMoObBWhMNEqPaTDuhLve2LY78lusg7I@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151127052511.GA25490-7LNsyQBKDXoIagZqoN9o3w@public.gmane.org>
List-Unsubscribe: <http://lists.linuxcontainers.org/options/lxc-devel>,
 <mailto:lxc-devel-request-cunTk1MwBs9qMoObBWhMNEqPaTDuhLve2LY78lusg7I@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxcontainers.org/pipermail/lxc-devel/>
List-Post: <mailto:lxc-devel-cunTk1MwBs9qMoObBWhMNEqPaTDuhLve2LY78lusg7I@public.gmane.org>
List-Help: <mailto:lxc-devel-request-cunTk1MwBs9qMoObBWhMNEqPaTDuhLve2LY78lusg7I@public.gmane.org?subject=help>
List-Subscribe: <http://lists.linuxcontainers.org/listinfo/lxc-devel>,
 <mailto:lxc-devel-request-cunTk1MwBs9qMoObBWhMNEqPaTDuhLve2LY78lusg7I@public.gmane.org?subject=subscribe>
Errors-To: lxc-devel-bounces-cunTk1MwBs9qMoObBWhMNEqPaTDuhLve2LY78lusg7I@public.gmane.org
Sender: "lxc-devel" <lxc-devel-bounces-cunTk1MwBs9qMoObBWhMNEqPaTDuhLve2LY78lusg7I@public.gmane.org>
To: "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Cc: adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lxc-devel-cunTk1MwBs9qMoObBWhMNEqPaTDuhLve2LY78lusg7I@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org
List-Id: linux-api@vger.kernel.org

SGVsbG8sCgpPbiBUaHUsIE5vdiAyNiwgMjAxNSBhdCAxMToyNToxMVBNIC0wNjAwLCBTZXJnZSBF
LiBIYWxseW4gd3JvdGU6Cj4gPiA+ICsJLyogU2hvcnQtY2lyY3VpdCB0aGUgZWFzeSBjYXNlIC0g
a25fdG8gaXMgdGhlIHJvb3Qgbm9kZS4gKi8KPiA+ID4gKwlpZiAoKGtuX2Zyb20gPT0ga25fdG8p
IHx8ICgha25fZnJvbSAmJiAha25fdG8tPnBhcmVudCkpIHsKPiA+ID4gKwkJKnAgPSAnLyc7Cj4g
PiA+ICsJCSoocCArIDEpID0gJ1wwJzsKPiA+IAo+ID4gSG1tLi4uIHNvIGlmIGtuX2Zyb20gPT0g
a25fdG8sIHRoZSBvdXRwdXQgaXMgIi8iPwo+IAo+IFllcywgdGhhdCdzIHdoYXQgc2VlbXMgdG8g
bWFrZSB0aGUgbW9zdCBzZW5zZSBmb3IgY2dyb3VwIG5hbWVzcGFjZXMuICBJCj4gY291bGQgc2Vl
IGEgY2FzZSBmb3IgJy4nIGJlaW5nIHVzZWQgaW5zdGVhZCBpbiBnZW5lcmFsLCBidXQgZm9yIGNn
cm91cAo+IG5hbWVzcGFjZXMgSSB0aGluayB3ZSdkIGhhdmUgdG8gY29udmVydCB0aG9zZSBiYWNr
IHRvICcvJy4gIE90aGVyd2lzZQo+IHdlJ2xsIGZhaWwgaW4gYmVpbmcgYWJsZSB0byBydW4gbGVn
YWN5IHNvZnR3YXJlLCB3aGljaCB3b3VsZCBnZXQKPiBjb25mdXNlZC4KClllYWgsIEkgYWdyZWUg
YnV0IHRoZSBuYW1lIGlzIGtpbmRhIG1pc2xlYWRpbmcgdGhvLiAgVGhlIG91dHB1dCBpc24ndApy
ZWFsbHkgYSByZWxhdGl2ZSBwYXRoIGJ1dCByYXRoZXIgYWJzb2x1dGUgcGF0aCBhZ2FpbnN0IHRo
ZSBzcGVjaWZpZWQKcm9vdC4gIE1heWJlIHVwZGF0aW5nIHRoZSBmdW5jdGlvbiBhbmQgcGFyYW1l
dGVyIG5hbWVzIHdvdWxkIGJlCmhlbHBmdWw/CgpUaGFua3MuCgotLSAKdGVqdW4KX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KbHhjLWRldmVsIG1haWxpbmcg
bGlzdApseGMtZGV2ZWxAbGlzdHMubGludXhjb250YWluZXJzLm9yZwpodHRwOi8vbGlzdHMubGlu
dXhjb250YWluZXJzLm9yZy9saXN0aW5mby9seGMtZGV2ZWwK
