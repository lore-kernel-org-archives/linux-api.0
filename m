From: Chen Gang <xili_gchen_5257@hotmail.com>
Subject: Re: [PATCH v3 03/17] arch: uapi: asm: mman.h: Let MADV_FREE have
 same value for all architectures
Date: Sun, 15 Nov 2015 22:23:44 +0800
Message-ID: <COL130-W41CC25BFF8E666EFDD317AB91F0@phx.gbl>
References: <1447302793-5376-1-git-send-email-minchan@kernel.org>
 <1447302793-5376-4-git-send-email-minchan@kernel.org>
 <20151112112753.GC22481@node.shutemov.name>
 <20151113061855.GD5235@bbox>,<564895F3.8090300@hotmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <564895F3.8090300@hotmail.com>
Sender: owner-linux-mm@kvack.org
To: Minchan Kim <minchan@kernel.org>, "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Andrew Morton <akpm@linux-foundation.org>, kernel mailing list <linux-kernel@vger.kernel.org>, Linux Memory <linux-mm@kvack.org>, Michael Kerrisk <mtk.manpages@gmail.com>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>, "riel@redhat.com" <riel@redhat.com>, Mel Gorman <mgorman@suse.de>, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, Jason Evans <je@fb.com>, Daniel Micay <danielmicay@gmail.com>, Shaohua Li <shli@kernel.org>, Michal Hocko <mhocko@suse.cz>, "yalin.wang2010@gmail.com" <yalin.wang2010@gmail.com>, "rth@twiddle.net" <rth@twiddle.net>, "ink@jurassic.park.msu.ru" <ink@jurassic.park.msu.ru>, "mattst88@gmail.com" <mattst88@gmail.com>, Ralf Baechle <ralf@linux-mips.org>, "jejb@parisc-linux.org" <jejb@parisc-linux.org>, "deller@gmx.de" <deller@gmx.de>, "chris@zankel.net" <chris@zankel.ne>
List-Id: linux-api@vger.kernel.org

T24gMTEvMTMvMTUgMTQ6MTgsIE1pbmNoYW4gS2ltIHdyb3RlOgo+IE9uIFRodSwgTm92IDEyLCAy
MDE1IGF0IDAxOjI3OjUzUE0gKzAyMDAsIEtpcmlsbCBBLiBTaHV0ZW1vdiB3cm90ZToKPj4gT24g
VGh1LCBOb3YgMTIsIDIwMTUgYXQgMDE6MzI6NTlQTSArMDkwMCwgTWluY2hhbiBLaW0gd3JvdGU6
Cj4+PiBGcm9tOiBDaGVuIEdhbmcgPGdhbmcuY2hlbi41aTVqQGdtYWlsLmNvbT4KPj4+Cj4+PiBG
b3IgdWFwaSwgbmVlZCB0cnkgdG8gbGV0IGFsbCBtYWNyb3MgaGF2ZSBzYW1lIHZhbHVlLCBhbmQg
TUFEVl9GUkVFIGlzCj4+PiBhZGRlZCBpbnRvIG1haW4gYnJhbmNoIHJlY2VudGx5LCBzbyBuZWVk
IHJlZGVmaW5lIE1BRFZfRlJFRSBmb3IgaXQuCj4+Pgo+Pj4gQXQgcHJlc2VudCwgJzgnIGNhbiBi
ZSBzaGFyZWQgd2l0aCBhbGwgYXJjaGl0ZWN0dXJlcywgc28gcmVkZWZpbmUgaXQgdG8KPj4+ICc4
Jy4KPj4KPj4gV2h5IG5vdCBmb2xkIHRoZSBwYXRjaCBpbnRvIHRocmUgcHJldmlvdXMgb25lPwo+
Cj4gQmVjYXVzZSBpdCB3YXMgYSBsaXR0bGUgYml0IGFyZ3VhYmxlIGF0IHRoYXQgdGltZSB3aGV0
aGVyIHdlIGNvdWxkIHVzZQo+IG51bWJlciA4IGZvciBhbGwgb2YgYXJjaGVzLiBJZiBzbywgc2lt
cGx5IEkgY2FuIGRyb3AgdGhpcyBwYXRjaCBvbmx5Lgo+CgpGb3IgbWUsIGlmIHRoaXMgcGF0Y2gg
YmxvY2tzIHlvdXIgYW5vdGhlciBwYXRjaGVzIGFwcGx5aW5nLCBJIGd1ZXNzLCB5b3UKY2FuIHNp
bXBseSBzZXBhcmF0ZSBpdCBmcm9tIHlvdXIgYW5vdGhlciBwYXRjaGVzLgoKQWZ0ZXIgeW91ciBh
bm90aGVyIHBhdGNoZXMgYXBwbGllZCwgeW91IGNhbiBjb25zaWRlciBhYm91dCB3aGV0aGVyIG5l
ZWQKdG8gc2VuZCB0aGlzIHBhdGNoIG9yIG5vdCwgYWdhaW4uCgpBbmQgdGhhbmsgeW91IGZvciB5
b3VyIHRyeWluZy4KCi0tCkNoZW4gR2FuZyAos8K41SkKCk9wZW4sIHNoYXJlLCBhbmQgYXR0aXR1
ZGUgbGlrZSBhaXIsIHdhdGVyLCBhbmQgbGlmZSB3aGljaCBHb2QgYmxlc3NlZAogCQkgCSAgIAkJ
ICA=

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
