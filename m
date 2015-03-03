From: Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH RFC 1/3] Drivers: hv: kvp: convert userspace/kernel
 communication to using char device
Date: Tue, 03 Mar 2015 10:53:19 +0100
Message-ID: <87pp8qif00.fsf@vitty.brq.redhat.com>
References: <1425053665-635-1-git-send-email-vkuznets@redhat.com>
 <1425053665-635-2-git-send-email-vkuznets@redhat.com>
 <20150227202715.GF2034@potion.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20150227202715.GF2034@potion.brq.redhat.com> ("Radim
 \=\?utf-8\?B\?S3LEjW3DocWZIidz\?\=
 message of "Fri, 27 Feb 2015 21:27:15 +0100")
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Haiyang Zhang <haiyangz@microsoft.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, devel@linuxdriverproject.org
List-Id: linux-api@vger.kernel.org

UmFkaW0gS3LEjW3DocWZIDxya3JjbWFyQHJlZGhhdC5jb20+IHdyaXRlczoKCj4gMjAxNS0wMi0y
NyAxNzoxNCswMTAwLCBWaXRhbHkgS3V6bmV0c292Ogo+PiBSZS1pbXBsZW1lbnQgdGhlIGNvbW11
bmljYXRpb24gdXNpbmcgbWlzYyBjaGFyIGRldmljZS4gVXNlIGlvY3RsIHRvIGRvCj4+IGtlcm5l
bC91c2Vyc3BhY2UgdmVyc2lvbiBuZWdvdGlhdGlvbiAoZG9lc24ndCBtYWtlIG11Y2ggc2Vuc2Ug
YXQgdGhpcyBtb21lbnQKPj4gYXMgd2UncmUgYnJlYWtpbmcgYmFja3dhcmRzIGNvbXBhdGliaWxp
dHkgYnV0IGNhbiBiZSB1c2VkIGluIGZ1dHVyZSkuCj4KPiBUaGUgbWFpbiBxdWVzdGlvbiBpcyB3
aGV0aGVyIHdlIHdhbnQgdG8gYWJvbGlzaCBiYWNrd2FyZCBjb21wYXRpYmlsaXR5Owo+IGtlcm5l
bCBydWxlcyBhcmUgdXN1YWxseSBhZ2FpbnN0IGJyZWFrYWdlcyBhbmQgaXQncyBoYXJkIHRvIHBy
b3ZlIHRoYXQKPiB0aGUgYnVuZGxlZCBkYWVtb24gaXMgYSBzb2xlIHVzZXIgYW5kIGdldHMgdXBk
YXRlZCBhdCB0aGUgc2FtZSB0aW1lLgo+IChOb3RlOiBJJ2QgZ2xhZGx5IGJyZWFrIGFueXRoaW5n
LikKPgo+IFRoZSBpb2N0bCBpcyB1c2VkIHRvbyBjcmVhdGl2ZWx5IGZvciBteSBsaWtpbmc6IGFz
IGFuIG91dC1vZi1iYW5kCj4gY29tbXVuaWNhdGlvbiB0aGF0IGlzIHJlcXVpcmVkIGFmdGVyIHRo
ZSBtYWluIGNoYW5uZWwgaGFzIGJlZW4gb3BlbmVkLgo+IEl0IHdvdWxkIGJlIHNpbXBsZXIgdG8g
aW5qZWN0IHRoZSB2ZXJzaW9uIGludG8gZmlyc3QgeCBieXRlcyBvZiB0aGUKPiBzdHJlYW0sIG1h
a2luZyBhIHJlYWQoKSBhZnRlciBvcGVuKCkgbWFuZGF0b3J5LgoKV2UgbmVlZCB0byBwZXJmb3Jt
IGEgaGFuZHNoYWtlIC0ga2VybmVsIHBhcnQgc2VuZHMgaXRzIHZlcnNpb24gYW5kCnJlY2VpdmVz
IGRhZW1vbidzIHZlcnNpb24uIFdlIGNhbiBkZWZpbml0ZWxseSBwYWNrIGV2ZXJ5dGhpbmcgaW4g
dGhlCmRhdGEgc3RyZWFtIGJ1dCB3aHkgZG8gd2UgbmVlZCB0byBhdm9pZCBpb2N0bHM/IEl0IHNl
ZW1zIHRvIG1lIHRoZQpoYW5kc2hha2Ugd2UncmUgcGVyZm9ybWluZyBoZXJlIGJlbG9uZ3MgdG8g
YSAnY29udHJvbCcgc3RyZWFtLCBub3QKJ2RhdGEnIHN0cmVhbS4KCj4KPiAoSSd2ZSBvbmx5IGRv
bmUgYSBoaWdoIGxldmVsIG92ZXJ2aWV3IHNvIGZhci4pCgpUaGFua3MhCgotLSAKICBWaXRhbHkK
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KZGV2ZWwgbWFp
bGluZyBsaXN0CmRldmVsQGxpbnV4ZHJpdmVycHJvamVjdC5vcmcKaHR0cDovL2RyaXZlcmRldi5s
aW51eGRyaXZlcnByb2plY3Qub3JnL21haWxtYW4vbGlzdGluZm8vZHJpdmVyZGV2LWRldmVsCg==
