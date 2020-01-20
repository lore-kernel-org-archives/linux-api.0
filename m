From: Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 3/6] cgroup: refactor fork helpers
Date: Mon, 20 Jan 2020 15:33:30 +0100
Message-ID: <20200120143329.o7cmmemfqexk3x37@wittgenstein>
References: <20200117181219.14542-1-christian.brauner@ubuntu.com>
 <20200117181219.14542-4-christian.brauner@ubuntu.com>
 <20200120140029.GB30403@redhat.com>
 <20200120140452.qyjogmmhyqc3gxon@wittgenstein>
 <20200120142202.GC30403@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20200120142202.GC30403-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, Jan 20, 2020 at 03:22:03PM +0100, Oleg Nesterov wrote:
> On 01/20, Christian Brauner wrote:
> >
> > On Mon, Jan 20, 2020 at 03:00:30PM +0100, Oleg Nesterov wrote:
> > > This is probably the only patch in series I can understand ;)
> > >
> > > To me it looks like a good cleanup regardless, but
> > >
> > > On 01/17, Christian Brauner wrote:
> > > >
> > > > The patch just passes in the parent task_struct
> > >
> > > For what? "parent" is always "current", no?
> >
> > Yes. What exactly are you hinting at? :) Would you prefer that the
> > commit message speaks of "current" instead of "parent"?
> 
> I meant, I don't understand why did you add the new "parent" arg,
> cgroup_xxx_fork() can simply use "current" ?

There's no specific reason behind it. I don't care much whether it's an
arg or we just grab current in each helper directly.

Christian
