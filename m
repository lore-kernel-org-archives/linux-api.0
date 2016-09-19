From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [Documentation] State of CPU controller in cgroup v2
Date: Mon, 19 Sep 2016 17:34:17 -0400
Message-ID: <20160919213417.GA4023@htj.duckdns.org>
References: <20160829222048.GH28713@mtj.duckdns.org>
 <CALCETrUEygWrJbG25wSfG3zMG_+TNeP8+gAkcbh4_=ZNWHQCkw@mail.gmail.com>
 <20160831173251.GY12660@htj.duckdns.org>
 <CALCETrUKOJZS+=QDPyQD+vxXpwyjoj4+Crg6wU7Xk8rP4prYkA@mail.gmail.com>
 <20160831210754.GZ12660@htj.duckdns.org>
 <CALCETrXj2Z=-GMaWV_EpCvw_8C3t1vc=D53Ff2wdvo=At8ZF1Q@mail.gmail.com>
 <20160903220526.GA20784@mtj.duckdns.org>
 <CALCETrVcAjFWLQ1arjSP-g=4jRY_J7G-j9JJHrvTDgOnxApYPw@mail.gmail.com>
 <20160909225747.GA30105@mtj.duckdns.org>
 <ab6f3376-4c09-a339-f984-937f537ddc17@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <ab6f3376-4c09-a339-f984-937f537ddc17-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Austin S. Hemmelgarn" <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mike Galbraith <umgwanakikbuti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hello, Austin.

On Mon, Sep 12, 2016 at 11:20:03AM -0400, Austin S. Hemmelgarn wrote:
> > If you confine it to the cpu controller, ignore anonymous
> > consumptions, the rather ugly mapping between nice and weight values
> > and the fact that nobody could come up with a practical usefulness for
> > such setup, yes.  My point was never that the cpu controller can't do
> > it but that we should find a better way of coordinating it with other
> > controllers and exposing it to individual applications.
>
> So, having a container where not everything in the container is split
> further into subgroups is not a practically useful situation?  Because
> that's exactly what both systemd and every other cgroup management tool
> expects to have work as things stand right now.  The root cgroup within a

Not true.

 $ cat /proc/1/cgroup
 11:hugetlb:/
 10:pids:/init.scope
 9:blkio:/
 8:cpuset:/
 7:memory:/
 6:freezer:/
 5:perf_event:/
 4:net_cls,net_prio:/
 3:cpu,cpuacct:/
 2:devices:/init.scope
 1:name=systemd:/init.scope
 $ systemctl --version
 systemd 229
 +PAM +AUDIT +SELINUX +IMA -APPARMOR +SMACK +SYSVINIT +UTMP +LIBCRYPTSETUP +GCRYPT +GNUTLS +ACL +XZ +LZ4 +SECCOMP +BLKID +ELFUTILS +KMOD +IDN

> cgroup namespace has to function exactly like the system-root, otherwise
> nothing can depend on the special cases for the system root, because they
> might get run in a cgroup namespace and such assumptions will be invalid.

systemd already behaves exactly the same whether it's inside a
namespace or not.

> This in turn means that no current distro can run unmodified in a cgroup
> namespace under a v2 hierarchy, which is a Very Bad Thing.

cgroup v1 hierarchies can be mounted the same inside a namespace
whether the system itself is on cgroup v1 or v2.  Obviously, a given
controller can only be attached to one hierarchy, so a controller
can't be used at the same time on both v1 and v2 hierarchies; however,
that is true with different v1 hierarchies too, and, given that
delegations doesn't work properly on v1, shouldn't be that much of an
issue.

I'm not just claiming it.  systemd-nspawn can already be on either v1
or v2 hierarchies regardless of what the outer systemd uses.

Out of the claims that you made, the only one which holds up is that
an existing software can't make use of cgroup v2 without
modifications, which is true but at the same time doesn't mean much of
anything.

Thanks.

-- 
tejun
