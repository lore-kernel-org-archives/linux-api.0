From: Nicholas Piggin <npiggin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH 1/2] mm, mincore2(): retrieve dax and tlb-size
 attributes of an address range
Date: Tue, 13 Sep 2016 12:16:45 +1000
Message-ID: <20160913121645.652e6512@roar.ozlabs.ibm.com>
References: <147361509579.17004.5258725187329709824.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20160912133536.1bdb57a9@roar.ozlabs.ibm.com>
 <CAPcyv4hS7i1DApKPDB5PkfBNZVbk321FgP94kUDjmuyGXDidZg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <CAPcyv4hS7i1DApKPDB5PkfBNZVbk321FgP94kUDjmuyGXDidZg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Xiao Guangrong <guangrong.xiao-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, 12 Sep 2016 10:29:17 -0700
Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:

> On Sun, Sep 11, 2016 at 8:35 PM, Nicholas Piggin <npiggin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> > On Sun, 11 Sep 2016 10:31:35 -0700
> > Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> >  
> >> As evidenced by this bug report [1], userspace libraries are interested
> >> in whether a mapping is DAX mapped, i.e. no intervening page cache.
> >> Rather than using the ambiguous VM_MIXEDMAP flag in smaps, provide an
> >> explicit "is dax" indication as a new flag in the page vector populated
> >> by mincore.  
> >
> > Can you cc linux-arch when adding new syscalls (or other such things that
> > need arch enablement).
> >
> > I wonder if the changelog for a new syscall should have a bit more grandeur.
> > Without seeing patch 2, you might not know this was a new syscall just by
> > reading the subject and changelog.  
> 
> Fair point, I'll beef up the documentation if this moves past an RFC.

Okay. Also, it would be good to summarise some of the justification
directly in the changelog rather than external link. Performance
numbers, etc.


> > mincore() defines other bits to be reserved, but I guess it probably breaks
> > things if you suddenly started using them.  
> 
> The new bits are left as zero unless an application explicitly asks
> for them, so an existing mincore() user shouldn't break.

Oh yeah, I was just musing that we can't really use the old syscall
despite it claims to have some reserved bits for future use.


> > It's a bit sad to introduce a new syscall for this and immediately use up
> > all bits that can be returned. Would it be a serious problem to return a
> > larger mask per page?  
> 
> Certainly one of the new request flags can indicate that the vector is
> made up of larger entries.

Hmm. Changing prototype depending on flags. I thought I was having
a nightmare about ioctls for a minute there :)

In general, is this what we want for a new API? Should we be thinking
about an extent API?

Thanks,
Nick
