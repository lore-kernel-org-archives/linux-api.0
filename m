From: Antonio SJ Musumeci <trapexit-wGTF+nt6ur047o9RxwvyTQ@public.gmane.org>
Subject: Re: [PATCH] fuse: Add support for fuse stacked I/O
Date: Fri, 15 Jan 2016 12:37:28 -0500
Message-ID: <CAB3-ZyT+xcU-0BnNvq-+GsDe6W8=MCWwxguS-+KQ39gajmM5pw@mail.gmail.com>
References: <565394BE.4040506@codeaurora.org> <5696E366.2080605@codeaurora.org>
	<20160114045716.GB8006@kroah.com> <5697EF97.9020800@codeaurora.org>
	<CA+55aFwxaU0Y_UxyKFv6WaYsPWDDzZG-rhVtMuLSPcJ0WLLw2A@mail.gmail.com>
	<CALCETrWNQ9ytw1bCOOjFJRstauYc6DocQAmZCF61CErAJ5BF2g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5945575100865241780=="
Return-path: <fuse-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <CALCETrWNQ9ytw1bCOOjFJRstauYc6DocQAmZCF61CErAJ5BF2g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/fuse-devel>,
	<mailto:fuse-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=fuse-devel>
List-Post: <mailto:fuse-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:fuse-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/fuse-devel>,
	<mailto:fuse-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: fuse-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, fuse-devel <fuse-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Miklos Szeredi <miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, sven.utcke-Mmb7MZpHnFY@public.gmane.org, Nikolaus Rath <nikolaus-BTH8mxji4b0@public.gmane.org>, Nikhilesh Reddy <reddyn-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org

--===============5945575100865241780==
Content-Type: multipart/alternative; boundary=001a1142e14ec95389052962dd54

--001a1142e14ec95389052962dd54
Content-Type: text/plain; charset=UTF-8

The idea is that you want to be able to reason about open, create, etc. but
don't care about the data transfer.

I have N filesystems I wish to unionize. When I create a new file I want to
pick the drive with the most free space (or some other algo). creat is
called, succeeds, and now the application issuing this starts writing. The
FUSE fs doesn't care about the writes. It just wanted to pick the drive
this file should have been created on. Anything I'd do with the FD after
that I'm happy to short circuit. I don't need to be asked what to do when
fstat'ing this FD or anything which in FUSE hands over the 'fh'. It's just
a file descriptor for me and I'd simply be calling the same function.

Ideally I think one would want to be able to select which functions to
short circuit and maybe even have it so that a short circuited function
could propagate back through FUSE on error. But the read and write short
circuiting is probably the biggest win given the overhead.

On Fri, Jan 15, 2016 at 11:31 AM, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
wrote:

> On Jan 14, 2016 11:19 AM, "Linus Torvalds"
> <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
> >
> > On Thu, Jan 14, 2016 at 10:57 AM, Nikhilesh Reddy <reddyn-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
> wrote:
> > >
> > > *I will send out a properly formatted patch shortly.*
> >
> > So before you do that, can you explain in what cases fuse just wants
> > to pass through the IO?
> >
> > Why aren't such cases just using unionfs or something?
> >
> > In other words, I think that patch needs an explanation for the
> > *reason* for the new functionality.
>
> Also, clarifying the functionality would be nice.  What is the
> "underlying" fs you speak of?  What f_cred gets used?  Who opens the
> underlying file, whatever that is?
>
> Is the intent overlay-style stacking or is it something else entirely?
>
> --Andy
>

--001a1142e14ec95389052962dd54
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">The idea is that you want to be able to reason about open,=
 create, etc. but don&#39;t care about the data transfer.=C2=A0<div><br></d=
iv><div>I have N filesystems I wish to unionize. When I create a new file I=
 want to pick the drive with the most free space (or some other algo). crea=
t is called, succeeds, and now the application issuing this starts writing.=
 The FUSE fs doesn&#39;t care about the writes. It just wanted to pick the =
drive this file should have been created on. Anything I&#39;d do with the F=
D after that I&#39;m happy to short circuit. I don&#39;t need to be asked w=
hat to do when fstat&#39;ing this FD or anything which in FUSE hands over t=
he &#39;fh&#39;. It&#39;s just a file descriptor for me and I&#39;d simply =
be calling the same function.</div><div><br></div><div>Ideally I think one =
would want to be able to select which functions to short circuit and maybe =
even have it so that a short circuited function could propagate back throug=
h FUSE on error. But the read and write short circuiting is probably the bi=
ggest win given the overhead.</div></div><div class=3D"gmail_extra"><br><di=
v class=3D"gmail_quote">On Fri, Jan 15, 2016 at 11:31 AM, Andy Lutomirski <=
span dir=3D"ltr">&lt;<a href=3D"mailto:luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org" target=3D"_blan=
k">luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_=
quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1=
ex">On Jan 14, 2016 11:19 AM, &quot;Linus Torvalds&quot;<br>
<span class=3D"">&lt;<a href=3D"mailto:torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org">torva=
lds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org</a>&gt; wrote:<br>
&gt;<br>
&gt; On Thu, Jan 14, 2016 at 10:57 AM, Nikhilesh Reddy &lt;<a href=3D"mailt=
o:reddyn-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org">reddyn-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org</a>&gt; wrote:<br>
&gt; &gt;<br>
&gt; &gt; *I will send out a properly formatted patch shortly.*<br>
&gt;<br>
&gt; So before you do that, can you explain in what cases fuse just wants<b=
r>
&gt; to pass through the IO?<br>
&gt;<br>
&gt; Why aren&#39;t such cases just using unionfs or something?<br>
&gt;<br>
&gt; In other words, I think that patch needs an explanation for the<br>
&gt; *reason* for the new functionality.<br>
<br>
</span>Also, clarifying the functionality would be nice.=C2=A0 What is the<=
br>
&quot;underlying&quot; fs you speak of?=C2=A0 What f_cred gets used?=C2=A0 =
Who opens the<br>
underlying file, whatever that is?<br>
<br>
Is the intent overlay-style stacking or is it something else entirely?<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
--Andy<br>
</font></span></blockquote></div><br></div>

--001a1142e14ec95389052962dd54--


--===============5945575100865241780==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=267308311&iu=/4140
--===============5945575100865241780==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

-- 
fuse-devel mailing list
To unsubscribe or subscribe, visit https://lists.sourceforge.net/lists/listinfo/fuse-devel

--===============5945575100865241780==--
