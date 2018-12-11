From: Florian Weimer <fweimer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Security modules and sending signals within the same
	process
Date: Tue, 11 Dec 2018 11:42:20 +0100
Message-ID: <87d0q8z6nn.fsf@oldenburg2.str.redhat.com>
References: <87lg5asilo.fsf@oldenburg.str.redhat.com>
 <e754fa24-899b-f77e-f226-0f070ebad132@tycho.nsa.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <apparmor-bounces-nLRlyDuq1AZFpShjVBNYrg@public.gmane.org>
In-Reply-To: <e754fa24-899b-f77e-f226-0f070ebad132-+05T5uksL2qpZYMLLGbcSA@public.gmane.org> (Stephen
 Smalley's message of "Fri, 30 Nov 2018 11:02:15 -0500")
List-Unsubscribe: <https://lists.ubuntu.com/mailman/options/apparmor>,
 <mailto:apparmor-request-nLRlyDuq1AZFpShjVBNYrg@public.gmane.org?subject=unsubscribe>
List-Archive: <https://lists.ubuntu.com/archives/apparmor>
List-Post: <mailto:apparmor-nLRlyDuq1AZFpShjVBNYrg@public.gmane.org>
List-Help: <mailto:apparmor-request-nLRlyDuq1AZFpShjVBNYrg@public.gmane.org?subject=help>
List-Subscribe: <https://lists.ubuntu.com/mailman/listinfo/apparmor>,
 <mailto:apparmor-request-nLRlyDuq1AZFpShjVBNYrg@public.gmane.org?subject=subscribe>
Errors-To: apparmor-bounces-nLRlyDuq1AZFpShjVBNYrg@public.gmane.org
Sender: "AppArmor" <apparmor-bounces-nLRlyDuq1AZFpShjVBNYrg@public.gmane.org>
To: Stephen Smalley <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>
Cc: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, selinux-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, apparmor-nLRlyDuq1AZFpShjVBNYrg@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

KiBTdGVwaGVuIFNtYWxsZXk6Cgo+IExvb2tzIGxpa2UgY29tbWl0IDA2NWFkZDM5NDFiZCAoInNp
Z25hbHM6IGNoZWNrX2tpbGxfcGVybWlzc2lvbigpOgo+IGRvbid0IGNoZWNrIGNyZWRzIGlmIHNh
bWVfdGhyZWFkX2dyb3VwKCkiKSBza2lwcGVkIHRoZSB1aWQtYmFzZWQKPiBjaGVja3MgaWYgdGhl
IHNlbmRlciBhbmQgdGFyZ2V0IHdlcmUgaW4gdGhlIHNhbWUgdGhyZWFkIGdyb3VwLCBidXQgbm90
Cj4gdGhlIHNlY3VyaXR5IGhvb2sgY2FsbC4gIE9uZSBjb3VsZCBhcmd1ZSB0aGF0IHRoZSBzZWN1
cml0eSBob29rIGNhbGwKPiBvdWdodCB0byBiZSBza2lwcGVkIGluIHRoYXQgY2FzZSBhcyB3ZWxs
IHVzaW5nIHRoZSBzYW1lIHJhdGlvbmFsZQo+IGdpdmVuIGluIHRoYXQgY29tbWl0LiAgTm90aGlu
ZyBhcHBlYXJzIHRvIGd1YXJhbnRlZSB0aGUgcHJvcGVydHkgeW91Cj4gc3RhdGUgYWJvdmUgZm9y
IHNlY3VyaXR5X3Rhc2tfa2lsbCBpbXBsZW1lbnRhdGlvbnMsIGFsdGhvdWdoIG5vbmUgb2YKPiB0
aGUgaW4tdHJlZSB1c2VycyBhcmUgYmFzZWQgb24gdWlkcyBvciBnaWRzIHNvIHNldHJlc3VpZC9z
ZXRyZXNnaWQKPiBzaG91bGRuJ3QgYWZmZWN0IHRoZW0uCgpPa2F5LCB0aGFua3MsIHNvIGl0IGxv
b2tzIGxpa2UgSSBkb24ndCBoYXZlIHRvIGRvIGFueXRoaW5nIHNwZWNpYWwgdG8Kc3VwcG9ydCB0
aHJlYWQgY2FuY2VsbGF0aW9uLgoKRmxvcmlhbgoKLS0gCkFwcEFybW9yIG1haWxpbmcgbGlzdApB
cHBBcm1vckBsaXN0cy51YnVudHUuY29tCk1vZGlmeSBzZXR0aW5ncyBvciB1bnN1YnNjcmliZSBh
dDogaHR0cHM6Ly9saXN0cy51YnVudHUuY29tL21haWxtYW4vbGlzdGluZm8vYXBwYXJtb3IK
