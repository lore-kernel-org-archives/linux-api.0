From: Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>
Subject: Re: [PATCH -next v2 0/4] mm: replace mmap_sem for mm->exe_file
 serialization
Date: Sun, 15 Mar 2015 10:34:23 -0700
Message-ID: <1426440863.28068.103.camel@stgolabs.net>
References: <1426372766-3029-1-git-send-email-dave@stgolabs.net>
	 <20150315142137.GA21741@redhat.com>
	 <1426431270.28068.92.camel@stgolabs.net>
	 <20150315152652.GA24590@redhat.com>
	 <1426434125.28068.100.camel@stgolabs.net> <20150315170521.GA2278@moon>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150315170521.GA2278@moon>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Cyrill Gorcunov <gorcunov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, koct9i-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Sun, 2015-03-15 at 20:05 +0300, Cyrill Gorcunov wrote:
> On Sun, Mar 15, 2015 at 08:42:05AM -0700, Davidlohr Bueso wrote:
> > > > > Yes, this code needs cleanups, I agree. Does this series makes it better?
> > > > > To me it doesn't, and the diffstat below shows that it blows the code.
> > > >
> > > > Looking at some of the caller paths now, I have to disagree.
> > > 
> > > And I believe you are wrong. But let me repeat, I leave this to Cyrill
> > > and Konstantin. Cleanups are always subjective.
> > > 
> > > > > In fact, to me it complicates this code. For example. Personally I think
> > > > > that MMF_EXE_FILE_CHANGED should die. And currently we can just remove it.
> > > >
> > > > How could you remove this?
> > > 
> > > Just remove this flag and the test_and_set_bit(MMF_EXE_FILE_CHANGED) check.
> > > Again, this is subjective, but to me it looks ugly. Why do we allow to
> > > change ->exe_file but only once?
> 
> This came from very first versions of the functionality implemented
> in prctl. It supposed to help sysadmins to notice if there exe
> transition happened. As to me it doesn't bring much security, if I
> would be a virus I would simply replace executing code with ptrace
> or via other ways without telling outside world that i've changed
> exe path. That said I would happily rip off this MMF_EXE_FILE_CHANGED
> bit but I fear security guys won't be that happy about it.
> (CC'ing Kees)

Also adding Michael for any prctl manpage and api changes.
