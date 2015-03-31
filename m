From: josh@joshtriplett.org
Subject: Re: [PATCH v2 0/7] CLONE_FD: Task exit notification via file
 descriptor
Date: Tue, 31 Mar 2015 15:02:24 -0700
Message-ID: <20150331220224.GA22707@cloud>
References: <cover.1426376419.git.josh@joshtriplett.org>
 <20150331220807.6927e780@lwn.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150331220807.6927e780@lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Jonathan Corbet <corbet@lwn.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>, Oleg Nesterov <oleg@redhat.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>, Rik van Riel <riel@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk <mtk.manpages@gmail.com>, Thiago Macieira <thiago.macieira@intel.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, x86@kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, Mar 31, 2015 at 10:08:07PM +0200, Jonathan Corbet wrote:
> So I finally got around to having a look at this, and one thing caught my
> eye:
> 
> >              read(2) (and similar)
> >                      When  the  new  process  exits,  reading  from  the  file
> >                      descriptor produces a single clonefd_info structure:
> > 
> >                      struct clonefd_info {
> >                          uint32_t code;   /* Signal code */
> >                          uint32_t status; /* Exit status or signal */
> >                          uint64_t utime;  /* User CPU time */
> >                          uint64_t stime;  /* System CPU time */
> >                      };
> 
> This would appear to assume that a clonefd_info structure is the only
> thing that will ever be read from this descriptor.  It seems to me that
> there is the potential for, someday, wanting to be able to read and write
> other things as well.  Should this structure be marked with type and
> length fields so that other structures could be added in the future?

I don't think it makes sense for a caller to get an arbitrary structure
on read(), and have to figure out what they got and ignore something
they don't understand.  Instead, I think it makes more sense for the
caller to say "Hey, here's a flag saying I understand the new thing, go
ahead and give me the new thing".  So, for instance, if you want to
receive SIGSTOP/SIGCONT messages for child processes through this
descriptor, we could add a flag for that.

- Josh Triplett
