From: Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCHv2 0/7] CGroup Namespaces
Date: Tue, 2 Dec 2014 11:14:04 -0800
Message-ID: <CAGr1F2F97LcORP6mbEfC+kU0Eib8AWt=n25Ok5EM5U_HB=DfsQ@mail.gmail.com>
References: <1414783141-6947-1-git-send-email-adityakali@google.com>
	<20141104131030.GA2937@redhat.com>
	<CAGr1F2Hm4+aCUz3RqkgUhbJAQtWvUbb2CRDkW5rJSZkwLM_huw@mail.gmail.com>
	<CAFLxGvybiem34J3zrtVhW=4itSdczassNt9RcuxnpJQeAz-JVA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <CAFLxGvybiem34J3zrtVhW=4itSdczassNt9RcuxnpJQeAz-JVA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Richard Weinberger <richard.weinberger-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups mailinglist <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Nov 26, 2014 at 2:58 PM, Richard Weinberger
<richard.weinberger-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
> On Thu, Nov 6, 2014 at 6:33 PM, Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> > On Tue, Nov 4, 2014 at 5:10 AM, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> >> On Fri, Oct 31, 2014 at 12:18:54PM -0700, Aditya Kali wrote:
> >> [..]
> >>>  fs/kernfs/dir.c                  | 194 ++++++++++++++++++++++++++++++++++-----
> >>>  fs/kernfs/mount.c                |  48 ++++++++++
> >>>  fs/proc/namespaces.c             |   1 +
> >>>  include/linux/cgroup.h           |  41 ++++++++-
> >>>  include/linux/cgroup_namespace.h |  36 ++++++++
> >>>  include/linux/kernfs.h           |   5 +
> >>>  include/linux/nsproxy.h          |   2 +
> >>>  include/linux/proc_ns.h          |   4 +
> >>>  include/uapi/linux/sched.h       |   3 +-
> >>>  kernel/Makefile                  |   2 +-
> >>>  kernel/cgroup.c                  | 108 +++++++++++++++++-----
> >>>  kernel/cgroup_namespace.c        | 148 +++++++++++++++++++++++++++++
> >>>  kernel/fork.c                    |   2 +-
> >>>  kernel/nsproxy.c                 |  19 +++-
> >>
> >> Hi Aditya,
> >>
> >> Can we provide a documentation file for cgroup namespace behavior. Say,
> >> Documentation/namespaces/cgroup-namespace.txt.
> >>
> > Yes, definitely. I will add it as soon as we have a consensus on the
> > overall series.
>
> Do you have a public git repository which contains your patches?
>

Hi, Sorry for late reply. I don't have these in a public git repo yet.
But I will try to post it on github or somewhere.
Also, I found a bug in this patchset that crashes the kernel in some
cases (when both unified and split hierarchies are mounted). I have a
fix and will send out the patches (with documentation) soon.

>
> --
> Thanks,
> //richard

Thanks,
-- 
Aditya
