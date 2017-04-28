From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v8 1/4] syscalls: Verify address limit before returning
 to user-mode
Date: Fri, 28 Apr 2017 08:33:23 +0200
Message-ID: <20170428063323.ntnc4tk7do2dor76@gmail.com>
References: <20170426183425.32158-1-thgarnie@google.com>
 <20170427064917.phwo6yl4v4q43fql@gmail.com>
 <CAJcbSZENjCgn3TNDGzCBBSOXMvbTX8mBO7Trugdb5VRzhxwmHg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAJcbSZENjCgn3TNDGzCBBSOXMvbTX8mBO7Trugdb5VRzhxwmHg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thomas Garnier <thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Martin Schwidefsky <schwidefsky-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Heiko Carstens <heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, =?iso-8859-1?Q?Ren=E9?= Nyffenegger <mail-gLCNRsNSrVdVZEhyV+6z5nIPMjoJpjVV@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Paul E . McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "Eric W . Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Pavel Tikhomirov <ptikhomirov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Josh Poimboeuf <jpoimboe@redhat.c>
List-Id: linux-api@vger.kernel.org


* Thomas Garnier <thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:

> > BTW., a further simplification would be:
> >
> > #ifndef ADDR_LIMIT_CHECK_PRE
> > # define ADDR_LIMIT_CHECK_PRE ...
> > #endif
> >
> > This way architectures could override this generic functionality simply by
> > defining the helpers. Architectures that don't do that get the generic version.
> 
> I don't think architectures need to do that. The optimizations are
> embedding the checks on their architecture-specific code to make it
> faster and remove the size impact. The pre/post is fine for the rest.

Indeed, only the generic code needs to turn off that code - architectures will 
place these callbacks elsewhere.

Thanks,

	Ingo
