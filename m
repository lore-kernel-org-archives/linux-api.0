From: Florian Weimer <fweimer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Security modules and sending signals within the same
	process
Date: Fri, 30 Nov 2018 16:14:27 +0100
Message-ID: <87lg5asilo.fsf@oldenburg.str.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <apparmor-bounces-nLRlyDuq1AZFpShjVBNYrg@public.gmane.org>
List-Unsubscribe: <https://lists.ubuntu.com/mailman/options/apparmor>,
 <mailto:apparmor-request-nLRlyDuq1AZFpShjVBNYrg@public.gmane.org?subject=unsubscribe>
List-Archive: <https://lists.ubuntu.com/archives/apparmor>
List-Post: <mailto:apparmor-nLRlyDuq1AZFpShjVBNYrg@public.gmane.org>
List-Help: <mailto:apparmor-request-nLRlyDuq1AZFpShjVBNYrg@public.gmane.org?subject=help>
List-Subscribe: <https://lists.ubuntu.com/mailman/listinfo/apparmor>,
 <mailto:apparmor-request-nLRlyDuq1AZFpShjVBNYrg@public.gmane.org?subject=subscribe>
Errors-To: apparmor-bounces-nLRlyDuq1AZFpShjVBNYrg@public.gmane.org
Sender: "AppArmor" <apparmor-bounces-nLRlyDuq1AZFpShjVBNYrg@public.gmane.org>
To: apparmor-nLRlyDuq1AZFpShjVBNYrg@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

SXMgaXQgZ3VhcmFudGVlZCB0aGF0IHRhc2tzIGluIHRoZSBzYW1lIHRocmVhZCBncm91cCBjYW4g
YWx3YXlzIHNlbmQKc2lnbmFscyB0byBlYWNoIG90aGVyLCBpcnJlc3BlY3RpdmUgb2YgdGhlaXIg
cmVzcGVjdGl2ZSBjcmVkZW50aWFscwpzdHJ1Y3RzPwoKSXQncyBub3QgY2xlYXIgdG8gbWUgd2hl
dGhlciB0aGlzIGlzIGFsd2F5cyBwb3NzaWJsZSBiYXNlZCBvbiB0aGUKc2VjdXJpdHlfdGFza19r
aWxsIGltcGxlbWVudGF0aW9ucyBJJ3ZlIGV4YW1pbmVkLgoKSSB3YW50IHRvIHN1cHBvcnQgcGVy
LXRocmVhZCBzZXRyZXN1aWQvc2V0cmVzZ2lkLCBidXQgd2UgYWxzbyB1c2UKc2lnbmFscyBmb3Ig
aW50ZXItdGhyZWFkIGNvbW11bmljYXRpb24uICBUaGlzIGlzIG1haW5seSBmb3IgdGhyZWFkCmNh
bmNlbGxhdGlvbjsgdGhlIHNldHhnaWQgc3R1ZmYgaXNuJ3QgbmVlZGVkIGZvciB0aHJlYWRzIHdp
dGggcHJpdmF0ZQpjcmVkZW50aWFscy4gIEkgd29uZGVyIGlmIEkgbmVlZCB0byBkaXNhYmxlIGNh
bmNlbGxhdGlvbiBmb3IgdGhyZWFkcwp3aXRoIHN1Y2ggY3JlZGVudGlhbHMuCgpUaGFua3MsCkZs
b3JpYW4KCi0tIApBcHBBcm1vciBtYWlsaW5nIGxpc3QKQXBwQXJtb3JAbGlzdHMudWJ1bnR1LmNv
bQpNb2RpZnkgc2V0dGluZ3Mgb3IgdW5zdWJzY3JpYmUgYXQ6IGh0dHBzOi8vbGlzdHMudWJ1bnR1
LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2FwcGFybW9yCg==
