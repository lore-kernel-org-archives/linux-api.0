From: Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/2 v2] fdmap(2)
Date: Tue, 26 Sep 2017 22:00:18 +0300
Message-ID: <20170926190018.GA30898@avx2>
References: <20170924200620.GA24368@avx2>
 <9bc11ace-d111-cdef-5280-8cdda027ae9a@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <9bc11ace-d111-cdef-5280-8cdda027ae9a-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, gladkov.alexey-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Aliaksandr Patseyenak <Aliaksandr_Patseyenak1-uRwfk40T5oI@public.gmane.org>, Tatsiana_Brouka-uRwfk40T5oI@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, Sep 25, 2017 at 09:42:58AM +0200, Michael Kerrisk (man-pages) wrote:
> [Not sure why original author is not in CC; added]
> 
> Hello Alexey,
> 
> On 09/24/2017 10:06 PM, Alexey Dobriyan wrote:
> > From: Aliaksandr Patseyenak <Aliaksandr_Patseyenak1-uRwfk40T5oI@public.gmane.org>
> > 
> > Implement system call for bulk retrieveing of opened descriptors
> > in binary form.
> > 
> > Some daemons could use it to reliably close file descriptors
> > before starting. Currently they close everything upto some number
> > which formally is not reliable. Other natural users are lsof(1) and CRIU
> > (although lsof does so much in /proc that the effect is thoroughly buried).
> > 
> > /proc, the only way to learn anything about file descriptors may not be
> > available. There is unavoidable overhead associated with instantiating
> > 3 dentries and 3 inodes and converting integers to strings and back.
> > 
> > Benchmark:
> > 
> > 	N=1<<22 times
> > 	4 opened descriptors (0, 1, 2, 3)
> > 	opendir+readdir+closedir /proc/self/fd vs fdmap
> > 
> > 	/proc 8.31 ± 0.37%
> > 	fdmap 0.32 ± 0.72%
> 
> From the text above, I'm still trying to understand: whose problem
> does this solve? I mean, we've lived with the daemon-close-all-files
> technique forever (and I'm not sure that performance is really an 
> important issue for the daemon case) .

> And you say that the effect for lsof(1) will be buried.

If only fdmap(2) is added, then effect will be negligible for lsof
because it has to go through /proc anyway.

The idea is to start process. In ideal world, only bynary system calls
would exist and shells could emulate /proc/* same way bash implement
/dev/tcp

> So, who does this new system call
> really help? (Note: I'm not saying don't add the syscall, but from
> explanation given here, it's not clear why we should.)

For fdmap(2) natural users are lsof(), CRIU.

At some point, checkpointing was moved to userspace forcing them
to run all over /proc extracting information which could be recovered in
couple of locks, bunch of list iterations and dereferences (just read CRIU).
All of this could not be beneficial for performance.

Parsing text files doesn't help either: most of the numbers in
/proc/*/stat et al are unpadded decimals so that user can't rewind to
exact field he wants.
