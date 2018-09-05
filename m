From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC] UAPI: Check headers by compiling all together as C++
Date: Wed, 05 Sep 2018 19:33:38 +0200
Message-ID: <a1efae8d26cc5b73b180e9521d6b62590c55aa86.camel@opteya.com>
References: <153616286704.23468.584491117180383924.stgit@warthog.procyon.org.uk>
 <20180905165552.GB25206@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20180905165552.GB25206-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: moderated for non-subscribers <alsa-devel-K7yf7f+aM1XWsZ/bQMPhNw@public.gmane.org>, "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, Jason Wang <jasowang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mat Martineau <mathew.j.martineau-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Masahiro Yamada <yamada.masahiro-uWyLwvC0a2jby3iVrkZq2A@public.gmane.org>, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, codalist-/uMB558Y47wP4a1z8dhFYw@public.gmane.org, coda-ETDLCGt7PQU3uPMLIKxrzw@public.gmane.org, coreteam-Cap9r6Oaw4JrovVCs/uTlw@public.gmane.org, Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kbuild-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-msm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Coly Li <colyli-l3A5Bk7waGM@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jaroslav Kysela <perex-/Fr2/VpizcU@public.gmane.org>, Jan Harkes <jaharkes-ETDLCGt7PQU3uPMLIKxrzw@public.gmane.org>, Michal Marek <michal.lkml-yyZNWGI4GtDR7s880joybQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Takashi Iwai <tiwai-IBi9RG/b67k@public.gmane.org>, linux-kernel@
List-Id: linux-api@vger.kernel.org

SGksCgpMZSBtZXJjcmVkaSAwNSBzZXB0ZW1icmUgMjAxOCDDoCAxODo1NSArMDIwMCwgR3JlZyBL
SCBhIMOpY3JpdCA6Cj4gT24gV2VkLCBTZXAgMDUsIDIwMTggYXQgMDQ6NTQ6MjdQTSArMDEwMCwg
RGF2aWQgSG93ZWxscyB3cm90ZToKPiA+IAo+ID4gSGVyZSdzIGEgc2V0IG9mIHBhdGNoZXMgdGhh
dCBpbnNlcnRzIGEgc3RlcCBpbnRvIHRoZSBidWlsZCBwcm9jZXNzIHRvIG1ha2UKPiA+IHN1cmUg
dGhhdCB0aGUgVUFQSSBoZWFkZXJzIGNhbiBhbGwgYmUgYnVpbHQgdG9nZXRoZXIgd2l0aCBDKysg
KGlmIHRoZQo+ID4gY29tcGlsZXIgYmVpbmcgdXNlZCBzdXBwb3J0cyBDKyspLiAgQWxsIGJ1dCB0
aGUgZmluYWwgcGF0Y2ggcGVyZm9ybSBmaXh1cHMsCj4gPiBpbmNsdWRpbmc6Cj4gCj4gV2FpdCwg
d2h5IGRvIHdlIGNhcmU/ICBXaGF0IGhhcyByZWNlbnRseSBjaGFuZ2VkIHRvIHN0YXJ0IHRvIGRp
cmVjdGx5Cj4gaW1wb3J0IGtlcm5lbCB1YXBpIGZpbGVzIGludG8gQysrIGNvZGU/Cj4gCj4gQW5k
IGlmIHVzZXJzcGFjZSB3YW50cyB0byBkbyB0aGlzLCBjYW4ndCB0aGV5IGRvIHRoZSBDIG5hbWVz
cGFjZSB0cmljawo+IHRoZW1zZWx2ZXMgd2hlbiB0aGV5IGRvIHRoZSBpbXBvcnQ/ICBUaGF0IG11
c3QgYmUgaG93IHRoZXkgYXJlIGRvaW5nIGl0Cj4gdG9kYXksIHJpZ2h0Pwo+IAoKVGhleSBjYW4n
dC4KCgpBZGRpbmcgZXh0ZXJuICJDIiB7IH0gZG9lc24ndCBtYWdpY2FsbHkgbWFrZSAiY2xhc3Mi
IGEgbm9uIGtleXdvcmQuCkV2ZW4gaWYgaXQgd2FzIHRoZSBjYXNlLCB3cml0aW5nIEMrKyBjb2Rl
IHVzaW5nIHdoYXRldmVyLT5jbGFzcyB3b3VsZApwcm9iYWJseSBicm9rZSBiZWNhdXNlIGNsYXNz
IGlzIGEga2V5d29yZCBpbiBDKysuCgotLSAKWWFubiBEcm9uZWF1ZApPUFRFWUEKCgpfX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpMaW51eC1udmRpbW0gbWFp
bGluZyBsaXN0CkxpbnV4LW52ZGltbUBsaXN0cy4wMS5vcmcKaHR0cHM6Ly9saXN0cy4wMS5vcmcv
bWFpbG1hbi9saXN0aW5mby9saW51eC1udmRpbW0K
