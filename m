From: Lyra Zhang <zhang.lyra@gmail.com>
Subject: Re: [PATCH v3 5/5] tty/serial: Add Spreadtrum sc9836-uart driver
 support
Date: Wed, 3 Dec 2014 17:17:13 +0800
Message-ID: <CAAfSe-u+g0mYGi9Adrd+YwwZ=q0-s79yCg_paB1UAVqFoufXEA@mail.gmail.com>
References: <1416917818-10506-1-git-send-email-chunyan.zhang@spreadtrum.com>
 <1416917818-10506-6-git-send-email-chunyan.zhang@spreadtrum.com>
 <54761BFC.4020705@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <54761BFC.4020705@ti.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Murali Karicheri <m-karicheri2@ti.com>
Cc: Mark Rutland <mark.rutland@arm.com>, "gnomes@lxorguk.ukuu.org.uk" <gnomes@lxorguk.ukuu.org.uk>, =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>, Mark Brown <broonie@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, "andrew@lunn.ch" <andrew@lunn.ch>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "jslaby@suse.cz" <jslaby@suse.cz>, Ramkumar Ramachandra <artagnon@gmail.com>, "lanqing.liu@spreadtrum.com" <lanqing.liu@spreadtrum.com>, Arnd Bergmann <arnd@arndb.de>, Jonathan Corbet <corbet@lwn.net>, Chunyan Zhang <chunyan.zhang@spreadtrum.com>, "zhizhou.zhang" <zhizhou.zhang@spreadtrum.com>, "geng.ren@spreadtrum.com" <geng.ren@spreadtrum.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>, Grant Likely <grant.likely@linaro.org>, Or
List-Id: linux-api@vger.kernel.org

