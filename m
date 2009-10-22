From: Sukadev Bhattiprolu <sukadev-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [RFC][v8][PATCH 9/10]: Define clone3() syscall
Date: Thu, 22 Oct 2009 11:10:47 -0700
Message-ID: <20091022181047.GA21628@us.ibm.com>
References: <20091016042041.GA7220@us.ibm.com> <cfd18e0f0910152325m4a9125c2q18f36f5bd7d4a0@mail.gmail.com> <20091016180631.GA31036@us.ibm.com> <20091019174405.GE27627@count0.beaverton.ibm.com> <4ADCDAA8.5080408@zytor.com> <20091019235012.GF27627@count0.beaverton.ibm.com> <cfd18e0f0910202126w1ebfa2e2u2ecbaa23b198d100@mail.gmail.com> <4ADF06B7.50508@zytor.com> <20091021194440.GA1283@us.ibm.com> <cfd18e0f0910220340n7c655daap78e395136c56f882@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <cfd18e0f0910220340n7c655daap78e395136c56f882-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Matt Helsley <matthltc-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, randy.dunlap-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Nathan Lynch <nathanl-V7BBcbaFuwjMbYB6QlFGEg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Louis.Rilling-aw0BnHfMbSpBDgjK7y7TUQ@public.gmane.org, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org, mingo-X9Un+BFzKDI@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, roland-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Pavel Emelyanov <xemul-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Michael Kerrisk [mtk.manpages-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org] wrote:
| Sukadev,
|=20
| On Wed, Oct 21, 2009 at 9:44 PM, Sukadev Bhattiprolu
| <sukadev-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org> wrote:
| > H. Peter Anvin [hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org] wrote:
| >> On 10/21/2009 01:26 PM, Michael Kerrisk wrote:
| >>>
| >>> My question here is: what does "3" actually mean? In general, sys=
tem
| >>> calls have not followed any convention of numbering to indicate
| >>> successive versions -- clone2() being the one possible exception =
that
| >>> I know of.
| >>>
| >>
| >> "3" is number of arguments.
| >
| > To me, it is a version number.
|=20
| See my precending mail. Isn't the number of arguments "2".

Well it was 2 at one point, but I have posted a new version of
just that one patch - please see http://lkml.org/lkml/2009/10/16/3
for comments.

I am working on some updates and will post a new patchset - it
will have 3 parameters to clone3() as shown in the above mail.

|=20
| > mmap() and mmap2() both have 6 parameters.
| >
| > Besides if wait4() were born before wait3(), would it still be wait=
4() :-)
| > But I see that it is hard to get one-convention-that-fits-all.
|=20
| Yes -- that's exactly right.
|=20
| >> It's better than "extended" or something
| >> like that simply because "extended" just means "more than", and a =
number
| >> at least tells you *how much more than*.
| >
| > And extended assumes we wont extend again.
|=20
| Well, if we do things right in this design, we may not need to ever
| extend (by creating a new syscall) again. That's why I mentioned the
| "flags" argument idea. Did you give this some thought?

Yes, we have done the best we can to avoid extending clone() again
anytime soon (some reserved bytes and clone_args_size field). Would
we still need the flags parameter ? Again its in the new patch
that I pointed to above.

|=20
| > An informal poll of reviewers has clone3() with a slight advantage =
:-)
| >
| > =A0 =A0 =A0 =A0clone_extended() camp: Serge Hallyn, Kerrisk, Louis =
Rilling,
| > =A0 =A0 =A0 =A0clone3(): Sukadev, H. Peter Anvin, Oren, Matt Helsle=
y.
| >
| > I like clone3() but am not insisting on it. I just want a name...
|=20
| And I'm not really insisting on a change. As you rightly point out,
| there is much inconsistency in the naming conventions that have been
| used over the years.
|=20
| But, because there has been no consistency in the use of numbers, and
| because the number of arguments that are presented in a glibc
| interface may differ from the number of arguments in an underlying
| syscall (several precedents: signalfd4(), pselect(), ppoll()), I'm
| inclined to think that clonex() or clone_ext() is slighly better than
| clone3(). But, certainly, my arguments are not compelling.
