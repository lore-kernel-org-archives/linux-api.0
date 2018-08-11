From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: BUG: Mount ignores mount options
Date: Fri, 10 Aug 2018 19:28:00 -0500
Message-ID: <87bma9oigf.fsf@xmission.com>
References: <20180810153902.GH21087@thunk.org> <87d0uqpba5.fsf@xmission.com>
 <153313703562.13253.5766498657900728120.stgit@warthog.procyon.org.uk>
 <22361.1533913891@warthog.procyon.org.uk>
 <28045.1533916438@warthog.procyon.org.uk>
 <20180810161400.GA627@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <apparmor-bounces-nLRlyDuq1AZFpShjVBNYrg@public.gmane.org>
In-Reply-To: <20180810161400.GA627-AKGzg7BKzIDYtjvyW6yDsg@public.gmane.org> (Theodore Y. Ts'o's message of
 "Fri, 10 Aug 2018 12:14:00 -0400")
List-Unsubscribe: <https://lists.ubuntu.com/mailman/options/apparmor>,
 <mailto:apparmor-request-nLRlyDuq1AZFpShjVBNYrg@public.gmane.org?subject=unsubscribe>
List-Archive: <https://lists.ubuntu.com/archives/apparmor>
List-Post: <mailto:apparmor-nLRlyDuq1AZFpShjVBNYrg@public.gmane.org>
List-Help: <mailto:apparmor-request-nLRlyDuq1AZFpShjVBNYrg@public.gmane.org?subject=help>
List-Subscribe: <https://lists.ubuntu.com/mailman/listinfo/apparmor>,
 <mailto:apparmor-request-nLRlyDuq1AZFpShjVBNYrg@public.gmane.org?subject=subscribe>
Errors-To: apparmor-bounces-nLRlyDuq1AZFpShjVBNYrg@public.gmane.org
Sender: "AppArmor" <apparmor-bounces-nLRlyDuq1AZFpShjVBNYrg@public.gmane.org>
To: "Theodore Y. Ts'o" <tytso-3s7WtUTddSA@public.gmane.org>
Cc: Eric Biggers <ebiggers-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org, tomoyo-dev-en-5NWGOfrQmneRv+LV9MX5uooqe+aC9MnS@public.gmane.org, Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>, Miklos Szeredi <miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org>, Stephen Smalley <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, fenghua.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, apparmor-nLRlyDuq1AZFpShjVBNYrg@public.gmane.org, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
List-Id: linux-api@vger.kernel.org

