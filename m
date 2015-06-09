From: Tycho Andersen <tycho.andersen-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: Re: [PATCH v2] seccomp: add ptrace options for suspend/resume
Date: Tue, 9 Jun 2015 15:52:27 -0600
Message-ID: <20150609215227.GG2045@hopstrocity>
References: <1433369396-13360-1-git-send-email-tycho.andersen@canonical.com>
 <20150604183149.GA560@redhat.com>
 <20150604210529.GJ3160@smitten>
 <20150605211650.GA25718@redhat.com>
 <20150609212222.GE2045@hopstrocity>
 <CAGXu5jLC-DcS-Mg5OTM-LEkuOKMMGrV2tq+Lky1Mxh_rDLa4Bg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAGXu5jLC-DcS-Mg5OTM-LEkuOKMMGrV2tq+Lky1Mxh_rDLa4Bg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Roland McGrath <roland-/Z5OmTQCD9xF6kxbq+BtvQ@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Jun 09, 2015 at 02:45:49PM -0700, Kees Cook wrote:
> On Tue, Jun 9, 2015 at 2:22 PM, Tycho Andersen
> <tycho.andersen-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org> wrote:
> > Hi Kees, Andy,
> >
> > On Fri, Jun 05, 2015 at 11:16:50PM +0200, Oleg Nesterov wrote:
> >> Hi Tycho,
> >>
> >> On 06/04, Tycho Andersen wrote:
> >> > > > +#ifdef CONFIG_CHECKPOINT_RESTORE
> >> > > > +bool may_suspend_seccomp(void)
> >> > > > +{
> >> > > > +       if (!capable(CAP_SYS_ADMIN))
> >> > > > +               return false;
> >> > > > +
> >> > > > +       if (current->seccomp.mode != SECCOMP_MODE_DISABLED)
> >> > > > +               return false;
> >> > >
> >> > > Heh. OK, I won't argue with the new check too ;)
> >> >
> >> > Actually now that I think about it I agree with you, these checks
> >> > don't seem necessary. Even inside a user namespace, if you can ptrace
> >> > a process you can make it do whatever you want irrespective of
> >> > seccomp, as long as it has the necessary capabilities. Once the
> >> > seccomp checks are run after ptrace, they'll be enforced so you
> >> > couldn't have it call whatever you want in the first place.
> >>
> >> Good ;)
> >>
> >> > Still, perhaps I'm missing something...
> >>
> >> Kees, Andy?
> >
> > Any thoughts on removing may_suspend_seccomp() all together?
> 
> As in, just open-code the check? That would be fine by me.

Sorry, I meant getting rid of any checks entirely. Using my argument
above I've managed to convince myself they don't add any value. You
guys know a lot more about this than I do, though.

Tycho
