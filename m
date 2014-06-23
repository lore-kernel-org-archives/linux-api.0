From: "chenhanxiao-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org" <chenhanxiao-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Subject: RE: [PATCH v2] ns: introduce getnspid syscall
Date: Mon, 23 Jun 2014 10:15:37 +0000
Message-ID: <5871495633F38949900D2BF2DC04883E54ECC5@G08CNEXMBPEKD02.g08.fujitsu.local>
References: <1403259512-10510-1-git-send-email-chenhanxiao@cn.fujitsu.com>
	<53A414B2.20108@nod.at>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5700312852427085892=="
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <53A414B2.20108-/L3Ra7n9ekc@public.gmane.org>
Content-Language: zh-CN
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, "containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
List-Id: linux-api@vger.kernel.org

--===============5700312852427085892==
Content-Language: zh-CN
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64

SGkNCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBSaWNoYXJkIFdlaW5i
ZXJnZXIgW21haWx0bzpyaWNoYXJkQG5vZC5hdF0NCj4gU2VudDogRnJpZGF5LCBKdW5lIDIwLCAy
MDE0IDc6MDIgUE0NCj4gVG86IENoZW4sIEhhbnhpYW8vs8Ig6s/P9jsgY29udGFpbmVyc0BsaXN0
cy5saW51eC1mb3VuZGF0aW9uLm9yZzsNCj4gbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZw0K
PiBDYzogRXJpYyBXLiBCaWVkZXJtYW47IFNlcmdlIEhhbGx5bjsgRGFuaWVsIFAuIEJlcnJhbmdl
OyBPbGVnIE5lc3Rlcm92OyBBbCBWaXJvOw0KPiBEYXZpZCBIb3dlbGxzOyBQYXZlbCBFbWVseWFu
b3Y7IFZhc2lsaXkgS3VsaWtvdjsgR290b3UsIFlhc3Vub3JpL87ljXUgv7XOxDsNCj4gbGludXgt
YXBpQHZnZXIua2VybmVsLm9yZw0KPiBTdWJqZWN0OiBSZTogW1BBVENIIHYyXSBuczogaW50cm9k
dWNlIGdldG5zcGlkIHN5c2NhbGwNCj4gDQo+IEFtIDIwLjA2LjIwMTQgMTI6MTgsIHNjaHJpZWIg
Q2hlbiBIYW54aWFvOg0KPiA+IFdlIG5lZWQgYSBkaXJlY3QgbWV0aG9kIG9mIGdldHRpbmcgdGhl
IHBpZCBpbnNpZGUgY29udGFpbmVycy4NCj4gPiBJZiBzb21lIGlzc3VlcyBvY2N1cnJlZCBpbnNp
ZGUgY29udGFpbmVyIGd1ZXN0LCBob3N0IHVzZXINCj4gPiBjb3VsZCBub3Qga25vdyB3aGljaCBw
cm9jZXNzIGlzIGluIHRyb3VibGUganVzdCBieSBndWVzdCBwaWQ6DQo+ID4gdGhlIHVzZXJzIG9m
IGNvbnRhaW5lciBndWVzdCBvbmx5IGtuZXcgdGhlIHBpZCBpbnNpZGUgY29udGFpbmVycy4NCj4g
PiBUaGlzIHdpbGwgYnJpbmcgb2JzdGFjbGUgZm9yIHRyb3VibGUgc2hvb3RpbmcuDQo+ID4NCj4g
PiBpbnQgZ2V0bnNwaWQocGlkX3QgcGlkLCBpbnQgZmQxLCBpbnQgZmQyKTsNCj4gPg0KPiA+IHBp
ZDogdGhlIHBpZCBudW1iZXIgbmVlZCB0byBiZSB0cmFuc2xhdGVkLg0KPiA+DQo+ID4gZmQ6IGEg
ZmlsZSBkZXNjcmlwdG9yIHJlZmVycmluZyB0byBvbmUgb2YNCj4gPiAgICAgdGhlIG5hbWVzcGFj
ZSBlbnRyaWVzIGluIGEgL3Byb2MvW3BpZF0vbnMvcGlkLg0KPiA+ICAgICBmZDEgZm9yIGRlc3Rp
bmF0aW9uIG5zKG5zMSksIHdoZXJlIHRoZSBwaWQgY2FtZSBmcm9tLg0KPiA+ICAgICBmZDIgZm9y
IHJlZmVyZW5jZSBucyhuczIpLCB3aGlsZSBmZDIgPSAtMiBtZWFucyBmb3IgY3VycmVudCBucy4N
Cj4gPg0KPiA+IHJldHVybiB2YWx1ZToNCj4gPiAgICAgPjAgOiB0cmFuc2xhdGVkIHBpZCBpbiBu
czEoZmQxKSBzZWVuIGZyb20gbnMyKGZkMikuDQo+ID4gICAgIDw9MDogb24gZmFpbHVyZS4NCj4g
Pg0KPiANCj4gSSBkb24ndCB0aGluayB0aGF0IGFkZGluZyBhIG5ldyBzeXN0ZW0gY2FsbCBmb3Ig
dGhpcyBpcyBhIGdvb2Qgc29sdXRpb24uDQo+IFdlIG5lZWQgYSBtb3JlIGdlbmVyaWMgd2F5LiBJ
IGJldCBwZW9wbGUgYXJlIGludGVyZXN0ZWQgaW4gbW9yZSB0aGFuIGp1c3QgUElEDQo+IG51bWJl
cnMuDQoNCkNvdWxkIHlvdSBwbGVhc2UgZ2l2ZSBzb21lIGhpbnRzIG9uIGhvdyB0byBleHBhbmQg
dGhpcyBpbnRlcmZhY2U/DQoNCj4gDQo+IEkgYWdyZWUgd2l0aCBFcmljIHRoYXQgYSBwcm9jZnMg
c29sdXRpb24gaXMgbW9yZSBhcHByb3ByaWF0ZS4NCj4gDQoNClByb2NmcyBpcyBhIGdvb2Qgc29s
dXRpb24sIGJ1dCBzeXNjYWxsIGlzIG5vdCBiYWQgdGhvdWdoLg0KUHJvY2ZzIHdvcmtzIGZvciBt
ZSwgYnV0IHRoYXQgc2VlbXMgY291bGQgbm90IGZpdA0KUGF2ZWwncyByZXF1aXJlbWVudC4NCkhp
cyBvcGluaW9uIGlzIHRoYXQgYSBzeXNjYWxsIGlzIGEgbW9yZSBnZW5lcmljIGludGVyZmFjZQ0K
dGhhbiBwcm9jIGZpbGVzLCBhbmQgIGFsc28gdmVyeSBoZWxwZnVsLg0KQW5kIHN5c2NhbGwgY291
bGQgdGVsbCB3aGV0aGVyIGEgcGlkIGxpdmVzIGluIGEgc3BlY2lmaWMgcGlkIG5hbWVzcGFjZSwN
Cm11Y2ggY29udmVuaWVudCB0aGFuIHByb2Nmcy4NCg0KVGhhbmtzLA0KLSBDaGVuDQo=

--===============5700312852427085892==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Containers mailing list
Containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
https://lists.linuxfoundation.org/mailman/listinfo/containers
--===============5700312852427085892==--
