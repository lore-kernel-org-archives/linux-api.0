From: Milosz Tanski <milosz@adfin.com>
Subject: Re: [PATCH v7 0/5] vfs: Non-blockling buffered fs read (page cache only)
Date: Thu, 26 Mar 2015 22:26:45 -0400
Message-ID: <CANP1eJEeF9oXp=Zoyb9FKB8RSG98jG0_ed2YNk_2ryARmXVrRw@mail.gmail.com>
References: <cover.1426528417.git.milosz@adfin.com>
	<20150326115514.GA12329@infradead.org>
	<CANP1eJGpgXUv626KQb6kduJgMaOzU5hH9GLGBM-QSVUBagoG8w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/alternative; boundary=001a11c3fd941c8a4905123bdd77
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <CANP1eJGpgXUv626KQb6kduJgMaOzU5hH9GLGBM-QSVUBagoG8w@mail.gmail.com>
Sender: owner-linux-aio@kvack.org
To: Christoph Hellwig <hch@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-aio@kvack.org" <linux-aio@kvack.org>, Mel Gorman <mgorman@suse.de>, Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>, Jeff Moyer <jmoyer@redhat.com>, Theodore Ts'o <tytso@mit.edu>, Al Viro <viro@zeniv.linux.org.uk>, Linux API <linux-api@vger.kernel.org>, Michael Kerrisk <mtk.manpages@gmail.com>, linux-arch@vger.kernel.org, Dave Chinner <david@fromorbit.com>, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-api@vger.kernel.org

--001a11c3fd941c8a4905123bdd77
Content-Type: text/plain; charset=UTF-8

On Thu, Mar 26, 2015 at 3:12 PM, Milosz Tanski <milosz@adfin.com> wrote:

> On Thu, Mar 26, 2015 at 7:55 AM, Christoph Hellwig <hch@infradead.org>
> wrote:
> >
> > On Mon, Mar 16, 2015 at 02:27:10PM -0400, Milosz Tanski wrote:
> > > This patchset introduces two new syscalls preadv2 and pwritev2. They
> are the
> > > same syscalls as preadv and pwrite but with a flag argument.
> Additionally,
> > > preadv2 implements an extra RWF_NONBLOCK flag.
> >
> > There was some arugment that we just don't wait and don't have the
> > classic unix "blocking" semantics.  Maybe it's time to bite the bullet
> > and rename it to RWF_DONTWAIT? (I personally dont really care).
>
>
> Sure. It is in line with the MSG_DONTWAIT flag for sendmsg() which
> this whole idea is based on anyways.
>

Okay, It's RWF_DONTWAIT now. I also split it into two RWF_DONTWAIT for the
userspace API and IOCB_DONTWAIT that goes into kiocb->ki_flags.


>
> >
> >
> > Second this probably needs to be on top of Al's for-next tree:
> >
> >
> https://git.kernel.org/cgit/linux/kernel/git/viro/vfs.git/log/?h=for-next
> >
> > Note that this has a flags field in struct kiocb, so we could just use
> > that for the flags.
>
>
> Okay I started rebasing the patches on-top of that. I did see that
> there is a new flags field "ki_flags". I see that there's already a
> IOCB_EVENTFD flag.
>
> Did you see you Andres' question about making the flags a enum? I
> usually wouldn't do that, because C++ is stronger when it comes enums,
> you can't combine them then assignment them to an enum without a cast.
> But in the kernel this doesn't matter.
>
> >
> >
> > Otherwise this version look fine to me, let's get it merged!
> >
> > Al, are yo ready to pick this up?  I'd hate to miss another merge
> > window.
>
>
> Just got back from vacation today, I'll try to get this out before the
> end of the week. I also have to make some adjustments to xfs-tests (to
> push preadv2 into xfs_io).
>

You'll see the patches and the pull request against  viro/for-next
branch tomorrow. The rebase was a bit of work since you guys changed a fair
amount of stuff.


>
>
> --
> Milosz Tanski
> CTO
> 16 East 34th Street, 15th floor
> New York, NY 10016
>
> p: 646-253-9055
> e: milosz@adfin.com
>



-- 
Milosz Tanski
CTO
16 East 34th Street, 15th floor
New York, NY 10016

p: 646-253-9055
e: milosz@adfin.com

--001a11c3fd941c8a4905123bdd77
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><br><div class=3D"gmail_extra"><br><div class=3D"gmail_quo=
te">On Thu, Mar 26, 2015 at 3:12 PM, Milosz Tanski <span dir=3D"ltr">&lt;<a=
 href=3D"mailto:milosz@adfin.com" target=3D"_blank">milosz@adfin.com</a>&gt=
