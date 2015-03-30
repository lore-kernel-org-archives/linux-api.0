From: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [patch 1/2] mm, doc: cleanup and clarify munmap behavior for
 hugetlb memory
Date: Mon, 30 Mar 2015 13:23:20 -0700 (PDT)
Message-ID: <alpine.LSU.2.11.1503301307490.2485@eggly.anvils>
References: <alpine.DEB.2.10.1503261621570.20009@chino.kir.corp.google.com> <alpine.LSU.2.11.1503291801400.1052@eggly.anvils> <20150330142336.GB17678@akamai.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150330142336.GB17678-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eric B Munson <emunson-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
Cc: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Davide Libenzi <davidel-AhlLAIvw+VEjIGhXcJzhZg@public.gmane.org>, Luiz Capitulino <lcapitulino-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Joern Engel <joern-PCqxUs/MD9bYtjvyW6yDsg@public.gmane.org>, Jianguo Wu <wujianguo-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, 30 Mar 2015, Eric B Munson wrote:
> On Sun, 29 Mar 2015, Hugh Dickins wrote:
> > 
> > Eric, I apologize for bringing you in to the discussion, and then
> > ignoring your input.  I understand that you would like MAP_HUGETLB
> > to behave more understandably.  We can all agree that the existing
> > behavior is unsatisfying.  But it's many years too late now to 
> > change it around - and I suspect that a full exercise to do so would
> > actually discover some good reasons why the original choices were made.
> 
> No worries, my main concern was avoiding the confusion that led me down
> the rabbit hole of compaction and mlock.  As long as the documentation,
> man pages, and the code all agree I am satisfied.  I would have
> preferred to make the code match the docs, but I understand that
> changing the code now introduces a risk of breaking userspace.
> 
> It is charitable of you to assume that there were good reasons for the
> original decision.  But as the author of the code in question, I suspect
> the omission was one of my own inexperience.

No, you are both too modest and too arrogant :)

You were extending the existing hugetlbfs infrastructure to be
accessible through a MAP_HUGETLB interface.  You therefore inherited
the defects (some probably necessary, others perhaps not) of the
original hugetlbfs implementation, which is where this disagreeable
behaviour comes from.

If you were to ask for MAP_HUGETLB to behave differently from mapping
hugetlbfs here, I would shout no.  For a start, we'd have to add a
VM_HUGETLB2 flag so that each place that tests VM_HUGETLB (usually
through is_vm_hugetlb_page(vma) - sic) could decide how to behave
instead.

I for one have neither time nor inclination to write or review
any such patch.

Hugh
