From: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Subject: Re: [PATCH] selftests/exec: Check if the syscall exists and bail if
 not
Date: Fri, 23 Jan 2015 17:01:26 +1100
Message-ID: <1421992886.24984.17.camel@ellerman.id.au>
References: <1421826060-2237-1-git-send-email-mpe@ellerman.id.au>
	 <CAHse=S_AWuY4YG7DJeU+Rma-kPuQLGZH2oqVV27RvF4unu61Aw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAHse=S_AWuY4YG7DJeU+Rma-kPuQLGZH2oqVV27RvF4unu61Aw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, davej-rdkfGonbjUTCLXcRTR1eJlpr/1R2p/CL@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, 2015-01-21 at 10:22 +0000, David Drysdale wrote:
> On Wed, Jan 21, 2015 at 7:41 AM, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org> wrote:
> > On systems which don't implement sys_execveat(), this test produces a
> > lot of output.
> >
> > Add a check at the beginning to see if the syscall is present, and if
> > not just note one error and return.
> 
> Good point, thanks.
> 
> > diff --git a/tools/testing/selftests/exec/execveat.c b/tools/testing/selftests/exec/execveat.c
> > index e238c9559caf..b87e4a843bea 100644
> > --- a/tools/testing/selftests/exec/execveat.c
> > +++ b/tools/testing/selftests/exec/execveat.c
> > @@ -234,6 +234,14 @@ static int run_tests(void)
> >         int fd_cloexec = open_or_die("execveat", O_RDONLY|O_CLOEXEC);
> >         int fd_script_cloexec = open_or_die("script", O_RDONLY|O_CLOEXEC);
> >
> > +       /* Check if we have execveat at all, and bail early if not */
> > +       errno = 0;
> > +       execveat_(-1, NULL, NULL, NULL, 0);
> > +       if (errno == -ENOSYS) {
> 
> Could we change this to ENOSYS (no minus) and also change
> the execveat_() function similarly, so that a binary built where
> __NR_execveat is available but running where it isn't also exits
> early?  (My bad for having the minus sign in execveat_() in the
> first place -- fingers too used to kernel mode.)

Ah yeah, me too, -ENOSYS just came naturally.

Will fix up and retest and resend.

cheers
