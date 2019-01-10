From: Michael Cree <mcree@orcon.net.nz>
Subject: Re: [PATCH 00/15] arch: synchronize syscall tables in
 preparation for y2038
Date: Fri, 11 Jan 2019 12:14:31 +1300
Message-ID: <20190110231431.ho6mjhjkj4p47hww@tower>
References: <20190110162435.309262-1-arnd@arndb.de>
 <alpine.DEB.2.21.1901101808220.31458@digraph.polyomino.org.uk>
 <CAK8P3a2f4SCJXrm6HWO9UKY-akSW+ONNpOvQOtYbia_fRo9ciQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <y2038-bounces@lists.linaro.org>
Content-Disposition: inline
In-Reply-To: <CAK8P3a2f4SCJXrm6HWO9UKY-akSW+ONNpOvQOtYbia_fRo9ciQ@mail.gmail.com>
List-Unsubscribe: <https://lists.linaro.org/mailman/options/y2038>,
 <mailto:y2038-request@lists.linaro.org?subject=unsubscribe>
List-Archive: <http://lists.linaro.org/pipermail/y2038/>
List-Post: <mailto:y2038@lists.linaro.org>
List-Help: <mailto:y2038-request@lists.linaro.org?subject=help>
List-Subscribe: <https://lists.linaro.org/mailman/listinfo/y2038>,
 <mailto:y2038-request@lists.linaro.org?subject=subscribe>
Errors-To: y2038-bounces@lists.linaro.org
Sender: "Y2038" <y2038-bounces@lists.linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Rich Felker <dalias@libc.org>, linux-ia64@vger.kernel.org, Linux-sh list <linux-sh@vger.kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Dominik Brodowski <linux@dominikbrodowski.net>, linux-mips@vger.kernel.org, Max Filippov <jcmvbkbc@gmail.com>, Deepa Dinamani <deepa.kernel@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>, sparclinux <sparclinux@vger.kernel.org>, Joseph Myers <joseph@codesourcery.com>, linux-s390 <linux-s390@vger.kernel.org>, Davidlohr Bueso <dave@stgolabs.net>, y2038 Mailman List <y2038@lists.linaro.org>, Michael Ellerman <mpe@ellerman.id.au>, Helge Deller <deller@gmx.de>, the arch/x86 maintainers <x86@kernel.org>, Russell King - ARM Linux <linux@armlinux.org.uk>, Ingo Molnar <mingo@redhat.com>, Geert Uytterhoeven <geert@linux-m68k.org>, Firoz Khan <firoz.khan@linaro.org>, Matt Turner <mattst88@gmail.com>
List-Id: linux-api@vger.kernel.org

