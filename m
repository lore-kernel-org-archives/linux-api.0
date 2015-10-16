From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [RFC 0/6] Non perf based Gen Graphics OA unit driver
Date: Fri, 16 Oct 2015 12:02:28 +0200
Message-ID: <20151016100228.GA22732@gmail.com>
References: <1443537549-6905-1-git-send-email-robert@sixbynine.org>
 <20151016094306.GA3604@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <intel-gfx-bounces@lists.freedesktop.org>
Content-Disposition: inline
In-Reply-To: <20151016094306.GA3604@twins.programming.kicks-ass.net>
List-Unsubscribe: <http://lists.freedesktop.org/mailman/options/intel-gfx>,
 <mailto:intel-gfx-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <http://lists.freedesktop.org/archives/intel-gfx>
List-Post: <mailto:intel-gfx@lists.freedesktop.org>
List-Help: <mailto:intel-gfx-request@lists.freedesktop.org?subject=help>
List-Subscribe: <http://lists.freedesktop.org/mailman/listinfo/intel-gfx>,
 <mailto:intel-gfx-request@lists.freedesktop.org?subject=subscribe>
Errors-To: intel-gfx-bounces@lists.freedesktop.org
Sender: "Intel-gfx" <intel-gfx-bounces@lists.freedesktop.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mark Rutland <mark.rutland@arm.com>, Matt Fleming <matt.fleming@intel.com>, dri-devel@lists.freedesktop.org, David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Sourab Gupta <sourab.gupta@intel.com>, linux-api@vger.kernel.org, Zheng Yan <zheng.z.yan@intel.com>, Daniel Vetter <daniel.vetter@intel.com>
List-Id: linux-api@vger.kernel.org

CiogUGV0ZXIgWmlqbHN0cmEgPHBldGVyekBpbmZyYWRlYWQub3JnPiB3cm90ZToKCj4gPiAtIFdl
IG1heSBiZSBtYWtpbmcgc29tZSB0ZWNobmljYWwgY29tcHJvbWlzZXMgYS50Lm0gZm9yIHRoZSBz
YWtlIG9mCj4gPiAgIHVzaW5nIHBlcmYuCj4gPiAKPiA+ICAgICBwZXJmX2V2ZW50X29wZW4oKSBy
ZXF1aXJlcyBldmVudHMgdG8gZWl0aGVyIHJlbGF0ZSB0byBhIHBpZCBvciBhCj4gPiAgICAgc3Bl
Y2lmaWMgY3B1IGNvcmUsIHdoaWxlIG91ciBkZXZpY2UgcG11IHJlbGF0ZXMgdG8gbmVpdGhlci4g
IEV2ZW50cwo+ID4gICAgIG9wZW5lZCB3aXRoIGEgcGlkIHdpbGwgYmUgYXV0b21hdGljYWxseSBl
bmFibGVkL2Rpc2FibGVkIGFjY29yZGluZwo+ID4gICAgIHRvIHRoZSBzY2hlZHVsaW5nIG9mIHRo
YXQgcHJvY2VzcyAtIHNvIG5vdCBhcHByb3ByaWF0ZSBmb3IgdXMuCj4gCj4gUmlnaHQ7IHRoZSB0
cmFkaXRpb25hbCBjcHUvcGlkIG1hcHBpbmcgZG9lc24ndCB3b3JrIHdlbGwgZm9yIGRldmljZXM7
Cj4gYnV0IG1heWJlLCB3aXRoIHNvbWUgd29yaywgd2UgY2FuIGNyZWF0ZSBzb21ldGhpbmcgbGlr
ZSB0aGF0Cj4gZ2xvYmFsL2xvY2FsIHJlbmRlciBjb250ZXh0IGZyb20gaXQ7IGFsdGhvdWdoIEkn
dmUgbm8gY2x1ZSB3aGF0IGZvcm0KPiB0aGF0IHdvdWxkIG5lZWQgYXQgdGhpcyB0aW1lLgoKQ291
bGQgc29tZW9uZSBwbGVhc2UgaGVscCB3aXRoIHNvbWUgdmVyeSBiYXNpYyBxdWVzdGlvbnMsIHN1
Y2ggYXMgd2hhdCB0aGUgCmhhcmR3YXJlIG1vZGVsIG9mIHRoZSAnT0EnIHVuaXQgbW9kZWwgaXM/
IEhvdyBhcmUgT0EgcmVnaXN0ZXJzIHNldCB1cCwgaG93IGFyZSAKdGhlaXIgdmFsdWVzIG1hZGUg
YWNjZXNzaWJsZSB0byB0aGUgaG9zdCBzaWRlLCBldGMuCgpJIHNlZSBzb21lIHJlZmVyZW5jZXMg
dG8gJ09BJyByZWdpc3RlcnMgaW46CgogIGh0dHBzOi8vMDEub3JnL3NpdGVzL2RlZmF1bHQvZmls
ZXMvZG9jdW1lbnRhdGlvbi9pbnRlbC1nZngtcHJtLW9zcmMtYmR3LXZvbDAzLWdwdV9vdmVydmll
d18xLnBkZgoKYW5kIEkgdHJpZWQgdG8gZmluZCBhIG1vcmUgaGlnaCBsZXZlbCBkZXNjcmlwdGlv
biBpbjoKCiAgIGh0dHBzOi8vMDEub3JnL2xpbnV4Z3JhcGhpY3MvZG9jdW1lbnRhdGlvbi9oYXJk
d2FyZS1zcGVjaWZpY2F0aW9uLXBybXMvMjAxNC0yMDE1LWludGVsLXByb2Nlc3NvcnMtYmFzZWQt
YnJvYWR3ZWxsLXBsYXRmb3JtCgpidXQgY291bGRuJ3QgZmluZCBpdC4gKE1heWJlIGl0J3MgbXkg
ZmF1bHQhKQoKVGhhbmtzLAoKCUluZ28KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX18KSW50ZWwtZ2Z4IG1haWxpbmcgbGlzdApJbnRlbC1nZnhAbGlzdHMuZnJl
ZWRlc2t0b3Aub3JnCmh0dHA6Ly9saXN0cy5mcmVlZGVza3RvcC5vcmcvbWFpbG1hbi9saXN0aW5m
by9pbnRlbC1nZngK
