From: Song Liu <songliubraving@fb.com>
Subject: Re: [PATCH v2 bpf-next 1/4] bpf: unprivileged BPF access via /dev/bpf
Date: Sat, 27 Jul 2019 18:20:17 +0000
Message-ID: <77354A95-4107-41A7-8936-D144F01C3CA4@fb.com>
References: <20190627201923.2589391-1-songliubraving@fb.com>
 <20190627201923.2589391-2-songliubraving@fb.com>
 <21894f45-70d8-dfca-8c02-044f776c5e05@kernel.org>
 <3C595328-3ABE-4421-9772-8D41094A4F57@fb.com>
 <CALCETrWBnH4Q43POU8cQ7YMjb9LioK28FDEQf7aHZbdf1eBZWg@mail.gmail.com>
 <0DE7F23E-9CD2-4F03-82B5-835506B59056@fb.com>
 <CALCETrWBWbNFJvsTCeUchu3BZJ3SH3dvtXLUB2EhnPrzFfsLNA@mail.gmail.com>
 <201907021115.DCD56BBABB@keescook>
 <CALCETrXTta26CTtEDnzvtd03-WOGdXcnsAogP8JjLkcj4-mHvg@mail.gmail.com>
 <4A7A225A-6C23-4C0F-9A95-7C6C56B281ED@fb.com>
 <CALCETrX2bMnwC6_t4b_G-hzJSfMPrkK4YKs5ebcecv2LJ0rt3w@mail.gmail.com>
 <514D5453-0AEE-420F-AEB6-3F4F58C62E7E@fb.com>
 <1DE886F3-3982-45DE-B545-67AD6A4871AB@amacapital.net>
 <7F51F8B8-CF4C-4D82-AAE1-F0F28951DB7F@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <7F51F8B8-CF4C-4D82-AAE1-F0F28951DB7F@fb.com>
Content-Language: en-US
Content-ID: <C3B1AC11B31A674F9AFF087411C1D71E@namprd15.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Andy Lutomirski <luto@kernel.org>, Kees Cook <keescook@chromium.org>, "linux-security@vger.kernel.org" <linux-security@vger.kernel.org>, Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Kernel Team <Kernel-team@fb.com>, Lorenz Bauer <lmb@cloudflare.com>, Jann Horn <jannh@google.com>, Greg KH <gregkh@linuxfoundation.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

SGkgQW5keSwgDQoNCj4+Pj4gDQo+Pj4gDQo+Pj4gV2VsbCwgeWVzLiBzeXNfYnBmKCkgaXMgcHJl
dHR5IHBvd2VyZnVsLiANCj4+PiANCj4+PiBUaGUgZ29hbCBvZiAvZGV2L2JwZiBpcyB0byBlbmFi
bGUgc3BlY2lhbCB1c2VycyB0byBjYWxsIHN5c19icGYoKS4gSW4gDQo+Pj4gdGhlIG1lYW53aGls
ZSwgc3VjaCB1c2VycyBzaG91bGQgbm90IHRha2UgZG93biB0aGUgd2hvbGUgc3lzdGVtIGVhc2ls
eQ0KPj4+IGJ5IGFjY2lkZW50LCBlLmcuLCB3aXRoIHJtIC1yZiAvLg0KPj4gDQo+PiBUaGF04oCZ
cyBlYXN5LCB0aG91Z2gg4oCUIGJwZnRvb2wgY291bGQgbGVhcm4gdG8gcmVhZCAvZXRjL2JwZnVz
ZXJzIGJlZm9yZSBhbGxvd2luZyBydWlkICE9IDAuDQo+IA0KPiBUaGlzIGlzIGEgZ3JlYXQgaWRl
YSEgZnNjYXBzICsgL2V0Yy9icGZ1c2VycyBzaG91bGQgZG8gdGhlIHRyaWNrLiANCg0KQWZ0ZXIg
c29tZSBkaXNjdXNzaW9ucyBhbmQgbW9yZSB0aGlua2luZyBvbiB0aGlzLCBJIGhhdmUgc29tZSBj
b25jZXJucyANCndpdGggdGhlIHVzZXIgc3BhY2Ugb25seSBhcHByb2FjaC4gIA0KDQpJSVVDLCB5
b3VyIHByb3Bvc2FsIGZvciB1c2VyIHNwYWNlIG9ubHkgYXBwcm9hY2ggaXMgbGlrZTogDQoNCjEu
IGJwZnRvb2wgKGFuZCBvdGhlciB0b29scykgY2hlY2sgL2V0Yy9icGZ1c2VycyBhbmQgb25seSBk
byANCiAgIHNldHVpZCBmb3IgYWxsb3dlZCB1c2VyczoNCg0KCWludCBtYWluKCkNCgl7DQoJCWlm
ICgvKiB1aWQgaW4gL2V0Yy9icGZ1c2VycyAqLykNCgkJCXNldHVpZCgwKTsNCgkJc3lzX2JwZigu
Li4pOw0KCX0NCg0KMi4gYnBmdG9vbCAoYW5kIG90aGVyIHRvb2xzKSBpcyBpbnN0YWxsZWQgd2l0
aCBDQVBfU0VUVUlEOg0KDQoJc2V0Y2FwIGNhcF9zZXR1aWQ9ZStwIC9iaW4vYnBmdG9vbA0KDQoz
LiBzeXMgYWRtaW4gbWFpbnRhaW5zIHByb3BlciAvZXRjL2JwZnVzZXJzLiANCg0KVGhpcyBhcHBy
b2FjaCBpcyBub3QgaWRlYWwsIGJlY2F1c2Ugd2UgbmVlZCB0byB0cnVzdCB0aGUgdG9vbCB0byBn
aXZlIA0KaXQgQ0FQX1NFVFVJRC4gQSBoYWNrZWQgdG9vbCBjb3VsZCBlYXNpbHkgYnlwYXNzIC9l
dGMvYnBmdXNlcnMgY2hlY2sNCm9yIHVzZSBvdGhlciByb290IG9ubHkgc3lzIGNhbGxzIGFmdGVy
IHNldHVpZCgwKS4gDQoNCkRvZXMgdGhpcyBtYWtlIHNlbnNlPyAoT3IgZGlkIEkgbWlzdW5kZXJz
dGFuZCBhbnl0aGluZz8pDQoNClRoYW5rcywNClNvbmcNCg0K
