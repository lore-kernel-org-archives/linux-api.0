From: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH v2 0/7] CLONE_FD: Task exit notification via file
 descriptor
Date: Tue, 31 Mar 2015 22:08:07 +0200
Message-ID: <20150331220807.6927e780@lwn.net>
References: <cover.1426376419.git.josh@joshtriplett.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1426376419.git.josh@joshtriplett.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Josh Triplett <josh@joshtriplett.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>, Oleg Nesterov <oleg@redhat.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>, Rik van Riel <riel@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk <mtk.manpages@gmail.com>, Thiago Macieira <thiago.macieira@intel.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, x86@kernel.org
List-Id: linux-api@vger.kernel.org

So I finally got around to having a look at this, and one thing caught my
eye:

>              read(2) (and similar)
>                      When  the  new  process  exits,  reading  from  the  file
>                      descriptor produces a single clonefd_info structure:
> 
>                      struct clonefd_info {
>                          uint32_t code;   /* Signal code */
>                          uint32_t status; /* Exit status or signal */
>                          uint64_t utime;  /* User CPU time */
>                          uint64_t stime;  /* System CPU time */
>                      };

This would appear to assume that a clonefd_info structure is the only
thing that will ever be read from this descriptor.  It seems to me that
there is the potential for, someday, wanting to be able to read and write
other things as well.  Should this structure be marked with type and
length fields so that other structures could be added in the future?

(I suppose we could just use ioctl() for any other functionality in the
future, though...:)

jon