IlRoZW9kb3JlIFkuIFRzJ28iIDx0eXRzb0BtaXQuZWR1PiB3cml0ZXM6Cgo+IE9uIEZyaSwgQXVn
IDEwLCAyMDE4IGF0IDA0OjUzOjU4UE0gKzAxMDAsIERhdmlkIEhvd2VsbHMgd3JvdGU6Cj4+IFRo
ZW9kb3JlIFkuIFRzJ28gPHR5dHNvQG1pdC5lZHU+IHdyb3RlOgo+PiAKPj4gPiBFdmVuICp3aXRo
KiBmaWxlIHN5c3RlbSBzdXBwb3J0LCB0aGVyZSdzIG5vIHdheSB0b2RheSBmb3IgdGhlIFZGUyB0
bwo+PiA+IGtlZXAgdHJhY2sgb2Ygd2hldGhlciBhIHBhdGhuYW1lIHJlc29sdXRpb24gY2FtZSB0
aHJvdWdoIG9uZQo+PiA+IG1vdW50cG9pbnQgb3IgYW5vdGhlciwgc28gSSBjYW4ndCBkbyBzb21l
dGhpbmcgbGlrZSB0aGlzOgo+PiAKCj4+IEhvd2V2ZXIsIHRoZSBjYXNlIGZvbGRpbmcgc3R1ZmYg
LSBpcyB0aGF0IGEgc3VwZXJibG9ja2lzbSBvZiBhIG1vdW50cG9pbnRpc20/Cj4KPiBJdCdzIGEg
c3VwZXJibG9jay1pc20uICBBcyBmYXIgYXMgSSBrbm93IHRoZSAqb25seSogdGhpbmcgdGhhdCB3
ZSBjYW4KPiBzdXBwb3J0IGFzIGEgbW91bnQtcG9pbnRpc20gaXMgdGhlIHJvIGZsYWcsIGFuZCB0
aGF0J3MgaGFuZGxlZCBhcyBhCj4gc3BlY2lhbCBjYXNlLCBhbmQgb25seSBpZiB0aGUgb3JpZ2lu
YWwgc3VwZXJibG9jayB3YXMgbW91bnRlZAo+IHJlYWQvd3JpdGUuICBleSBUaGF0IHdhcyBteSBw
b2ludDsgYXNpZGUgZnJvbSB0aGUgcm8gZmxhZywgd2UgY2FuJ3QKPiBzdXBwb3J0IGFueSBvdGhl
ciBtb3VudCBvcHRpb25zIGFzIGEgcGVyLW1vdW50IHBvaW50IHRoaW5nLCBzbyB0aGUKPiBvbmx5
IHRoaW5nIHdlIGNhbiBkbyBpcyB0byBmYWlsIHRoZSBtb3VudCBpZiB0aGVyZSBhcmUgY29uZmxp
Y3RpbmcKPiBtb3VudCBvcHRpb25zLiAgQW5kIEknbSBub3QgcmVhbGx5IHN1cmUgaXQgaGVscHMg
dGhlIGNvbnRhaW5lciB1c2UKPiBjYXNlLCBzaW5jZSB0aGUgd2hvbGUgcG9pbnQgaXMgdGhleSB3
YW50IHRoZWlyICJndWVzdCIgdG8gYmUgYWJsZSB0bwo+IGJsaXRoZWx5IHJ1biAibW91bnQgL2Rl
di9zZGExIC1vIG5veGF0dHIgL21udCIgYW5kIG5vdCB3b3JyeSBhYm91dCB0aGUKPiBmYWN0IHRo
YXQgaW4gc29tZSBvdGhlciBjb250YWluZXIsIHNvbWVvbmUgaGFkIHJ1biAibW91bnQgL2Rldi9z
ZGExIC1vCj4geGF0dHIgL21udCIuICBCdXQgaGF2aW5nIHRoZSBzZWNvbmQgbW91bnQgZmFpbCBi
ZWNhdXNlIG9mIGNvbmZsaWN0aW5nCj4gbW91bnQgb3B0aW9uIGJyZWFrcyB0aGUgaWxsdXNpb24g
dGhhdCBjb250YWluZXJzIGFyZSBmdW5jdGlvbmFsbHkgYXMKPiByaWNoIGFzIFZNJ3MuCgpUZWQg
dGhpcyBpc24ndCBhYm91dCBzb21lIGNvbnRhaW5lciBjYXNlLgoKSXQgYWJvdXQgdGhlIGZhY3Qg
dGhhdCBwcmFjdGljYWxseSBldmVyeSBmaWxlc3lzdGVtIGluIHRoZSBrZXJuZWwgaGFzCnRoZSBi
ZWhhdmlvciBJIGhhdmUgZGVzY3JpYmVkIGFuZCBpdCBtZWFucyB0aGF0IGlmIHJvb3QgaXMgbm90
IHN1cGVyCmNhcmVmdWwgcm9vdCB3aWxsIHNob290IGhpbXNlbGYgaW4gdGhlIGZvb3Qgd2l0aCB0
aGUgc2hvdGd1biB3ZSBoYXZlCnBvaW50ZWQgdGhlcmUuCgpJdCByZWFsbHkgaXMgYWJvdXQgbG9v
c2luZyBhY2xzIG9yIHNvbWUgb3RoZXIgZmlsZXN5c3RlbSBvcHRpb24uCgoKRXJpYwoKLS0gCkFw
cEFybW9yIG1haWxpbmcgbGlzdApBcHBBcm1vckBsaXN0cy51YnVudHUuY29tCk1vZGlmeSBzZXR0
aW5ncyBvciB1bnN1YnNjcmliZSBhdDogaHR0cHM6Ly9saXN0cy51YnVudHUuY29tL21haWxtYW4v
bGlzdGluZm8vYXBwYXJtb3IK
