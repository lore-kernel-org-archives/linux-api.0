From: Matthew Fortune <Matthew.Fortune-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>
Subject: RE: MIPS MSA sigcontext changes in 3.15
Date: Tue, 17 Jun 2014 16:32:40 +0000
Message-ID: <6D39441BF12EF246A7ABCE6654B0235320E03BD4@LEMAIL01.le.imgtec.org>
References: <Pine.LNX.4.64.1406171447030.23412@digraph.polyomino.org.uk>
 <Pine.LNX.4.64.1406171539240.23412@digraph.polyomino.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.64.1406171539240.23412-9YEB1lltEqivcGRMvF24k2I39yigxGEX@public.gmane.org>
Content-Language: en-US
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Joseph S. Myers" <joseph-qD8j1LwMmJjtCj0u4l0SBw@public.gmane.org>, "linux-mips-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org" <linux-mips-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org>, "libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org" <libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Joseph S. Myers <joseph-qD8j1LwMmJjtCj0u4l0SBw@public.gmane.org> writes:
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

An attempt was made to appropriately version the sigcontext structure to
allow readers to determine whether the MSA part of the context was present
or not but this only helps the sigcontext structure and not necessarily
the impact that has on the overall ucontext. On the face of it then it
does seem better to have the extra context at the end of ucontext as it
does indeed look broken for existing glibc versions.

A brief scan of how other architectures have handled extending ucontext
shows a wide variety of solutions although adding to the end of ucontext
seems to be the underlying theme.

Thanks for finding this.

Regards,
Matthew
