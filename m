From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Subject: Re: [PATCH RFC] mm: add MAP_EXCLUSIVE to create exclusive user
 mappings
Date: Wed, 30 Oct 2019 17:48:20 +0000
Message-ID: <b4d87f54b02cfccb58442f791485cad1ac080063.camel@intel.com>
References: <1572171452-7958-1-git-send-email-rppt@kernel.org>
         <1572171452-7958-2-git-send-email-rppt@kernel.org>
         <20191028123124.ogkk5ogjlamvwc2s@box> <20191028130018.GA7192@rapoport-lnx>
         <20191028131623.zwuwguhm4v4s5imh@box>
         <20191028135521.GB4097@hirez.programming.kicks-ass.net>
         <0a35765f7412937c1775daa05177b20113760aee.camel@intel.com>
         <20191028210052.GM4643@worktop.programming.kicks-ass.net>
         <69c57f7fa9a1be145827673b37beff155a3adc3c.camel@intel.com>
         <20191030100418.GV4097@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191030100418.GV4097@hirez.programming.kicks-ass.net>
Content-Language: en-US
Content-ID: <7AA923C2D8CFCE44B7E3F1866A3D8051@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "peterz@infradead.org" <peterz@infradead.org>
Cc: "adobriyan@gmail.com" <adobriyan@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "rppt@kernel.org" <rppt@kernel.org>, "rostedt@goodmis.org" <rostedt@goodmis.org>, "jejb@linux.ibm.com" <jejb@linux.ibm.com>, "tglx@linutronix.de" <tglx@linutronix.de>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>, "luto@kernel.org" <luto@kernel.org>, "kirill@shutemov.name" <kirill@shutemov.name>, "bp@alien8.de" <bp@alien8.de>, "rppt@linux.ibm.com" <rppt@linux.ibm.com>
List-Id: linux-api@vger.kernel.org

T24gV2VkLCAyMDE5LTEwLTMwIGF0IDExOjA0ICswMTAwLCBQZXRlciBaaWpsc3RyYSB3cm90ZToN
Cj4gPiBZb3UgbWVhbiBzaGF0dGVyIHBlcmZvcm1hbmNlPw0KPiANCj4gU2hhdHRlciAoYWxsKSBs
YXJnZSBwYWdlcy4NCg0KU28gaXQgbG9va3MgbGlrZSB0aGlzIGlzIGFscmVhZHkgaGFwcGVuaW5n
IHRoZW4gdG8gc29tZSBkZWdyZWUuIEl0J3Mgbm90IGp1c3QNCkJQRiBlaXRoZXIsIGFueSBtb2R1
bGVfYWxsb2MoKSB1c2VyIGlzIGdvaW5nIHRvIGRvIHNvbWV0aGluZyBzaW1pbGFyIHdpdGggdGhl
DQpkaXJlY3QgbWFwIGFsaWFzIG9mIHRoZSBwYWdlIHRoZXkgZ290IGZvciB0aGUgdGV4dC4NCg0K
U28gdGhlcmUgbXVzdCBiZSBhdCBsZWFzdCBzb21lIHVzYWdlcyB3aGVyZSBicmVha2luZyB0aGUg
ZGlyZWN0IG1hcCBkb3duLCBmb3INCmxpa2UgYSBwYWdlIHRvIHN0b3JlIGEga2V5IG9yIHNvbWV0
aGluZywgaXNuJ3QgdG90YWxseSBob3JyaWJsZS4NCg0K
