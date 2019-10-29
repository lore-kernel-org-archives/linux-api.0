From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Subject: Re: [PATCH RFC] mm: add MAP_EXCLUSIVE to create exclusive user
 mappings
Date: Tue, 29 Oct 2019 17:27:43 +0000
Message-ID: <69c57f7fa9a1be145827673b37beff155a3adc3c.camel@intel.com>
References: <1572171452-7958-1-git-send-email-rppt@kernel.org>
         <1572171452-7958-2-git-send-email-rppt@kernel.org>
         <20191028123124.ogkk5ogjlamvwc2s@box> <20191028130018.GA7192@rapoport-lnx>
         <20191028131623.zwuwguhm4v4s5imh@box>
         <20191028135521.GB4097@hirez.programming.kicks-ass.net>
         <0a35765f7412937c1775daa05177b20113760aee.camel@intel.com>
         <20191028210052.GM4643@worktop.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191028210052.GM4643@worktop.programming.kicks-ass.net>
Content-Language: en-US
Content-ID: <4DA018406618604E969C1F0F7211E856@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "peterz@infradead.org" <peterz@infradead.org>
Cc: "adobriyan@gmail.com" <adobriyan@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "rppt@kernel.org" <rppt@kernel.org>, "rostedt@goodmis.org" <rostedt@goodmis.org>, "jejb@linux.ibm.com" <jejb@linux.ibm.com>, "tglx@linutronix.de" <tglx@linutronix.de>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>, "luto@kernel.org" <luto@kernel.org>, "kirill@shutemov.name" <kirill@shutemov.name>, "bp@alien8.de" <bp@alien8.de>, "rppt@linux.ibm.com" <rppt@linux.ibm.com>
List-Id: linux-api@vger.kernel.org

