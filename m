From: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [patch -mm] mm, doc: cleanup and clarify munmap behavior for
 hugetlb memory fix
Date: Thu, 9 Apr 2015 12:46:09 -0700 (PDT)
Message-ID: <alpine.DEB.2.10.1504091244501.11370@chino.kir.corp.google.com>
References: <alpine.DEB.2.10.1503261621570.20009@chino.kir.corp.google.com> <alpine.LSU.2.11.1503291801400.1052@eggly.anvils> <alpine.DEB.2.10.1504021536210.15536@chino.kir.corp.google.com> <alpine.DEB.2.10.1504021547330.15536@chino.kir.corp.google.com>
 <20150404113456.55468dc3@lwn.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150404113456.55468dc3-T1hC0tSOHrs@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Davide Libenzi <davidel-AhlLAIvw+VEjIGhXcJzhZg@public.gmane.org>, Luiz Capitulino <lcapitulino-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Joern Engel <joern-PCqxUs/MD9bYtjvyW6yDsg@public.gmane.org>, Jianguo Wu <wujianguo-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Eric B Munson <emunson-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Sat, 4 Apr 2015, Jonathan Corbet wrote:

> On Thu, 2 Apr 2015 15:50:15 -0700 (PDT)
> David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> 
> > Don't only specify munmap(2) behavior with respect the hugetlb memory, all 
> > other syscalls get naturally aligned to the native page size of the 
> > processor.  Rather, pick out munmap(2) as a specific example.
> 
> So I was going to apply this to the docs tree, but it doesn't even come
> close.  What tree was this patch generated against?
> 

Sorry, it's not intended to go through the docs tree, it's a patch to fix 
mm-doc-cleanup-and-clarify-munmap-behavior-for-hugetlb-memory.patch in 
-mm.  It's been merged into that tree, but I would still appreciate your 
ack!
