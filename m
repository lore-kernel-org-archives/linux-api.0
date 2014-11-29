From: Cyrill Gorcunov <gorcunov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH] proc, pidns: Add highpid
Date: Sat, 29 Nov 2014 19:06:59 +0300
Message-ID: <20141129160659.GA2256@moon>
References: <b0f6c4df0e8ef8afcc7b786edecb4be8c752941e.1417215468.git.luto@amacapital.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <b0f6c4df0e8ef8afcc7b786edecb4be8c752941e.1417215468.git.luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, systemd Mailing List <systemd-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Nov 28, 2014 at 03:05:01PM -0800, Andy Lutomirski wrote:
> Pid reuse is common, which means that it's difficult or impossible
> to read information about a pid from /proc without races.
> 
> This introduces a second number associated with each (task, pidns)
> pair called highpid.  Highpid is a 64-bit number, and, barring
> extremely unlikely circumstances or outright error, a (highpid, pid)
> will never be reused.
> 
> With just this change, a program can open /proc/PID/status, read the
> "Highpid" field, and confirm that it has the expected value.  If the
> pid has been reused, then highpid will be different.
> 
> The initial implementation is straightforward: highpid is simply a
> 64-bit counter. If a high-end system can fork every 3 ns (which
> would be amazing, given that just allocating a pid requires at
> atomic operation), it would take well over 1000 years for highpid to
> wrap.
> 
> For CRIU's benefit, the next highpid can be set by a privileged
> user.
> 
> NB: The sysctl stuff only works on 64-bit systems.  If the approach
> looks good, I'll fix that somehow.
> 
> Signed-off-by: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
> ---
> 
> If this goes in, there's plenty of room to add new interfaces to
> make this more useful.  For example, we could add a fancier tgkill
> that adds and validates hightgid and highpid, and we might want to
> add a syscall to read one's own hightgid and highpid.  These would
> be quite useful for pidfiles.
> 
> David, would this be useful for kdbus?
> 
> CRIU people: will this be unduly difficult to support in CRIU?

Hi Andy. I think it won't be hard to support.
