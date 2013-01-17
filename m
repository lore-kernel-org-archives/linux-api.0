From: Andrew Vagin <avagin@parallels.com>
Subject: Re: [PATCH 2/3] signalfd: add ability to return siginfo in a raw
 format (v2)
Date: Thu, 17 Jan 2013 19:28:16 +0400
Message-ID: <20130117152816.GB26891@paralelels.com>
References: <1358182435-19245-1-git-send-email-avagin@openvz.org>
 <1358182435-19245-3-git-send-email-avagin@openvz.org>
 <20130116123502.70af6b85.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="koi8-r"
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130116123502.70af6b85.akpm@linux-foundation.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrey Vagin <avagin@openvz.org>, linux-kernel@vger.kernel.org, criu@openvz.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, David Howells <dhowells@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@redhat.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Pavel Emelyanov <xemul@parallels.com>, Cyrill Gorcunov <gorcunov@openvz.org>
List-Id: linux-api@vger.kernel.org

On Wed, Jan 16, 2013 at 12:35:02PM -0800, Andrew Morton wrote:
> > --- a/include/uapi/linux/signalfd.h
> > +++ b/include/uapi/linux/signalfd.h
> > @@ -15,6 +15,7 @@
> >  /* Flags for signalfd4.  */
> >  #define SFD_CLOEXEC O_CLOEXEC
> >  #define SFD_NONBLOCK O_NONBLOCK
> > +#define SFD_RAW O_DIRECT
> >  
> >  struct signalfd_siginfo {
> >  	__u32 ssi_signo;
> 
> As SFD_RAW is being added to the kernel API we should document it. 
> Please keep Michael cc'ed and work with him on getting the manpages
> updated.

Ok

> 
> I usually ask that checkpoint-restart specific code be wrapped in
> #ifdef CONFIG_CHECKPOINT_RESTORE, mainly so we can identify it all
> if/when your project fails and we decide to remove the feature ;) But
> as this patch extends the user API I think it simplifies life if we
> make the extension permanent.  Perhaps this is a bad idea, as
> permanently adding this extension to the API makes it harder to ever
> remove the c/r feature.  

I think CRIU is already enough functional to be successful ;).
It already can dump/restore a Linux Container with Oracle Data Base,
Apache and a few other deamons.

> 
> 
> Proposed fixups.  Please review and test this and check that sparse is
> happy with it.
>
I have tested this patch. All is ok and sparce are happy with it.

Thank you.
