From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH v3 0/2] capabilities: Ambient capability patchset
Date: Thu, 4 Jun 2015 12:33:18 -0700
Message-ID: <CALCETrW8s8eCAK_Ei=H27KQq-BynbTBPdA9qVjYRZ=Vu4Dif+g@mail.gmail.com>
References: <cover.1432770087.git.luto@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1432770087.git.luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Ted Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, "Andrew G. Morgan" <morgan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-security-module <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Aaron Jones <aaronmdjones-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Markku Savela <msa-kXoF896ld44xHbG02/KK1g@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, May 27, 2015 at 4:47 PM, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> This adds ambient capabilities.  See the individual patch changelogs
> for details.
>
> Preliminary userspace code is here:
>
> https://git.kernel.org/cgit/linux/kernel/git/luto/util-linux-playground.git/commit/?h=cap_ambient&id=7f5afbd175d2
>
> James or akpm, I think this is ready for 4.2.  Can one of you queue it up?

akpm / James: Ping?  Do I need more acks?

--Andy

>
> Thanks,
> Andy
>
> Changes from v2:
>  - Improve the patch 1 changelog a bit.
>  - Add acks.
>  - Add comment clarifying the pE' rule.
>  - s/except/expect
>
> Changes from v1:
>  - Lots of cleanups to the ambient cap code.
>  - The securebit is new.
>
> Andy Lutomirski (2):
>   capabilities: Ambient capabilities
>   capabilities: Add a securebit to disable PR_CAP_AMBIENT_RAISE
>
>  fs/proc/array.c                 |  5 ++-
>  include/linux/cred.h            |  8 ++++
>  include/uapi/linux/prctl.h      |  6 +++
>  include/uapi/linux/securebits.h | 11 ++++-
>  kernel/user_namespace.c         |  1 +
>  security/commoncap.c            | 92 ++++++++++++++++++++++++++++++++++++-----
>  security/keys/process_keys.c    |  1 +
>  7 files changed, 112 insertions(+), 12 deletions(-)
>
> --
> 2.1.0
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
