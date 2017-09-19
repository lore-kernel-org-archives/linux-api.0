From: Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [patch v2] madvise.2: Add MADV_WIPEONFORK documentation
Date: Tue, 19 Sep 2017 15:21:47 -0400
Message-ID: <1505848907.5486.9.camel@redhat.com>
References: <20170914130040.6faabb18@cuia.usersys.redhat.com>
         <CAAF6GDdnY2AmzKx+t4ffCFxJ+RZS++4tmWvoazdVNVSYjra_WA@mail.gmail.com>
         <20170914150546.74ad3a9a@cuia.usersys.redhat.com>
         <a1715d1d-7a03-d2db-7a8a-8a2edceae5d1@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-XZi3YTtVGWBoV0g1jWxu"
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <a1715d1d-7a03-d2db-7a8a-8a2edceae5d1-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Colm =?ISO-8859-1?Q?MacC=E1rthaigh?= <colm-ZXBCfW2eEe/k1uMJSBkQmQ@public.gmane.org>
Cc: linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, nilal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Florian Weimer <fweimer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org


--=-XZi3YTtVGWBoV0g1jWxu
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64

T24gVHVlLCAyMDE3LTA5LTE5IGF0IDIxOjA3ICswMjAwLCBNaWNoYWVsIEtlcnJpc2sgKG1hbi1w
YWdlcykgd3JvdGU6Cgo+IFRoYW5rcy4gSSBhcHBsaWVkIHRoaXMsIGFuZCB0d2Vha2VkIHRoZSBt
YWR2aXNlLjIgdGV4dCBhIGxpdHRsZSwgdG8KPiByZWFkIGFzIGZvbGxvd3MgKHBsZWFzZSBsZXQg
bWUga25vdyBpZiBJIG1lc3NlZCBhbnl0aGluZyB1cCk6Cj4gCj4gwqDCoMKgwqDCoMKgwqBNQURW
X1dJUEVPTkZPUksgKHNpbmNlIExpbnV4IDQuMTQpCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoFByZXNlbnQgdGhlIGNoaWxkIHByb2Nlc3Mgd2l0aCB6ZXJvLWZpbGxlZAo+IG1lbW9yecKg
wqBpbsKgwqB0aGlzCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJhbmdlwqDCoGFmdGVy
wqDCoGEgZm9yaygyKS7CoMKgVGhpcyBpcyB1c2VmdWwgaW4gZm9ya2luZwo+IHNlcnZlcnMKPiDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgaW4gb3JkZXIgdG8gZW5zdXJlIHRoYXTCoMKgc2Vu
c2l0aXZlwqDCoHBlci0KPiBwcm9jZXNzwqDCoGRhdGHCoMKgKGZvcgo+IMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqBleGFtcGxlLMKgwqBQUk5HwqDCoHNlZWRzLCBjcnlwdG9ncmFwaGljIHNl
Y3JldHMsIGFuZCBzbwo+IG9uKSBpcwo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBub3Qg
aGFuZGVkIHRvIGNoaWxkIHByb2Nlc3Nlcy4KPiAKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgVGhlIE1BRFZfV0lQRU9ORk9SSyBvcGVyYXRpb24gY2FuIGJlIGFwcGxpZWQKPiBvbmx5wqDC
oHRvwqDCoHByaeKAkAo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqB2YXRlIGFub255bW91
cyBwYWdlcyAoc2VlIG1tYXAoMikpLgoKVGhhdCBsb29rcyBncmVhdC4gVGhhbmsgeW91LCBNaWNo
YWVsIQoKLS0gCkFsbCByaWdodHMgcmV2ZXJzZWQ=


--=-XZi3YTtVGWBoV0g1jWxu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAABCAAGBQJZwW5LAAoJEM553pKExN6DHx0H/A+rY3gziTqL3ZAWKBcAXoLb
JZDXnNUHB2tN+pQKna07HULQiWPCOve3DnQcMADDEGa8DZY2vHyjmg0gJBLQD96I
fjatk+H7S+//a0Uzj4koAgxGDVS0/10ht9ouxlKpX0y7XD4ts3o1NC2/LXh2sGMe
F3g3CxccDV3br8V2IUAvQYjm1tHuPzrIqLYtGdt8+BQD+zeePTW6Q4AXgjWGc0oK
+S0/iKeyTgrOuHan0DQv+3Fk36Qc96btl4iRpu2OUMW8pA/6cmtSqSW3ru0POzRf
Ks2cytWjeYlY7x4BpSVPUc5IIby76twl18lF8y03AN7A4U7iI/ELmPRE4/OBr/Q=
=7BXP
-----END PGP SIGNATURE-----

--=-XZi3YTtVGWBoV0g1jWxu--

--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
