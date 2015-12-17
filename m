From: David Laight <David.Laight@ACULAB.COM>
Subject: RE: [RFC PATCH 3/3] vfio-pci: Allow to mmap MSI-X table if EEH is
 supported
Date: Thu, 17 Dec 2015 10:08:04 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D1CBEF1BC@AcuExch.aculab.com>
References: <1449823994-3356-1-git-send-email-xyjxie@linux.vnet.ibm.com>
 <1449823994-3356-4-git-send-email-xyjxie@linux.vnet.ibm.com>
 <1450296869.2674.62.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1450296869.2674.62.camel@redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: 'Alex Williamson' <alex.williamson@redhat.com>, Yongji Xie <xyjxie@linux.vnet.ibm.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Cc: "nikunj@linux.vnet.ibm.com" <nikunj@linux.vnet.ibm.com>, "zhong@linux.vnet.ibm.com" <zhong@linux.vnet.ibm.com>, "aik@ozlabs.ru" <aik@ozlabs.ru>, "paulus@samba.org" <paulus@samba.org>, "warrier@linux.vnet.ibm.com" <warrier@linux.vnet.ibm.com>
List-Id: linux-api@vger.kernel.org

PiBUaGUgTVNJLVggdGFibGUgaXMgcGFyYXZpcnR1YWxpemVkIG9uIHZmaW8gaW4gZ2VuZXJhbCBh
bmQgaW50ZXJydXB0DQo+IHJlbWFwcGluZyB0aGVvcmV0aWNhbGx5IHByb3RlY3RzIGFnYWluc3Qg
ZXJyYW50IGludGVycnVwdHMsIHNvIHdoeSBpcw0KPiB0aGlzIFBQQzY0IHNwZWNpZmljPyBXZSBo
YXZlIHRoZSBzYW1lIHNhZmVndWFyZHMgb24geDg2IGlmIHdlIHdhbnQgdG8NCj4gZGVjaWRlIHRo
ZXkncmUgc3VmZmljaWVudC4gT2ZmaGFuZCwgdGhlIG9ubHkgd2F5IEkgY2FuIHRoaW5rIHRoYXQg
YQ0KPiBkZXZpY2UgY2FuIHRvdWNoIHRoZSBNU0ktWCB0YWJsZSBpcyB2aWEgYmFja2Rvb3JzIG9y
IHAycCBETUEgd2l0aA0KPiBhbm90aGVyIGRldmljZS4NCg0KSXMgdGhpcyBhbGwgcmVsYXRlZCB0
byB0aGUgc3RhdGVtZW50cyBpbiB0aGUgUENJKGUpIHNwZWMgdGhhdCB0aGUNCk1TSS1YIHRhYmxl
IGFuZCBQZW5kaW5nIGJpdCBhcnJheSBzaG91bGQgaW4gdGhlaXIgb3duIEJBUnM/DQooSVNUUiBp
dCBldmVuIHN1Z2dlc3RzIGEgQkFSIGVhY2guKQ0KDQpTaW5jZSB0aGUgTVNJLVggdGFibGUgZXhp
c3RzIGluIGRldmljZSBtZW1vcnkvcmVnaXN0ZXJzIHRoZXJlIGlzDQpub3RoaW5nIHRvIHN0b3Ag
dGhlIGRldmljZSBtb2RpZnlpbmcgdGhlIHRhYmxlIGNvbnRlbnRzIChvciBldmVuDQppZ25vcmlu
ZyB0aGUgY29udGVudHMgYW5kIHdyaXRpbmcgYWRkcmVzcytkYXRhIHBhaXJzIHRoYXQgYXJlIGtu
b3duDQp0byByZWZlcmVuY2UgdGhlIENQVXMgTVNJLVggaW50ZXJydXB0IGdlbmVyYXRpb24gbG9n
aWMpLg0KDQpXZSd2ZSBhbiBmcGdhIGJhc2VkIFBDSWUgc2xhdmUgdGhhdCBoYXMgc29tZSBhZGRp
dGlvbmFsIFBDSWUgc2xhdmVzDQooYXNzb2NpYXRlZCB3aXRoIHRoZSBpbnRlcnJ1cHQgZ2VuZXJh
dGlvbiBsb2dpYykgdGhhdCBhcmUgY3VycmVudGx5DQpuZXh0IHRvIHRoZSBQQkEgKHdoaWNoIGlz
IDhrIGZyb20gdGhlIE1TSS1YIHRhYmxlKS4NCklmIHdlIGNhbid0IG1hcCB0aGUgUEJBIHdlIGNh
bid0IGFjdHVhbGx5IHJhaXNlIGFueSBpbnRlcnJ1cHRzLg0KVGhlIHNhbWUgd291bGQgYmUgdHJ1
ZSBpZiBwYWdlIHNpemUgaXMgNjRrIGFuZCBtYXBwaW5nIHRoZSBNU0ktWA0KdGFibGUgYmFubmVk
Lg0KDQpEbyB3ZSBuZWVkIHRvIGNoYW5nZSBvdXIgUENJZSBzbGF2ZSBhZGRyZXNzIG1hcCBzbyB3
ZSBkb24ndCBuZWVkDQp0byBhY2Nlc3MgYW55dGhpbmcgaW4gdGhlIHNhbWUgcGFnZSAod2hpY2gg
bWlnaHQgYmUgNjRrIHdlcmUgd2UgdG8NCnRhcmdldCBsYXJnZSBwcGMgLSB3aGljaCB3ZSBkb24n
dCBhdCB0aGUgbW9tZW50KSBhcyBib3RoIHRoZQ0KTVNJLVggdGFibGUgYW5kIHRoZSBQQkE/DQoN
CkknZCBhbHNvIG5vdGUgdGhhdCBiZWluZyBhYmxlIHRvIHJlYWQgdGhlIE1TSS1YIHRhYmxlIGlz
IGEgdXNlZnVsDQpkaWFnbm9zdGljIHRoYXQgdGhlIHJlbGV2YW50IGludGVycnVwdHMgYXJlIGVu
YWJsZWQgcHJvcGVybHkuDQoNCglEYXZpZA0KDQo=
