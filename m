From: Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH bpf-next v13 4/7] landlock: Add ptrace LSM hooks
Date: Tue, 5 Nov 2019 09:55:42 -0800
Message-ID: <c5c6b433-7e6a-c8f8-f063-e704c3df4cc6@schaufler-ca.com>
References: <20191104172146.30797-1-mic@digikod.net>
 <20191104172146.30797-5-mic@digikod.net>
 <20191105171824.dfve44gjiftpnvy7@ast-mbp.dhcp.thefacebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191105171824.dfve44gjiftpnvy7@ast-mbp.dhcp.thefacebook.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>, =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Cc: linux-kernel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>, Andy Lutomirski <luto@amacapital.net>, Daniel Borkmann <daniel@iogearbox.net>, David Drysdale <drysdale@google.com>, Florent Revest <revest@chromium.org>, James Morris <jmorris@namei.org>, Jann Horn <jann@thejh.net>, John Johansen <john.johansen@canonical.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, KP Singh <kpsingh@chromium.org>, Michael Kerrisk <mtk.manpages@gmail.com>, =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mickael.salaun@ssi.gouv.fr>, Paul Moore <paul@paul-moore.com>, Sargun Dhillon <sargun@sargun.me>, "Serge E . Hallyn" <serge@hallyn.com>, Shuah Khan <shuah@kernel.org>, Stephen Smalley <sds@tycho.nsa.gov>, Tejun Heo <tj@kernel.org>, Tetsuo Handa <pen>
List-Id: linux-api@vger.kernel.org

On 11/5/2019 9:18 AM, Alexei Starovoitov wrote:
> On Mon, Nov 04, 2019 at 06:21:43PM +0100, Micka=C3=ABl Sala=C3=BCn wrot=
e:
>> Add a first Landlock hook that can be used to enforce a security polic=
y
>> or to audit some process activities.  For a sandboxing use-case, it is=

>> needed to inform the kernel if a task can legitimately debug another.
>> ptrace(2) can also be used by an attacker to impersonate another task
>> and remain undetected while performing malicious activities.
>>
>> Using ptrace(2) and related features on a target process can lead to a=

>> privilege escalation.  A sandboxed task must then be able to tell the
>> kernel if another task is more privileged, via ptrace_may_access().
>>
>> Signed-off-by: Micka=C3=ABl Sala=C3=BCn <mic@digikod.net>
> ...
>> +static int check_ptrace(struct landlock_domain *domain,
>> +		struct task_struct *tracer, struct task_struct *tracee)
>> +{
>> +	struct landlock_hook_ctx_ptrace ctx_ptrace =3D {
>> +		.prog_ctx =3D {
>> +			.tracer =3D (uintptr_t)tracer,
>> +			.tracee =3D (uintptr_t)tracee,
>> +		},
>> +	};
> So you're passing two kernel pointers obfuscated as u64 into bpf progra=
m
> yet claiming that the end goal is to make landlock unprivileged?!
> The most basic security hole in the tool that is aiming to provide secu=
rity.
>
> I think the only way bpf-based LSM can land is both landlock and KRSI
> developers work together on a design that solves all use cases. BPF is =
capable
> to be a superset of all existing LSMs

I can't agree with this. Nope. There are many security models
for which BPF introduces excessive complexity. You don't need
or want the generality of a general purpose programming language
to implement Smack or TOMOYO. Or a simple Bell & LaPadula for
that matter. SELinux? I can't imagine anyone trying to do that
in eBPF, although I'm willing to be surprised. Being able to
enforce a policy isn't the only criteria for an LSM. It's got
to perform well and integrate with the rest of the system. I
see many issues with a BPF <-> vfs interface.

> whereas landlock and KRSI propsals today
> are custom solutions to specific security concerns.

Yes. As they should be. No one has every solved the entire
security problem, and no one ever will. The only hope we have
to address security issues is to have the flexibility to add
the mechanisms needed for the concerns of the day. Ideally,
we should be able to drop mechanisms when we decide that they
no longer add value.

> BPF subsystem was extended
> with custom things in the past. In networking we have lwt, skb, tc, xdp=
, sk
> program types with a lot of overlapping functionality. We couldn't figu=
re out
> how to generalize them into single 'networking' program. Now we can and=
 we
> should. Accepting two partially overlapping bpf-based LSMs would be rep=
eating
> the same mistake again.

I don't get your analogy at all. You have a variety of programs because
you have a variety of protocols and administrative interfaces. Of course
you don't have a single 'networking" program. Security has a variety of
issues and policies. A single 'security' program makes no sense whatever.=
