From: Edward Napierala <trasz@freebsd.org>
Subject: Re: [PATCH v2 0/2] mm: introduce MAP_FIXED_SAFE
Date: Thu, 14 Dec 2017 12:44:17 +0000
Message-ID: <CAFLM3-oANXKEU=tuurSJx9rdzfWGfym-0FUEWnfBq8mOaVMzOA@mail.gmail.com>
References: <20171213092550.2774-1-mhocko@kernel.org> <20171213163210.6a16ccf8753b74a6982ef5b6@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/alternative; boundary="001a11458e22081e6a05604c3e56"
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20171213163210.6a16ccf8753b74a6982ef5b6@linux-foundation.org>
Sender: owner-linux-mm@kvack.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@kernel.org>, linux-api@vger.kernel.org, Khalid Aziz <khalid.aziz@oracle.com>, Michael Ellerman <mpe@ellerman.id.au>, Russell King - ARM Linux <linux@armlinux.org.uk>, Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org, Florian Weimer <fweimer@redhat.com>, John Hubbard <jhubbard@nvidia.com>, Matthew Wilcox <willy@infradead.org>, Abdul Haleem <abdhalee@linux.vnet.ibm.com>, Joel Stanley <joel@jms.id.au>, Kees Cook <keescook@chromium.org>, Michal Hocko <mhocko@suse.com>, jasone@google.com, davidtgoldblatt@gmail.com
List-Id: linux-api@vger.kernel.org

--001a11458e22081e6a05604c3e56
Content-Type: text/plain; charset="UTF-8"

Regarding the name - how about adopting MAP_EXCL?  It was introduced in
FreeBSD,
and seems to do exactly this; quoting mmap(2):

MAP_FIXED    Do not permit the system to select a different address
                        than the one specified.  If the specified address
                        cannot be used, mmap() will fail.  If MAP_FIXED is
                        specified, addr must be a multiple of the page size.
                        If MAP_EXCL is not specified, a successful MAP_FIXED
                        request replaces any previous mappings for the
                        process' pages in the range from addr to addr + len.
                        In contrast, if MAP_EXCL is specified, the request
                        will fail if a mapping already exists within the
                        range.

--001a11458e22081e6a05604c3e56
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: base64

PGRpdiBkaXI9Imx0ciI+UmVnYXJkaW5nIHRoZSBuYW1lIC0gaG93IGFib3V0IGFkb3B0aW5nIE1B
UF9FWENMP8KgIEl0IHdhcyBpbnRyb2R1Y2VkIGluIEZyZWVCU0QsPGRpdj5hbmQgc2VlbXMgdG8g
ZG8gZXhhY3RseSB0aGlzOyBxdW90aW5nIG1tYXAoMik6PC9kaXY+PGRpdj48YnI+PC9kaXY+PGRp
dj5NQVBfRklYRUQgwqAgwqBEbyBub3QgcGVybWl0IHRoZSBzeXN0ZW0gdG8gc2VsZWN0IGEgZGlm
ZmVyZW50IGFkZHJlc3M8YnI+PC9kaXY+PGRpdj48ZGl2PsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIHRoYW4gdGhlIG9uZSBzcGVjaWZpZWQuwqAgSWYgdGhlIHNwZWNpZmllZCBh
ZGRyZXNzPC9kaXY+PGRpdj7CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBjYW5u
b3QgYmUgdXNlZCwgbW1hcCgpIHdpbGwgZmFpbC7CoCBJZiBNQVBfRklYRUQgaXM8L2Rpdj48ZGl2
PsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIHNwZWNpZmllZCwgYWRkciBtdXN0
IGJlIGEgbXVsdGlwbGUgb2YgdGhlIHBhZ2Ugc2l6ZS48L2Rpdj48ZGl2PsKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIElmIE1BUF9FWENMIGlzIG5vdCBzcGVjaWZpZWQsIGEgc3Vj
Y2Vzc2Z1bCBNQVBfRklYRUQ8L2Rpdj48ZGl2PsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIHJlcXVlc3QgcmVwbGFjZXMgYW55IHByZXZpb3VzIG1hcHBpbmdzIGZvciB0aGU8L2Rp
dj48ZGl2PsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIHByb2Nlc3MmIzM5OyBw
YWdlcyBpbiB0aGUgcmFuZ2UgZnJvbSBhZGRyIHRvIGFkZHIgKyBsZW4uPC9kaXY+PGRpdj7CoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBJbiBjb250cmFzdCwgaWYgTUFQX0VYQ0wg
aXMgc3BlY2lmaWVkLCB0aGUgcmVxdWVzdDwvZGl2PjxkaXY+wqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgd2lsbCBmYWlsIGlmIGEgbWFwcGluZyBhbHJlYWR5IGV4aXN0cyB3aXRo
aW4gdGhlPC9kaXY+PGRpdj7CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCByYW5n
ZS48L2Rpdj48L2Rpdj48ZGl2Pjxicj48L2Rpdj48L2Rpdj4NCg==
--001a11458e22081e6a05604c3e56--

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
