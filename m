From: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Subject: [PATCH v06 21/36] uapi linux/kexec.h: use __kernel_size_t instead of
 size_t
Date: Sun,  6 Aug 2017 18:44:12 +0200
Message-ID: <20170806164428.2273-22-mikko.rapeli@iki.fi>
References: <20170806164428.2273-1-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
In-Reply-To: <20170806164428.2273-1-mikko.rapeli-X3B1VOXEql0@public.gmane.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/kexec/>
List-Post: <mailto:kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Help: <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=subscribe>
Sender: "kexec" <kexec-bounces-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Errors-To: kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Eric Biederman <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Rml4ZXMgdXNlcnNwYWNlIGNvbXBpbGF0aW9uIGVycm9yOgoKZXJyb3I6IHVua25vd24gdHlwZSBu
YW1lIOKAmHNpemVfdOKAmQogIHNpemVfdCBidWZzejsKClNpZ25lZC1vZmYtYnk6IE1pa2tvIFJh
cGVsaSA8bWlra28ucmFwZWxpQGlraS5maT4KQ2M6IGtleGVjQGxpc3RzLmluZnJhZGVhZC5vcmcK
Q2M6IEVyaWMgQmllZGVybWFuIDxlYmllZGVybUB4bWlzc2lvbi5jb20+Ci0tLQogaW5jbHVkZS91
YXBpL2xpbnV4L2tleGVjLmggfCA0ICsrLS0KIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMo
KyksIDIgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvaW5jbHVkZS91YXBpL2xpbnV4L2tleGVj
LmggYi9pbmNsdWRlL3VhcGkvbGludXgva2V4ZWMuaAppbmRleCBhYWU1ZWJmMjAyMmIuLmY5NjRk
ODNiMjc1NyAxMDA2NDQKLS0tIGEvaW5jbHVkZS91YXBpL2xpbnV4L2tleGVjLmgKKysrIGIvaW5j
bHVkZS91YXBpL2xpbnV4L2tleGVjLmgKQEAgLTUxLDkgKzUxLDkgQEAKICAqLwogc3RydWN0IGtl
eGVjX3NlZ21lbnQgewogCWNvbnN0IHZvaWQgKmJ1ZjsKLQlzaXplX3QgYnVmc3o7CisJX19rZXJu
ZWxfc2l6ZV90IGJ1ZnN6OwogCWNvbnN0IHZvaWQgKm1lbTsKLQlzaXplX3QgbWVtc3o7CisJX19r
ZXJuZWxfc2l6ZV90IG1lbXN6OwogfTsKIAogI2VuZGlmIC8qIF9fS0VSTkVMX18gKi8KLS0gCjIu
MTMuMwoKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmtl
eGVjIG1haWxpbmcgbGlzdAprZXhlY0BsaXN0cy5pbmZyYWRlYWQub3JnCmh0dHA6Ly9saXN0cy5p
bmZyYWRlYWQub3JnL21haWxtYW4vbGlzdGluZm8va2V4ZWMK
