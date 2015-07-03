From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [PATCH v7 09/11] KVM: arm64: guest debug,
 HW assisted debug support
Date: Fri, 03 Jul 2015 17:07:41 +0100
Message-ID: <87h9plrzqq.fsf@linaro.org>
References: <1435775343-20034-1-git-send-email-alex.bennee@linaro.org>
 <1435775343-20034-10-git-send-email-alex.bennee@linaro.org>
 <20150702084847.GB3418@arm.com> <87pp4asm6u.fsf@linaro.org>
 <20150703092323.GA1588@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
In-reply-to: <20150703092323.GA1588@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Will Deacon <will.deacon@arm.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, Catalin Marinas <Catalin.Marinas@arm.com>, Ingo Molnar <mingo@kernel.org>, Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>, Jonathan Corbet <corbet@lwn.net>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Gleb Natapov <gleb@kernel.org>, "zhichao.huang@linaro.org" <zhichao.huang@linaro.org>, "jan.kiszka@siemens.com" <jan.kiszka@siemens.com>, "bp@suse.de" <bp@suse.de>, Marc Zyngier <Marc.Zyngier@arm.com>, "r65777@freescale.com" <r65777@freescale.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "open list:ABI/API" <linux-api@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, "dahi@linux.vnet.ibm.com" <dahi@linux.vnet.ibm.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>
List-Id: linux-api@vger.kernel.org

CldpbGwgRGVhY29uIDx3aWxsLmRlYWNvbkBhcm0uY29tPiB3cml0ZXM6Cgo+IEhpIEFsZXgsCj4K
PiBPbiBUaHUsIEp1bCAwMiwgMjAxNSBhdCAwMjo1MDozM1BNICswMTAwLCBBbGV4IEJlbm7DqWUg
d3JvdGU6Cj4+IEFyZSB5b3UgaGFwcHkgd2l0aCB0aGlzPzoKPgo+IFsuLi5dCj4KPj4gKy8qKgo+
PiArICoga3ZtX2FyY2hfZGV2X2lvY3RsX2NoZWNrX2V4dGVuc2lvbgo+PiArICoKPj4gKyAqIFdl
IGN1cnJlbnRseSBhc3N1bWUgdGhhdCB0aGUgbnVtYmVyIG9mIEhXIHJlZ2lzdGVycyBpcyB1bmlm
b3JtCj4+ICsgKiBhY3Jvc3MgYWxsIENQVXMgKHNlZSBjcHVpbmZvX3Nhbml0eV9jaGVjaykuCj4+
ICsgKi8KPj4gIGludCBrdm1fYXJjaF9kZXZfaW9jdGxfY2hlY2tfZXh0ZW5zaW9uKGxvbmcgZXh0
KQo+PiAgewo+PiAgICAgICAgIGludCByOwo+PiBAQCAtNjQsNiArNzEsMTIgQEAgaW50IGt2bV9h
cmNoX2Rldl9pb2N0bF9jaGVja19leHRlbnNpb24obG9uZyBleHQpCj4+ICAgICAgICAgY2FzZSBL
Vk1fQ0FQX0FSTV9FTDFfMzJCSVQ6Cj4+ICAgICAgICAgICAgICAgICByID0gY3B1X2hhc18zMmJp
dF9lbDEoKTsKPj4gICAgICAgICAgICAgICAgIGJyZWFrOwo+PiArICAgICAgIGNhc2UgS1ZNX0NB
UF9HVUVTVF9ERUJVR19IV19CUFM6Cj4+ICsgICAgICAgICAgICAgICByID0gaHdfYnJlYWtwb2lu
dF9zbG90cyhUWVBFX0lOU1QpOwo+PiArICAgICAgICAgICAgICAgYnJlYWs7Cj4+ICsgICAgICAg
Y2FzZSBLVk1fQ0FQX0dVRVNUX0RFQlVHX0hXX1dQUzoKPj4gKyAgICAgICAgICAgICAgIHIgID0g
aHdfYnJlYWtwb2ludF9zbG90cyhUWVBFX0RBVEEpOwo+PiArICAgICAgICAgICAgICAgYnJlYWs7
Cj4KPiBXaGlsc3QgSSBtdWNoIHByZWZlciB0aGlzIGNvZGUsIGl0IGFjdHVhbGx5IGFkZHMgYW4g
dW53YW50ZWQgZGVwZW5kZW5jeQo+IG9uIFBFUkZfRVZFTlRTIHRoYXQgSSBkaWRuJ3QgdGhpbmsg
YWJvdXQgdG8gc3RhcnQgd2l0aC4gU29ycnkgdG8ga2VlcAo+IG1lc3NpbmcgeW91IGFib3V0IC0t
IEkgZ3Vlc3MgeW91ciBvcmlnaW5hbCBwYXRjaCBpcyB0aGUgYmVzdCB0aGluZyBhZnRlcgo+IGFs
bC4KCkV2ZXJ5dGhpbmcgbG9va3MgdG8gYmUgaW4gaHdfYnJlYWtwb2ludC5bY2hdIHdoaWNoIGRv
ZXMgZGVwZW5kIG9uCkNPTkZJR19IQVZFX0hXX0JSRUFLUE9JTlQgd2hpY2ggZGVwZW5kcyBvbiBQ
RVJGX0VWRU5UUyB0byBiZSBidWlsdC4KSG93ZXZlciB0aGUgcHJldmlvdXMgY29kZSBkZXBlbmRl
ZCBvbiB0aGlzIGJlaGF2aW91ciBhcyB3ZWxsLgoKSXQgd291bGQgc2VlbSB3ZWlyZCB0byBlbmFi
bGUgZ3Vlc3QgZGVidWcgdXNpbmcgSFcgZGVidWcgcmVnaXN0ZXJzIHRvCmRlYnVnIHRoZSBndWVz
dCB5ZXQgbm90IGFsbG93aW5nIHRoZSBob3N0IGtlcm5lbCB0byB1c2UgdGhlbT8gT2YgY291cnNl
CnRoaXMgaXMgdGhlIG9ubHkgY29kZSB0aGV5IHdvdWxkIHNoYXJlIGFzIGFsbCB0aGUgbWFnaWMg
b2YgZ3Vlc3QKZGVidWdnaW5nIGlzIGFscmVhZHkgbW9zdGx5IHRoZXJlIGZvciBkaXJ0eSBndWVz
dCBoYW5kbGluZy4KCkknbSBub3QgZmFtaWxpYXIgd2l0aCBLY29uZmlnIGJ1dCBpdCBsb29rcyBs
aWtlIHRoaXMgaXMgYWxsIHBhcnQgb2YKYXJtNjQgZGVmY29uZmlnLiBBcmUgcGVvcGxlIHJlYWxs
eSBnb2luZyB0byB3YW50IHRvIGRpc2FibGUgUEVSRl9FVkVOVFMKYnV0IHN0aWxsIGRlYnVnIHRo
ZWlyIGd1ZXN0cyB3aXRoIEhXIHN1cHBvcnQ/Cgo+Cj4gV2lsbAoKLS0gCkFsZXggQmVubsOpZQpf
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFp
bGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5j
b2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