T24gVGh1LCBKYW4gMTAsIDIwMTkgYXQgMTE6NDI6MzJQTSArMDEwMCwgQXJuZCBCZXJnbWFubiB3
cm90ZToKPiBPbiBUaHUsIEphbiAxMCwgMjAxOSBhdCA3OjEwIFBNIEpvc2VwaCBNeWVycyA8am9z
ZXBoQGNvZGVzb3VyY2VyeS5jb20+IHdyb3RlOgo+ID4KPiA+IE9uIFRodSwgMTAgSmFuIDIwMTks
IEFybmQgQmVyZ21hbm4gd3JvdGU6Cj4gPgo+ID4gPiAtIEFkZCBzeXN0ZW0gY2FsbHMgdGhhdCBo
YXZlIG5vdCB5ZXQgYmVlbiBpbnRlZ3JhdGVkIGludG8gYWxsCj4gPiA+ICAgYXJjaGl0ZWN0dXJl
cyBidXQgdGhhdCB3ZSBkZWZpbml0ZWx5IHdhbnQgdGhlcmUuCj4gPgo+ID4gZ2xpYmMgaGFzIGEg
bm90ZSB0aGF0IGFscGhhIGxhY2tzIHN0YXRmczY0LCBhbnkgcGxhbnMgZm9yIHRoYXQ/Cj4gCj4g
R29vZCBjYXRjaCwgSSBtaXNzZWQgdGhhdCBiZWNhdXNlIGFsbCBvdGhlciA2NC1iaXQgYXJjaGl0
ZWN0dXJlcwo+IGhhdmUgYSBzdGF0ZnMoKSBjYWxsIHdpdGggNjQtYml0IGZpZWxkcy4gSSBzZWUg
dGhhdCBpdCBhbHNvIGhhcyBhbgo+IG9zZl9zdGF0ZnM2NCBzdHJ1Y3R1cmUgYW5kIHN5c3RlbSBj
YWxsIHdpdGggbG90cyBvZiBwYWRkaW5nIGFuZCBzb21lCj4gb2RkbHkgc2l6ZWQgZmllbGRzOiBm
X3R5cGUsIGZfZmxhZ3MgYW5kIGZfbmFtZW1heCBhcmUgb25seSAxNiBiaXRzCj4gd2lkZSwgdGhl
IHJlc3QgaXMgYWxsIDY0LWJpdC4KPiAKPiBBZGRpbmcgdGhlIHJlZ3VsYXIgc3RhdGZzNjQoKSBz
aG91bGQgYmUgZWFzeSBlbm91Z2gsIHdlIGp1c3QgbmVlZCB0bwo+IGRlY2lkZSB3aGljaCBsYXlv
dXQgdG8gdXNlOgo+IAo+IGEpIHVzZSB0aGUgY3VycmVudGx5IHVudXNlZCAnc3RydWN0IHN0YXRm
czY0JyBhcyBwcm92aWRlZCBieSB0aGUKPiAgICAgYWxwaGEgdWFwaSBoZWFkZXJzLCB3aGljaCBo
YXMgYSAzMi1iaXQgX19zdGF0ZnNfd29yZCBidXQKPiAgICAgNjQtYml0IGZfYmxvY2tzLCBmX2Jm
cmVlLCBmX2JhdmFpbCwgZl9maWxlcywgYW5kIGZfZmZyZWUuCj4gCj4gYikgY29weSBhc20tZ2Vu
ZXJpYy9zdGF0ZnMuaCB0byB0aGUgYWxwaGEgYXNtL3N0YXRmcy5oIGFuZAo+ICAgICBjaGFuZ2Ug
c3RhdGZzNjQgdG8gaGF2ZSB0aGUgcmVndWxhciBsYXlvdXQgdGhhdCB3ZSB1c2UKPiAgICAgb24g
YWxsIG90aGVyIDY0LWJpdCBhcmNoaXRlY3R1cmVzLCB1c2luZyBhbGwgNjQtYml0IGZpZWxkcy4K
PiAKPiBUaGUgb3RoZXIgb3BlbiBxdWVzdGlvbiBmb3IgYWxwaGEgKGFzIG1lbnRpb25lZCBpbiBv
bmUgb2YgdGhlCj4gcGF0Y2hlcyBJIHNlbnQpIHdvdWxkIGJlIHdoZXRoZXIgdG8gYWRkIGdldHtl
ZyxldSxnLHAscHAsdX1pZCgpCj4gd2l0aCB0aGUgcmVndWxhciBjYWxsaW5nIGNvbnZlbnRpb25z
LgoKSSB3b3VsZCBiZSBpbnRlcmVzdGVkIGluIHNlZWluZyB0aG9zZSBwcm92aWRlZCBvbiBBbHBo
YS4gIFRoZXJlIGFyZQphIGhhbmRmdWwgb2YgcHJvamVjdHMgY2hvb3NpbmcgdG8gc2lkZXN0ZXAg
Z2xpYmMgZm9yIHRoZXNlIHN5c2NhbGxzCmFuZCB0aGV5IGJyZWFrIG9uIEFscGhhLiAgU3VjaCBw
cm9qZWN0cyBhcmUgbmV2ZXIga2VlbiB0byBpbmNsdWRlCnNwZWNpYWwgYXNzZW1ibGVyIGNvZGUg
KGJlY2F1c2UgdGhlIGV4dGFudCBzeXNjYWxscyBvbiBBbHBoYSBhcmUgbm90CkMgQUJJIGNvbXBs
aWFudCkgdG8gc3VwcG9ydCBhIGxlZ2FjeSBhcmNoLgoKQ2hlZXJzCk1pY2hhZWwuCl9fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fClkyMDM4IG1haWxpbmcgbGlz
dApZMjAzOEBsaXN0cy5saW5hcm8ub3JnCmh0dHBzOi8vbGlzdHMubGluYXJvLm9yZy9tYWlsbWFu
L2xpc3RpbmZvL3kyMDM4Cg==
