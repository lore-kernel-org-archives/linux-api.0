From: Paul Burton <paul.burton-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>
Subject: Re: MIPS MSA sigcontext changes in 3.15
Date: Tue, 17 Jun 2014 19:14:09 +0100
Message-ID: <20140617181409.GD7020@pburton-laptop.home>
References: <Pine.LNX.4.64.1406171447030.23412@digraph.polyomino.org.uk>
 <Pine.LNX.4.64.1406171539240.23412@digraph.polyomino.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1406171539240.23412-9YEB1lltEqivcGRMvF24k2I39yigxGEX@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Joseph S. Myers" <joseph-qD8j1LwMmJjtCj0u4l0SBw@public.gmane.org>
Cc: linux-mips-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org, libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Jun 17, 2014 at 03:44:36PM +0000, Joseph S. Myers wrote:
> On Tue, 17 Jun 2014, Joseph S. Myers wrote:
> 
> > signal mask at a particular offset in the ucontext.  As far as I can see, 
> > extending sigcontext requires a new sigaction flag that could be used to 
> > opt in, for a particular signal handler, to receiving the new-layout 
> > ucontext (so new symbol versions of sigaction in glibc could then pass 
> > that flag to the kernel, but existing binaries would continue to get 
> > old-layout ucontext from the kernel), or else putting the new data at the 
> 
> And a new flag would itself be problematic - signal handlers would need 
> wrapping with userspace code to convert structure layout when new-version 
> sigaction is used on an older kernel.  That suggests putting the new data 
> at the end of ucontext is to be preferred (but in any case it would be 
> best to revert the incompatible changes until something compatible with 
> existing userspace can be produced).
> 
> -- 
> Joseph S. Myers
> joseph-qD8j1LwMmJjtCj0u4l0SBw@public.gmane.org
> 

True. Oops. I hadn't realised this...

I wonder if the sensible thing is to switch to sigcontext merely
containing a pointer to another struct holding FP state, much like x86.
Only in response to a flag as you describe of course. That way the
kernel could avoid the games it currently plays with splitting the
vector registers into 64b pieces, and it would probably be more open
to wider vector registers if they appear in the future.

Anyway, I agree with reverting the sigcontext change (eec43a224cf1
"MIPS: Save/restore MSA context around signals") in the meantime. I'll
submit a patch as soon as I can.

Given:

 - This issue.

 - A couple of other MSA fixes I have pending cleanup.

 - The fact that the only CPU the kernel supports which has MSA is the
      P5600, and since that is 32b it can't actually make use of MSA
   without the experimental CONFIG_MIPS_O32_FP64_SUPPORT option. Thus
   MSA isn't actually being used yet beyond a few small groups who
   accepted that big shouty experimental warning.

...I wonder if it makes sense to disable MSA support by default for the
moment also.

Thanks,
    Paul
