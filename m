From: Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH bpf-next v13 4/7] landlock: Add ptrace LSM hooks
Date: Tue, 5 Nov 2019 14:32:27 -0800
Message-ID: <93f53bdd-a499-6425-111c-ab90d81874d7@schaufler-ca.com>
References: <20191104172146.30797-1-mic@digikod.net>
 <20191104172146.30797-5-mic@digikod.net>
 <20191105171824.dfve44gjiftpnvy7@ast-mbp.dhcp.thefacebook.com>
 <c5c6b433-7e6a-c8f8-f063-e704c3df4cc6@schaufler-ca.com>
 <20191105193130.qam2eafnmgvrvjwk@ast-mbp.dhcp.thefacebook.com>
 <637736ef-c48e-ac3b-3eef-8a6a095a96f1@schaufler-ca.com>
 <20191105215453.szhdkrvuekwfz6le@ast-mbp.dhcp.thefacebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20191105215453.szhdkrvuekwfz6le@ast-mbp.dhcp.thefacebook.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>, linux-kernel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>, Andy Lutomirski <luto@amacapital.net>, Daniel Borkmann <daniel@iogearbox.net>, David Drysdale <drysdale@google.com>, Florent Revest <revest@chromium.org>, James Morris <jmorris@namei.org>, Jann Horn <jann@thejh.net>, John Johansen <john.johansen@canonical.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, KP Singh <kpsingh@chromium.org>, Michael Kerrisk <mtk.manpages@gmail.com>, =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mickael.salaun@ssi.gouv.fr>, Paul Moore <paul@paul-moore.com>, Sargun Dhillon <sargun@sargun.me>, "Serge E . Hallyn" <serge@hallyn.com>, Shuah Khan <shuah@kernel.org>, Stephen Smalley <sds@tych>
List-Id: linux-api@vger.kernel.org

On 11/5/2019 1:54 PM, Alexei Starovoitov wrote:
> On Tue, Nov 05, 2019 at 11:55:17AM -0800, Casey Schaufler wrote:
>> On 11/5/2019 11:31 AM, Alexei Starovoitov wrote:
>>> On Tue, Nov 05, 2019 at 09:55:42AM -0800, Casey Schaufler wrote:
>>>> On 11/5/2019 9:18 AM, Alexei Starovoitov wrote:
>>>>> On Mon, Nov 04, 2019 at 06:21:43PM +0100, Micka=C3=ABl Sala=C3=BCn =
wrote:
>>>>>> Add a first Landlock hook that can be used to enforce a security p=
olicy
>>>>>> or to audit some process activities.  For a sandboxing use-case, i=
t is
>>>>>> needed to inform the kernel if a task can legitimately debug anoth=
er.
>>>>>> ptrace(2) can also be used by an attacker to impersonate another t=
ask
>>>>>> and remain undetected while performing malicious activities.
>>>>>>
>>>>>> Using ptrace(2) and related features on a target process can lead =
to a
>>>>>> privilege escalation.  A sandboxed task must then be able to tell =
the
>>>>>> kernel if another task is more privileged, via ptrace_may_access()=
=2E
>>>>>>
>>>>>> Signed-off-by: Micka=C3=ABl Sala=C3=BCn <mic@digikod.net>
>>>>> ...
>>>>>> +static int check_ptrace(struct landlock_domain *domain,
>>>>>> +		struct task_struct *tracer, struct task_struct *tracee)
>>>>>> +{
>>>>>> +	struct landlock_hook_ctx_ptrace ctx_ptrace =3D {
>>>>>> +		.prog_ctx =3D {
>>>>>> +			.tracer =3D (uintptr_t)tracer,
>>>>>> +			.tracee =3D (uintptr_t)tracee,
>>>>>> +		},
>>>>>> +	};
>>>>> So you're passing two kernel pointers obfuscated as u64 into bpf pr=
ogram
>>>>> yet claiming that the end goal is to make landlock unprivileged?!
>>>>> The most basic security hole in the tool that is aiming to provide =
security.
>>>>>
>>>>> I think the only way bpf-based LSM can land is both landlock and KR=
SI
>>>>> developers work together on a design that solves all use cases. BPF=
 is capable
>>>>> to be a superset of all existing LSMs
>>>> I can't agree with this. Nope. There are many security models
>>>> for which BPF introduces excessive complexity. You don't need
>>>> or want the generality of a general purpose programming language
>>>> to implement Smack or TOMOYO. Or a simple Bell & LaPadula for
>>>> that matter. SELinux? I can't imagine anyone trying to do that
>>>> in eBPF, although I'm willing to be surprised. Being able to
>>>> enforce a policy isn't the only criteria for an LSM.=20
>>> what are the other criteria?
>> They include, but are not limited to, performance impact
>> and the ability to be analyzed.=20
> Right and BPF is the only thing that exists in the kernel where the ver=
ifier
> knows precisely the number of instructions the critical path through th=
e
> program will take. Currently we don't quantify this cost for bpf helper=
s, but
> it's easy to add. Can you do this for smack? Can you tell upfront the l=
ongest
> execution time for all security rules?

There's much more to analyze than number of instructions.
There's also completion of policy enforcement. There are
lots of tools for measuring performance within the kernel.

>> It has to be fast, or the networking people are
>> going to have fits. You can't require the addition
>> of a pointer into the skb because it'll get rejected
>> out of hand. You can't completely refactor the vfs locking
>> to accommodate you needs.
> I'm not sure why you got such impression. I'm not proposing to refactor=
 vfs or
> add fields to skb.

I'm not saying you did. Those are examples of things you would
have trouble with.

>  Once we have equivalent to smack policy implemented in
> bpf-based lsm let's do performance benchmarking and compare actual numb=
ers
> instead of hypothesizing about them. Which policy do you think would be=

> the most representative of smack use case?

The Tizen3 Three domain model will do just fine.
https://wiki.tizen.org/Security:SmackThreeDomainModel


>
>>>> I see many issues with a BPF <-> vfs interface.
>>> There is no such interface today. What do you have in mind?
>> You can't implement SELinux or Smack using BPF without a way
>> to manipulate inode data.
> Are you talking about inode->i_security ? That's not manipulating inode=
 data.

Poppycock.

> It's attaching extra metadata to inode object without changing inode it=
self.

Where I come from, we call that inode object data.

> BPF can do it already via hash maps. It's not as fast as direct pointer=
 access,

Then you're not listening. Performance MATTERS!

> but for many use cases it's good enough. If it turns out to be a perfor=
mance
> limiting factor we will accelerate it.

How many times have I heard that bit of rubbish?
No. You can't start with a bad design and tweak it to acceptability later=
=2E


>>>> the mechanisms needed for the concerns of the day. Ideally,
>>>> we should be able to drop mechanisms when we decide that they
>>>> no longer add value.
>>> Exactly. bpf-based lsm must not add to kernel abi.
>> Huh? I have no idea where that came from.
> It sounds to me that some folks in the community got wrong impression t=
hat
> anything that BPF accesses is magically turning that thing into stable =
kernel
> ABI. That is not true. BPF progs had access _all_ kernel data pointers =
and
> structures for years without turning the whole kernel into stable ABI. =
I want
> to make sure that this part is understood. This is also a requirement f=
or
> bpf-based LSM. It must not make LSM hooks into stable ABI.
>
