From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] x86: ipc: fix x32 version of shmid64_ds and
	msqid64_ds
Date: Fri, 20 Apr 2018 16:38:29 +0200
Message-ID: <CAK8P3a0nL4B+t6BMRhr36RrZ_jDgwnY1BviNPD+cFzsUGeppmA@mail.gmail.com>
References: <CAK8P3a3qAoR1afmTTK1CAp1L81dzwtBL+SKj=QMqD=dBr_8oRQ@mail.gmail.com>
 <20180420130346.3178914-1-arnd@arndb.de>
 <CAH8yC8mnfNnG86kgjnfwiZJ0=qN+w=5PVcLcxddaJdDtYbSanA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <y2038-bounces@lists.linaro.org>
In-Reply-To: <CAH8yC8mnfNnG86kgjnfwiZJ0=qN+w=5PVcLcxddaJdDtYbSanA@mail.gmail.com>
List-Unsubscribe: <https://lists.linaro.org/mailman/options/y2038>,
 <mailto:y2038-request@lists.linaro.org?subject=unsubscribe>
List-Archive: <http://lists.linaro.org/pipermail/y2038/>
List-Post: <mailto:y2038@lists.linaro.org>
List-Help: <mailto:y2038-request@lists.linaro.org?subject=help>
List-Subscribe: <https://lists.linaro.org/mailman/listinfo/y2038>,
 <mailto:y2038-request@lists.linaro.org?subject=subscribe>
Errors-To: y2038-bounces@lists.linaro.org
Sender: "Y2038" <y2038-bounces@lists.linaro.org>
To: Jeffrey Walton <noloader@gmail.com>
Cc: "open list:RALINK MIPS ARCHITECTURE" <linux-mips@linux-mips.org>, Adam Borowski <kilobyte@angband.pl>, James Hogan <jhogan@kernel.org>, Will Deacon <will.deacon@arm.com>, Albert ARIBAUD <albert.aribaud@3adev.fr>, Deepa Dinamani <deepa.kernel@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>, sparclinux <sparclinux@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, linux-s390 <linux-s390@vger.kernel.org>, y2038 Mailman List <y2038@lists.linaro.org>, the arch/x86 maintainers <x86@kernel.org>, Ingo Molnar <mingo@redhat.com>, tg@mirbsd.de, Catalin Marinas <catalin.marinas@arm.com>, Ben Hutchings <ben@decadent.org.uk>, "H . J . Lu" <hjl.tools@gmail.com>, Daniel Schepler <dschepler@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, Thomas Gleixner <tglx@linutronix.de>, GNU C Library <libc-alpha@sourceware.org>, Linux
List-Id: linux-api@vger.kernel.org

T24gRnJpLCBBcHIgMjAsIDIwMTggYXQgMzo1MyBQTSwgSmVmZnJleSBXYWx0b24gPG5vbG9hZGVy
QGdtYWlsLmNvbT4gd3JvdGU6Cj4+ICsjaWYgIWRlZmluZWQoX194ODZfNjRfXykgfHwgIWRlZmlu
ZWQoX19pbHAzMl9fKQo+PiAgI2luY2x1ZGUgPGFzbS1nZW5lcmljL21zZ2J1Zi5oPgo+PiArI2Vs
c2UKPgo+IEkgdW5kZXJzdGFuZCB0aGVyZSdzIHNvbWUgcHJvZ3Jlc3MgaGF2aW5nIENsYW5nIGNv
bXBpbGUgdGhlIGtlcm5lbC4KPiBDbGFuZyB0cmVhdHMgX19JTFAzMl9fIGFuZCBmcmllbmRzIGRp
ZmZlcmVudGx5IHRoYW4gR0NDLiBJIGJlbGlldmUKPiBJTFAzMiBzaG93cyB1cCBqdXN0IGFib3V0
IGV2ZXJ5d2hlcmUgdGhlcmUgYXJlIDMyLWJpdCBpbnRzLCBsb25ncyBhbmQKPiBwb2ludGVycy4g
WW91IG1pZ2h0IGZpbmQgaXQgb24gQWFyY2g2NCBvciB5b3UgbWlnaHQgZmluZCBpdCBvbiBNSVBT
NjQKPiB3aGVuIHVzaW5nIENsYW5nLgo+Cj4gSSB0aGluayB0aGF0IG1lYW5zIHRoaXMgbWF5IGJl
IGEgbGl0dGxlIHN1c3BpY2lvdXM6Cj4KPiAgICAgPiArI2lmICFkZWZpbmVkKF9feDg2XzY0X18p
IHx8ICFkZWZpbmVkKF9faWxwMzJfXykKPgo+IEkga2luZCBvZiBmZWx0IExMVk0gd2FzIHdhbmRl
cmluZyBhd2F5IGZyb20gdGhlIHgzMiBBQkksIGJ1dCB0aGUgTExWTQo+IGRldnMgaW5zaXN0ZWQg
dGhleSB3ZXJlIHdpdGhpbiB0aGVpciBwdXJ2aWV3LiBBbHNvIHNlZQo+IGh0dHBzOi8vbGlzdHMu
bGx2bS5vcmcvcGlwZXJtYWlsL2NmZS1kZXYvMjAxNS1EZWNlbWJlci8wNDYzMDAuaHRtbC4KPgo+
IFNvcnJ5IGFib3V0IHRoZSB0b3AtcG9zdC4gSSBqdXN0IHdhbnRlZCB0byBwaWNrIG91dCB0aGF0
IG9uZSBwaWVjZS4KCkl0IHNlZW1zIEkgbWFkZSBhIHR5cG8gYW5kIGl0IG5lZWRzIHRvIGJlIF9f
SUxQMzJfXyByYXRoZXIgdGhhbgpfX2lscDMyX18gKGNvcnJlY3RlZCB0aGF0IGxvY2FsbHksIHdp
bGwgcmVzZW5kIG9uY2Ugd2UgaGF2ZSByZXNvbHZlZAp0aGlzKS4KCkFzaWRlIGZyb20gdGhhdCwg
dGhlICNpZiBjaGVjayBzZWVtcyB0byBiZSBjb3JyZWN0IHRvIG1lOiB0aGlzCmlzIGFuIHg4Ni1z
cGVjaWZpYyBoZWFkZXIsIHNvIGl0IHdvbid0IGV2ZXIgYmUgc2VlbiBvbiBvdGhlcgphcmNoaXRl
Y3R1cmVzLiBPbiB4ODYtMzIsIF9feDg2XzY0X18gaXNuJ3Qgc2V0LCBzbyB3ZSBkb24ndCBjYXJl
CmFib3V0IHdoZXRoZXIgX19pbHAzMl9fIGlzIHNldCBvciBub3QsIGFuZCBvbiB4ODYtNjQgKGxw
NjQpLApfX2lscDMyX18gaXMgbmV2ZXIgc2V0LCBzbyB3ZSBzdGlsbCBnZXQgdGhlIGFzbS1nZW5l
cmljIGhlYWRlci4KCiAgICAgIEFybmQKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX18KWTIwMzggbWFpbGluZyBsaXN0ClkyMDM4QGxpc3RzLmxpbmFyby5vcmcK
aHR0cHM6Ly9saXN0cy5saW5hcm8ub3JnL21haWxtYW4vbGlzdGluZm8veTIwMzgK
