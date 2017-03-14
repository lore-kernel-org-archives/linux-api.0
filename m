From: Carlos O'Donell <carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: binfmts.h MAX_ARG_STRINGS excessive value allows heap spraying
Date: Mon, 13 Mar 2017 20:51:50 -0400
Message-ID: <b736f01f-ef0a-56de-bf57-c6d3d74262a4@redhat.com>
References: <1488897868.5178.3.camel@quad>
 <f7f9f60b-0f39-7dce-1778-3aa40ba198ef@redhat.com>
 <1488997111.5155.10.camel@quad>
 <f16cd7f8-f996-cf66-d640-50b0ccee06c7@redhat.com>
 <1489068854.1026.14.camel@quad>
 <81d8e14e-e110-4b96-5d45-8bb3b56f4866@redhat.com>
 <1489147810.5038.31.camel@quad>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1489147810.5038.31.camel@quad>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leonard den Ottolander <leonard-lists-2Avth2y2NeLyQNdsBcn8aGZHpeb/A1Y/@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 03/10/2017 07:10 AM, Leonard den Ottolander wrote:
> A whopping gigabyte on 32 bit systems for arguments passed to an
> executable. That sounds excessive. A use case of "ls *"-ing 128k files
> with 32 byte names adds up to 4 MiB. That is 16 times what you need to
> build a kernel. That sounds sufficient don't you think? And again, if
> not, show us a use case.

You have already been given use cases.

* Mail spool directory with millions of files.

* Large and complex build system with potentially long paths.

Artificial limits are always going to cause problems, particularly when
going from a higher limit to a lower limit.

Your present justification is simply that nobody could have use for
lots of arguments, which is not true, and that heap spraying needs to be
stopped, which may be right but may not be the place to start.

We should investigate other ways in which we can tackle the manner in
which the zero day was carried out (like malloc metadata hardening for
the default glibc allocator).

Fundamentally our disagreement is about the risk versus value of the
code in the kernel. Because we disagree about risk and value we will
disagree about the action that needs to be taken.

You have now been given the expert opinion of Joseph Myers and myself,
so take that as you will.

Deployed existing code stands, and the burden of proof is on _you_ to
justify changing the code, not on me to justify all the use cases that
users might have for the current implementation.

Please invite more experts, security or otherwise, to come discuss on
linux-api, the relative merits of _where_ we should be fixing attacks
of this kind.

-- 
Cheers,
Carlos.
