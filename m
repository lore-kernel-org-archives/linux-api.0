From: "Dmitry V. Levin" <ldv@altlinux.org>
Subject: Re: [PATCH] samples: make pidfd-metadata fail gracefully on older
 kernels
Date: Thu, 20 Jun 2019 14:00:37 +0300
Message-ID: <20190620110037.GA4998@altlinux.org>
References: <20190620103105.cdxgqfelzlnkmblv@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190620103105.cdxgqfelzlnkmblv@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian@brauner.io>
Cc: Jann Horn <jannh@google.com>, Oleg Nesterov <oleg@redhat.com>, Arnd Bergmann <arnd@arndb.de>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Cc'ed more people as the issue is not just with the example but
with the interface itself.

On Thu, Jun 20, 2019 at 12:31:06PM +0200, Christian Brauner wrote:
> On Thu, Jun 20, 2019 at 06:11:44AM +0300, Dmitry V. Levin wrote:
> > Initialize pidfd to an invalid descriptor, to fail gracefully on
> > those kernels that do not implement CLONE_PIDFD and leave pidfd
> > unchanged.
> > 
> > Signed-off-by: Dmitry V. Levin <ldv@altlinux.org>
> > ---
> >  samples/pidfd/pidfd-metadata.c | 8 ++++++--
> >  1 file changed, 6 insertions(+), 2 deletions(-)
> > 
> > diff --git a/samples/pidfd/pidfd-metadata.c b/samples/pidfd/pidfd-metadata.c
> > index 14b454448429..ff109fdac3a5 100644
> > --- a/samples/pidfd/pidfd-metadata.c
> > +++ b/samples/pidfd/pidfd-metadata.c
> > @@ -83,7 +83,7 @@ static int pidfd_metadata_fd(pid_t pid, int pidfd)
> >  
> >  int main(int argc, char *argv[])
> >  {
> > -	int pidfd = 0, ret = EXIT_FAILURE;
> > +	int pidfd = -1, ret = EXIT_FAILURE;
> 
> Hm, that currently won't work since we added a check in fork.c for
> pidfd == 0. If it isn't you'll get EINVAL.

Sorry, I must've missed that check.  But this makes things even worse.

> This was done to ensure that
> we can potentially extend CLONE_PIDFD by passing in flags through the
> return argument.
> However, I find this increasingly unlikely. Especially since the
> interface would be horrendous and an absolute last resort.
> If clone3() gets merged for 5.3 (currently in linux-next) we also have
> no real need anymore to extend legacy clone() this way. So either wait
> until (if) we merge clone3() where the check I mentioned is gone anyway,
> or remove the pidfd == 0 check from fork.c in a preliminary patch.
> Thoughts?

Userspace needs a reliable way to tell whether CLONE_PIDFD is supported
by the kernel or not.

If CLONE_PIDFD is not supported, then pidfd remains unchanged.

If CLONE_PIDFD is supported and fd 0 is closed, then mandatory pidfd == 0
also remains unchanged, which effectively means that userspace must ensure
that fd 0 is not closed when invoking CLONE_PIDFD.  This is ugly.

If we can assume that clone(CLONE_PIDFD) is not going to be extended,
then I'm for removing the pidfd == 0 check along with recommending
userspace to initialize pidfd with -1.


-- 
ldv