T24gTW9uLCAyMDE5LTEwLTI4IGF0IDIyOjAwICswMTAwLCBQZXRlciBaaWpsc3RyYSB3cm90ZToN
Cj4gT24gTW9uLCBPY3QgMjgsIDIwMTkgYXQgMDc6NTk6MjVQTSArMDAwMCwgRWRnZWNvbWJlLCBS
aWNrIFAgd3JvdGU6DQo+ID4gT24gTW9uLCAyMDE5LTEwLTI4IGF0IDE0OjU1ICswMTAwLCBQZXRl
ciBaaWpsc3RyYSB3cm90ZToNCj4gPiA+IE9uIE1vbiwgT2N0IDI4LCAyMDE5IGF0IDA0OjE2OjIz
UE0gKzAzMDAsIEtpcmlsbCBBLiBTaHV0ZW1vdiB3cm90ZToNCj4gPiA+IA0KPiA+ID4gPiBJIHRo
aW5rIGFjdGl2ZSB1c2Ugb2YgdGhpcyBmZWF0dXJlIHdpbGwgbGVhZCB0byBwZXJmb3JtYW5jZSBk
ZWdyYWRhdGlvbg0KPiA+ID4gPiBvZg0KPiA+ID4gPiB0aGUgc3lzdGVtIHdpdGggdGltZS4NCj4g
PiA+ID4gDQo+ID4gPiA+IFNldHRpbmcgYSBzaW5nbGUgNGsgcGFnZSBub24tcHJlc2VudCBpbiB0
aGUgZGlyZWN0IG1hcHBpbmcgd2lsbCByZXF1aXJlDQo+ID4gPiA+IHNwbGl0dGluZyAyTSBvciAx
RyBwYWdlIHdlIHVzdWFsbHkgbWFwIGRpcmVjdCBtYXBwaW5nIHdpdGguIEFuZCBpdCdzIG9uZQ0K
PiA+ID4gPiB3YXkgcm9hZC4gV2UgZG9uJ3QgaGF2ZSBhbnkgbWVjaGFuaXNtIHRvIG1hcCB0aGUg
bWVtb3J5IHdpdGggaHVnZSBwYWdlDQo+ID4gPiA+IGFnYWluIGFmdGVyIHRoZSBhcHBsaWNhdGlv
biBoYXMgZnJlZWQgdGhlIHBhZ2UuDQo+ID4gPiANCj4gPiA+IFJpZ2h0LCB3ZSByZWNlbnRseSBo
YWQgYSAnYnVnJyB3aGVyZSBmdHJhY2UgdHJpZ2dlcmVkIHNvbWV0aGluZyBsaWtlDQo+ID4gPiB0
aGlzIGFuZCBmYWNlYm9vayByYW4gaW50byBpdCBhcyBhIHBlcmZvcm1hbmNlIHJlZ3Jlc3Npb24u
IFNvIHllcywgdGhpcw0KPiA+ID4gaXMgYSByZWFsIGNvbmNlcm4uDQo+ID4gDQo+ID4gRG9uJ3Qg
ZS9jQlBGIGZpbHRlcnMgYWxzbyBicmVhayB0aGUgZGlyZWN0IG1hcCBkb3duIHRvIDRrIHBhZ2Vz
IHdoZW4gY2FsbGluZw0KPiA+IHNldF9tZW1vcnlfcm8oKSBvbiB0aGUgZmlsdGVyIGZvciA2NCBi
aXQgeDg2IGFuZCBhcm0/DQo+ID4gDQo+ID4gSSd2ZSBiZWVuIHdvbmRlcmluZyBpZiB0aGUgcGFn
ZSBhbGxvY2F0b3Igc2hvdWxkIG1ha2Ugc29tZSBlZmZvcnQgdG8gZmluZCBhDQo+ID4gYnJva2Vu
IGRvd24gcGFnZSBmb3IgYW55dGhpbmcgdGhhdCBjYW4gYmUga25vd24gd2lsbCBoYXZlIGRpcmVj
dCBtYXANCj4gPiBwZXJtaXNzaW9ucw0KPiA+IGNoYW5nZWQgKG9yIGlmIGl0IGFscmVhZHkgZ3Jv
dXBzIHRoZW0gc29tZWhvdykuIEJ1dCBhbHNvLCB3aHkgYW55IHBvdGVudGlhbA0KPiA+IHNsb3dk
b3duIG9mIDRrIHBhZ2VzIG9uIHRoZSBkaXJlY3QgbWFwIGhhc24ndCBiZWVuIG5vdGljZWQgZm9y
IGFwcHMgdGhhdCBkbw0KPiA+IGENCj4gPiBsb3Qgb2YgaW5zZXJ0aW9ucyBhbmQgcmVtb3ZhbHMg
b2YgQlBGIGZpbHRlcnMsIGlmIHRoaXMgaXMgaW5kZWVkIHRoZSBjYXNlLg0KPiANCj4gVGhhdCBz
aG91bGQgYmUgbGltaXRlZCB0byB0aGUgbW9kdWxlIHJhbmdlLiBSYW5kb20gZGF0YSBtYXBzIGNv
dWxkDQo+IHNoYXR0ZXIgdGhlIHdvcmxkLg0KDQpCUEYgaGFzIG9uZSB2bWFsbG9jIHNwYWNlIGFs
bG9jYXRpb24gZm9yIHRoZSBieXRlIGNvZGUgYW5kIG9uZSBmb3IgdGhlIG1vZHVsZQ0Kc3BhY2Ug
YWxsb2NhdGlvbiBmb3IgdGhlIEpJVC4gQm90aCBnZXQgUk8gYWxzbyBzZXQgb24gdGhlIGRpcmVj
dCBtYXAgYWxpYXMgb2YNCnRoZSBwYWdlcywgYW5kIHJlc2V0IFJXIHdoZW4gZnJlZWQuDQoNCllv
dSBtZWFuIHNoYXR0ZXIgcGVyZm9ybWFuY2U/DQo=
