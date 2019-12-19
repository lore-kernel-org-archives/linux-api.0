From: David Laight <David.Laight@ACULAB.COM>
Subject: RE: [PATCH 1/2] uapi: split openat2(2) definitions from fcntl.h
Date: Thu, 19 Dec 2019 14:05:04 +0000
Message-ID: <845fc9e8b55e4868bb4d20655e674b50@AcuMS.aculab.com>
References: <20191219105533.12508-1-cyphar@cyphar.com>
 <20191219105533.12508-2-cyphar@cyphar.com>
 <87a77oy3oe.fsf@oldenburg2.str.redhat.com>
 <20191219134525.mgzmjbsp4wo5b2bw@yavin.dot.cyphar.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191219134525.mgzmjbsp4wo5b2bw@yavin.dot.cyphar.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: 'Aleksa Sarai' <cyphar@cyphar.com>, Florian Weimer <fweimer@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Shuah Khan <shuah@kernel.org>, Christian Brauner <christian.brauner@ubuntu.com>, "dev@opencontainers.org" <dev@opencontainers.org>, "containers@lists.linux-foundation.org" <containers@lists.linux-foundation.org>, "libc-alpha@sourceware.org" <libc-alpha@sourceware.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

RnJvbTogQWxla3NhIFNhcmFpDQo+IFNlbnQ6IDE5IERlY2VtYmVyIDIwMTkgMTM6NDUNCj4gT24g
MjAxOS0xMi0xOSwgRmxvcmlhbiBXZWltZXIgPGZ3ZWltZXJAcmVkaGF0LmNvbT4gd3JvdGU6DQo+
ID4gKiBBbGVrc2EgU2FyYWk6DQo+ID4NCj4gPiA+IGRpZmYgLS1naXQgYS9pbmNsdWRlL3VhcGkv
bGludXgvb3BlbmF0Mi5oIGIvaW5jbHVkZS91YXBpL2xpbnV4L29wZW5hdDIuaA0KPiA+ID4gbmV3
IGZpbGUgbW9kZSAxMDA2NDQNCj4gPiA+IGluZGV4IDAwMDAwMDAwMDAwMC4uMTllZjc3NWU4ZTVl
DQo+ID4gPiAtLS0gL2Rldi9udWxsDQo+ID4gPiArKysgYi9pbmNsdWRlL3VhcGkvbGludXgvb3Bl
bmF0Mi5oDQo+ID4gPiBAQCAtMCwwICsxLDQxIEBADQo+ID4gPiArLyogU1BEWC1MaWNlbnNlLUlk
ZW50aWZpZXI6IEdQTC0yLjAgV0lUSCBMaW51eC1zeXNjYWxsLW5vdGUgKi8NCj4gPiA+ICsjaWZu
ZGVmIF9VQVBJX0xJTlVYX09QRU5BVDJfSA0KPiA+ID4gKyNkZWZpbmUgX1VBUElfTElOVVhfT1BF
TkFUMl9IDQo+ID4NCj4gPiBJIHRoaW5rIHlvdSBzaG91bGQgaW5jbHVkZSB0aGUgcmVsZXZhbnQg
aGVhZGVyIGZvciBfX2FsaWduX3U2NA0KPiA+IGV0Yy4gaGVyZS4NCj4gDQo+IFJpZ2h0IC0tIG5v
IGlkZWEgd2h5IEkgZm9yZ290IHRvIGluY2x1ZGUgdGhlbS4NCg0KSSdtIGd1ZXNzaW5nIHRoYXQg
aXMganVzdCA2NGJpdCBhbGlnbmVkIG9uIDMyYml0IGFyY2hzIGxpa2UgeDg2Pw0KDQpObyBuZWVk
IHRvIGVuZm9yY2UgaXQgcHJvdmlkZWQgdGhlIHN0cnVjdHVyZSB3aWxsIGhhdmUgbm8gcGFkZGlu
Zw0Kb24gYXJjaHMgd2hlcmUgdGhlIDY0Yml0IGZpZWxkcyBhcmUgNjRiaXQgYWxpZ25lZC4NCkEg
cGxhaW4gX191NjQgc2hvdWxkIGJlIGZpbmUuDQoNCglEYXZpZA0KDQotDQpSZWdpc3RlcmVkIEFk
ZHJlc3MgTGFrZXNpZGUsIEJyYW1sZXkgUm9hZCwgTW91bnQgRmFybSwgTWlsdG9uIEtleW5lcywg
TUsxIDFQVCwgVUsNClJlZ2lzdHJhdGlvbiBObzogMTM5NzM4NiAoV2FsZXMpDQo=
