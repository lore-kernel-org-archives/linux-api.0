From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v4 3/6] cgroup: refactor fork helpers
Date: Mon, 20 Jan 2020 15:22:03 +0100
Message-ID: <20200120142202.GC30403@redhat.com>
References: <20200117181219.14542-1-christian.brauner@ubuntu.com>
 <20200117181219.14542-4-christian.brauner@ubuntu.com>
 <20200120140029.GB30403@redhat.com>
 <20200120140452.qyjogmmhyqc3gxon@wittgenstein>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200120140452.qyjogmmhyqc3gxon@wittgenstein>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian.brauner@ubuntu.com>
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Li Zefan <lizefan@huawei.com>, cgroups@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 01/20, Christian Brauner wrote:
>
> On Mon, Jan 20, 2020 at 03:00:30PM +0100, Oleg Nesterov wrote:
> > This is probably the only patch in series I can understand ;)
> >
> > To me it looks like a good cleanup regardless, but
> >
> > On 01/17, Christian Brauner wrote:
> > >
> > > The patch just passes in the parent task_struct
> >
> > For what? "parent" is always "current", no?
>
> Yes. What exactly are you hinting at? :) Would you prefer that the
> commit message speaks of "current" instead of "parent"?

I meant, I don't understand why did you add the new "parent" arg,
cgroup_xxx_fork() can simply use "current" ?

Oleg.
