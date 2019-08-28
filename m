From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH bpf-next] bpf, capabilities: introduce CAP_BPF
Date: Tue, 27 Aug 2019 18:12:59 -0700
Message-ID: <A95DA1BC-E2A1-4CC3-B17F-36C494FB7540@amacapital.net>
References: <20190827205213.456318-1-ast@kernel.org> <CALCETrV8iJv9+Ai11_1_r6MapPhhwt9hjxi=6EoixytabTScqg@mail.gmail.com> <20190827192144.3b38b25a@gandalf.local.home> <CALCETrUOHRMkBRJi_s30CjZdOLDGtdMOEgqfgPf+q0x+Fw7LtQ@mail.gmail.com> <20190827204433.3af91faf@gandalf.local.home>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190827204433.3af91faf@gandalf.local.home>
Sender: netdev-owner@vger.kernel.org
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Andy Lutomirski <luto@kernel.org>, Alexei Starovoitov <ast@kernel.org>, Kees Cook <keescook@chromium.org>, LSM List <linux-security-module@vger.kernel.org>, James Morris <jmorris@namei.org>, Jann Horn <jannh@google.com>, Peter Zijlstra <peterz@infradead.org>, Masami Hiramatsu <mhiramat@kernel.org>, "David S. Miller" <davem@davemloft.net>, Daniel Borkmann <daniel@iogearbox.net>, Network Development <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>, kernel-team <kernel-team@fb.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org



> On Aug 27, 2019, at 5:44 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
>=20
> On Tue, 27 Aug 2019 16:34:47 -0700
> Andy Lutomirski <luto@kernel.org> wrote:
>=20
>>>> CAP_TRACING does not override normal permissions on sysfs or debugfs.
>>>> This means that, unless a new interface for programming kprobes and
>>>> such is added, it does not directly allow use of kprobes. =20
>>>=20
>>> kprobes can be created in the tracefs filesystem (which is separate from=

>>> debugfs, tracefs just gets automatically mounted
>>> in /sys/kernel/debug/tracing when debugfs is mounted) from the
>>> kprobe_events file. /sys/kernel/tracing is just the tracefs
>>> directory without debugfs, and was created specifically to allow
>>> tracing to be access without opening up the can of worms in debugfs. =20=

>>=20
>> I think that, in principle, CAP_TRACING should allow this, but I'm not
>> sure how to achieve that.  I suppose we could set up
>> inode_operations.permission on tracefs, but what exactly would it do?
>> Would it be just like generic_permission() except that it would look
>> at CAP_TRACING instead of CAP_DAC_OVERRIDE?  That is, you can use
>> tracefs if you have CAP_TRACING *or* acl access?  Or would it be:
>>=20
>> int tracing_permission(struct inode *inode, int mask)
>> {
>>  if (!capable(CAP_TRACING))
>>    return -EPERM;
>>=20
>>  return generic_permission(inode, mask);
>> }
>=20
> Perhaps we should make a group for it?
>=20

Hmm. That means that you=E2=80=99d need CAP_TRACING and a group. That=E2=80=99=
s probably not terrible, but it could be annoying.

>>=20
>> Which would mean that you need ACL *and* CAP_TRACING, so
>> administrators would change the mode to 777.  That's a bit scary.
>>=20
>> And this still doesn't let people even *find* tracefs, since it's
>> hidden in debugfs.
>>=20
>> So maybe make CAP_TRACING override ACLs but also add /sys/fs/tracing
>> and mount tracefs there, too, so that regular users can at least find
>> the mountpoint.
>=20
> I think you missed what I said. It's not hidden in /sys/kernel/debug.
> If you enable tracefs, you have /sys/kernel/tracing created, and is
> completely separate from debugfs. I only have it *also* automatically
> mounted to /sys/kernel/debug/tracing for backward compatibility
> reasons, as older versions of trace-cmd will only mount debugfs (as
> root), and expect to find it there.
>=20
> mount -t tracefs nodev /sys/kernel/tracing

Too many slashes :/

A group could work for v1.  Maybe all the tools should get updated to use th=
is path?

>=20
> -- Steve
>=20
>>=20
>>>=20
>>> Should we allow CAP_TRACING access to /proc/kallsyms? as it is helpful
>>> to convert perf and trace-cmd's function pointers into names. Once you
>>> allow tracing of the kernel, hiding /proc/kallsyms is pretty useless. =20=

>>=20
>> I think we should.
>=20
