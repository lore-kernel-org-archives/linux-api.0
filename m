From: "Joseph S. Myers" <joseph-qD8j1LwMmJjtCj0u4l0SBw@public.gmane.org>
Subject: MIPS MSA sigcontext changes in 3.15
Date: Tue, 17 Jun 2014 15:03:15 +0000
Message-ID: <Pine.LNX.4.64.1406171447030.23412@digraph.polyomino.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-mips-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org, libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Reviewing changes in Linux 3.15 for anything for which glibc changes would 
be appropriate, I don't see how the MSA sigcontext changes are supposed to 
work with existing binaries.

The sigcontext structure isn't used on its own - it's part of ucontext, 
which is passed to signal handlers, and it's not at the end of ucontext, 
but followed by the signal mask.  So existing binaries will expect the 
signal mask at a particular offset in the ucontext.  As far as I can see, 
extending sigcontext requires a new sigaction flag that could be used to 
opt in, for a particular signal handler, to receiving the new-layout 
ucontext (so new symbol versions of sigaction in glibc could then pass 
that flag to the kernel, but existing binaries would continue to get 
old-layout ucontext from the kernel), or else putting the new data at the 
end of ucontext rather than in the main sigcontext structure (though I 
don't know if that would have other issues).

-- 
Joseph S. Myers
joseph-qD8j1LwMmJjtCj0u4l0SBw@public.gmane.org
