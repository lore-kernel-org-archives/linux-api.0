From: Joseph Myers <joseph-qD8j1LwMmJjtCj0u4l0SBw@public.gmane.org>
Subject: Re: binfmts.h MAX_ARG_STRINGS excessive value allows heap spraying
Date: Wed, 8 Mar 2017 20:47:33 +0000
Message-ID: <alpine.DEB.2.20.1703082042100.2181@digraph.polyomino.org.uk>
References: <1488897868.5178.3.camel@quad>         <f7f9f60b-0f39-7dce-1778-3aa40ba198ef@redhat.com> <1488997111.5155.10.camel@quad>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1488997111.5155.10.camel@quad>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leonard den Ottolander <leonard-lists-2Avth2y2NeLyQNdsBcn8aGZHpeb/A1Y/@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, 8 Mar 2017, Leonard den Ottolander wrote:

> If you don't feel the limit of 4096 arguments is sufficient please
> provide us with an example where that limit is insufficient.

mv * /some/where/

(in a directory with many files).

Linking thousands of .o files into a large program or putting them in a .a 
file in a single command.

Constructing a make command line with thousands of -o options to mark 
files as considered to be old (a real case where I ran into the old 128k 
limit when it was there).

There are of course workarounds for these - but "the number of files in 
the source + build trees of a very large project" seems a better way of 
judging limits than 4096.

-- 
Joseph S. Myers
joseph-qD8j1LwMmJjtCj0u4l0SBw@public.gmane.org
