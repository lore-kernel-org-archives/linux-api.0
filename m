From: "H.J. Lu" <hjl.tools@gmail.com>
Subject: Re: [PATCH] x86: ipc: fix x32 version of shmid64_ds and
	msqid64_ds
Date: Sun, 22 Apr 2018 05:38:45 -0700
Message-ID: <CAMe9rOrTzgDmCF+A7nYdGR6BHZBuK5SMnJxeRxBFQW00VmdXvg@mail.gmail.com>
References: <CAK8P3a3qAoR1afmTTK1CAp1L81dzwtBL+SKj=QMqD=dBr_8oRQ@mail.gmail.com>
 <20180420130346.3178914-1-arnd@arndb.de>
 <CAH8yC8mnfNnG86kgjnfwiZJ0=qN+w=5PVcLcxddaJdDtYbSanA@mail.gmail.com>
 <CAK8P3a0nL4B+t6BMRhr36RrZ_jDgwnY1BviNPD+cFzsUGeppmA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <y2038-bounces@lists.linaro.org>
In-Reply-To: <CAK8P3a0nL4B+t6BMRhr36RrZ_jDgwnY1BviNPD+cFzsUGeppmA@mail.gmail.com>
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
Cc: "open list:RALINK MIPS ARCHITECTURE" <linux-mips@linux-mips.org>, James Hogan <jhogan@kernel.org>, Will Deacon <will.deacon@arm.com>, Albert ARIBAUD <albert.aribaud@3adev.fr>, Deepa Dinamani <deepa.kernel@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>, sparclinux <sparclinux@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, linux-s390 <linux-s390@vger.kernel.org>, y2038 Mailman List <y2038@lists.linaro.org>, the arch/x86 maintainers <x86@kernel.org>, Ingo Molnar <mingo@redhat.com>, Thorsten Glaser <tg@mirbsd.de>, Catalin Marinas <catalin.marinas@arm.com>, Ben Hutchings <ben@decadent.org.uk>, Adam Borowski <kilobyte@angband.pl>, Daniel Schepler <dschepler@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, Thomas Gleixner <tglx@linutronix.de>, Jeffrey Walton <noloader@gmail.com>, GNU C Library <libc-alpha@source>
List-Id: linux-api@vger.kernel.org

