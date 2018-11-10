From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: Official Linux system wrapper library?
Date: Sat, 10 Nov 2018 11:20:27 -0800
Message-ID: <20181110192027.GA29892@kroah.com>
References: <CAKOZuesB4R=dCz4merWQN0FSCGrXmOgUUr4ienSbStBJguNv8g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKOZuesB4R=dCz4merWQN0FSCGrXmOgUUr4ienSbStBJguNv8g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Daniel Colascione <dancol@google.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Joel Fernandes <joelaf@google.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Sat, Nov 10, 2018 at 10:52:06AM -0800, Daniel Colascione wrote:
> Now that glibc is basically not adding any new system call wrappers,

Why are they not doing that anymore?

And there's no reason you have to use glibc, there are many other libcs
out there that hopefully are adding the new syscalls :)

> how about publishing an "official" system call glue library as part of
> the kernel distribution, along with the uapi headers? I don't think
> it's reasonable to expect people to keep using syscall(__NR_XXX) for
> all new functionality, especially as the system grows increasingly
> sophisticated capabilities (like the new mount API, and hopefully the
> new process API) outside the strictures of the POSIX process.

Patches are always welcome to be reviewed.  But watch out that they
don't conflict with the libc headers.  I know we had a "klibc" proposed
a long time ago but that died off for various reasons before it could
get merged.

Also, what about the basic work of making sure our uapi header files can
actually be used untouched by a libc?  That isn't the case these days as
the bionic maintainers like to keep reminding me.  That might be a good
thing to do _before_ trying to add new things like syscall wrappers.

thanks,

greg k-h
