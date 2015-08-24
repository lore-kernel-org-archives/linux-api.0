From: Darren Hart <dvhart-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: Next round: revised futex(2) man page for review
Date: Mon, 24 Aug 2015 14:47:16 -0700
Message-ID: <20150824214716.GA3703@vmdeb7>
References: <55B61EF3.7080302@gmail.com>
 <20150805222140.GA74817@vmdeb7>
 <55C5A85F.3020202@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <55C5A85F.3020202-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Torvald Riegel <triegel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Carlos O'Donell <carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, Jakub Jelinek <jakub-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland McGrath <roland-/Z5OmTQCD9xF6kxbq+BtvQ@public.gmane.org>, Anton Blanchard <anton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, bill o gallmeister <bgallmeister-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>, Daniel Wagner <wagi-kQCPcA+X3s7YtjvyW6yDsg@public.gmane.org>, Rich Felker <dalias-8zAoT0mYgF4@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, bert hubert <bert.hubert-dxZxOz86jR8sYtaaK7K+xw@public.gmane.org>, Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, Heinrich Schuchardt <xypron.glpk-Mmb7MZpHnFY@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Sat, Aug 08, 2015 at 08:57:35AM +0200, Michael Kerrisk (man-pages) w=
rote:

=2E..

> >> .\" FIXME =3D=3D=3D=3D=3D End of adapted Hart/Guniguntala text =3D=
=3D=3D=3D=3D
> >>
> >>
> >>
> >> .\" FIXME We need some explanation in the following paragraph of *=
why*
> >> .\"       it is important to note that "the kernel will update the
> >> .\"       futex word's value prior
> >>        It is important to note to returning to user space" . Can s=
omeone
> >>        explain?   that  the  kernel  will  update the futex word's=
 value
> >>        prior to returning to user space.  Unlike the other futex  =
opera=E2=80=90
> >>        tions  described  above, the PI futex operations are design=
ed for
> >>        the implementation of very specific IPC mechanisms.
> >=20
> > If the kernel didn't perform the update prior to returning to users=
pace,
> > we could end up in an invalid state. Such as having an owner, but t=
he
> > value being 0. Or having waiters, but not having FUTEX_WAITERS set.
>=20
> So I've now reworked this passage to read:
>=20
>        It  is  important  to  note that the kernel will update the fu=
tex
>        word's value prior to returning to user  space.   (This  preve=
nts
>        the possibility of the futex word's value ending up in an inva=
lid
>        state, such as having an owner but the value being 0,  or  hav=
ing
>        waiters but not having the FUTEX_WAITERS bit set.)
>=20
> Okay?

Yes.

>=20
> >> .\"
> >> .\" FIXME XXX In discussing errors for FUTEX_CMP_REQUEUE_PI, Darre=
n Hart
> >> .\"       made the observation that "EINVAL is returned if the non=
-pi=20
> >> .\"       to pi or op pairing semantics are violated."
> >> .\"       Probably there needs to be a general statement about thi=
s
> >> .\"       requirement, probably located at about this point in the=
 page.
