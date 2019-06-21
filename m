From: Matthew Garrett <mjg59-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V31 07/25] kexec_file: Restrict at runtime if the kernel
 is locked down
Date: Fri, 21 Jun 2019 13:18:03 -0700
Message-ID: <CACdnJut=J1YTpM4s6g5XWCEs+=X0Jvf8otfMg+w=_oqSZmf01Q@mail.gmail.com>
References: <20190326182742.16950-1-matthewgarrett@google.com>
 <20190326182742.16950-8-matthewgarrett@google.com>
 <20190621064340.GB4528@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
In-Reply-To: <20190621064340.GB4528-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/kexec/>
List-Post: <mailto:kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Help: <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=subscribe>
Sender: "kexec" <kexec-bounces-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Errors-To: kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
To: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jiri Bohac <jbohac-AlSwsSmVLrQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, James Morris <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, LSM List <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Jun 20, 2019 at 11:43 PM Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>
> On 03/26/19 at 11:27am, Matthew Garrett wrote:
> > From: Jiri Bohac <jbohac-AlSwsSmVLrQ@public.gmane.org>
> >
> > When KEXEC_SIG is not enabled, kernel should not load images through
> > kexec_file systemcall if the kernel is locked down.
> >
> > [Modified by David Howells to fit with modifications to the previous patch
> >  and to return -EPERM if the kernel is locked down for consistency with
> >  other lockdowns. Modified by Matthew Garrett to remove the IMA
> >  integration, which will be replaced by integrating with the IMA
> >  architecture policy patches.]
> >
> > Signed-off-by: Jiri Bohac <jbohac-AlSwsSmVLrQ@public.gmane.org>
> > Signed-off-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > Signed-off-by: Matthew Garrett <mjg59-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > Reviewed-by: Jiri Bohac <jbohac-AlSwsSmVLrQ@public.gmane.org>
> > cc: kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
> > ---
> >  kernel/kexec_file.c | 6 ++++++
> >  1 file changed, 6 insertions(+)
> >
> > diff --git a/kernel/kexec_file.c b/kernel/kexec_file.c
> > index 67f3a866eabe..a1cc37c8b43b 100644
> > --- a/kernel/kexec_file.c
> > +++ b/kernel/kexec_file.c
> > @@ -239,6 +239,12 @@ kimage_file_prepare_segments(struct kimage *image, int kernel_fd, int initrd_fd,
> >               }
> >
> >               ret = 0;
> > +
> > +             if (kernel_is_locked_down(reason, LOCKDOWN_INTEGRITY)) {
> > +                     ret = -EPERM;
> > +                     goto out;
> > +             }
> > +
>
> Checking here is late, it would be good to move the check to earlier
> code around below code:
>         /* We only trust the superuser with rebooting the system. */
>         if (!capable(CAP_SYS_BOOT) || kexec_load_disabled)
>                 return -EPERM;

I don't think so - we want it to be possible to load images if they
have a valid signature.
