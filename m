From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 0/9] posix_clocks: Prepare syscalls for 64 bit
	time_t conversion
Date: Fri, 17 Nov 2017 11:46:37 +0100
Message-ID: <CAK8P3a1J0C5A+SzVWDz52ZkawG1HZYj2cR6oc=DL=QrXgYaiHg@mail.gmail.com>
References: <20171110224259.15930-1-deepa.kernel@gmail.com>
 <CAK8P3a2uD=xV5GKtL+nhVoPckb6uoXztEvXK-iP_OYbct8QvJA@mail.gmail.com>
 <CABeXuvpy1jbqjeUFHHX-MrJXQLA2QNYbAa6OX7qOpPp4q-mQYQ@mail.gmail.com>
 <alpine.DEB.2.20.1711160958430.2191@nanos>
 <CAK8P3a0wxs59T1zW4ahbJXeW6QjStm0mbCFoL_RQexAa6dzh_w@mail.gmail.com>
 <alpine.DEB.2.20.1711170954000.1709@nanos>
 <CAK8P3a3fcVKTwoqN0CxYchzcFqUZPBeko=oYsA9eNxu4bQoYyw@mail.gmail.com>
 <alpine.DEB.2.20.1711171049180.1709@nanos>
 <CAK8P3a10N42rBO8XBrZWYOCwVB8jayjgZu2oa8FSpHTzszQacQ@mail.gmail.com>
 <alpine.DEB.2.20.1711171138510.7700@nanos>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <y2038-bounces@lists.linaro.org>
In-Reply-To: <alpine.DEB.2.20.1711171138510.7700@nanos>
List-Unsubscribe: <https://lists.linaro.org/mailman/options/y2038>,
 <mailto:y2038-request@lists.linaro.org?subject=unsubscribe>
List-Archive: <http://lists.linaro.org/pipermail/y2038/>
List-Post: <mailto:y2038@lists.linaro.org>
List-Help: <mailto:y2038-request@lists.linaro.org?subject=help>
List-Subscribe: <https://lists.linaro.org/mailman/listinfo/y2038>,
 <mailto:y2038-request@lists.linaro.org?subject=subscribe>
Errors-To: y2038-bounces@lists.linaro.org
Sender: "Y2038" <y2038-bounces@lists.linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Mark Rutland <mark.rutland@arm.com>, "open list:RALINK MIPS ARCHITECTURE" <linux-mips@linux-mips.org>, Peter Zijlstra <peterz@infradead.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Stefan Haberland <sth@linux.vnet.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Paul Mackerras <paulus@samba.org>, Deepa Dinamani <deepa.kernel@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>, sparclinux <sparclinux@vger.kernel.org>, devel@driverdev.osuosl.org, linux-s390 <linux-s390@vger.kernel.org>, y2038 Mailman List <y2038@lists.linaro.org>, Michael Ellerman <mpe@ellerman.id.au>, Helge Deller <deller@gmx.de>, the arch/x86 maintainers <x86@kernel.org>, sebott@linux.vnet.ibm.com, "James E.J. Bottomley" <jejb@parisc-linux.org>, Will Deacon <will.deacon@arm.com>, Christian Borntraeger <borntraeger@de.ibm.com>, Ingo Molnar <mingo@redhat.com>, oprofile-list@lists.sf.net, Catali
List-Id: linux-api@vger.kernel.org

