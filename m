From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 19/19] y2038: use __kernel_timespec in
 sys_sched_rr_get_interval
Date: Tue, 19 May 2015 11:27:14 +0200 (CEST)
Message-ID: <alpine.DEB.2.11.1505191127020.4225@nanos>
References: <1430929826-318934-1-git-send-email-arnd@arndb.de>
 <1430929826-318934-20-git-send-email-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <y2038-bounces@lists.linaro.org>
In-Reply-To: <1430929826-318934-20-git-send-email-arnd@arndb.de>
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
Cc: libc-alpha@sourceware.org, baolin.wang@linaro.org, y2038@lists.linaro.org, linux-api@vger.kernel.org, ruchandani.tina@gmail.com, linux-kernel@vger.kernel.org, albert.aribaud@3adev.fr, john.stultz@linaro.org, bamvor.zhangjian@linaro.org
List-Id: linux-api@vger.kernel.org

T24gV2VkLCA2IE1heSAyMDE1LCBBcm5kIEJlcmdtYW5uIHdyb3RlOgoKPiBzeXNfc2NoZWRfcnJf
Z2V0X2ludGVydmFsIGlzIGVhc2lseSBjb252ZXJ0ZWQgdG8gdXNlIF9fa2VybmVsX3RpbWVzcGVj
LAo+IGJ5IGNoYW5naW5nIHRoZSBmdW5jdGlvbiBwcm90b3R5cGUuIEluIG9yZGVyIHRvIGFsbG93
IGNvbXBhdCBoYW5kbGluZwo+IG9uIDMyLWJpdCBhcmNoaXRlY3R1cmVzLCB3ZSBhbHNvIG1vdmUg
Y29tcGF0X3N5c19zY2hlZF9nZXRhZmZpbml0eQo+IGludG8gdGhlIHNhbWUgZmlsZSBhbmQgdW5p
ZnkgdGhlIGltcGxlbWVudGF0aW9uLCB3aGljaCBhdm9pZHMgY29udmVydGluZwo+IHRoZSBzdHJ1
Y3R1cmUgbXVsdGlwbGUgdGltZXMuCj4gCj4gU2lnbmVkLW9mZi1ieTogQXJuZCBCZXJnbWFubiA8
YXJuZEBhcm5kYi5kZT4KClJldmlld2VkLWJ5OiBUaG9tYXMgR2xlaXhuZXIgPHRnbHhAbGludXRy
b25peC5kZT4KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18K
WTIwMzggbWFpbGluZyBsaXN0ClkyMDM4QGxpc3RzLmxpbmFyby5vcmcKaHR0cHM6Ly9saXN0cy5s
aW5hcm8ub3JnL21haWxtYW4vbGlzdGluZm8veTIwMzgK
