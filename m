From: Christian Brauner <christian.brauner@ubuntu.com>
Subject: Re: [PATCH 12/23] y2038: syscalls: change remaining timeval
 to __kernel_old_timeval
Date: Mon, 11 Nov 2019 13:44:26 +0100
Message-ID: <20191111124425.bmsdg5e4ikpdh5bu@wittgenstein>
References: <20191108210236.1296047-1-arnd@arndb.de>
 <20191108211323.1806194-3-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <y2038-bounces@lists.linaro.org>
Content-Disposition: inline
In-Reply-To: <20191108211323.1806194-3-arnd@arndb.de>
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
Cc: Len Brown <len.brown@intel.com>, linux-pm@vger.kernel.org, y2038@lists.linaro.org, Benjamin Herrenschmidt <benh@kernel.crashing.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org, Stephen Boyd <sboyd@kernel.org>, Paul Mackerras <paulus@samba.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Pavel Machek <pavel@ucw.cz>, Michael Ellerman <mpe@ellerman.id.au>, linux-fsdevel@vger.kernel.org, John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, linux-api@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, Christian Brauner <christian@brauner.io>
List-Id: linux-api@vger.kernel.org

T24gRnJpLCBOb3YgMDgsIDIwMTkgYXQgMTA6MTI6MTFQTSArMDEwMCwgQXJuZCBCZXJnbWFubiB3
cm90ZToKPiBBbGwgb2YgdGhlIHJlbWFpbmluZyBzeXNjYWxscyB0aGF0IHBhc3MgYSB0aW1ldmFs
IChnZXR0aW1lb2ZkYXksIHV0aW1lLAo+IGZ1dGltZXNhdCkgY2FuIHRyaXZpYWxseSBiZSBjaGFu
Z2VkIHRvIHBhc3MgYSBfX2tlcm5lbF9vbGRfdGltZXZhbAo+IGluc3RlYWQsIHdoaWNoIGhhcyBh
IGNvbXBhdGlibGUgbGF5b3V0LCBidXQgYXZvaWRzIGFtYmlndWl0eSB3aXRoCj4gdGhlIHRpbWV2
YWwgdHlwZSBpbiB1c2VyIHNwYWNlLgo+IAo+IFNpZ25lZC1vZmYtYnk6IEFybmQgQmVyZ21hbm4g
PGFybmRAYXJuZGIuZGU+CgpTZWVtcyByZWFzb25hYmxlLgpBY2tlZC1ieTogQ2hyaXN0aWFuIEJy
YXVuZXIgPGNocmlzdGlhbi5icmF1bmVyQHVidW50dS5jb20+Cl9fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fClkyMDM4IG1haWxpbmcgbGlzdApZMjAzOEBsaXN0
cy5saW5hcm8ub3JnCmh0dHBzOi8vbGlzdHMubGluYXJvLm9yZy9tYWlsbWFuL2xpc3RpbmZvL3ky
MDM4Cg==
