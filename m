From: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Subject: Re: BUG: Mount ignores mount options
Date: Sat, 11 Aug 2018 17:51:24 +0100
Message-ID: <20180811165123.GH6515@ZenIV.linux.org.uk>
References: <87pnyphf8i.fsf@xmission.com> <87d0uqpba5.fsf@xmission.com>
 <153313703562.13253.5766498657900728120.stgit@warthog.procyon.org.uk>
 <22361.1533913891@warthog.procyon.org.uk>
 <30365.1533972586@warthog.procyon.org.uk>
 <9B6E2781-484B-4C42-95F5-F900EA36CEA5@amacapital.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <apparmor-bounces-nLRlyDuq1AZFpShjVBNYrg@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <9B6E2781-484B-4C42-95F5-F900EA36CEA5-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
List-Unsubscribe: <https://lists.ubuntu.com/mailman/options/apparmor>,
 <mailto:apparmor-request-nLRlyDuq1AZFpShjVBNYrg@public.gmane.org?subject=unsubscribe>
List-Archive: <https://lists.ubuntu.com/archives/apparmor>
List-Post: <mailto:apparmor-nLRlyDuq1AZFpShjVBNYrg@public.gmane.org>
List-Help: <mailto:apparmor-request-nLRlyDuq1AZFpShjVBNYrg@public.gmane.org?subject=help>
List-Subscribe: <https://lists.ubuntu.com/mailman/listinfo/apparmor>,
 <mailto:apparmor-request-nLRlyDuq1AZFpShjVBNYrg@public.gmane.org?subject=subscribe>
Errors-To: apparmor-bounces-nLRlyDuq1AZFpShjVBNYrg@public.gmane.org
Sender: "AppArmor" <apparmor-bounces-nLRlyDuq1AZFpShjVBNYrg@public.gmane.org>
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Eric Biggers <ebiggers-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org, tomoyo-dev-en-5NWGOfrQmneRv+LV9MX5uooqe+aC9MnS@public.gmane.org, Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>, Miklos Szeredi <miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org>, Stephen Smalley <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, fenghua.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, apparmor-nLRlyDuq1AZFpShjVBNYrg@public.gmane.org, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Theodore Y. Ts'o" <tytso-3s7WtUTddSA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
List-Id: linux-api@vger.kernel.org

T24gU2F0LCBBdWcgMTEsIDIwMTggYXQgMDk6MzE6MjlBTSAtMDcwMCwgQW5keSBMdXRvbWlyc2tp
IHdyb3RlOgoKPiBJIGRvbuKAmXQgc2VlIHdoeSB3ZSBuZWVkIGFsbCB0aGlzIGZhbmN5IOKAnGRv
IHRoZSBvcHRpb25zIG1hdGNo4oCdIHN0dWZmLiAgRm9yIHRoZSBoYW5kZnVsIG9mIGZpbGVzeXN0
ZW1zIChsaWtlIE5GUykgdGhhdCBkbyBzb21ldGhpbmcgaW50ZWxsaWdlbnQgd2hlbiBtdWx0aXBs
ZSBub24tYmluZCBtb3VudCByZXF1ZXN0cyBhZ2FpbnN0IHRoZSBzYW1lIHVuZGVybHlpbmcgc3Rv
cmFnZSBoYXBwZW4sICB3ZSBjYW4ga2VlcCB0aGF0IGJlaGF2aW9yIGluIHRoZSBuZXcgQVBJLiBG
b3Igb3RoZXIgZmlsZXN5c3RlbXMgdGhhdCBkb27igJl0IGhhdmUgdGhpcyBmZWF0dXJlLCB3ZSBz
aG91bGQgc2ltcGx5IGZhaWwgdGhlIHJlcXVlc3QuCgo+IElPVyBJIHNlZSBzbyBjb21wZWxsaW5n
IHJlYXNvbiB0byBjYWxsIHNnZXQoKSBhdCBhbGwgZnJvbSB0aGUgbmV3IEFQSS4gIFRoZSBvbmx5
IHNvcnQtb2YtbGVnaXQgdXNlIGNhc2UgSSBjYW4gdGhpbmsgb2YgaXMgbW91bnRpbmcgbW9yZSB0
aGFuIG9uZSBidHJmcyBzdWJ2b2x1bWUuIEJ1dCBldmVuIHRoYXQgc2hvdWxkIHByb2JhYmx5IG5v
dCBiZSBkb25lIGJ5IGFza2luZyB0aGUga2VybmVsIHRvIHNlcGFyYXRlbHkgaW5zdGFudGlhdGUg
dGhlIGZpbGVzeXN0ZW0uCgoKTWF5IEkgcG9saXRlbHkgc3VnZ2VzdCB0aGUgZXN0ZWVtZWQgcGFy
dGljaXBhbnRzIG9mIHRoYXQgY29udmVyc2F0aW9uCnRvIFJURlM/ICBZZXMsIEkga25vdyB0aGF0
IGl0J3MgbGVzcyBmdW4gdGhhdCB0YWxraW5nIGFib3V0IHlvdXIKcmF0aGVyIHZhZ3VlIGlkZWFz
IG9mIGhvdyB0aGUgdGhpbmdzIChzdXJlbHkpIHdvcmssIGJ1dCBpdCBqdXN0IG1pZ2h0CmF2b2lk
IHRoZSBmZWF0cyBvZiBpZGlvY3kgbGlrZSB0aGUgYWJvdmUuCgpBbmR5LCBJIGRvbid0IGtub3cg
aG93IHRvIHB1dCBpdCBtb3JlIHBsYWlubHk6IHJlYWQgdGhlIGZ1Y2tpbmcgc291cmNlLgpFdmVu
IGdyZXAgd291bGQgZG8uICBUaGUgc2FtZSBORlMgeW91J3ZlIGdyYW50ZWQgKGFtb25nIHRoZSAi
aGFuZGZ1bCIKb2YgZmlsZXN5c3RlbXMpIGFuIGV4Y2VwdGlvbiwgKkRPRVMqICpDQUxMKiAqVEhF
KiAqRlVDS0lORyogc2dldCgpLgoKWWVzLCByZWFsbHkuICBBbmQgaW4gc29tZSBvYnNjdXJlWzFd
IGNhc2VzIChpbmNsdWRpbmcgdGhlIG9uZSBtZW50aW9uZWQKdXB0aHJlYWQpIGl0IGRvZXMgcmV1
c2UgYSBwcmUtZXhpc3Rpbmcgc3VwZXJibG9jay4gIEZvciBhIHZlcnkgZ29vZApyZWFzb24uCgpb
MV0gc3VjaCBhcywgb2gsIG1vdW50aW5nIHR3byBmaWxlc3lzdGVtcyBmcm9tIHRoZSBzYW1lIHNl
cnZlciB3aXRoCmRlZmF1bHQgb3B0aW9ucyAtIHdobyB3b3VsZCd2ZSBldmVyIHRob3VnaHQgb2Yg
ZG9pbmcgc29tZXRoaW5nIHNvCnBlcnZlcnRlZD8KCi0tIApBcHBBcm1vciBtYWlsaW5nIGxpc3QK
QXBwQXJtb3JAbGlzdHMudWJ1bnR1LmNvbQpNb2RpZnkgc2V0dGluZ3Mgb3IgdW5zdWJzY3JpYmUg
YXQ6IGh0dHBzOi8vbGlzdHMudWJ1bnR1LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2FwcGFybW9yCg==
