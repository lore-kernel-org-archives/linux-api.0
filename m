From: "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 7/8] cgroup: mount cgroupns-root when inside
 non-init cgroupns
Date: Wed, 2 Dec 2015 11:02:39 -0600
Message-ID: <20151202170239.GA21009@mail.hallyn.com>
References: <1447703505-29672-8-git-send-email-serge@hallyn.com>
 <20151124171610.GS17033@mtj.duckdns.org>
 <20151127051745.GA24521@mail.hallyn.com>
 <20151130150938.GF3535@mtj.duckdns.org>
 <20151201040704.GA31067@mail.hallyn.com>
 <20151201164649.GD12922@mtj.duckdns.org>
 <20151201215853.GA9153@mail.hallyn.com>
 <20151202165312.GB19878@mtj.duckdns.org>
 <20151202165637.GA20840@mail.hallyn.com>
 <20151202165839.GD19878@mtj.duckdns.org>
Reply-To: LXC development mailing-list <lxc-devel-cunTk1MwBs9qMoObBWhMNEqPaTDuhLve2LY78lusg7I@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <lxc-devel-bounces-cunTk1MwBs9qMoObBWhMNEqPaTDuhLve2LY78lusg7I@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151202165839.GD19878-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
List-Unsubscribe: <http://lists.linuxcontainers.org/options/lxc-devel>,
 <mailto:lxc-devel-request-cunTk1MwBs9qMoObBWhMNEqPaTDuhLve2LY78lusg7I@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxcontainers.org/pipermail/lxc-devel/>
List-Post: <mailto:lxc-devel-cunTk1MwBs9qMoObBWhMNEqPaTDuhLve2LY78lusg7I@public.gmane.org>
List-Help: <mailto:lxc-devel-request-cunTk1MwBs9qMoObBWhMNEqPaTDuhLve2LY78lusg7I@public.gmane.org?subject=help>
List-Subscribe: <http://lists.linuxcontainers.org/listinfo/lxc-devel>,
 <mailto:lxc-devel-request-cunTk1MwBs9qMoObBWhMNEqPaTDuhLve2LY78lusg7I@public.gmane.org?subject=subscribe>
Errors-To: lxc-devel-bounces-cunTk1MwBs9qMoObBWhMNEqPaTDuhLve2LY78lusg7I@public.gmane.org
Sender: "lxc-devel" <lxc-devel-bounces-cunTk1MwBs9qMoObBWhMNEqPaTDuhLve2LY78lusg7I@public.gmane.org>
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lxc-devel-cunTk1MwBs9qMoObBWhMNEqPaTDuhLve2LY78lusg7I@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org
List-Id: linux-api@vger.kernel.org

T24gV2VkLCBEZWMgMDIsIDIwMTUgYXQgMTE6NTg6MzlBTSAtMDUwMCwgVGVqdW4gSGVvIHdyb3Rl
Ogo+IE9uIFdlZCwgRGVjIDAyLCAyMDE1IGF0IDEwOjU2OjM3QU0gLTA2MDAsIFNlcmdlIEUuIEhh
bGx5biB3cm90ZToKPiA+IENhbiBpdCBiZSBmbHVzaGVkIHdoZW4gd2Uga25vdyB0aGF0IHRoZSBj
Z3JvdXAgaXMgYmVpbmcgcGlubmVkIGJ5Cj4gPiBhIGNzc19zZXQ/ICAoVGhlcmUncyBlaXRoZXIg
YSB0YXNrIG9yIGEgY2dyb3VwX25hbWVzcGFjZSBwaW5uaW5nIGl0Cj4gPiBvciB3ZSB3b3VsZG4n
dCBnZXQgaGVyZSkKPiAKPiBZZWFwLCBpdCBjYW4gYmUgZmx1c2hlZC4gIFRoZXJlJ3Mgbm8gcmVm
IGNvbWluZyBvdXQgb2YgY2dyb3VwIHRvIHRoZQo+IHZmcyBvYmplY3RzLgoKT2ssIHRoYW5rcy4g
IFN0aWxsIHNlZW1zIHRvIG1lIHRvIGJlIG1vcmUgd29yayB0byBhY3R1YWxseSB3YWxrIHRoZQpw
YXRoIG91cnNlbHZlcywgYnV0IEknbGwgZ28gdGhhdCByb3V0ZSBhbmQgc2VlIHdoYXQgaXQgbG9v
a3MgbGlrZSA6KQoKdGhhbmtzCi1zZXJnZQpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fXwpseGMtZGV2ZWwgbWFpbGluZyBsaXN0Cmx4Yy1kZXZlbEBsaXN0cy5s
aW51eGNvbnRhaW5lcnMub3JnCmh0dHA6Ly9saXN0cy5saW51eGNvbnRhaW5lcnMub3JnL2xpc3Rp
bmZvL2x4Yy1kZXZlbAo=