;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin:0px 0p=
x 0px 0.8ex;border-left-width:1px;border-left-color:rgb(204,204,204);border=
-left-style:solid;padding-left:1ex"><span class=3D"">On Thu, Mar 26, 2015 a=
t 7:55 AM, Christoph Hellwig &lt;<a href=3D"mailto:hch@infradead.org">hch@i=
nfradead.org</a>&gt; wrote:<br>
&gt;<br>
&gt; On Mon, Mar 16, 2015 at 02:27:10PM -0400, Milosz Tanski wrote:<br>
&gt; &gt; This patchset introduces two new syscalls preadv2 and pwritev2. T=
hey are the<br>
&gt; &gt; same syscalls as preadv and pwrite but with a flag argument. Addi=
tionally,<br>
&gt; &gt; preadv2 implements an extra RWF_NONBLOCK flag.<br>
&gt;<br>
&gt; There was some arugment that we just don&#39;t wait and don&#39;t have=
 the<br>
&gt; classic unix &quot;blocking&quot; semantics.=C2=A0 Maybe it&#39;s time=
 to bite the bullet<br>
&gt; and rename it to RWF_DONTWAIT? (I personally dont really care).<br>
<br>
<br>
</span>Sure. It is in line with the MSG_DONTWAIT flag for sendmsg() which<b=
r>
this whole idea is based on anyways.<br></blockquote><div><br></div><div>Ok=
ay, It&#39;s RWF_DONTWAIT now. I also split it into two RWF_DONTWAIT for th=
e userspace API and IOCB_DONTWAIT that goes into kiocb-&gt;ki_flags.</div><=
div>=C2=A0</div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0=
px 0.8ex;border-left-width:1px;border-left-color:rgb(204,204,204);border-le=
ft-style:solid;padding-left:1ex">
<span class=3D""><br>
&gt;<br>
&gt;<br>
&gt; Second this probably needs to be on top of Al&#39;s for-next tree:<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0<a href=3D"https://git.kernel.org/cgi=
t/linux/kernel/git/viro/vfs.git/log/?h=3Dfor-next" target=3D"_blank">https:=
//git.kernel.org/cgit/linux/kernel/git/viro/vfs.git/log/?h=3Dfor-next</a><b=
r>
&gt;<br>
&gt; Note that this has a flags field in struct kiocb, so we could just use=
<br>
&gt; that for the flags.<br>
<br>
<br>
</span>Okay I started rebasing the patches on-top of that. I did see that<b=
r>
there is a new flags field &quot;ki_flags&quot;. I see that there&#39;s alr=
eady a<br>
IOCB_EVENTFD flag.<br>
<br>
Did you see you Andres&#39; question about making the flags a enum? I<br>
usually wouldn&#39;t do that, because C++ is stronger when it comes enums,<=
br>
you can&#39;t combine them then assignment them to an enum without a cast.<=
br>
But in the kernel this doesn&#39;t matter.<br>
<span class=3D""><br>
&gt;<br>
&gt;<br>
&gt; Otherwise this version look fine to me, let&#39;s get it merged!<br>
&gt;<br>
&gt; Al, are yo ready to pick this up?=C2=A0 I&#39;d hate to miss another m=
erge<br>
&gt; window.<br>
<br>
<br>
</span>Just got back from vacation today, I&#39;ll try to get this out befo=
re the<br>
end of the week. I also have to make some adjustments to xfs-tests (to<br>
push preadv2 into xfs_io).<br></blockquote><div><br></div><div>You&#39;ll s=
ee the patches and the pull request against =C2=A0viro/for-next branch=C2=
=A0tomorrow. The rebase was a bit of work since you guys changed a fair amo=
unt of stuff.</div><div>=C2=A0</div><blockquote class=3D"gmail_quote" style=
=3D"margin:0px 0px 0px 0.8ex;border-left-width:1px;border-left-color:rgb(20=
4,204,204);border-left-style:solid;padding-left:1ex">
<span class=3D""><font color=3D"#888888"><br>
<br>
--<br>
Milosz Tanski<br>
CTO<br>
16 East 34th Street, 15th floor<br>
New York, NY 10016<br>
<br>
p: <a href=3D"tel:646-253-9055" value=3D"+16462539055">646-253-9055</a><br>
e: <a href=3D"mailto:milosz@adfin.com">milosz@adfin.com</a><br>
</font></span></blockquote></div><br><br clear=3D"all"><div><br></div>-- <b=
r><div class=3D"gmail_signature"><div dir=3D"ltr">Milosz Tanski<br>CTO<br>1=
6 East 34th Street, 15th floor<br>New York, NY 10016<br><br>p: 646-253-9055=
<br>e: <a href=3D"mailto:milosz@adfin.com" target=3D"_blank">milosz@adfin.c=
om</a><br></div></div>
</div></div>

--001a11c3fd941c8a4905123bdd77--

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
