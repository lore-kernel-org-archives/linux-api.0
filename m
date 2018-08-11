From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: BUG: Mount ignores mount options
Date: Sat, 11 Aug 2018 08:29:46 +0100
Message-ID: <30365.1533972586@warthog.procyon.org.uk>
References: <87pnyphf8i.fsf@xmission.com> <87d0uqpba5.fsf@xmission.com>
 <153313703562.13253.5766498657900728120.stgit@warthog.procyon.org.uk>
 <22361.1533913891@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <apparmor-bounces-nLRlyDuq1AZFpShjVBNYrg@public.gmane.org>
In-Reply-To: <87pnyphf8i.fsf-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Content-ID: <30364.1533972586.1-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
List-Unsubscribe: <https://lists.ubuntu.com/mailman/options/apparmor>,
 <mailto:apparmor-request-nLRlyDuq1AZFpShjVBNYrg@public.gmane.org?subject=unsubscribe>
List-Archive: <https://lists.ubuntu.com/archives/apparmor>
List-Post: <mailto:apparmor-nLRlyDuq1AZFpShjVBNYrg@public.gmane.org>
List-Help: <mailto:apparmor-request-nLRlyDuq1AZFpShjVBNYrg@public.gmane.org?subject=help>
List-Subscribe: <https://lists.ubuntu.com/mailman/listinfo/apparmor>,
 <mailto:apparmor-request-nLRlyDuq1AZFpShjVBNYrg@public.gmane.org?subject=subscribe>
Errors-To: apparmor-bounces-nLRlyDuq1AZFpShjVBNYrg@public.gmane.org
Sender: "AppArmor" <apparmor-bounces-nLRlyDuq1AZFpShjVBNYrg@public.gmane.org>
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: Eric Biggers <ebiggers-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org, tomoyo-dev-en-5NWGOfrQmneRv+LV9MX5uooqe+aC9MnS@public.gmane.org, Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>, Miklos Szeredi <miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org>, Stephen Smalley <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, fenghua.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, apparmor-nLRlyDuq1AZFpShjVBNYrg@public.gmane.org, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Theodore Y. Ts'o" <tytso-3s7WtUTddSA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
List-Id: linux-api@vger.kernel.org

RXJpYyBXLiBCaWVkZXJtYW4gPGViaWVkZXJtQHhtaXNzaW9uLmNvbT4gd3JvdGU6Cgo+ID4gWWVz
LCBJIGFncmVlIGl0IHdvdWxkIGJlIG5pY2UgdG8gaGF2ZSwgYnV0IGl0ICpkb2Vzbid0KiByZWFs
bHkgbmVlZAo+ID4gc3VwcG9ydGluZyByaWdodCB0aGlzIG1pbnV0ZSwgc2luY2Ugd2hhdCBJIGhh
dmUgbm93IG91Z2h0bid0IHRvIGJyZWFrIHRoZQo+ID4gY3VycmVudCBiZWhhdmlvdXIuCj4gCj4g
SSBhbSByZWFsbHkgcmVsdWN0YW50IHRvIGVuZG9yc2UgYW55dGhpbmcgdGhhdCBwcm9wYWdhdGVz
IHRoZSBpc3N1ZXMgb2YKPiB0aGUgY3VycmVudCBpbnRlcmZhY2UgaW4gdGhlIG5ldyBtb3VudCBp
bnRlcmZhY2UuCgpEbyByZWFsaXNlIHRoYXQgeW91ciBwcm9ibGVtIGNhbm5vdCBiZSBzb2x2ZWQg
dGhyb3VnaCBmc29wZW4oKSB1bnRpbCBldmVyeQpmaWxlc3lzdGVtIGlzIGNvbnZlcnRlZCB0byB0
aGUgbmV3IGZzX2NvbnRleHQtYmFzZWQgc2dldCgpIHNpbmNlIHRoZSBmbGFnIGhhcwp0byBtYWtl
IGl0IGZyb20gdGhlIFZGUyB0aHJvdWdoIHRoZSBmaWxlc3lzdGVtIHRvIHNnZXQoKS4KCkknbSBy
ZWx1Y3RhbnQgdG8gYWRkIHRoaXMgZmxhZyB0aWxsIHRoYXQgcG9pbnQgdW50aWwgdGhhdCB0aW1l
IHVubGVzcyB3ZSBlcnJvcgpvdXQgaWYgdGhlIGZsYWcgaXMgc2V0IGFnYWluc3QgYSBsZWdhY3kg
ZmlsZXN5c3RlbS4KCkRhdmlkCgotLSAKQXBwQXJtb3IgbWFpbGluZyBsaXN0CkFwcEFybW9yQGxp
c3RzLnVidW50dS5jb20KTW9kaWZ5IHNldHRpbmdzIG9yIHVuc3Vic2NyaWJlIGF0OiBodHRwczov
L2xpc3RzLnVidW50dS5jb20vbWFpbG1hbi9saXN0aW5mby9hcHBhcm1vcgo=