MjAxNC0xMS0yNyAyOjI5IEdNVCswODowMCBNdXJhbGkgS2FyaWNoZXJpIDxtLWthcmljaGVyaTJA
dGkuY29tPjoKPgo+IE9uIDExLzI1LzIwMTQgMDc6MTYgQU0sIENodW55YW4gWmhhbmcgd3JvdGU6
Cj4+Cj4+IEFkZCBhIGZ1bGwgc2M5ODM2LXVhcnQgZHJpdmVyIGZvciBTQzk4MzYgU29DIHdoaWNo
IGlzIGJhc2VkIG9uIHRoZQo+PiBzcHJlYWR0cnVtIHNoYXJrbDY0IHBsYXRmb3JtLgo+PiBUaGlz
IGRyaXZlciBhbHNvIHN1cHBvcnQgZWFybHljb24uCj4+Cj4+IFsuLi5dCgoKPj4KPj4gKysrIGIv
ZHJpdmVycy90dHkvc2VyaWFsL3NwcmRfc2VyaWFsLmMKPj4gQEAgLTAsMCArMSw3NTIgQEAKPj4g
Ky8qCj4+ICsgKiBDb3B5cmlnaHQgKEMpIDIwMTIgU3ByZWFkdHJ1bSBDb21tdW5pY2F0aW9ucyBJ
bmMuCj4+ICsgKgo+PiArICogVGhpcyBzb2Z0d2FyZSBpcyBsaWNlbnNlZCB1bmRlciB0aGUgdGVy
bXMgb2YgdGhlIEdOVSBHZW5lcmFsIFB1YmxpYwo+PiArICogTGljZW5zZSB2ZXJzaW9uIDIsIGFz
IHB1Ymxpc2hlZCBieSB0aGUgRnJlZSBTb2Z0d2FyZSBGb3VuZGF0aW9uLCBhbmQKPj4gKyAqIG1h
eSBiZSBjb3BpZWQsIGRpc3RyaWJ1dGVkLCBhbmQgbW9kaWZpZWQgdW5kZXIgdGhvc2UgdGVybXMu
Cj4+ICsgKgo+PiArICogVGhpcyBwcm9ncmFtIGlzIGRpc3RyaWJ1dGVkIGluIHRoZSBob3BlIHRo
YXQgaXQgd2lsbCBiZSB1c2VmdWwsCj4+ICsgKiBidXQgV0lUSE9VVCBBTlkgV0FSUkFOVFk7IHdp
dGhvdXQgZXZlbiB0aGUgaW1wbGllZCB3YXJyYW50eSBvZgo+PiArICogTUVSQ0hBTlRBQklMSVRZ
IG9yIEZJVE5FU1MgRk9SIEEgUEFSVElDVUxBUiBQVVJQT1NFLiAgU2VlIHRoZQo+PiArICogR05V
IEdlbmVyYWwgUHVibGljIExpY2Vuc2UgZm9yIG1vcmUgZGV0YWlscy4KPj4gKyAqLwo+PiArCj4+
ICsjaW5jbHVkZTxsaW51eC9tb2R1bGUuaD4KPj4gKyNpbmNsdWRlPGxpbnV4L3R0eS5oPgo+PiAr
I2luY2x1ZGU8bGludXgvaW9wb3J0Lmg+Cj4+ICsjaW5jbHVkZTxsaW51eC9jb25zb2xlLmg+Cj4+
ICsjaW5jbHVkZTxsaW51eC9wbGF0Zm9ybV9kZXZpY2UuaD4KPj4gKyNpbmNsdWRlPGxpbnV4L3R0
eV9mbGlwLmg+Cj4+ICsjaW5jbHVkZTxsaW51eC9zZXJpYWxfY29yZS5oPgo+PiArI2luY2x1ZGU8
bGludXgvc2VyaWFsLmg+Cj4+ICsjaW5jbHVkZTxsaW51eC9kZWxheS5oPgo+PiArI2luY2x1ZGU8
bGludXgvaW8uaD4KPj4gKyNpbmNsdWRlPGFzbS9pcnEuaD4KPj4gKyNpbmNsdWRlPGxpbnV4L3Ns
YWIuaD4KPj4gKyNpbmNsdWRlPGxpbnV4L29mLmg+Cj4+ICsjaW5jbHVkZTxsaW51eC9rZXJuZWwu
aD4KPj4gKyNpbmNsdWRlPGxpbnV4L3NsYWIuaD4KPj4gKyNpbmNsdWRlPGxpbnV4L2Nsay5oPgo+
Cj4gSG93IGFib3V0IHNvcnRpbmcgdGhpcyBpbmNsdWRlcz8gYXNtL2lycS5oIGdvIGZpcnN0IGZv
bGxvd2VkIGxpbnV4LyBpbiBhbHBoYWJhdGljYWwgb3JkZXI/CgoKVGhlcmUgYXJlIGEgZmV3IGNv
bXBpbGUgd2FybmluZ3MgaWYgSSBtb3ZlZCBhc20vaXJxLmggdG8gdGhlIHRvcCBvZgphbGwgaW5j
bHVkZWQgZmlsZXMuCldhcm5pbmcgZGV0YWlscyBhcmUgYmVsb3c6CgpJbiBmaWxlIGluY2x1ZGVk
IGZyb20gZHJpdmVycy90dHkvc2VyaWFsL3NwcmRfc2VyaWFsLmM6MTQ6MDoKLi9hcmNoL2FybTY0
L2luY2x1ZGUvYXNtL2lycS5oOjY6Mzk6IHdhcm5pbmc6IOKAmHN0cnVjdCBwdF9yZWdz4oCZCmRl
Y2xhcmVkIGluc2lkZSBwYXJhbWV0ZXIgbGlzdCBbZW5hYmxlZCBieSBkZWZhdWx0XQogZXh0ZXJu
IHZvaWQgKCpoYW5kbGVfYXJjaF9pcnEpKHN0cnVjdCBwdF9yZWdzICopOwogICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICBeCi4vYXJjaC9hcm02NC9pbmNsdWRlL2FzbS9pcnEu
aDo2OjM5OiB3YXJuaW5nOiBpdHMgc2NvcGUgaXMgb25seSB0aGlzCmRlZmluaXRpb24gb3IgZGVj
bGFyYXRpb24sIHdoaWNoIGlzIHByb2JhYmx5IG5vdCB3aGF0IHlvdSB3YW50CltlbmFibGVkIGJ5
IGRlZmF1bHRdCi4vYXJjaC9hcm02NC9pbmNsdWRlL2FzbS9pcnEuaDo4OjU0OiB3YXJuaW5nOiDi
gJhzdHJ1Y3QgcHRfcmVnc+KAmQpkZWNsYXJlZCBpbnNpZGUgcGFyYW1ldGVyIGxpc3QgW2VuYWJs
ZWQgYnkgZGVmYXVsdF0KIGV4dGVybiB2b2lkIHNldF9oYW5kbGVfaXJxKHZvaWQgKCpoYW5kbGVf
aXJxKShzdHJ1Y3QgcHRfcmVncyAqKSk7CgpUaGFua3MsCkNodW55YW4KCl9fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmxpbnV4LWFybS1rZXJuZWwgbWFpbGlu
ZyBsaXN0CmxpbnV4LWFybS1rZXJuZWxAbGlzdHMuaW5mcmFkZWFkLm9yZwpodHRwOi8vbGlzdHMu
aW5mcmFkZWFkLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2xpbnV4LWFybS1rZXJuZWwK
