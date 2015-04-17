From: Jean Delvare <jdelvare@suse.de>
Subject: Re: [dmidecode] [Patch 1/3] firmware: dmi_scan: rename dmi_table to
 dmi_decode_table
Date: Fri, 17 Apr 2015 16:12:49 +0200
Message-ID: <1429279969.4600.0.camel@chaos.site>
References: <1427979423-22767-1-git-send-email-ivan.khoronzhuk@globallogic.com>
	<1427979423-22767-2-git-send-email-ivan.khoronzhuk@globallogic.com>
	<20150415143530.GF4804@codeblueprint.co.uk>
	<20150416103511.55927ccc@endymion.delvare>
	<20150417134036.GA3671@codeblueprint.co.uk>
Reply-To: dmidecode-devel@nongnu.org
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dmidecode-devel-bounces+ghsdd-dmidecode-devel=m.gmane.org@nongnu.org>
In-Reply-To: <20150417134036.GA3671@codeblueprint.co.uk>
List-Unsubscribe: <https://lists.nongnu.org/mailman/options/dmidecode-devel>,
	<mailto:dmidecode-devel-request@nongnu.org?subject=unsubscribe>
List-Archive: <http://lists.nongnu.org/archive/html/dmidecode-devel>
List-Post: <mailto:dmidecode-devel@nongnu.org>
List-Help: <mailto:dmidecode-devel-request@nongnu.org?subject=help>
List-Subscribe: <https://lists.nongnu.org/mailman/listinfo/dmidecode-devel>,
	<mailto:dmidecode-devel-request@nongnu.org?subject=subscribe>
Errors-To: dmidecode-devel-bounces+ghsdd-dmidecode-devel=m.gmane.org@nongnu.org
Sender: dmidecode-devel-bounces+ghsdd-dmidecode-devel=m.gmane.org@nongnu.org
To: Matt Fleming <matt@codeblueprint.co.uk>
Cc: dmidecode-devel@nongnu.org, matt.fleming@intel.com, ard.biesheuvel@linaro.org, linux-api@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, leif.lindholm@linaro.org, mikew@google.com, roy.franz@linaro.org, Ivan Khoronzhuk <ivan.khoronzhuk@globallogic.com>, msalter@redhat.com, grant.likely@linaro.org
List-Id: linux-api@vger.kernel.org

SGkgTWF0dCwKCkxlIEZyaWRheSAxNyBBcHJpbCAyMDE1IMOgIDE0OjQwICswMTAwLCBNYXR0IEZs
ZW1pbmcgYSDDqWNyaXQgOgo+IE9uIFRodSwgMTYgQXByLCBhdCAxMDozNToxMUFNLCBKZWFuIERl
bHZhcmUgd3JvdGU6Cj4gPiAKPiA+IEkgZG9uJ3QgcmVhbGx5IGNhcmUgd2hvIHBpY2tzIHRoZXNl
IHBhdGNoZXMgdXAgYW5kIHNlbmRzIHRoZW0gdG8gTGludXMsCj4gPiBidXQgSSB0aGluayB0aGV5
IHNob3VsZCBhbGwgZm9sbG93IHRoZSBzYW1lIHJvdXRlIHNvIHRoYXQgTGludXMgaGFzIGFzCj4g
PiBsaXR0bGUgbWVyZ2Ugd29yayB0byBkbyBhcyBwb3NzaWJsZS4gU28gZWl0aGVyIHlvdSBwaWNr
IHRoZW0gYWxsLCBvciBJCj4gPiBkby4gSWYgSSBkbywgeW91J2xsIGhhdmUgdG8gZHJvcCB0aGUg
MiBwYXRjaGVzIHlvdSBoYXZlIGluIGVmaS1uZXh0Lgo+ID4gQWdhaW4gSSdtIGZpbmUgZWl0aGVy
IHdheSwgc28gcGxlYXNlIGxldCBtZSBrbm93IHdoYXQgbWFrZXMgeW91ciBsaWZlCj4gPiBlYXNp
ZXIgYW5kIGxldCdzIGRvIHRoYXQuCj4gCj4gQXMgd2FzIG1lbnRpb25lZCBieSBJdmFuLCB0aGUg
Zm9sbG93aW5nIHBhdGNoZXMgaGF2ZSBhbHJlYWR5IGJlZW4gbWVyZ2VkCj4gYnkgTGludXMsCj4g
Cj4gICBmNjE3YjBmMzJkYTIgKCJmaXJtd2FyZTogZG1pX3NjYW46IFVzZSBmdWxsIGRtaSB2ZXJz
aW9uIGZvciBTTUJJT1MzIikKPiAgIGU0YjFkZWM0NDhhZiAoImZpcm13YXJlOiBkbWlfc2Nhbjog
VXNlIGRpcmVjdCBhY2Nlc3MgdG8gc3RhdGljIHZhcnMiKQo+IAo+IHNvIG5vIHBhdGNoZXMgbmVl
ZCB0byBiZSBkcm9wcGVkIGZyb20gbXkgdHJlZSBhbmQgdGhlcmUgYXJlIG5vIHBlbmRpbmcKPiBE
TUkvU01CSU9TIHBhdGNoZXMgaW4gYW55IG9mIG15IGJyYW5jaGVzLgoKQ29ycmVjdC4KCj4gSG93
IGFib3V0IHlvdSBnbyBhaGVhZCBhbmQgY29sbGVjdCBhbGwgdGhlIHBhdGNoZXMgYW5kIHNlbmQg
dGhlbSB0bwo+IExpbnVzPyBJJ20gaGFwcHkgdG8gcGlja3VwIGFueSBwYXRjaGVzIGluIHRoZSBm
dXR1cmUgaWYgSSdtIGV4cGxpY2l0bHkKPiBhc2tlZCwgYnV0IG9ubHkgaWYgT0snZCBieSB5b3Us
IEplYW4uCj4gCj4gU291bmQgT0sgdG8gZXZlcnlvbmU/CgpEZWFsISA6LSkKCi0tIApKZWFuIERl
bHZhcmUKU1VTRSBMMyBTdXBwb3J0CgoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX18KaHR0cHM6Ly9saXN0cy5ub25nbnUub3JnL21haWxtYW4vbGlzdGluZm8v
ZG1pZGVjb2RlLWRldmVsCg==
