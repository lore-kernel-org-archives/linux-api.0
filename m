From: Matt Helsley <matthltc-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC][v8][PATCH 9/10]: Define clone3() syscall
Date: Mon, 19 Oct 2009 10:44:05 -0700
Message-ID: <20091019174405.GE27627@count0.beaverton.ibm.com>
References: <20091013044925.GA28181@us.ibm.com> <20091013045439.GI28435@us.ibm.com> <20091016042041.GA7220@us.ibm.com> <cfd18e0f0910152325m4a9125c2q18f36f5bd7d4a0@mail.gmail.com> <20091016180631.GA31036@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20091016180631.GA31036-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sukadev Bhattiprolu <sukadev-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, randy.dunlap-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Nathan Lynch <nathanl-V7BBcbaFuwjMbYB6QlFGEg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Louis.Rilling-aw0BnHfMbSpBDgjK7y7TUQ@public.gmane.org, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, mingo-X9Un+BFzKDI@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, roland-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Pavel Emelyanov <xemul-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Oct 16, 2009 at 11:06:31AM -0700, Sukadev Bhattiprolu wrote:
> Michael Kerrisk [mtk.manpages-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org] wrote:
> | Hi Sukadev
> |=20
> | On Fri, Oct 16, 2009 at 6:20 AM, Sukadev Bhattiprolu
> | <sukadev-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org> wrote:
> | > Here is an updated patch with the following interface:
> | >
> | > =A0 =A0 =A0 =A0long sys_clone3(unsigned int flags_low, struct clo=
ne_args __user *cs,
> | > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0pid_t *pids);
> | >
> | > There are just two other (minor) changes pending to this patchset=
:
> | >
> | > =A0 =A0 =A0 =A0- PATCH 7: add a CLONE_UNUSED bit to VALID_CLONE_F=
LAGS().
> | > =A0 =A0 =A0 =A0- PATCH 10: update documentation to reflect new in=
terface.
> | >
> | > If this looks ok, we repost entire patchset next week.
> |=20
> | I know I'm late to this discussion, but why the name clone3()? It's
> | not consistent with any other convention used fo syscall naming,
> | AFAICS. I think a name like clone_ext() or clonex() (for extended)
> | might make more sense.
>=20
> Sure, we talked about calling it clone_extended() and I can go back
> to that.
>=20
> Only minor concern with that name was if this new call ever needs to
> be extended, what would we call it :-). With clone3() we could add a
> real/fake parameter and call it clone4() :-p

Perhaps clone64 (somewhat like stat64 for example)?

Cheers,
	-Matt Helsley
