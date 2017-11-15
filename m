From: Miklos Szeredi <miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org>
Subject: Re: [musl] Re: [(resend)] seq_file: reset iterator to first record
 for zero offset
Date: Wed, 15 Nov 2017 11:34:58 +0100
Message-ID: <CAJfpegv0CqPjvosp81SSOfCW5eOyzd4ciFWRrMc0_1ZkVDUAvA@mail.gmail.com>
References: <20161219113800.GE27207@veci.piliscsaba.szeredi.hu>
 <20171108131005.GA15263@port70.net> <20171110011419.GP1627@brightrain.aerifal.cx>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="001a1141e49433022b055e030e66"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171110011419.GP1627-C3MtFaGISjmo6RMmaWD+6Sb1p8zYI1N1@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Rich Felker <dalias-8zAoT0mYgF4@public.gmane.org>
Cc: Szabolcs Nagy <nsz-4P1ElwuDYu6sTnJN9+BGXg@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Tomasz Majchrzak <tomasz.majchrzak-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, musl-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org
List-Id: linux-api@vger.kernel.org

--001a1141e49433022b055e030e66
Content-Type: text/plain; charset="UTF-8"

On Fri, Nov 10, 2017 at 2:14 AM, Rich Felker <dalias-8zAoT0mYgF4@public.gmane.org> wrote:
> On Wed, Nov 08, 2017 at 02:10:05PM +0100, Szabolcs Nagy wrote:
>>
>> this patch broke userspace abi:
>>
>> commit e522751d605d99a81508e58390a8f51ee96fb662
>
> Thanks for reporting this!

Thanks for the report and the reproducer.

Tested fix attached.

Thanks,
Miklos

--001a1141e49433022b055e030e66
Content-Type: text/x-patch; charset="US-ASCII";
	name="seq_file-fix-incomplete-reset-on-read-from-zero-offset.patch"
Content-Disposition: attachment;
	filename="seq_file-fix-incomplete-reset-on-read-from-zero-offset.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ja0wtgqe0

RnJvbTogTWlrbG9zIFN6ZXJlZGkgPG1zemVyZWRpQHJlZGhhdC5jb20+ClN1YmplY3Q6IHNlcV9m
aWxlOiBmaXggaW5jb21wbGV0ZSByZXNldCBvbiByZWFkIGZyb20gemVybyBvZmZzZXQKCldoZW4g
cmVzZXR0aW5nIGl0ZXJhdG9yIG9uIGEgemVybyBvZmZzZXQgd2UgbmVlZCB0byBkaXNjYXJkIGFu
eSBkYXRhCmFscmVhZHkgaW4gdGhlIGJ1ZmZlciAoY291bnQpLCBhbmQgcHJpdmF0ZSBzdGF0ZSBv
ZiB0aGUgaXRlcmF0b3IgKHZlcnNpb24pLgoKRm9yIGV4YW1wbGUgdGhpcyBidWcgcmVzdWx0cyBp
biBmaXJzdCBsaW5lIGJlaW5nIHJlcGVhdGVkIGluIC9wcm9jL21vdW50cwppZiBkb2luZyBhIHpl
cm8gc2l6ZSByZWFkIGJlZm9yZSBhIG5vbi16ZXJvIHNpemUgcmVhZC4KClJlcG9ydGVkLWJ5OiBS
aWNoIEZlbGtlciA8ZGFsaWFzQGxpYmMub3JnPiAKU2lnbmVkLW9mZi1ieTogTWlrbG9zIFN6ZXJl
ZGkgPG1zemVyZWRpQHJlZGhhdC5jb20+CkZpeGVzOiBlNTIyNzUxZDYwNWQgKCJzZXFfZmlsZTog
cmVzZXQgaXRlcmF0b3IgdG8gZmlyc3QgcmVjb3JkIGZvciB6ZXJvIG9mZnNldCIpCkNjOiA8c3Rh
YmxlQHZnZXIua2VybmVsLm9yZz4gIyB2NC4xMAotLS0KIGZzL3NlcV9maWxlLmMgfCAgICA1ICsr
KystCiAxIGZpbGUgY2hhbmdlZCwgNCBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pCgotLS0g
YS9mcy9zZXFfZmlsZS5jCisrKyBiL2ZzL3NlcV9maWxlLmMKQEAgLTE4MSw4ICsxODEsMTEgQEAg
c3NpemVfdCBzZXFfcmVhZChzdHJ1Y3QgZmlsZSAqZmlsZSwgY2hhcgogCSAqIGlmIHJlcXVlc3Qg
aXMgdG8gcmVhZCBmcm9tIHplcm8gb2Zmc2V0LCByZXNldCBpdGVyYXRvciB0byBmaXJzdAogCSAq
IHJlY29yZCBhcyBpdCBtaWdodCBoYXZlIGJlZW4gYWxyZWFkeSBhZHZhbmNlZCBieSBwcmV2aW91
cyByZXF1ZXN0cwogCSAqLwotCWlmICgqcHBvcyA9PSAwKQorCWlmICgqcHBvcyA9PSAwKSB7CiAJ
CW0tPmluZGV4ID0gMDsKKwkJbS0+dmVyc2lvbiA9IDA7CisJCW0tPmNvdW50ID0gMDsKKwl9CiAK
IAkvKiBEb24ndCBhc3N1bWUgKnBwb3MgaXMgd2hlcmUgd2UgbGVmdCBpdCAqLwogCWlmICh1bmxp
a2VseSgqcHBvcyAhPSBtLT5yZWFkX3BvcykpIHsK
--001a1141e49433022b055e030e66--
