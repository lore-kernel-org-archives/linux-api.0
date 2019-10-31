From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH v2] mm: Fix checking unmapped holes for mbind
Date: Thu, 31 Oct 2019 12:26:09 +0100
Message-ID: <20191031112609.GG13102@dhcp22.suse.cz>
References: <201910291756045288126@gmail.com>
 <20191030210836.a17c0649354b59961903d1a8@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20191030210836.a17c0649354b59961903d1a8@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Li Xinhai <lixinhai.lxh@gmail.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, Babka <vbabka@suse.cz>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, API <linux-api@vger.kernel.org>, Dickins <hughd@google.com>, linux-man@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed 30-10-19 21:08:36, Andrew Morton wrote:
> (cc linux-man@vger.kernel.org)
> 
> On Tue, 29 Oct 2019 17:56:06 +0800 "Li Xinhai" <lixinhai.lxh@gmail.com> wrote:
> 
> > queue_pages_range() will check for unmapped holes besides queue pages for
> > migration. The rules for checking unmapped holes are:
> > 1 Unmapped holes at any part of the specified range should be reported as
> >   EFAULT if mbind() for none MPOL_DEFAULT cases;
> > 2 Unmapped holes at any part of the specified range should be ignored if
> >   mbind() for MPOL_DEFAULT case;
> > Note that the second rule is the current implementation, but it seems
> > conflicts the Linux API definition.
> 
> Can you quote the part of the API definition which you're looking at?
> 
> My mbind(2) manpage says
> 
> ERRORS
>        EFAULT Part or all of the memory range specified by nodemask and maxn-
>               ode points outside your accessible address space.  Or, there was
>               an unmapped hole in the specified memory range specified by addr
>               and len.
> 
> (I assume the first sentence meant to say "specified by addr and len")

My understanding is that this really refers to area pointed to by nodemask.
Btw. why there is any special casing around the unmapped holes with the
address space range? This looks like an antipattern to other address
space operations to me. E.g. munmap simply unmaps all existing vmas in
the given range, mprotect, madvise etc. behave the same.

So my question is, do we want to remove that weird restriction and
simply act on all existing VMAs in the range? The only situation this
could regress would be if somebody used mbind to probe for existing VMAs
and that sounds a more than sensible to me. Or am I missing anything?
-- 
Michal Hocko
SUSE Labs