T24gRnJpLCBBcHIgMjAsIDIwMTggYXQgNzozOCBBTSwgQXJuZCBCZXJnbWFubiA8YXJuZEBhcm5k
Yi5kZT4gd3JvdGU6Cj4gT24gRnJpLCBBcHIgMjAsIDIwMTggYXQgMzo1MyBQTSwgSmVmZnJleSBX
YWx0b24gPG5vbG9hZGVyQGdtYWlsLmNvbT4gd3JvdGU6Cj4+PiArI2lmICFkZWZpbmVkKF9feDg2
XzY0X18pIHx8ICFkZWZpbmVkKF9faWxwMzJfXykKPj4+ICAjaW5jbHVkZSA8YXNtLWdlbmVyaWMv
bXNnYnVmLmg+Cj4+PiArI2Vsc2UKPj4KPj4gSSB1bmRlcnN0YW5kIHRoZXJlJ3Mgc29tZSBwcm9n
cmVzcyBoYXZpbmcgQ2xhbmcgY29tcGlsZSB0aGUga2VybmVsLgo+PiBDbGFuZyB0cmVhdHMgX19J
TFAzMl9fIGFuZCBmcmllbmRzIGRpZmZlcmVudGx5IHRoYW4gR0NDLiBJIGJlbGlldmUKPj4gSUxQ
MzIgc2hvd3MgdXAganVzdCBhYm91dCBldmVyeXdoZXJlIHRoZXJlIGFyZSAzMi1iaXQgaW50cywg
bG9uZ3MgYW5kCj4+IHBvaW50ZXJzLiBZb3UgbWlnaHQgZmluZCBpdCBvbiBBYXJjaDY0IG9yIHlv
dSBtaWdodCBmaW5kIGl0IG9uIE1JUFM2NAo+PiB3aGVuIHVzaW5nIENsYW5nLgo+Pgo+PiBJIHRo
aW5rIHRoYXQgbWVhbnMgdGhpcyBtYXkgYmUgYSBsaXR0bGUgc3VzcGljaW91czoKPj4KPj4gICAg
ID4gKyNpZiAhZGVmaW5lZChfX3g4Nl82NF9fKSB8fCAhZGVmaW5lZChfX2lscDMyX18pCj4+Cj4+
IEkga2luZCBvZiBmZWx0IExMVk0gd2FzIHdhbmRlcmluZyBhd2F5IGZyb20gdGhlIHgzMiBBQkks
IGJ1dCB0aGUgTExWTQo+PiBkZXZzIGluc2lzdGVkIHRoZXkgd2VyZSB3aXRoaW4gdGhlaXIgcHVy
dmlldy4gQWxzbyBzZWUKPj4gaHR0cHM6Ly9saXN0cy5sbHZtLm9yZy9waXBlcm1haWwvY2ZlLWRl
di8yMDE1LURlY2VtYmVyLzA0NjMwMC5odG1sLgo+Pgo+PiBTb3JyeSBhYm91dCB0aGUgdG9wLXBv
c3QuIEkganVzdCB3YW50ZWQgdG8gcGljayBvdXQgdGhhdCBvbmUgcGllY2UuCj4KPiBJdCBzZWVt
cyBJIG1hZGUgYSB0eXBvIGFuZCBpdCBuZWVkcyB0byBiZSBfX0lMUDMyX18gcmF0aGVyIHRoYW4K
PiBfX2lscDMyX18gKGNvcnJlY3RlZCB0aGF0IGxvY2FsbHksIHdpbGwgcmVzZW5kIG9uY2Ugd2Ug
aGF2ZSByZXNvbHZlZAo+IHRoaXMpLgo+Cj4gQXNpZGUgZnJvbSB0aGF0LCB0aGUgI2lmIGNoZWNr
IHNlZW1zIHRvIGJlIGNvcnJlY3QgdG8gbWU6IHRoaXMKPiBpcyBhbiB4ODYtc3BlY2lmaWMgaGVh
ZGVyLCBzbyBpdCB3b24ndCBldmVyIGJlIHNlZW4gb24gb3RoZXIKPiBhcmNoaXRlY3R1cmVzLiBP
biB4ODYtMzIsIF9feDg2XzY0X18gaXNuJ3Qgc2V0LCBzbyB3ZSBkb24ndCBjYXJlCj4gYWJvdXQg
d2hldGhlciBfX2lscDMyX18gaXMgc2V0IG9yIG5vdCwgYW5kIG9uIHg4Ni02NCAobHA2NCksCj4g
X19pbHAzMl9fIGlzIG5ldmVyIHNldCwgc28gd2Ugc3RpbGwgZ2V0IHRoZSBhc20tZ2VuZXJpYyBo
ZWFkZXIuCj4KCkdsaWJjIGhhcyBjb3JyZWN0IGhlYWRlciBmaWxlcyBmb3Igc3lzdGVtIGNhbGxz
LiAgSSBoYXZlIGEgdmVyeSBvbGQKcHJvZ3JhbSB0byBjaGVjayBpZiBMaW51eCBrZXJuZWwgaGVh
ZGVyIGZpbGVzIGFyZSBjb3JyZWN0IGZvciB1c2VyCnNwYWNlOgoKaHR0cHM6Ly9naXRodWIuY29t
L2hqbC10b29scy9saW51eC1oZWFkZXIKCkl0IG5lZWRzIHVwZGF0ZSB0byBjaGVjayB1YXBpLgoK
LS0gCkguSi4KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18K
WTIwMzggbWFpbGluZyBsaXN0ClkyMDM4QGxpc3RzLmxpbmFyby5vcmcKaHR0cHM6Ly9saXN0cy5s
aW5hcm8ub3JnL21haWxtYW4vbGlzdGluZm8veTIwMzgK
