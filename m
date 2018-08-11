From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: BUG: Mount ignores mount options
Date: Fri, 10 Aug 2018 20:32:04 -0500
Message-ID: <87zhxtg02z.fsf@xmission.com>
References: <20180810153902.GH21087@thunk.org> <87d0uqpba5.fsf@xmission.com>
 <153313703562.13253.5766498657900728120.stgit@warthog.procyon.org.uk>
 <22361.1533913891@warthog.procyon.org.uk>
 <28045.1533916438@warthog.procyon.org.uk>
 <20180810161400.GA627@thunk.org>
 <CALCETrXC8Z-q+PzzqMC-McA7UdmFubVcs2dVsT0Dt+GbSqjF5A@mail.gmail.com>
 <20180810204639.GI627@thunk.org> <20180810221234.GC4211@magnolia>
 <20180810235447.GK627@thunk.org> <20180811003852.GA10463@magnolia>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <apparmor-bounces-nLRlyDuq1AZFpShjVBNYrg@public.gmane.org>
In-Reply-To: <20180811003852.GA10463@magnolia> (Darrick J. Wong's message of
 "Fri, 10 Aug 2018 17:38:52 -0700")
List-Unsubscribe: <https://lists.ubuntu.com/mailman/options/apparmor>,
 <mailto:apparmor-request-nLRlyDuq1AZFpShjVBNYrg@public.gmane.org?subject=unsubscribe>
List-Archive: <https://lists.ubuntu.com/archives/apparmor>
List-Post: <mailto:apparmor-nLRlyDuq1AZFpShjVBNYrg@public.gmane.org>
List-Help: <mailto:apparmor-request-nLRlyDuq1AZFpShjVBNYrg@public.gmane.org?subject=help>
List-Subscribe: <https://lists.ubuntu.com/mailman/listinfo/apparmor>,
 <mailto:apparmor-request-nLRlyDuq1AZFpShjVBNYrg@public.gmane.org?subject=subscribe>
Errors-To: apparmor-bounces-nLRlyDuq1AZFpShjVBNYrg@public.gmane.org
Sender: "AppArmor" <apparmor-bounces-nLRlyDuq1AZFpShjVBNYrg@public.gmane.org>
To: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Eric Biggers <ebiggers-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tetsuo Handa <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, SELinux-NSA <selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, tomoyo-dev-en-5NWGOfrQmneRv+LV9MX5uooqe+aC9MnS@public.gmane.org, Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>, Miklos Szeredi <miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org>, Stephen Smalley <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, Fenghua Yu <fenghua.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, apparmor-nLRlyDuq1AZFpShjVBNYrg@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Theodore Y. Ts'o" <tytso-3s7WtUTddSA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, LSM List <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linus Torvalds <torvalds@li>
List-Id: linux-api@vger.kernel.org

IkRhcnJpY2sgSi4gV29uZyIgPGRhcnJpY2sud29uZ0BvcmFjbGUuY29tPiB3cml0ZXM6Cgo+IE9u
IEZyaSwgQXVnIDEwLCAyMDE4IGF0IDA3OjU0OjQ3UE0gLTA0MDAsIFRoZW9kb3JlIFkuIFRzJ28g
d3JvdGU6Cgo+PiBUaGUgcmVhc29uIHdoeSBJIGJyaW5nIHRoaXMgdXAgaGVyZSBpcyB0aGF0IGlu
IGNvbnRhaW5lciBsYW5kLCB0aGVyZQo+PiBhcmUgdGhvc2Ugd2hvIGJlbGlldmUgdGhhdCAiY29u
dGFpbmVyIHJvb3QiIHNob3VsZCBiZSBhYmxlIHRvIG1vdW50Cj4+IGZpbGUgc3lzdGVtcywgYW5k
IGlmIHRoZSAiY29udGFpbmVyIHJvb3QiIGlzbid0IHRydXN0ZWQsIHRoZSBmYWN0IHRoYXQKPj4g
dGhlICJjb250YWluZXIgcm9vdCIgY2FuIGNyYXNoIHRoZSBob3N0IGtlcm5lbCwgb3Igd29yc2Us
IGNvcnJ1cHQgdGhlCj4+IGhvc3Qga2VybmVsIGFuZCBicmVhayBvdXQgb2YgdGhlIGNvbnRhaW5l
ciBhcyBhIHJlc3VsdCwgdGhhdCB3b3VsZCBiZQo+PiBzYWQuCj4+IAo+PiBJIHdhcyBwcmV0dHkg
c3VyZSBtb3N0IGZpbGUgc3lzdGVtIGRldmVsb3BlcnMgYXJlIG9uIHRoZSBzYW1lIHBhZ2UKPj4g
dGhhdCBhbGxvd2luZyB1bnRydXN0ZWQgImNvbnRhaW5lciByb290cyIgdGhlIGFiaWxpdHkgdG8g
bW91bnQKPj4gYXJiaXRyYXJ5IGJsb2NrIGRldmljZSBmaWxlIHN5c3RlbXMgaXMgaW5zYW5pdHku
Cj4KPiBBZ3JlZWQuCgpGb3IgbWUgSSBhbSBoYXBweSB3aXRoIGZ1c2UuICBUaGF0IGlzIHN1ZmZp
Y2llbnQgdG8gY292ZXIgYW55IGNvbnRhaW5lcgp1c2UgY2FzZXMgcGVvcGxlIGhhdmUuICAgSWYg
YW55b25lIGNvbWVzIGJ1Z2dpbmcgeW91IGZvciBtb3JlIEkgd2lsbCBiZQpoYXBweSB0byBwdXNo
IGJhY2suCgpUaGUgb25seSB0aGluZyB0aGF0IGNvbnRhaW5lcnMgaGF2ZSB0byBkbyB3aXRoIHRo
aXMgaXMgSSB3aW5kIHVwCnRvdWNoaW5nIGEgbG90IG9mIHRoZSBrZXJuZWwvdXNlciBib3VuZGFy
eSBzbyBJIGdldCB0byBzZWUgYSBsb3Qgb2YgaXQKYW5kIHNvbWV0aW1lcyBzZWUgd2VpcmQgdGhp
bmdzLgoKRXJpYwoKLS0gCkFwcEFybW9yIG1haWxpbmcgbGlzdApBcHBBcm1vckBsaXN0cy51YnVu
dHUuY29tCk1vZGlmeSBzZXR0aW5ncyBvciB1bnN1YnNjcmliZSBhdDogaHR0cHM6Ly9saXN0cy51
YnVudHUuY29tL21haWxtYW4vbGlzdGluZm8vYXBwYXJtb3IK
