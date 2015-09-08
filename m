From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Subject: Re: [Qemu-devel] [PATCH 19/23] userfaultfd: activate syscall
Date: Tue, 8 Sep 2015 13:28:26 +0100
Message-ID: <20150908122826.GJ2246@work-vm>
References: <1431624680-20153-1-git-send-email-aarcange@redhat.com>
 <1431624680-20153-20-git-send-email-aarcange@redhat.com>
 <20150811100728.GB4587@in.ibm.com>
 <20150811134826.GI4520@redhat.com>
 <20150812052346.GC4587@in.ibm.com>
 <1441692486.14597.17.camel@ellerman.id.au>
 <20150908063948.GB678@in.ibm.com>
 <1441696463.4689.1.camel@ellerman.id.au>
 <1441708821.13127.0.camel@ellerman.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1441708821.13127.0.camel@ellerman.id.au>
Sender: kvm-owner@vger.kernel.org
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: bharata@linux.vnet.ibm.com, kvm@vger.kernel.org, qemu-devel@nongnu.org, Sanidhya Kashyap <sanidhya.gatech@gmail.com>, linux-mm@kvack.org, Andrea Arcangeli <aarcange@redhat.com>, zhang.zhanghailiang@huawei.com, Pavel Emelyanov <xemul@parallels.com>, Hugh Dickins <hughd@google.com>, Mel Gorman <mgorman@suse.de>, "Huangpeng (Peter)" <peter.huangpeng@huawei.com>, Andres Lagar-Cavilla <andreslc@google.com>, "Kirill A. Shutemov" <kirill@shutemov.name>, Dave Hansen <dave.hansen@intel.com>, linux-api@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>, Johannes Weiner <hannes@cmpxchg.org>, Paolo Bonzini <pbonzini@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Feiner <pfeiner@google.com>
List-Id: linux-api@vger.kernel.org

* Michael Ellerman (mpe@ellerman.id.au) wrote:
> On Tue, 2015-09-08 at 17:14 +1000, Michael Ellerman wrote:
> > On Tue, 2015-09-08 at 12:09 +0530, Bharata B Rao wrote:
> > > On Tue, Sep 08, 2015 at 04:08:06PM +1000, Michael Ellerman wrote:
> > > > Hmm, not for me. See below.
> > > > 
> > > > What setup were you testing on Bharata?
> > > 
> > > I was on commit a94572f5799dd of userfault21 branch in Andrea's tree
> > > git://git.kernel.org/pub/scm/linux/kernel/git/andrea/aa.git
> > > 
> > > #uname -a
> > > Linux 4.1.0-rc8+ #1 SMP Tue Aug 11 11:33:50 IST 2015 ppc64le ppc64le ppc64le GNU/Linux
> > > 
> > > In fact I had successfully done postcopy migration of sPAPR guest with
> > > this setup.
> > 
> > OK, do you mind testing mainline with the same setup to see if the selftest
> > passes.
> 
> Ah, I just tried it on big endian and it works. So it seems to not work on
> little endian for some reason, /probably/ a test case bug?

Hmm; I think we're missing a test-case fix that Andrea made me for a bug I hit on Power
I hit a couple of weeks back.  I think that would have been on le.

Dave

> cheers
> 
> 
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK
