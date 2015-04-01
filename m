From: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH v2 0/7] CLONE_FD: Task exit notification via file
 descriptor
Date: Wed, 1 Apr 2015 09:24:20 +0200
Message-ID: <20150401092420.4c1dbb6e@lwn.net>
References: <cover.1426376419.git.josh@joshtriplett.org>
	<20150331220807.6927e780@lwn.net>
	<20150331220224.GA22707@cloud>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150331220224.GA22707@cloud>
Sender: linux-kernel-owner@vger.kernel.org
To: josh@joshtriplett.org
Cc: Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>, Oleg Nesterov <oleg@redhat.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>, Rik van Riel <riel@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk <mtk.manpages@gmail.com>, Thiago Macieira <thiago.macieira@intel.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, x86@kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, 31 Mar 2015 15:02:24 -0700
josh@joshtriplett.org wrote:

> > This would appear to assume that a clonefd_info structure is the only
> > thing that will ever be read from this descriptor.  It seems to me that
> > there is the potential for, someday, wanting to be able to read and write
> > other things as well.  Should this structure be marked with type and
> > length fields so that other structures could be added in the future?  
> 
> I don't think it makes sense for a caller to get an arbitrary structure
> on read(), and have to figure out what they got and ignore something
> they don't understand.  Instead, I think it makes more sense for the
> caller to say "Hey, here's a flag saying I understand the new thing, go
> ahead and give me the new thing".  So, for instance, if you want to
> receive SIGSTOP/SIGCONT messages for child processes through this
> descriptor, we could add a flag for that.

The flag is fine, but, once we have set that flag saying we want those
messages, how do we know which type of structure we've gotten?  That's
the piece of the puzzle I'm missing, sorry if I'm being overly slow.

Thanks,

jon
