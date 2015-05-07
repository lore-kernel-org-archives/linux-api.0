From: Paul Bolle <pebolle-IWqWACnzNjzz+pZb47iToQ@public.gmane.org>
Subject: Re: [PATCH 00/19] converting system calls to 64-bit time_t, part 1
Date: Thu, 07 May 2015 09:27:58 +0200
Message-ID: <1430983678.8171.23.camel@x220>
References: <1430929826-318934-1-git-send-email-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1430929826-318934-1-git-send-email-arnd-r2nGTMty4D4@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: y2038-cunTk1MwBs8s++Sfvej+rw@public.gmane.org, baolin.wang-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, albert.aribaud-iEu9NFBzPZE@public.gmane.org, john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, bamvor.zhangjian-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, ruchandani.tina-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, 2015-05-06 at 18:30 +0200, Arnd Bergmann wrote:
> * After all system calls are converted, we can change one architecture
>   at a time to select ARCH_HAS_COMPAT_TIME, and modify its system
>   call table accordingly. In this version, I do it for ARM32, x86-32,
>   and x86-64 for demonstration purposes.

Perhaps this was correct for your first draft. Because this series adds
ARCH_HAS_COMPAT_TIME in 04/19, but it doesn't add any selects of that
symbol, does it? As far as I can see ARCH_HAS_COMPAT_TIME simply
functions as an alias for COMPAT in this series.

> * A follow-up series changes over all other architectures.
> 
> * The last patch in the series changes the CONFIG_COMPAT_TIME
>   Kconfig symbol to be user visible. Disabling this symbol will
>   get you a kernel that intentionally breaks support for old tasks
>   in order to provide an interface that will survive 2038.

This doesn't happen in 19/19, or in any other patch in this series.
Maybe also something that has changed since the first draft.

>   This is meant mostly as a debugging help for now, to let people
>   build a y2038 safe distro, but at some point in the 2030s, we
>   should remove that option and all the compat handling.

Thanks,


Paul Bolle
