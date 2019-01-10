From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 03/15] ia64: assign syscall numbers for perf and
	seccomp
Date: Thu, 10 Jan 2019 17:24:23 +0100
Message-ID: <20190110162435.309262-4-arnd@arndb.de>
References: <20190110162435.309262-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <y2038-bounces@lists.linaro.org>
In-Reply-To: <20190110162435.309262-1-arnd@arndb.de>
List-Unsubscribe: <https://lists.linaro.org/mailman/options/y2038>,
 <mailto:y2038-request@lists.linaro.org?subject=unsubscribe>
List-Archive: <http://lists.linaro.org/pipermail/y2038/>
List-Post: <mailto:y2038@lists.linaro.org>
List-Help: <mailto:y2038-request@lists.linaro.org?subject=help>
List-Subscribe: <https://lists.linaro.org/mailman/listinfo/y2038>,
 <mailto:y2038-request@lists.linaro.org?subject=subscribe>
Errors-To: y2038-bounces@lists.linaro.org
Sender: "Y2038" <y2038-bounces@lists.linaro.org>
To: y2038@lists.linaro.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: dalias@libc.org, linux-ia64@vger.kernel.org, linux-sh@vger.kernel.org, catalin.marinas@arm.com, will.deacon@arm.com, linux@dominikbrodowski.net, jcmvbkbc@gmail.com, deepa.kernel@gmail.com, hpa@zytor.com, sparclinux@vger.kernel.org, linux-s390@vger.kernel.org, dave@stgolabs.net, mpe@ellerman.id.au, deller@gmx.de, x86@kernel.org, linux@armlinux.org.uk, mingo@redhat.com, geert@linux-m68k.org, firoz.khan@linaro.org, mattst88@gmail.com, fenghua.yu@intel.com, Arnd Bergmann <arnd@arndb.de>, heiko.carstens@de.ibm.com, linux-m68k@lists.linux-m68k.org, ink@jurassic.park.msu.ru, luto@kernel.org, tglx@linutronix.de, linux-arm-kernel@lists.infradead.org, monstr@monstr.eu, tony.luck@intel.com, linux-parisc@vger.kernel.org, linux-mips@vger.kernel.org, paul.burton@mips.com, ebiederm@xmission.com, linux-alpha@vger.kernel.org, schwidefsky@de.ibm.com, akpm@linux-foundation.org, linuxppc-dev
List-Id: linux-api@vger.kernel.org

TW9zdCBhcmNoaXRlY3R1cmVzIGhhdmUgYXNzaWduZWQgbnVtYmVycyBmb3IgYm90aCBzZWNjb21w
IGFuZApwZXJmX2V2ZW50X29wZW4sIGV2ZW4gd2hlbiB0aGV5IGRvIG5vdCBpbXBsZW1lbnQgZWl0
aGVyLgoKaWE2NCBpcyBhbiBleGNlcHRpb24gaGVyZSwgc28gZm9yIGNvbnNpc3RlbmN5IGxldHMg
YWRkIG51bWJlcnMgZm9yIGJvdGgKb2YgdGhlbS4gVW5sZXNzIENPTkZJR19QRVJGX0VWRU5UUyBh
bmQgQ09ORklHX1NFQ0NPTVAgYXJlIGltcGxlbWVudGVkLAp0aGUgc3lzdGVtIGNhbGxzIGp1c3Qg
cmV0dXJuIC1FTk9TWVMuCgpTaWduZWQtb2ZmLWJ5OiBBcm5kIEJlcmdtYW5uIDxhcm5kQGFybmRi
LmRlPgotLS0KIGFyY2gvaWE2NC9rZXJuZWwvc3lzY2FsbHMvc3lzY2FsbC50YmwgfCAyICsrCiAx
IGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspCgpkaWZmIC0tZ2l0IGEvYXJjaC9pYTY0L2tl
cm5lbC9zeXNjYWxscy9zeXNjYWxsLnRibCBiL2FyY2gvaWE2NC9rZXJuZWwvc3lzY2FsbHMvc3lz
Y2FsbC50YmwKaW5kZXggNTI1ODUyODEyMDViLi4yZTkzZGJkY2RiODAgMTAwNjQ0Ci0tLSBhL2Fy
Y2gvaWE2NC9rZXJuZWwvc3lzY2FsbHMvc3lzY2FsbC50YmwKKysrIGIvYXJjaC9pYTY0L2tlcm5l
bC9zeXNjYWxscy9zeXNjYWxsLnRibApAQCAtMzM3LDMgKzMzNyw1IEBACiAzMjUJY29tbW9uCXB3
cml0ZXYyCQkJc3lzX3B3cml0ZXYyCiAzMjYJY29tbW9uCXN0YXR4CQkJCXN5c19zdGF0eAogMzI3
CWNvbW1vbglpb19wZ2V0ZXZlbnRzCQkJc3lzX2lvX3BnZXRldmVudHMKKzMyOAljb21tb24JcGVy
Zl9ldmVudF9vcGVuCQkJc3lzX3BlcmZfZXZlbnRfb3BlbgorMzI5CWNvbW1vbglzZWNjb21wCQkJ
CXN5c19zZWNjb21wCi0tIAoyLjIwLjAKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fClkyMDM4IG1haWxpbmcgbGlzdApZMjAzOEBsaXN0cy5saW5hcm8ub3Jn
Cmh0dHBzOi8vbGlzdHMubGluYXJvLm9yZy9tYWlsbWFuL2xpc3RpbmZvL3kyMDM4Cg==