T24gRnJpLCBOb3YgMTcsIDIwMTcgYXQgMTE6NDAgQU0sIFRob21hcyBHbGVpeG5lciA8dGdseEBs
aW51dHJvbml4LmRlPiB3cm90ZToKPiBPbiBGcmksIDE3IE5vdiAyMDE3LCBBcm5kIEJlcmdtYW5u
IHdyb3RlOgo+PiBPbiBGcmksIE5vdiAxNywgMjAxNyBhdCAxMDo1NCBBTSwgVGhvbWFzIEdsZWl4
bmVyIDx0Z2x4QGxpbnV0cm9uaXguZGU+IHdyb3RlOgo+PiA+IE9uIEZyaSwgMTcgTm92IDIwMTcs
IEFybmQgQmVyZ21hbm4gd3JvdGU6Cj4+ID4+IE9uIEZyaSwgTm92IDE3LCAyMDE3IGF0IDk6NTgg
QU0sIFRob21hcyBHbGVpeG5lciA8dGdseEBsaW51dHJvbml4LmRlPiB3cm90ZToKPj4gPj4KPj4g
Pj4gTm8sIHN5c2NhbGwgdGhhdCBleGlzdGluZyAzMi1iaXQgdXNlciBzcGFjZSBlbnRlcnMgd291
bGQgYmUgaGFuZGxlZCBieQo+PiA+PiBjb21wYXRfc3lzX25hbm9zbGVlcCgpIG9uIGJvdGggMzIt
Yml0IGFuZCA2NC1iaXQga2VybmVscyBhdCB0aGF0Cj4+ID4+IHBvaW50LiBUaGUgaWRlYSBoZXJl
IGlzIHRvIG1ha2UgdGhlIGNvZGUgcGF0aCBtb3JlIHVuaWZvcm0gYmV0d2Vlbgo+PiA+PiAzMi1i
aXQgYW5kIDY0LWJpdCBrZXJuZWxzLgo+PiA+Cj4+ID4gU28gb24gYSAzMmJpdCBzeXN0ZW0gY29t
cGF0X3N5c19uYW5vc2xlZXAoKSB3b3VsZCBiZSB0aGUgbGVnYWN5Cj4+ID4gc3lzX25hbm9zbGVl
cCgpIHdpdGggdGhlIGV4aXN0aW5nIHN5c2NhbGwgbnVtYmVyLCBidXQgeW91IGRvbid0IHdhbnQg
dG8KPj4gPiBpbnRyb2R1Y2UgYSBuZXcgc3lzX25hbm9zbGVlcDY0KCkgZm9yIDMyYml0LiBUaGF0
IG1ha2VzIGEgbG90IG9mIHNlbnNlLgo+PiA+Cj4+ID4gU28gYmFjayB0byB5b3VyIG9yaWdpbmFs
IHF1ZXN0aW9uIHdoZXRoZXIgdG8gdXNlICNpZiAoTUFHSUMgbG9naWMpIG9yIGEKPj4gPiBzZXBh
cmF0ZSBjb25maWcgc3ltYm9sLiBQbGVhc2UgdXNlIHRoZSBsYXR0ZXIsIHRoZXNlIG1hZ2ljIGxv
Z2ljIGNvbnN0cnVjdHMKPj4gPiBhcmUgaGFyZGVyIHRvIHJlYWQgYW5kIHByb25lIHRvIGdldCB3
cm9uZyBhdCBzb21lIHBvaW50LiBIYXZpbmcgdGhlCj4+ID4gZGVjaXNpb24gbG9naWMgaW4gb25l
IHBsYWNlIGlzIGFsd2F5cyB0aGUgcmlnaHQgdGhpbmcgdG8gZG8uCj4+Cj4+IEhvdyBhYm91dCB0
aGlzOgo+Pgo+PiBjb25maWcgTEVHQUNZX1RJTUVfU1lTQ0FMTFMKPj4gICAgICAgZGVmX2Jvb2wg
NjRCSVQgfHwgITY0QklUX1RJTUUKPj4gICAgICAgaGVscAo+PiAgICAgICAgIFRoaXMgY29udHJv
bHMgdGhlIGNvbXBpbGF0aW9uIG9mIHRoZSBmb2xsb3dpbmcgc3lzdGVtIGNhbGxzOgo+PiB0aW1l
LCBzdGltZSwKPj4gICAgICAgICBnZXR0aW1lb2ZkYXksIHNldHRpbWVvZmRheSwgYWRqdGltZXgs
IG5hbm9zbGVlcCwgYWxhcm0sIGdldGl0aW1lciwKPj4gICAgICAgICBzZXRpdGltZXIsIHNlbGVj
dCwgdXRpbWUsIHV0aW1lcywgZnV0aW1lc2F0LCBhbmQKPj4ge29sZCxuZXd9e2wsZix9c3RhdHss
NjR9Lgo+PiAgICAgICAgIFRoZXNlIGFsbCBwYXNzIDMyLWJpdCB0aW1lX3QgYXJndW1lbnRzIG9u
IDMyLWJpdCBhcmNoaXRlY3R1cmVzIGFuZAo+PiAgICAgICAgIGFyZSByZXBsYWNlZCBieSBvdGhl
ciBpbnRlcmZhY2VzIChlLmcuIHBvc2l4IHRpbWVycyBhbmQgY2xvY2tzLCBzdGF0eCkuCj4+ICAg
ICAgICAgQyBsaWJyYXJpZXMgaW1wbGVtZW50aW5nIDY0LWJpdCB0aW1lX3QgaW4gMzItYml0IGFy
Y2hpdGVjdHVyZXMgaGF2ZSB0bwo+PiAgICAgICAgIGltcGxlbWVudCB0aGUgaGFuZGxlcyBieSB3
cmFwcGluZyBhcm91bmQgdGhlIG5ld2VyIGludGVyZmFjZXMuCj4KPiBzL2hhbmRsZXMvaGFuZGxp
bmcvID8/Pz8KCkkgbWVhbnQgImhhbmRsZXJzIi4KCj4+ICAgICAgICAgTmV3IGFyY2hpdGVjdHVy
ZXMgc2hvdWxkIG5vdCBleHBsaWNpdGx5IGRpc2FibGUgdGhpcy4KPgo+IE5ldyBhcmNoaXRlY3R1
cmVzIHNob3VsZCBuZXZlciBlbmFibGUgdGhpcywgcmlnaHQ/CgpSaWdodCwgSSBnb3QgYW4gZXh0
cmEgIm5vdCIuIEkgZ3Vlc3MgaWYgRGVlcGEgaW5jb3Jwb3JhdGVzIHRoZSBuZXcgb3B0aW9uLApz
aGUgY2FuIGFsc28gaW1wcm92ZSBteSBFbmdsaXNoIDstKQoKICAgICAgICAgQXJuZApfX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpZMjAzOCBtYWlsaW5nIGxp
c3QKWTIwMzhAbGlzdHMubGluYXJvLm9yZwpodHRwczovL2xpc3RzLmxpbmFyby5vcmcvbWFpbG1h
bi9saXN0aW5mby95MjAzOAo=
