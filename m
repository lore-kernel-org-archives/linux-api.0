From: kbuild test robot <fengguang.wu@intel.com>
Subject: [RFC PATCH] y2038: __get_old_timespec32() can be static
Date: Wed, 29 Aug 2018 20:50:52 +0800
Message-ID: <20180829125052.GA114325@lkp-g5>
References: <20180827194531.3796559-4-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <y2038-bounces@lists.linaro.org>
Content-Disposition: inline
In-Reply-To: <20180827194531.3796559-4-arnd@arndb.de>
List-Unsubscribe: <https://lists.linaro.org/mailman/options/y2038>,
 <mailto:y2038-request@lists.linaro.org?subject=unsubscribe>
List-Archive: <http://lists.linaro.org/pipermail/y2038/>
List-Post: <mailto:y2038@lists.linaro.org>
List-Help: <mailto:y2038-request@lists.linaro.org?subject=help>
List-Subscribe: <https://lists.linaro.org/mailman/listinfo/y2038>,
 <mailto:y2038-request@lists.linaro.org?subject=subscribe>
Errors-To: y2038-bounces@lists.linaro.org
Sender: "Y2038" <y2038-bounces@lists.linaro.org>
Cc: linux-arch@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, y2038@lists.linaro.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, kbuild-all@01.org, tglx@linutronix.de, torvalds@linux-foundation.org, Christoph Hellwig <hch@lst.de>, deepa.kernel@gmail.com
List-Id: linux-api@vger.kernel.org

CkZpeGVzOiBlZTE2YzhmNDE1ZTQgKCJ5MjAzODogR2xvYmFsbHkgcmVuYW1lIGNvbXBhdF90aW1l
IHRvIG9sZF90aW1lMzIiKQpTaWduZWQtb2ZmLWJ5OiBrYnVpbGQgdGVzdCByb2JvdCA8ZmVuZ2d1
YW5nLnd1QGludGVsLmNvbT4KLS0tCiB0aW1lLmMgfCAgICA0ICsrLS0KIDEgZmlsZSBjaGFuZ2Vk
LCAyIGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEva2VybmVsL3Rp
bWUvdGltZS5jIGIva2VybmVsL3RpbWUvdGltZS5jCmluZGV4IGYxOTgzZjQuLmUzYTdmN2YgMTAw
NjQ0Ci0tLSBhL2tlcm5lbC90aW1lL3RpbWUuYworKysgYi9rZXJuZWwvdGltZS90aW1lLmMKQEAg
LTg2Myw3ICs4NjMsNyBAQCBpbnQgcHV0X3RpbWVzcGVjNjQoY29uc3Qgc3RydWN0IHRpbWVzcGVj
NjQgKnRzLAogfQogRVhQT1JUX1NZTUJPTF9HUEwocHV0X3RpbWVzcGVjNjQpOwogCi1pbnQgX19n
ZXRfb2xkX3RpbWVzcGVjMzIoc3RydWN0IHRpbWVzcGVjNjQgKnRzNjQsCitzdGF0aWMgaW50IF9f
Z2V0X29sZF90aW1lc3BlYzMyKHN0cnVjdCB0aW1lc3BlYzY0ICp0czY0LAogCQkJCSAgIGNvbnN0
IHN0cnVjdCBvbGRfdGltZXNwZWMzMiBfX3VzZXIgKmN0cykKIHsKIAlzdHJ1Y3Qgb2xkX3RpbWVz
cGVjMzIgdHM7CkBAIC04NzksNyArODc5LDcgQEAgaW50IF9fZ2V0X29sZF90aW1lc3BlYzMyKHN0
cnVjdCB0aW1lc3BlYzY0ICp0czY0LAogCXJldHVybiAwOwogfQogCi1pbnQgX19wdXRfb2xkX3Rp
bWVzcGVjMzIoY29uc3Qgc3RydWN0IHRpbWVzcGVjNjQgKnRzNjQsCitzdGF0aWMgaW50IF9fcHV0
X29sZF90aW1lc3BlYzMyKGNvbnN0IHN0cnVjdCB0aW1lc3BlYzY0ICp0czY0LAogCQkJCSAgIHN0
cnVjdCBvbGRfdGltZXNwZWMzMiBfX3VzZXIgKmN0cykKIHsKIAlzdHJ1Y3Qgb2xkX3RpbWVzcGVj
MzIgdHMgPSB7Cl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
ClkyMDM4IG1haWxpbmcgbGlzdApZMjAzOEBsaXN0cy5saW5hcm8ub3JnCmh0dHBzOi8vbGlzdHMu
bGluYXJvLm9yZy9tYWlsbWFuL2xpc3RpbmZvL3kyMDM4Cg==
