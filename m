From: "Joseph S. Myers" <joseph-qD8j1LwMmJjtCj0u4l0SBw@public.gmane.org>
Subject: Re: MIPS MSA sigcontext changes in 3.15
Date: Tue, 17 Jun 2014 15:44:36 +0000
Message-ID: <Pine.LNX.4.64.1406171539240.23412@digraph.polyomino.org.uk>
References: <Pine.LNX.4.64.1406171447030.23412@digraph.polyomino.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.64.1406171447030.23412-9YEB1lltEqivcGRMvF24k2I39yigxGEX@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-mips-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org, libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, 17 Jun 2014, Joseph S. Myers wrote:

> signal mask at a particular offset in the ucontext.  As far as I can see, 
> extending sigcontext requires a new sigaction flag that could be used to 
> opt in, for a particular signal handler, to receiving the new-layout 
> ucontext (so new symbol versions of sigaction in glibc could then pass 
> that flag to the kernel, but existing binaries would continue to get 
> old-layout ucontext from the kernel), or else putting the new data at the 

And a new flag would itself be problematic - signal handlers would need 
wrapping with userspace code to convert structure layout when new-version 
sigaction is used on an older kernel.  That suggests putting the new data 
at the end of ucontext is to be preferred (but in any case it would be 
best to revert the incompatible changes until something compatible with 
existing userspace can be produced).

-- 
Joseph S. Myers
joseph-qD8j1LwMmJjtCj0u4l0SBw@public.gmane.org
