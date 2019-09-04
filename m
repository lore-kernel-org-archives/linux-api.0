From: Alexei Starovoitov <ast@fb.com>
Subject: Re: [PATCH v2 bpf-next 2/3] bpf: implement CAP_BPF
Date: Wed, 4 Sep 2019 01:39:28 +0000
Message-ID: <46df2c36-4276-33c0-626b-c51e77b3a04f@fb.com>
References: <20190829051253.1927291-1-ast@kernel.org>
 <20190829051253.1927291-2-ast@kernel.org>
 <ed8796f5-eaea-c87d-ddd9-9d624059e5ee@iogearbox.net>
 <20190829173034.up5g74onaekp53zd@ast-mbp.dhcp.thefacebook.com>
 <59ac111e-7ce7-5e00-32c9-9b55482fe701@6wind.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <59ac111e-7ce7-5e00-32c9-9b55482fe701@6wind.com>
Content-Language: en-US
Content-ID: <032BE727726D484FB96AD8BCF8C8DC4F@namprd15.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
To: "nicolas.dichtel@6wind.com" <nicolas.dichtel@6wind.com>, Alexei Starovoitov <alexei.starovoitov@gmail.com>, Daniel Borkmann <daniel@iogearbox.net>
Cc: Alexei Starovoitov <ast@kernel.org>, "luto@amacapital.net" <luto@amacapital.net>, "davem@davemloft.net" <davem@davemloft.net>, "peterz@infradead.org" <peterz@infradead.org>, "rostedt@goodmis.org" <rostedt@goodmis.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "bpf@vger.kernel.org" <bpf@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

T24gOC8zMC8xOSA4OjE5IEFNLCBOaWNvbGFzIERpY2h0ZWwgd3JvdGU6DQo+IExlIDI5LzA4LzIw
MTkgw6AgMTk6MzAsIEFsZXhlaSBTdGFyb3ZvaXRvdiBhIMOpY3JpdMKgOg0KPiBbc25pcF0NCj4+
IFRoZXNlIGFyZSB0aGUgbGlua3MgdGhhdCBzaG93aW5nIHRoYXQgazggY2FuIGRlbGVnYXRlcyBj
YXBzLg0KPj4gQXJlIHlvdSBzYXlpbmcgdGhhdCB5b3Uga25vdyBvZiBmb2xrcyB3aG8gc3BlY2lm
aWNhbGx5DQo+PiBkZWxlZ2F0ZSBjYXBfc3lzX2FkbWluIGFuZCBjYXBfbmV0X2FkbWluIF9vbmx5
XyB0byBhIGNvbnRhaW5lciB0byBydW4gYnBmIGluIHRoZXJlPw0KPj4NCj4gWWVzLCB3ZSBuZWVk
IGNhcF9zeXNfYWRtaW4gb25seSB0byBsb2FkIGJwZjoNCj4gdGMgZmlsdGVyIGFkZCBkZXYgZXRo
MCBpbmdyZXNzIG1hdGNoYWxsIGFjdGlvbiBicGYgb2JqIC4vdGNfdGVzdF9rZXJuLm8gc2VjIHRl
c3QNCj4gDQo+IEknbSBub3Qgc3VyZSB0byB1bmRlcnN0YW5kIHdoeSBjYXBfbmV0X2FkbWluIGlz
IG5vdCBlbm91Z2ggdG8gcnVuIHRoZSBwcmV2aW91cw0KPiBjb21tYW5kIChpZSB3aHkgbG9hZCBp
cyBmb3JiaWRkZW4pLg0KDQpiZWNhdXNlIGJwZiBzeXNjYWxsIHByb2dfbG9hZCBjb21tYW5kIHJl
cXVpcmVzIGNhcF9zeXNfYWRtaW4gaW4NCnRoZSBjdXJyZW50IGltcGxlbWVudGF0aW9uLg0KDQo+
IEkgd2FudCB0byBhdm9pZCBzeXNfYWRtaW4sIHRodXMgY2FwX2JwZiB3aWxsIGJlIG9rLiBCdXQg
d2UgbmVlZCB0byBtYW5hZ2UgdGhlDQo+IGJhY2t3YXJkIGNvbXBhdGliaWxpdHkuDQoNCnJlOiBi
YWNrd2FyZCBjb21wYXRpYmlsaXR5Li4uDQpkbyB5b3Uga25vdyBvZiBhbnkgY2FzZSB3aGVyZSB0
YXNrIGlzIHJ1bm5pbmcgdW5kZXIgdXNlcmlkPW5vYm9keQ0Kd2l0aCBjYXBfc3lzX2FkbWluIGFu
ZCBjYXBfbmV0X2FkbWluIGluIG9yZGVyIHRvIGRvIGJwZiA/DQoNCklmIG5vdCB0aGVuIHdoYXQg
aXMgdGhlIGNvbmNlcm4gYWJvdXQgY29tcGF0aWJpbGl0eT8NCg==
