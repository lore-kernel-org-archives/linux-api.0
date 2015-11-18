From: Shuichi Ihara <sihara@ddn.com>
Subject: Re: [v15 0/4] ext4: add project quota support
Date: Wed, 18 Nov 2015 14:14:32 +0000
Message-ID: <81500210-A31E-45CE-A3AE-9F5D0A785954@ddn.com>
References: <1442146833-13652-1-git-send-email-lixi@ddn.com>
 <43B1BB97-8D53-4D93-9B57-B5E2048F7E7A@dilger.ca>
 <CAPTn0cBp4d09u9XzQm2cXzd6kcE0+FDRX0b_H=xJBZT-i5eKcw@mail.gmail.com>
 <7360A48E-8576-49DB-878B-DFC2EFC83BC4@ddn.com>
 <20151108212830.GL19199@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20151108212830.GL19199@dastard>
Content-Language: ja-JP
Content-ID: <FFB51B8D7215304CA532148B0EFD5957@ddn.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: Li Xi <pkuelelixi@gmail.com>, Andreas Dilger <adilger@dilger.ca>, Theodore Ts'o <tytso@mit.edu>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Jan Kara <jack@suse.cz>, Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@infradead.org>, =?utf-8?B?0JTQvNC40YLRgNC40Lkg0JzQvtC90LDRhdC+0LI=?= <dmonakhov@openvz.org>, Shuichi Ihara <ihashu@gmail.com>
List-Id: linux-api@vger.kernel.org

DQoxMS85LzE1LCA2OjI4IEFNICwgIkRhdmUgQ2hpbm5lciIgPGRhdmlkQGZyb21vcmJpdC5jb20+
IHdyb3RlOg0KDQo+T24gVGh1LCBOb3YgMDUsIDIwMTUgYXQgMDM6MTM6MTBQTSArMDAwMCwgU2h1
aWNoaSBJaGFyYSB3cm90ZToNCj4+IEhlbGxvIFRlZCwgQW5kcmVhcywNCj4+IA0KPj4gU2hpbG9u
ZyBwb3N0ZWQgYW4gZW1haWwgaGVyZSBhIHdlZWsgYWdvIGJlbG93Lg0KPj4gaHR0cDovL2xpc3Rz
Lm9wZW53YWxsLm5ldC9saW51eC1leHQ0LzIwMTUvMTAvMzAvMg0KPj4gDQo+PiB3ZSBpZGVudGlm
aWVkIDEwIHByb2plY3QgcXVvdGEgcmVsYXRlZCB4ZnN0ZXN0IGFuZCBwb3J0ZWQgdGhlbSBpbnRv
IGV4dDQveHh4Lg0KPj4gdGVzdCBudW1iZXIgYXJlIDMwNCwgMzA1LCAyOTksIDI0NCwgMTk2LCAx
MzQsIDEwOCwgMTA3LCAxMDYsIDA1MCBpbiB4ZnMuDQo+PiANCj4+IA0KPj4gV2UgcG9ydGVkIDkv
MTAgdGVzdHMgaW50byBleHQ0L3h4eA0KPj4gZXh0NC8wNTAgZXh0NC8xMDYgZXh0NC8xMDcgZXh0
NC8xMDggZXh0NC8xOTYgZXh0NC8yNDQgZXh0NC8yOTkgZXh0NC80MDAgZXh0NC80MDENCj4NCj5Q
bGVhc2UgbWFrZSB0aGVtIGdlbmVyaWMgdGVzdHMgLSB0aGUgZXh0NCBwcm9qZWN0IHF1b3RhDQo+
ZnVuY3Rpb2FubGl0eSBzaG91bGQgd29yayB3aXRoIHRob3NlIHRlc3RzIGJlaW5nIGNvbXBsZXRl
bHkNCj51bmNoYW5nZWQgZXhjZXB0IGZvciBhICJfcmVxdWlyZXNfcHJvamVjdF9xdW90YSgpIiBm
dW5jdGlvbi4uLg0KDQpSaWdodCBub3csIHdlIGVuaGFuY2VkIHF1b3RhdG9vbCB0byBzdXBwb3J0
IHByb2plY3QgcXVvdGEgYW5kIGFib3ZlIHByb2plY3QgcXVvdGEgdGVzdHMgaW4gZXh0NCB1c2Vz
IHRoYXQgaW50ZXJmYWNlLg0KeGZzIHVzZXMgb3duIGludGVyZmFjZSB4ZnNfeHggZm9yIHByb2pl
Y3QgcXVvdGEgdGVzdHMgaW4geGZzLg0Kd2hhdCBpbnRlcmZhY2UgYXJlIHlvdSBsb29raW5nIGF0
IGlmIHdlIG1vdmUgZXh0NCdzIHByb2plY3QgcXVvdGEgdGVzdHMgaW50byBnZW5lcmljIHRlc3Rz
Pw0KDQpUaGFua3MNCkloYXJhDQo=
