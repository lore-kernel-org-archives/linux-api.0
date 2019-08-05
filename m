From: Song Liu <songliubraving@fb.com>
Subject: Re: [PATCH v2 bpf-next 1/4] bpf: unprivileged BPF access via /dev/bpf
Date: Mon, 5 Aug 2019 07:36:50 +0000
Message-ID: <EE7B7AE1-3D44-4561-94B9-E97A626A251D@fb.com>
References: <20190627201923.2589391-1-songliubraving@fb.com>
 <20190627201923.2589391-2-songliubraving@fb.com>
 <21894f45-70d8-dfca-8c02-044f776c5e05@kernel.org>
 <3C595328-3ABE-4421-9772-8D41094A4F57@fb.com>
 <CALCETrWBnH4Q43POU8cQ7YMjb9LioK28FDEQf7aHZbdf1eBZWg@mail.gmail.com>
 <0DE7F23E-9CD2-4F03-82B5-835506B59056@fb.com>
 <CALCETrWBWbNFJvsTCeUchu3BZJ3SH3dvtXLUB2EhnPrzFfsLNA@mail.gmail.com>
 <201907021115.DCD56BBABB@keescook>
 <CALCETrXTta26CTtEDnzvtd03-WOGdXcnsAogP8JjLkcj4-mHvg@mail.gmail.com>
 <4A7A225A-6C23-4C0F-9A95-7C6C56B281ED@fb.com>
 <CALCETrX2bMnwC6_t4b_G-hzJSfMPrkK4YKs5ebcecv2LJ0rt3w@mail.gmail.com>
 <514D5453-0AEE-420F-AEB6-3F4F58C62E7E@fb.com>
 <1DE886F3-3982-45DE-B545-67AD6A4871AB@amacapital.net>
 <7F51F8B8-CF4C-4D82-AAE1-F0F28951DB7F@fb.com>
 <77354A95-4107-41A7-8936-D144F01C3CA4@fb.com>
 <369476A8-4CE1-43DA-9239-06437C0384C7@fb.com>
 <CALCETrUpVMrk7aaf0trfg9AfZ4fy279uJgZH7V+gZzjFw=hUxA@mail.gmail.com>
 <D4040C0C-47D6-4852-933C-59EB53C05242@fb.com>
 <CALCETrVoZL1YGUxx3kM-d21TWVRKdKw=f2B8aE5wc2zmX1cQ4g@mail.gmail.com>
 <5A2FCD7E-7F54-41E5-BFAE-BB9494E74F2D@fb.com>
 <CALCETrU7NbBnXXsw1B+DvTkfTVRBFWXuJ8cZERCCNvdFG6KqRw@mail.gmail.com>
 <CALCETrUjh6DdgW1qSuSRd1_=0F9CqB8+sNj__e_6AHEvh_BaxQ@mail.gmail.com>
 <CALCETrWtE2U4EvZVYeq8pSmQjBzF2PHH+KxYW8FSeF+W=1FYjw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <CALCETrWtE2U4EvZVYeq8pSmQjBzF2PHH+KxYW8FSeF+W=1FYjw@mail.gmail.com>
Content-Language: en-US
Content-ID: <929F87C777254648A2737B8F6F5EF976@namprd15.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: Kees Cook <keescook@chromium.org>, Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Kernel Team <Kernel-team@fb.com>, Lorenz Bauer <lmb@cloudflare.com>, Jann Horn <jannh@google.com>, Greg KH <gregkh@linuxfoundation.org>, Linux API <linux-api@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Hi Andy,=20

> On Aug 4, 2019, at 10:47 PM, Andy Lutomirski <luto@kernel.org> wrote:
>=20
> On Sun, Aug 4, 2019 at 5:08 PM Andy Lutomirski <luto@kernel.org> wrote:
>>=20
>> On Sun, Aug 4, 2019 at 3:16 PM Andy Lutomirski <luto@kernel.org> wrote:
>>>=20
>>> On Fri, Aug 2, 2019 at 12:22 AM Song Liu <songliubraving@fb.com> wrote:
>>>>=20
>>>> Hi Andy,
>>>>=20
>>>>> I actually agree CAP_BPF_ADMIN makes sense. The hard part is to make
>>>>>> existing tools (setcap, getcap, etc.) and libraries aware of the new=
 CAP.
