From: Daniel Jacobowitz <dan-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC v7][PATCH 2/9] General infrastructure for checkpoint
	restart
Date: Wed, 22 Oct 2008 10:29:07 -0400
Message-ID: <20081022142907.GA13574@caradoc.them.org>
References: <1224481237-4892-1-git-send-email-orenl@cs.columbia.edu> <1224481237-4892-3-git-send-email-orenl@cs.columbia.edu> <20081021124130.a002e838.akpm@linux-foundation.org> <20081021202410.GA10423@us.ibm.com> <48FE82DF.6030005@cs.columbia.edu> <20081022025513.GA7504@caradoc.them.org> <1224644563.1848.232.camel@nimitz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1224644563.1848.232.camel@nimitz>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Hansen <dave-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: Oren Laadan <orenl-eQaUEPhvms7ENvBUuze7eA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, mingo-X9Un+BFzKDI@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Oct 21, 2008 at 08:02:43PM -0700, Dave Hansen wrote:
> Let's say you have a process you want to checkpoint.  If it uses a
> completely discrete IPC namespace, you *know* that nothing else depends
> on those IPC ids.  We don't even have to worry about who might have been
> using them and when.
> 
> Also think about pids.  Without containers, how can you guarantee a
> restarted process that it can regain the same pid?

OK, that makes sense.  In a lot of simple cases you can get by without
regaining the same pid; there's an implementation of checkpointing in
GDB that works by injecting fork calls into the child, and it is
useful for a reasonable selection of single-threaded programs.

-- 
Daniel Jacobowitz
CodeSourcery
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
