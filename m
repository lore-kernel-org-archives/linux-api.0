From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH v06 14/36] arm uapi asm/signal.h: include <stddef.h> for
 size_t in userspace
Date: Sun,  6 Aug 2017 18:44:05 +0200
Message-ID: <20170806164428.2273-15-mikko.rapeli@iki.fi>
References: <20170806164428.2273-1-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20170806164428.2273-1-mikko.rapeli@iki.fi>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Mikko Rapeli <mikko.rapeli@iki.fi>, Russell King <linux@armlinux.org.uk>, Arnd Bergmann <arnd@arndb.de>
List-Id: linux-api@vger.kernel.org

QXJuZCBCZXJnbWFubiA8YXJuZEBhcm5kYi5kZT4gZG91YnRzIHRoYXQgX19rZXJuZWxfc2l6ZV90
IGNvdWxkIGJlIHVzZWQgaGVyZQpzbyB0cnlpbmcgdG8gZmFsbCBiYWNrIHRvIGdjYydzIDxzdGRk
ZWYuaD4uCgpGaXhlcyB1YXBpIGhlYWRlciBjb21waWxhdGlvbiBlcnJvciBmcm9tIHVzZXJzcGFj
ZSBvbiBBUkNIPWFybToKCmFzbS9zaWduYWwuaDoxMTI6MjogZXJyb3I6IHVua25vd24gdHlwZSBu
YW1lIOKAmHNpemVfdOKAmQogIHNpemVfdCBzc19zaXplOwoKU2lnbmVkLW9mZi1ieTogTWlra28g
UmFwZWxpIDxtaWtrby5yYXBlbGlAaWtpLmZpPgpDYzogQXJuZCBCZXJnbWFubiA8YXJuZEBhcm5k
Yi5kZT4KLS0tCiBhcmNoL2FybS9pbmNsdWRlL3VhcGkvYXNtL3NpZ25hbC5oIHwgMiArKwogMSBm
aWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKQoKZGlmZiAtLWdpdCBhL2FyY2gvYXJtL2luY2x1
ZGUvdWFwaS9hc20vc2lnbmFsLmggYi9hcmNoL2FybS9pbmNsdWRlL3VhcGkvYXNtL3NpZ25hbC5o
CmluZGV4IDMzMDczYmRjZjA5MS4uNjMwNjZmNjI0YzEwIDEwMDY0NAotLS0gYS9hcmNoL2FybS9p
bmNsdWRlL3VhcGkvYXNtL3NpZ25hbC5oCisrKyBiL2FyY2gvYXJtL2luY2x1ZGUvdWFwaS9hc20v
c2lnbmFsLmgKQEAgLTEyLDYgKzEyLDggQEAgc3RydWN0IHNpZ2luZm87CiAjZGVmaW5lIE5TSUcJ
CTMyCiB0eXBlZGVmIHVuc2lnbmVkIGxvbmcgc2lnc2V0X3Q7CiAKKyNpbmNsdWRlIDxzdGRkZWYu
aD4KKwogI2VuZGlmIC8qIF9fS0VSTkVMX18gKi8KIAogI2RlZmluZSBTSUdIVVAJCSAxCi0tIAoy
LjEzLjMKCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwps
aW51eC1hcm0ta2VybmVsIG1haWxpbmcgbGlzdApsaW51eC1hcm0ta2VybmVsQGxpc3RzLmluZnJh
ZGVhZC5vcmcKaHR0cDovL2xpc3RzLmluZnJhZGVhZC5vcmcvbWFpbG1hbi9saXN0aW5mby9saW51
eC1hcm0ta2VybmVsCg==