> >> .\"       Darren (or someone else), care to take a shot at this?
> >=20
> > We can probably borrow from either the futex.c comments or the
> > futex-requeue-pi.txt in Documentation. Also, it is important to not=
e
> > that the PI requeue operations require two distinct uadders (althou=
gh
> > that is implied by requiring "non-pi to pi" as a futex cannot be bo=
th.
> >=20
> > Or... perhaps something like:
> >=20
> > 	Due to the kernel imposed futex word value policy, PI futex
> > 	operations have additional usage requirements:
> > =09
> > 	FUTEX_WAIT_REQUEUE_PI must be paired with FUTEX_CMP_REQUEUE_PI
> > 	and be performed from a non-pi futex to a distinct pi futex.
> > 	Failing to do so will return EINVAL.=20
>=20
> For which operation does the EINVAL occur: FUTEX_WAIT_REQUEUE_PI or=20
> FUTEX_CMP_REQUEUE_PI?

=46UTEX_WAIT_REQUEUE_PI can return -EINVAL if called with invalid param=
eters, such
as uaddr=3D=3Duaddr2, or (in the case of SHARED futexes), the associate=
d keys match
(meaning it's the same futex word - shared memory, inode, etc.). This c=
an't
happen if the stated policy of requeueing from non-pi to pi is followed=
 as the
same word cannot be both non-pi and pi at the same time, requiring them=
 to be
unique futex words.

=46UTEX_CMP_REQUEUE_PI will fail similarly if uaddr and uaddr2 are the =
same futex
word. Also, if nr_wake !=3D 1.

But, to the point I was making above, FUTEX_CMP_REQUEUE_PI must reque u=
addr to
same uaddr2 specified in the previous FUTEX_WAIT_REQUEUE_PI call.
=46UTEX_WAIT_REQUEUE_PI sets up the operation, FUTEX_CMP_REQUEUE_PI com=
pletes it,
and they must agree on uaddr and uaddr2.

=2E..

> > And their PRIVATE counterparts of course (which is assumed as it is=
 a
> > flag to the opcode).
>=20
> Yes. But I don't think that needs to be called out explicitly here (?=
).


Agreed.

>=20
> >> .\" FIXME XXX =3D=3D=3D=3D=3D Start of adapted Hart/Guniguntala te=
xt =3D=3D=3D=3D=3D
> >> .\"       The following text is drawn from the Hart/Guniguntala pa=
per
> >> .\"       (listed in SEE ALSO), but I have reworded some pieces
> >> .\"       significantly. Please check it.
> >>
> >>        The PI futex operations described below  differ  from  the =
 other
> >>        futex  operations  in  that  they impose policy on the use =
of the
> >>        value of the futex word:
> >>
> >>        *  If the lock is not acquired, the futex word's value  sha=
ll  be
> >>           0.
> >>
> >>        *  If  the  lock is acquired, the futex word's value shall =
be the
> >>           thread ID (TID; see gettid(2)) of the owning thread.
> >>
> >>        *  If the lock is owned and there are threads contending fo=
r  the
> >>           lock,  then  the  FUTEX_WAITERS  bit shall be set in the=
 futex
> >>           word's value; in other words, this value is:
> >>
> >>               FUTEX_WAITERS | TID
> >>
> >>
> >>        Note that a PI futex word never just has the value FUTEX_WA=
ITERS,
> >>        which is a permissible state for non-PI futexes.
> >=20
> > The second clause is inappropriate. I don't know if that was yours =
or
> > mine, but non-PI futexes do not have a kernel defined value policy,=
 so
> > =3D=3DFUTEX_WAITERS cannot be a "permissible state" as any value is
> > permissible for non-PI futexes, and none have a kernel defined stat=
e.
> >=20
> > Perhaps include a Note under the third bullet as:
> >=20
> > 	  Note: It is invalid for a PI futex word to have no owner and
> > 	        FUTEX_WAITERS set.
>=20
> Done.
>=20
> >>        With this policy in place, a user-space application can acq=
uire a
> >>        not-acquired lock or release a lock that no other threads t=
ry  to
> >=20
> > "that no other threads try to acquire" seems out of place. I think
> > "atomic instructions" is sufficient to express how contention is
> > handled.
>=20
> Yup, changed.
>=20
> >>        acquire using atomic instructions executed in user space (e=
=2Eg., a
> >>        compare-and-swap operation such as cmpxchg on the  x86  arc=
hitec=E2=80=90
> >>        ture).   Acquiring  a  lock simply consists of using compar=
e-and-
> >>        swap to atomically set the futex word's value to the caller=
's TID
> >>        if  its  previous  value  was 0.  Releasing a lock requires=
 using
> >>        compare-and-swap to set the futex word's value to 0 if the =
previ=E2=80=90
> >>        ous value was the expected TID.
> >>
> >>        If a futex is already acquired (i.e., has a nonzero value),=
 wait=E2=80=90
> >>        ers must employ the FUTEX_LOCK_PI operation to acquire the =
 lock.
> >>        If other threads are waiting for the lock, then the FUTEX_W=
AITERS
> >>        bit is set in the futex value; in this case, the lock owner=
  must
> >>        employ the FUTEX_UNLOCK_PI operation to release the lock.
> >>
> >>        In  the  cases  where  callers  are forced into the kernel =
(i.e.,
> >>        required to perform a futex() call), they then deal directl=
y with
> >>        a so-called RT-mutex, a kernel locking mechanism which impl=
ements
> >>        the required priority-inheritance semantics.  After the  RT=
-mutex
> >>        is  acquired,  the futex value is updated accordingly, befo=
re the
> >>        calling thread returns to user space.
> >=20
> > This last paragraph relies on kernel implementation rather than
> > behavior. If the RT-mutex is renamed or the mechanism is implemente=
d
> > differently in futexes, this section will require updating. Is that
> > appropriate for a user-space man page?
>=20
> In the end, I'm not sure. This is (so far) my best attempt at trying
> to convey an explanation of the behavior provided by the API.
>=20
>           results).
>=20
> But see my question just above. I'll tweak the first bullet point a
> little after I hear back from you.

Arg, lost context. Which question?

In my humble opinion, the paragraph about RT-mutex above should perhaps=
 instead
read something like:


	    In  the  cases  where  callers  are forced into the kernel (i.e.,
	    required to perform a futex() call), they then deal directly with
	    Linux kernel internal mechanisms which implement the required
	    priority-inheritance semantics.  Once the internal locking structu=
re
	    is  acquired,  the futex value is updated accordingly, before the
	    calling thread returns to user space.

I'm not terribly particular about this, but in my opinion, we should no=
t refer
to internal-only kernel structures in the man page. Feel free to ignore=
, or to
defer to a differing opinion from Thomas or others.

Thanks for all your work on this!

--=20
Darren Hart
Intel Open Source Technology Center
--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
