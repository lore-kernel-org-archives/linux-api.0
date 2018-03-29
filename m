From: Manfred Spraul <manfred-nhLOkwUX5cPe2c5cEj3t2g@public.gmane.org>
Subject: Re: [RFC][PATCH] ipc: Remove IPCMNI
Date: Thu, 29 Mar 2018 20:07:44 +0200
Message-ID: <05772f83-d680-aea1-b222-cef2430dcc83@colorfullife.com>
References: <87woyfyh57.fsf@xmission.com>
	<5d4a858a-3136-5ef4-76fe-a61e7f2aed56@redhat.com>
	<87o9jru3bf.fsf@xmission.com>
	<935a7c50-50cc-2dc0-33bb-92c000d039bc@redhat.com>
	<87woyego2u.fsf_-_@xmission.com>
	<047c6ed6-6581-b543-ba3d-cadc543d3d25@redhat.com>
	<87h8ph6u67.fsf@xmission.com>
	<7d3a1f93-f8e5-5325-f9a7-0079f7777b6f@redhat.com>
	<20180329021409.gcjjrmviw2lckbfk@linux-n805>
	<3e201de2-bed2-6f7d-0783-700d095142e0@colorfullife.com>
	<20180329105601.GA597@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Content-Transfer-Encoding: base64
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20180329105601.GA597-PfSpb0PWhxZc2C7mugBRk2EX/6BAtgUQ@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>, Stanislav Kinsbursky <skinsbursky-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, "Luis R. Rodriguez" <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

SGVsbG8gTWF0aGV3LAoKT24gMDMvMjkvMjAxOCAxMjo1NiBQTSwgTWF0dGhldyBXaWxjb3ggd3Jv
dGU6Cj4gT24gVGh1LCBNYXIgMjksIDIwMTggYXQgMTA6NDc6NDVBTSArMDIwMCwgTWFuZnJlZCBT
cHJhdWwgd3JvdGU6Cj4+Pj4+Pj4gVGhpcyBjYW4gYmUgaW1wbGVtZW50ZWQgdHJpdmlhbGx5IHdp
dGggdGhlIGN1cnJlbnQgY29kZQo+Pj4+Pj4+IHVzaW5nIGlkcl9hbGxvY19jeWNsaWMuCj4+IElz
IHRoZXJlIGEgcGVyZm9ybWFuY2UgaW1wYWN0Pwo+PiBSaWdodCBub3csIHRoZSBpZHIgdHJlZSBp
cyBvbmx5IGxhcmdlIGlmIHRoZXJlIGFyZSBsb3RzIG9mIG9iamVjdHMuCj4+IFdoYXQgaGFwcGVu
cyBpZiB3ZSBoYXZlIG9ubHkgMSBvYmplY3QsIHdpdGggaWQ9SU5UX01BWC0xPwo+IFRoZSByYWRp
eCB0cmVlIHVzZXMgYSBicmFuY2hpbmcgZmFjdG9yIG9mIDY0IGVudHJpZXMgKDYgYml0cykgcGVy
IGxldmVsLgo+IFRoZSBtYXhpbXVtIElEIGlzIDMxIGJpdHMgKHBvc2l0aXZlIHNpZ25lZCAzMi1i
aXQgaW50ZWdlcikuICBTbyB0aGUKPiB3b3JzdCBjYXNlIGZvciBhIHNpbmdsZSBvYmplY3QgaXMg
NiBwb2ludGVyIGRlcmVmZXJlbmNlcyB0byBmaW5kIHRoZQo+IG9iamVjdCBhbnl3aGVyZSBpbiB0
aGUgcmFuZ2UgKElOVF9NQVgvMiAtIElOVF9NQVhdLiAgVGhhdCB3aWxsIHJlYWQgMTIKPiBjYWNo
ZWxpbmVzLiAgSWYgd2Ugd2VyZSB0byBjb25zdHJhaW4gb3Vyc2VsdmVzIHRvIGEgbWF4aW11bSBv
ZiBJTlRfTUFYLzIKPiAoMzAgYml0cyksIHdlJ2QgcmVkdWNlIHRoYXQgdG8gNSBwb2ludGVyIGRl
cmVmZXJlbmNlcyBhbmQgMTAgY2FjaGVsaW5lcy4KSSdtIGNvbmNlcm5lZCBhYm91dCB0aGUgdXAg
dG8gNiBicmFuY2hlcy4KQnV0IHRoaXMgaXMganVzdCBndWVzc2luZywgd2UgbmVlZCBhIHRlc3Qg
d2l0aCBhIHJlYWxpc3RpYyB3b3JrbG9hZC4KCi0tCiDCoMKgwqAgTWFuZnJlZApfX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpDb250YWluZXJzIG1haWxpbmcg
bGlzdApDb250YWluZXJzQGxpc3RzLmxpbnV4LWZvdW5kYXRpb24ub3JnCmh0dHBzOi8vbGlzdHMu
bGludXhmb3VuZGF0aW9uLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2NvbnRhaW5lcnM=
