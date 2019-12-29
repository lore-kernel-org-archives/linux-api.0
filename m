From: Tycho Andersen <tycho@tycho.ws>
Subject: Re: [PATCH v2 1/2] samples, selftests/seccomp: Zero out seccomp_notif
Date: Sat, 28 Dec 2019 17:18:18 -0700
Message-ID: <20191229001818.GC6746@cisco>
References: <20191228014837.GA31774@ircssh-2.c.rugged-nimbus-611.internal>
 <20191228181825.GB6746@cisco>
 <CAMp4zn91GoB=1eTbc_ux4eNs2-QFm+JocodgFQYUiiXL7H4m9w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAMp4zn91GoB=1eTbc_ux4eNs2-QFm+JocodgFQYUiiXL7H4m9w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sargun Dhillon <sargun@sargun.me>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Jann Horn <jannh@google.com>, Christian Brauner <christian.brauner@ubuntu.com>, Kees Cook <keescook@chromium.org>, Aleksa Sarai <cyphar@cyphar.com>
List-Id: linux-api@vger.kernel.org

On Sat, Dec 28, 2019 at 07:10:29PM -0500, Sargun Dhillon wrote:
> On Sat, Dec 28, 2019 at 1:18 PM Tycho Andersen <tycho@tycho.ws> wrote:
> >
> > On Sat, Dec 28, 2019 at 01:48:39AM +0000, Sargun Dhillon wrote:
> > > The seccomp_notif structure should be zeroed out prior to calling the
> > > SECCOMP_IOCTL_NOTIF_RECV ioctl. Previously, the kernel did not check
> > > whether these structures were zeroed out or not, so these worked.
> > >
> > > Signed-off-by: Sargun Dhillon <sargun@sargun.me>
> > > Cc: Kees Cook <keescook@chromium.org>
> > > ---
> > >  samples/seccomp/user-trap.c                   | 2 +-
> > >  tools/testing/selftests/seccomp/seccomp_bpf.c | 2 ++
> > >  2 files changed, 3 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/samples/seccomp/user-trap.c b/samples/seccomp/user-trap.c
> > > index 6d0125ca8af7..0ca8fb37cd79 100644
> > > --- a/samples/seccomp/user-trap.c
> > > +++ b/samples/seccomp/user-trap.c
> > > @@ -298,7 +298,6 @@ int main(void)
> > >               req = malloc(sizes.seccomp_notif);
> > >               if (!req)
> > >                       goto out_close;
> > > -             memset(req, 0, sizeof(*req));
> > >
> > >               resp = malloc(sizes.seccomp_notif_resp);
> > >               if (!resp)
> > > @@ -306,6 +305,7 @@ int main(void)
> > >               memset(resp, 0, sizeof(*resp));
> >
> > I know it's unrelated, but it's probably worth sending a patch to fix
> > this to be sizes.seccomp_notif_resp instead of sizeof(*resp), since if
> > the kernel is older this will over-zero things. I can do that, or you
> > can add the patch to this series, just let me know which.
> 
> I was thinking about this, and initially, I chose to make the smaller
> change. I think it might make more sense to combine the patch,
> given that the memset behaviour is "incorrect" if we do it based on
> sizeof(*req), or sizeof(*resp).
> 
> I'll go ahead and respin this patch with the change to call memset
> based on sizes.

I think it would be good to keep it as a separate patch, since it's an
unrelated bug fix. That way if we have to revert these because of some
breakage, we won't lose the fix.

Cheers,

Tycho
