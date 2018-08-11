From: "Theodore Y. Ts'o" <tytso-3s7WtUTddSA@public.gmane.org>
Subject: Re: BUG: Mount ignores mount options
Date: Fri, 10 Aug 2018 21:46:19 -0400
Message-ID: <20180811014619.GA14368@thunk.org>
References: <153313703562.13253.5766498657900728120.stgit@warthog.procyon.org.uk>
 <87d0uqpba5.fsf@xmission.com>
 <20180810151606.GA6515@ZenIV.linux.org.uk>
 <87pnypiufr.fsf@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <apparmor-bounces-nLRlyDuq1AZFpShjVBNYrg@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <87pnypiufr.fsf-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
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
Cc: Eric Biggers <ebiggers-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org, tomoyo-dev-en-5NWGOfrQmneRv+LV9MX5uooqe+aC9MnS@public.gmane.org, Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>, Miklos Szeredi <miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org>, Stephen Smalley <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, fenghua.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, apparmor-nLRlyDuq1AZFpShjVBNYrg@public.gmane.org, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
List-Id: linux-api@vger.kernel.org

T24gRnJpLCBBdWcgMTAsIDIwMTggYXQgMDg6MDU6NDRQTSAtMDUwMCwgRXJpYyBXLiBCaWVkZXJt
YW4gd3JvdGU6Cj4gCj4gTXkgY29tcGxhaW50IGlzIHRoYXQgdGhlIGN1cnJlbnQgaW1wbGVtZW50
ZWQgYmVoYXZpb3Igb2YgcHJhY3RpY2FsbHkKPiBldmVyeSBmaWxlc3lzdGVtIGluIHRoZSBrZXJu
ZWwsIGlzIHRoYXQgaXQgd2lsbCBpZ25vcmUgbW91bnQgb3B0aW9ucwo+IHdoZW4gbW91bnRlZCBh
IHNlY29uZCB0aW1lLgoKVGhlIGZpbGUgc3lzdGVtIGlzICoqKm5vdCoqKiBtb3VudGVkIGEgc2Vj
b25kIHRpbWUuCgpUaGUgZGVzaWduIGJ1ZyBpcyB0aGF0IHdlIGFsbG93IGJpbmQgbW91bnRzIHRv
IGJlIHNwZWNpZmllZCB2aWEgYQpibG9jayBkZXZpY2UuICBBIGJpbmQgbW91bnQgaXMgbm90ICJh
IHNlY29uZCBtb3VudCIgb2YgdGhlIGZpbGUKc3lzdGVtLiAgQmluZCBtb3VudHMgIT0gbW91bnRz
LgoKSSBoYWQgYXNzdW1lZCB3ZSBoYWQgYWxsb3dlZCBiaW5kIG1vdW50cyB0byBiZSBzcGVjaWZp
ZWQgdmlhIHRoZSBibG9jawpkZXZpY2UgYmVjYXVzZSBvZiBjb250YWluZXIgdXNlIGNhc2VzLiAg
SWYgdGhlIGNvbnRhaW5lciBmb2xrcyBkb24ndAp3YW50IGl0LCBJIHdvdWxkIGJlIHB1c2hpbmcg
dG8gc2ltcGx5IG5vdCBhbGxvdyBiaW5kIG1vdW50cyB0byBiZQpzcGVjaWZpZWQgdmlhIGJsb2Nr
IGRldmljZSBhdCBhbGwuCgpUaGUgb25seSByZWFzb24gd2h5IHdlIHNob3VsZCBzdXBwb3J0IGl0
IGlzIGJlY2F1c2Ugd2UgZG9uJ3Qgd2FudCB0bwpicmVhayBzY3JpcHRzOyBhbmQgaWYgdGhlIGdv
YWwgaXMgbm90IHRvIGJyZWFrIHNjcmlwdHMsIHRoZW4gd2UgaGF2ZQp0byBrZWVwIHRvIHRoZSBj
dXJyZW50IHNlbWFudGljcywgaG93ZXZlciBicm9rZW4geW91IHRoaW5rIGl0IGlzLgoKCQkJCQkt
IFRlZAoKLS0gCkFwcEFybW9yIG1haWxpbmcgbGlzdApBcHBBcm1vckBsaXN0cy51YnVudHUuY29t
Ck1vZGlmeSBzZXR0aW5ncyBvciB1bnN1YnNjcmliZSBhdDogaHR0cHM6Ly9saXN0cy51YnVudHUu
Y29tL21haWxtYW4vbGlzdGluZm8vYXBwYXJtb3IK
