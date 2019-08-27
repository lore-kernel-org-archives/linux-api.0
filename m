From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH bpf-next] bpf, capabilities: introduce CAP_BPF
Date: Tue, 27 Aug 2019 16:34:47 -0700
Message-ID: <CALCETrUOHRMkBRJi_s30CjZdOLDGtdMOEgqfgPf+q0x+Fw7LtQ@mail.gmail.com>
References: <20190827205213.456318-1-ast@kernel.org> <CALCETrV8iJv9+Ai11_1_r6MapPhhwt9hjxi=6EoixytabTScqg@mail.gmail.com>
 <20190827192144.3b38b25a@gandalf.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190827192144.3b38b25a@gandalf.local.home>
Sender: netdev-owner@vger.kernel.org
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Andy Lutomirski <luto@kernel.org>, Alexei Starovoitov <ast@kernel.org>, Kees Cook <keescook@chromium.org>, LSM List <linux-security-module@vger.kernel.org>, James Morris <jmorris@namei.org>, Jann Horn <jannh@google.com>, Peter Zijlstra <peterz@infradead.org>, Masami Hiramatsu <mhiramat@kernel.org>, "David S. Miller" <davem@davemloft.net>, Daniel Borkmann <daniel@iogearbox.net>, Network Development <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>, kernel-team <kernel-team@fb.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, Aug 27, 2019 at 4:21 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Tue, 27 Aug 2019 16:01:08 -0700
> Andy Lutomirski <luto@kernel.org> wrote:
>
> > [adding some security and tracing folks to cc]
> >
> > On Tue, Aug 27, 2019 at 1:52 PM Alexei Starovoitov <ast@kernel.org> wrote:
> > >
> > > Introduce CAP_BPF that allows loading all types of BPF programs,
> > > create most map types, load BTF, iterate programs and maps.
> > > CAP_BPF alone is not enough to attach or run programs.
> > >
> > > Networking:
> > >
> > > CAP_BPF and CAP_NET_ADMIN are necessary to:
> > > - attach to cgroup-bpf hooks like INET_INGRESS, INET_SOCK_CREATE, INET4_CONNECT
> > > - run networking bpf programs (like xdp, skb, flow_dissector)
> > >
> > > Tracing:
> > >
> > > CAP_BPF and perf_paranoid_tracepoint_raw() (which is kernel.perf_event_paranoid == -1)
> > > are necessary to:
> > > - attach bpf program to raw tracepoint
> > > - use bpf_trace_printk() in all program types (not only tracing programs)
> > > - create bpf stackmap
> > >
> > > To attach bpf to perf_events perf_event_open() needs to succeed as usual.
> > >
> > > CAP_BPF controls BPF side.
> > > CAP_NET_ADMIN controls intersection where BPF calls into networking.
> > > perf_paranoid_tracepoint_raw controls intersection where BPF calls into tracing.
> > >
> > > In the future CAP_TRACING could be introduced to control
> > > creation of kprobe/uprobe and attaching bpf to perf_events.
> > > In such case bpf_probe_read() thin wrapper would be controlled by CAP_BPF.
> > > Whereas probe_read() would be controlled by CAP_TRACING.
> > > CAP_TRACING would also control generic kprobe+probe_read.
> > > CAP_BPF and CAP_TRACING would be necessary for tracing bpf programs
> > > that want to use bpf_probe_read.
>
> No mention of the tracefs (/sys/kernel/tracing) file?

See below.  Also, I am embarrassed to admit that I just assumed that
/sys/kernel/debug/tracing was just like any other debugfs directory.

>
>
> >
> > Changing the capability that some existing operation requires could
> > break existing programs.  The old capability may need to be accepted
> > as well.
> >
> > I'm inclined to suggest that CAP_TRACING be figured out or rejected
> > before something like this gets applied.
> >
> >
> > >
> > > Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> > > ---
> > > I would prefer to introduce CAP_TRACING soon, since it
> > > will make tracing and networking permission model symmetrical.
> > >
> >
> > Here's my proposal for CAP_TRACING, documentation-style:
> >
> > --- begin ---
> >
> > CAP_TRACING enables a task to use various kernel features to trace
> > running user programs and the kernel itself.  CAP_TRACING also enables
> > a task to bypass some speculation attack countermeasures.  A task in
> > the init user namespace with CAP_TRACING will be able to tell exactly
> > what kernel code is executed and when, and will be able to read kernel
> > registers and kernel memory.  It will, similarly, be able to read the
> > state of other user tasks.
> >
> > Specifically, CAP_TRACING allows the following operations.  It may
> > allow more operations in the future:
> >
> >  - Full use of perf_event_open(), similarly to the effect of
> > kernel.perf_event_paranoid == -1.
> >
> >  - Loading and attaching tracing BPF programs, including use of BPF
> > raw tracepoints.
> >
> >  - Use of BPF stack maps.
> >
> >  - Use of bpf_probe_read() and bpf_trace_printk().
> >
> >  - Use of unsafe pointer-to-integer conversions in BPF.
> >
> >  - Bypassing of BPF's speculation attack hardening measures and
> > constant blinding.  (Note: other mechanisms might also allow this.)
> >
> > CAP_TRACING does not override normal permissions on sysfs or debugfs.
> > This means that, unless a new interface for programming kprobes and
> > such is added, it does not directly allow use of kprobes.
>
> kprobes can be created in the tracefs filesystem (which is separate from
> debugfs, tracefs just gets automatically mounted
> in /sys/kernel/debug/tracing when debugfs is mounted) from the
> kprobe_events file. /sys/kernel/tracing is just the tracefs
> directory without debugfs, and was created specifically to allow
> tracing to be access without opening up the can of worms in debugfs.

I think that, in principle, CAP_TRACING should allow this, but I'm not
sure how to achieve that.  I suppose we could set up
inode_operations.permission on tracefs, but what exactly would it do?
Would it be just like generic_permission() except that it would look
at CAP_TRACING instead of CAP_DAC_OVERRIDE?  That is, you can use
tracefs if you have CAP_TRACING *or* acl access?  Or would it be:

int tracing_permission(struct inode *inode, int mask)
{
  if (!capable(CAP_TRACING))
    return -EPERM;

  return generic_permission(inode, mask);
}

Which would mean that you need ACL *and* CAP_TRACING, so
administrators would change the mode to 777.  That's a bit scary.

And this still doesn't let people even *find* tracefs, since it's
hidden in debugfs.

So maybe make CAP_TRACING override ACLs but also add /sys/fs/tracing
and mount tracefs there, too, so that regular users can at least find
the mountpoint.

>
> Should we allow CAP_TRACING access to /proc/kallsyms? as it is helpful
> to convert perf and trace-cmd's function pointers into names. Once you
> allow tracing of the kernel, hiding /proc/kallsyms is pretty useless.

I think we should.
