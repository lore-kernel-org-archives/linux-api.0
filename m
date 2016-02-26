From: Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [lxc-devel] CGroup Namespaces (v10)
Date: Fri, 26 Feb 2016 22:47:27 +0000
Message-ID: <20160226224727.GB24680@ubuntumail>
References: <1454057651-23959-1-git-send-email-serge.hallyn@ubuntu.com>
 <CAMXgnP4Wss0ctx7mHzD0WHL4+-fC59iLZNkYONE5pAeHYr18+A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAMXgnP4Wss0ctx7mHzD0WHL4+-fC59iLZNkYONE5pAeHYr18+A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alban Crequy <alban.crequy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: LXC development mailing-list <lxc-devel-cunTk1MwBs9qMoObBWhMNEqPaTDuhLve2LY78lusg7I@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Quoting Alban Crequy (alban.crequy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org):
> Hi,
> 
> On 29 January 2016 at 09:54,  <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org> wrote:
> > Hi,
> >
> > following is a revised set of the CGroup Namespace patchset which Aditya
> > Kali has previously sent.  The code can also be found in the cgroupns.v10
> > branch of
> >
> > https://git.kernel.org/cgit/linux/kernel/git/sergeh/linux-security.git/
> >
> > To summarize the semantics:
> >
> > 1. CLONE_NEWCGROUP re-uses 0x02000000, which was previously CLONE_STOPPED
> 
> What's the best way for a userspace application to test at run-time
> whether the kernel supports cgroup namespaces? Would you recommend to
> test if the file /proc/self/ns/cgroup exists?

Yup.
