From: Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH] samples: make pidfd-metadata fail gracefully on older
 kernels
Date: Sat, 22 Jun 2019 00:13:39 +0200
Message-ID: <20190621221339.6yj4vg4zexv4y2j7@brauner.io>
References: <20190620103105.cdxgqfelzlnkmblv@brauner.io>
 <20190620110037.GA4998@altlinux.org>
 <20190620111036.asi3mbcv4ax5ekrw@brauner.io>
 <20190621170613.GA26182@altlinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190621170613.GA26182@altlinux.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Dmitry V. Levin" <ldv@altlinux.org>
Cc: Jann Horn <jannh@google.com>, Oleg Nesterov <oleg@redhat.com>, Arnd Bergmann <arnd@arndb.de>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, Jun 21, 2019 at 08:06:14PM +0300, Dmitry V. Levin wrote:
> On Thu, Jun 20, 2019 at 01:10:37PM +0200, Christian Brauner wrote:
> > On Thu, Jun 20, 2019 at 02:00:37PM +0300, Dmitry V. Levin wrote:
> > > Cc'ed more people as the issue is not just with the example but
> > > with the interface itself.
> > > 
> > > On Thu, Jun 20, 2019 at 12:31:06PM +0200, Christian Brauner wrote:
> > > > On Thu, Jun 20, 2019 at 06:11:44AM +0300, Dmitry V. Levin wrote:
> > > > > Initialize pidfd to an invalid descriptor, to fail gracefully on
> > > > > those kernels that do not implement CLONE_PIDFD and leave pidfd
> > > > > unchanged.
> > > > > 
> > > > > Signed-off-by: Dmitry V. Levin <ldv@altlinux.org>
> > > > > ---
> > > > >  samples/pidfd/pidfd-metadata.c | 8 ++++++--
> > > > >  1 file changed, 6 insertions(+), 2 deletions(-)
> > > > > 
> > > > > diff --git a/samples/pidfd/pidfd-metadata.c b/samples/pidfd/pidfd-metadata.c
> > > > > index 14b454448429..ff109fdac3a5 100644
> > > > > --- a/samples/pidfd/pidfd-metadata.c
> > > > > +++ b/samples/pidfd/pidfd-metadata.c
> > > > > @@ -83,7 +83,7 @@ static int pidfd_metadata_fd(pid_t pid, int pidfd)
> > > > >  
> > > > >  int main(int argc, char *argv[])
> > > > >  {
> > > > > -	int pidfd = 0, ret = EXIT_FAILURE;
> > > > > +	int pidfd = -1, ret = EXIT_FAILURE;
> > > > 
> > > > Hm, that currently won't work since we added a check in fork.c for
> > > > pidfd == 0. If it isn't you'll get EINVAL.
> > > 
> > > Sorry, I must've missed that check.  But this makes things even worse.
> > > 
> > > > This was done to ensure that
> > > > we can potentially extend CLONE_PIDFD by passing in flags through the
> > > > return argument.
> > > > However, I find this increasingly unlikely. Especially since the
> > > > interface would be horrendous and an absolute last resort.
> > > > If clone3() gets merged for 5.3 (currently in linux-next) we also have
> > > > no real need anymore to extend legacy clone() this way. So either wait
> > > > until (if) we merge clone3() where the check I mentioned is gone anyway,
> > > > or remove the pidfd == 0 check from fork.c in a preliminary patch.
> > > > Thoughts?
> > > 
> > > Userspace needs a reliable way to tell whether CLONE_PIDFD is supported
> > > by the kernel or not.
> > 
> > Right, that's the general problem with legacy clone(): it ignores
> > unknown flags... clone3() will EINVAL you if you pass any flag it
> > doesn't know about.
> > 
> > For legacy clone you can pass
> > 
> > (CLONE_PIDFD | CLONE_DETACHED)
> > 
> > on all relevant kernels >= 2.6.2. CLONE_DETACHED will be silently
> > ignored by the kernel if specified in flags. But if you specify both
> > CLONE_PIDFD and CLONE_DETACHED on a kernel that does support CLONE_PIDFD
> > you'll get EINVALed. (We did this because we wanted to have the ability
> > to make CLONE_DETACHED reuseable with CLONE_PIDFD.)
> > Does that help?
> 
> Yes, this is feasible, but the cost is extra syscall for new kernels
> and more complicated userspace code, so...

Out of curiosity: what makes the new flag different than say
CLONE_NEWCGROUP or any new clone flag that got introduced?
CLONE_NEWCGROUP too would not be detectable apart from the method I gave
you above; same for other clone flags. Why are you so keen on being able
to detect this flag when other flags didn't seem to matter that much.
(Again, mere curiosity.)

> 
> > > If CLONE_PIDFD is not supported, then pidfd remains unchanged.
> > > 
> > > If CLONE_PIDFD is supported and fd 0 is closed, then mandatory pidfd == 0
> > > also remains unchanged, which effectively means that userspace must ensure
> > > that fd 0 is not closed when invoking CLONE_PIDFD.  This is ugly.
> > > 
> > > If we can assume that clone(CLONE_PIDFD) is not going to be extended,
> > > then I'm for removing the pidfd == 0 check along with recommending
> > > userspace to initialize pidfd with -1.
> > 
> > Right, I'm ok with that too.
> 
> ... I'd prefer this variant.

Please send a patch for review.

Christian
