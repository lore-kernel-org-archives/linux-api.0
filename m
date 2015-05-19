From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 16/19] y2038: use __kernel_timespec in
 sys_rt_sigtimedwait
Date: Tue, 19 May 2015 11:28:25 +0200 (CEST)
Message-ID: <alpine.DEB.2.11.1505191127430.4225@nanos>
References: <1430929826-318934-1-git-send-email-arnd@arndb.de>
 <1430929826-318934-17-git-send-email-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <y2038-bounces@lists.linaro.org>
In-Reply-To: <1430929826-318934-17-git-send-email-arnd@arndb.de>
List-Unsubscribe: <https://lists.linaro.org/mailman/options/y2038>,
 <mailto:y2038-request@lists.linaro.org?subject=unsubscribe>
List-Archive: <http://lists.linaro.org/pipermail/y2038/>
List-Post: <mailto:y2038@lists.linaro.org>
List-Help: <mailto:y2038-request@lists.linaro.org?subject=help>
List-Subscribe: <https://lists.linaro.org/mailman/listinfo/y2038>,
 <mailto:y2038-request@lists.linaro.org?subject=subscribe>
Errors-To: y2038-bounces@lists.linaro.org
Sender: "Y2038" <y2038-bounces@lists.linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: libc-alpha@sourceware.org, baolin.wang@linaro.org, y2038@lists.linaro.org, linux-api@vger.kernel.org, ruchandani.tina@gmail.com, LKML <linux-kernel@vger.kernel.org>, albert.aribaud@3adev.fr, John Stultz <john.stultz@linaro.org>, Oleg Nesterov <oleg@redhat.com>, bamvor.zhangjian@linaro.org
List-Id: linux-api@vger.kernel.org

T24gV2VkLCA2IE1heSAyMDE1LCBBcm5kIEJlcmdtYW5uIHdyb3RlOgoKPiBUaGlzIGlzIGEgc3Ry
YWlnaHRmb3J3YXJkIGNvbnZlcnNpb24gb2YgdGhlIG5hdGl2ZSBhbmQgY29tcGF0Cj4gc3lzX3J0
X3NpZ3RpbWVkd2FpdCBmdW5jdGlvbnMgdG8gdXNlIF9fa2VybmVsX3RpbWVzcGVjLCBzbwo+IDMy
LWJpdCB1c2VyIHNwYWNlIGNhbiBwYXNzIGEgNjQtYml0IHRpbWVfdCBpbnRvIHRoZSBuYXRpdmUK
PiBzeXNjYWxsIGFuZCB1c2UgdGhlIGNvbXBhdCBzeXNjYWxsIGZvciB0aGUgdHJhZGl0aW9uYWwg
MzItYml0Cj4gdGltZV90Lgo+IAo+IFNpZ25lZC1vZmYtYnk6IEFybmQgQmVyZ21hbm4gPGFybmRA
YXJuZGIuZGU+CgpSZXZpZXdlZC1ieTogVGhvbWFzIEdsZWl4bmVyIDx0Z2x4QGxpbnV0cm9uaXgu
ZGU+Cl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fClkyMDM4
IG1haWxpbmcgbGlzdApZMjAzOEBsaXN0cy5saW5hcm8ub3JnCmh0dHBzOi8vbGlzdHMubGluYXJv
Lm9yZy9tYWlsbWFuL2xpc3RpbmZvL3kyMDM4Cg==