>>>>>=20
>>>>> It's been done before -- it's not that hard.  IMO the main tricky bit
>>>>> would be try be somewhat careful about defining exactly what
>>>>> CAP_BPF_ADMIN does.
>>>>=20
>>>> Agreed. I think defining CAP_BPF_ADMIN could be a good topic for the
>>>> Plumbers conference.
>>>>=20
>>>> OTOH, I don't think we have to wait for CAP_BPF_ADMIN to allow daemons
>>>> like systemd to do sys_bpf() without root.
>>>=20
>>> I don't understand the use case here.  Are you talking about systemd
>>> --user?  As far as I know, a user is expected to be able to fully
>>> control their systemd --user process, so giving it unrestricted bpf
>>> access is very close to giving it superuser access, and this doesn't
>>> sound like a good idea.  I think that, if systemd --user needs bpf(),
>>> it either needs real unprivileged bpf() or it needs a privileged
>>> helper (SUID or a daemon) to intermediate this access.
>>>=20
>>>>=20
>>>>>=20
>>>>>>> I don't see why you need to invent a whole new mechanism for this.
>>>>>>> The entire cgroup ecosystem outside bpf() does just fine using the
>>>>>>> write permission on files in cgroupfs to control access.  Why can't
>>>>>>> bpf() do the same thing?
>>>>>>=20
>>>>>> It is easier to use write permission for BPF_PROG_ATTACH. But it is
>>>>>> not easy to do the same for other bpf commands: BPF_PROG_LOAD and
>>>>>> BPF_MAP_*. A lot of these commands don't have target concept. Maybe
>>>>>> we should have target concept for all these commands. But that is a
>>>>>> much bigger project. OTOH, "all or nothing" model allows all these
>>>>>> commands at once.
>>>>>=20
>>>>> For BPF_PROG_LOAD, I admit I've never understood why permission is
>>>>> required at all.  I think that CAP_SYS_ADMIN or similar should be
>>>>> needed to get is_priv in the verifier, but I think that should mainly
>>>>> be useful for tracing, and that requires lots of privilege anyway.
>>>>> BPF_MAP_* is probably the trickiest part.  One solution would be some
>>>>> kind of bpffs, but I'm sure other solutions are possible.
>>>>=20
>>>> Improving permission management of cgroup_bpf is another good topic to
>>>> discuss. However, it is also an overkill for current use case.
>>>>=20
>>>=20
>>> I looked at the code some more, and I don't think this is so hard
>>> after all.  As I understand it, all of the map..by_id stuff is, to
>>> some extent, deprecated in favor of persistent maps.  As I see it, the
>>> map..by_id calls should require privilege forever, although I can
>>> imagine ways to scope that privilege to a namespace if the maps
>>> themselves were to be scoped to a namespace.
>>>=20
>>> Instead, unprivileged tools would use the persistent map interface
>>> roughly like this:
>>>=20
>>> $ bpftool map create /sys/fs/bpf/my_dir/filename type hash key 8 value
>>> 8 entries 64 name mapname
>>>=20
>>> This would require that the caller have either CAP_DAC_OVERRIDE or
>>> that the caller have permission to create files in /sys/fs/bpf/my_dir
>>> (using the same rules as for any filesystem), and the resulting map
>>> would end up owned by the creating user and have mode 0600 (or maybe
>>> 0666, or maybe a new bpf_attr parameter) modified by umask.  Then all
>>> the various capable() checks that are currently involved in accessing
>>> a persistent map would instead check FMODE_READ or FMODE_WRITE on the
>>> map file as appropriate.
>>>=20
>>> Half of this stuff already works.  I just set my system up like this:
>>>=20
>>> $ ls -l /sys/fs/bpf
>>> total 0
>>> drwxr-xr-x. 3 luto luto 0 Aug  4 15:10 luto
>>>=20
>>> $ mkdir /sys/fs/bpf/luto/test
>>>=20
>>> $ ls -l /sys/fs/bpf/luto
>>> total 0
>>> drwxrwxr-x. 2 luto luto 0 Aug  4 15:10 test
>>>=20
>>> I bet that making the bpf() syscalls work appropriately in this
>>> context without privilege would only be a couple of hours of work.
>>> The hard work, creating bpffs and making it function, is already done
>>> :)
>>>=20
>>> P.S. The docs for bpftool create are less than fantastic.  The
>>> complete lack of any error message at all when the syscall returns
>>> -EACCES is also not fantastic.
>>=20
>> This isn't remotely finished, but I spent a bit of time fiddling with th=
is:
>>=20
>> https://git.kernel.org/pub/scm/linux/kernel/git/luto/linux.git/commit/?h=
=3Dbpf/perms
>>=20
>> What do you think?  (It's obviously not done.  It doesn't compile, and
>> I haven't gotten to the permissions needed to do map operations.  I
>> also haven't touched the capable() checks.)
>=20
> I updated the branch.  It compiles, and basic map functionality works!

Thanks a lot for trying this out. This is a very interesting direction
that we will explore.=20

>=20
> # mount -t bpf bpf /sys/fs/bpf
> # cd /sys/fs/bpf
> # mkdir luto
> # chown luto: luto
> # setpriv --euid=3D1000 --ruid=3D1000 bash
> $ pwd
> /sys/fs/bpf
> bash-5.0$ ls -l
> total 0
> drwxr-xr-x 2 luto luto 0 Aug  4 22:41 luto
> bash-5.0$ bpftool map create /sys/fs/bpf/luto/filename type hash key 8
> value 8 entries 64 name mapname
> bash-5.0$ bpftool map dump pinned /sys/fs/bpf/luto/filename
> Found 0 elements
>=20
> # chown root: /sys/fs/bpf/luto/filename
>=20
> $ bpftool map dump pinned /sys/fs/bpf/luto/filename
> Error: bpf obj get (/sys/fs/bpf/luto): Permission denied
>=20
> So I think it's possible to get a respectable subset of bpf()
> functionality working without privilege in short order :)

I think we have two key questions to answer:=20
  1. What subset of bpf() functionality will the users need?
  2. Who are the users?=20

Different answers to these two questions lead to different directions.


In our use case, the answers are=20
  1) almost all bpf() functionality
  2) highly trusted users (sudoers)

So our initial approach of /dev/bpf allows all bpf() functionality
in one bit in task_struct. (Yes, we can just sudo. But, we would=20
rather not use sudo when possible.)


"cgroup management" use case may have answers like:
  1) cgroup_bpf only
  2) users in their own containers

For this case, getting cgroup_bpf related features (cgroup_bpf progs;=20
some map types, etc.) work with unprivileged users would be the right=20
direction.=20


"USDT tracing" use case may have answers like:
  1) uprobe, stockmap, histogram, etc.
  2) unprivileged user, w/ or w/o containers

For this case, the first step is likely hacking sys_perf_event_open().=20


I guess we will need more discussions to decide how to make bpf()=20
work better for all these (and more) use cases.=20

Thanks,
Song
