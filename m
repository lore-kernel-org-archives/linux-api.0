From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC] UAPI: Check headers by compiling all together as C++
Date: Thu, 06 Sep 2018 09:12:58 +0200
Message-ID: <48b8af08170fb896c12cc4e3eae7501b4fa4181d.camel@opteya.com>
References: <153616286704.23468.584491117180383924.stgit@warthog.procyon.org.uk>
 <20180905165552.GB25206@kroah.com>
 <a1efae8d26cc5b73b180e9521d6b62590c55aa86.camel@opteya.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <a1efae8d26cc5b73b180e9521d6b62590c55aa86.camel-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
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

TGUgbWVyY3JlZGkgMDUgc2VwdGVtYnJlIDIwMTggw6AgMTk6MzMgKzAyMDAsIFlhbm4gRHJvbmVh
dWQgYSDDqWNyaXQgOgo+IExlIG1lcmNyZWRpIDA1IHNlcHRlbWJyZSAyMDE4IMOgIDE4OjU1ICsw
MjAwLCBHcmVnIEtIIGEgw6ljcml0IDoKPiA+IE9uIFdlZCwgU2VwIDA1LCAyMDE4IGF0IDA0OjU0
OjI3UE0gKzAxMDAsIERhdmlkIEhvd2VsbHMgd3JvdGU6Cj4gPiA+IAo+ID4gPiBIZXJlJ3MgYSBz
ZXQgb2YgcGF0Y2hlcyB0aGF0IGluc2VydHMgYSBzdGVwIGludG8gdGhlIGJ1aWxkCj4gPiA+IHBy
b2Nlc3MgdG8gbWFrZQo+ID4gPiBzdXJlIHRoYXQgdGhlIFVBUEkgaGVhZGVycyBjYW4gYWxsIGJl
IGJ1aWx0IHRvZ2V0aGVyIHdpdGggQysrIChpZgo+ID4gPiB0aGUKPiA+ID4gY29tcGlsZXIgYmVp
bmcgdXNlZCBzdXBwb3J0cyBDKyspLiAgQWxsIGJ1dCB0aGUgZmluYWwgcGF0Y2gKPiA+ID4gcGVy
Zm9ybSBmaXh1cHMsCj4gPiA+IGluY2x1ZGluZzoKPiA+IAo+ID4gV2FpdCwgd2h5IGRvIHdlIGNh
cmU/ICBXaGF0IGhhcyByZWNlbnRseSBjaGFuZ2VkIHRvIHN0YXJ0IHRvCj4gPiBkaXJlY3RseQo+
ID4gaW1wb3J0IGtlcm5lbCB1YXBpIGZpbGVzIGludG8gQysrIGNvZGU/Cj4gPiAKPiA+IEFuZCBp
ZiB1c2Vyc3BhY2Ugd2FudHMgdG8gZG8gdGhpcywgY2FuJ3QgdGhleSBkbyB0aGUgQyBuYW1lc3Bh
Y2UKPiA+IHRyaWNrCj4gPiB0aGVtc2VsdmVzIHdoZW4gdGhleSBkbyB0aGUgaW1wb3J0PyAgVGhh
dCBtdXN0IGJlIGhvdyB0aGV5IGFyZQo+ID4gZG9pbmcgaXQKPiA+IHRvZGF5LCByaWdodD8KPiA+
IAo+IAo+IFRoZXkgY2FuJ3QuCj4gCj4gCj4gQWRkaW5nIGV4dGVybiAiQyIgeyB9IGRvZXNuJ3Qg
bWFnaWNhbGx5IG1ha2UgImNsYXNzIiBhIG5vbiBrZXl3b3JkLgo+IEV2ZW4gaWYgaXQgd2FzIHRo
ZSBjYXNlLCB3cml0aW5nIEMrKyBjb2RlIHVzaW5nIHdoYXRldmVyLT5jbGFzcyB3b3VsZAo+IHBy
b2JhYmx5IGJyb2tlIGJlY2F1c2UgY2xhc3MgaXMgYSBrZXl3b3JkIGluIEMrKy4KPiAKCkZvciB0
aGUgcmVjb3JkLCBsaWJYMTEgaGFzIHRvIGhhbmRsZSB0aGUga2luayBwZiBpc3N1ZSB3aXRoIEMr
KwprZXl3b3JkOgoKCmh0dHBzOi8vZ2l0bGFiLmZyZWVkZXNrdG9wLm9yZy94b3JnL2xpYi9saWJ4
MTEvYmxvYi83MzNmNjRiZmViMzExYzFkMDQwYjJmNzUxYmZkZWY5YzlkMGY4OWVmL2luY2x1ZGUv
WDExL1hsaWIuaCNMMjI3Cgp0eXBlZGVmIHN0cnVjdCB7CglYRXh0RGF0YSAqZXh0X2RhdGE7CS8q
IGhvb2sgZm9yIGV4dGVuc2lvbiB0byBoYW5nIGRhdGEgKi8KCVZpc3VhbElEIHZpc3VhbGlkOwkv
KiB2aXN1YWwgaWQgb2YgdGhpcyB2aXN1YWwgKi8KI2lmIGRlZmluZWQoX19jcGx1c3BsdXMpIHx8
IGRlZmluZWQoY19wbHVzcGx1cykKCWludCBjX2NsYXNzOwkJLyogQysrIGNsYXNzIG9mIHNjcmVl
biAobW9ub2Nocm9tZSwgZXRjLikgKi8KI2Vsc2UKCWludCBjbGFzczsJCS8qIGNsYXNzIG9mIHNj
cmVlbiAobW9ub2Nocm9tZSwgZXRjLikgKi8KI2VuZGlmCgl1bnNpZ25lZCBsb25nIHJlZF9tYXNr
LCBncmVlbl9tYXNrLCBibHVlX21hc2s7CS8qIG1hc2sgdmFsdWVzICovCglpbnQgYml0c19wZXJf
cmdiOwkvKiBsb2cgYmFzZSAyIG9mIGRpc3RpbmN0IGNvbG9yIHZhbHVlcyAqLwoJaW50IG1hcF9l
bnRyaWVzOwkvKiBjb2xvciBtYXAgZW50cmllcyAqLwp9IFZpc3VhbDsKCgpSZWdhcmRzLgoKLS0g
Cllhbm4gRHJvbmVhdWQKT1BURVlBCgoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX18KTGludXgtbnZkaW1tIG1haWxpbmcgbGlzdApMaW51eC1udmRpbW1AbGlz
dHMuMDEub3JnCmh0dHBzOi8vbGlzdHMuMDEub3JnL21haWxtYW4vbGlzdGluZm8vbGludXgtbnZk
aW1tCg==
