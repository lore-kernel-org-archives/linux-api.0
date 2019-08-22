From: Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH v2 bpf-next 1/4] bpf: unprivileged BPF access via /dev/bpf
Date: Thu, 22 Aug 2019 16:17:43 +0200
Message-ID: <98fee747-795a-ff10-fa98-10ddb5afcc03@iogearbox.net>
References: <D4040C0C-47D6-4852-933C-59EB53C05242@fb.com>
 <CALCETrVoZL1YGUxx3kM-d21TWVRKdKw=f2B8aE5wc2zmX1cQ4g@mail.gmail.com>
 <5A2FCD7E-7F54-41E5-BFAE-BB9494E74F2D@fb.com>
 <CALCETrU7NbBnXXsw1B+DvTkfTVRBFWXuJ8cZERCCNvdFG6KqRw@mail.gmail.com>
 <CALCETrUjh6DdgW1qSuSRd1_=0F9CqB8+sNj__e_6AHEvh_BaxQ@mail.gmail.com>
 <CALCETrWtE2U4EvZVYeq8pSmQjBzF2PHH+KxYW8FSeF+W=1FYjw@mail.gmail.com>
 <EE7B7AE1-3D44-4561-94B9-E97A626A251D@fb.com>
 <CALCETrXX-Jeb4wiQuL6FUai4wNMmMiUxuLLh_Lb9mT7h=0GgAw@mail.gmail.com>
 <20190805192122.laxcaz75k4vxdspn@ast-mbp>
 <CALCETrVtPs8gY-H4gmzSqPboid3CB++n50SvYd6RU9YVde_-Ow@mail.gmail.com>
 <20190806011134.p5baub5l3t5fkmou@ast-mbp>
 <CALCETrXEHL3+NAY6P6vUj7Pvd9ZpZsYC6VCLXOaNxb90a_POGw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <CALCETrXEHL3+NAY6P6vUj7Pvd9ZpZsYC6VCLXOaNxb90a_POGw@mail.gmail.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>, Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Song Liu <songliubraving@fb.com>, Kees Cook <keescook@chromium.org>, Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>, Kernel Team <Kernel-team@fb.com>, Lorenz Bauer <lmb@cloudflare.com>, Jann Horn <jannh@google.com>, Greg KH <gregkh@linuxfoundation.org>, Linux API <linux-api@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>, Chenbo Feng <chenbofeng.kernel@gmail.com>
List-Id: linux-api@vger.kernel.org

On 8/7/19 7:24 AM, Andy Lutomirski wrote:
> On Mon, Aug 5, 2019 at 6:11 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
>> On Mon, Aug 05, 2019 at 02:25:35PM -0700, Andy Lutomirski wrote:
>>> It tries to make the kernel respect the access modes for fds.  Without
>>> this patch, there seem to be some holes: nothing looked at program fds
>>> and, unless I missed something, you could take a readonly fd for a
>>> program, pin the program, and reopen it RW.
>>
>> I think it's by design. iirc Daniel had a use case for something like this.
> 
> That seems odd.  Daniel, can you elaborate?

[ ... catching up late. ]

Not from my side, the change was added by Chenbo back then for Android
use-case to replace xt_qtaguid and xt_owner with BPF programs and to
allow unprivileged applications to read maps. More on their architecture:

   https://source.android.com/devices/tech/datausage/ebpf-traffic-monitor

 From the cover-letter:

   [...]
   The network-control daemon (netd) creates and loads an eBPF object for
   network packet filtering and analysis. It passes the object FD to an
   unprivileged network monitor app (netmonitor), which is not allowed to
   create, modify or load eBPF objects, but is allowed to read the traffic
   stats from the map.
   [...]

Iuuc, netd would be in charge with the ability to r/w into maps and
pin them, but with the ability to to hand off some map fds as r/o to
unprivileged applications in order for them to query data.

>> Hence unprivileged bpf is actually something that can be deprecated.

There is actually a publicly known use-case on unprivileged bpf wrt
socket filters, see the SO_ATTACH_BPF on sockets section as an example:

   https://blog.cloudflare.com/cloudflare-architecture-and-how-bpf-eats-the-world/

If I'd have to take a good guess, I'd think it's major use-case is in
SO_ATTACH_REUSEPORT_EBPF in the wild, I don't think the sysctl can be
outright flipped or deprecated w/o breaking existing applications unless
it's cleanly modeled into some sort of customizable CAP_BPF* type policy
(more below) where this would be the lowest common denominator.

> I hope not.  There are a couple setsockopt uses right now, and and
> seccomp will surely want it someday.  And the bpf-inside-container use
> case really is unprivileged bpf -- containers are, in many (most?)
> cases, explicitly not trusted by the host.
[...]
>> Inside containers and inside nested containers we need to start processes
>> that will use bpf. All of the processes are trusted.
> 
> Trusted by whom?  In a non-nested container, the container manager
> *might* be trusted by the outside world.  In a *nested* container,
> unless the inner container management is controlled from outside the
> outer container, it's not trusted.  I don't know much about how
> Facebook's containers work, but the LXC/LXD/Podman world is moving
> very strongly toward user namespaces and maximally-untrusted
> containers, and I think bpf() should work in that context.

[...] and if we opt-in with CAP_NET_ADMIN, for example, then it should
ideally be possible for that container to install BPF programs for
mangling, dropping, forwarding etc as long as it's only affecting it's
/own/ netns like the rest of networking subsystem controls that work
in that case. I would actually like to get to this at some point and
make it more approachable as long as there is a way for an admin to
/opt into it/ via policy (aka not by default). Thinking out loud, I'd
love some sort of a hybrid, that is, a mixture of CAP_BPF_ADMIN and
customizable seccomp policy. Meaning, there could be several CAP_BPF
type sub-policies e.g. from allowing everything (equivalent to the
/dev/bpf on/off handle or CAP_SYS_ADMIN we have today) down to
programmable user defined policy that can be tailored to specific
needs like granting apps to BPF_OBJ_GET and BPF_MAP_LOOKUP elements
or granting to load+mangle a specific subset of maps (e.g. BPF_MAP_TYPE_{ARRAY,
HASH,LRU_HASH,LPM_TRIE}) and prog types (...) plus attaching them to
their own netns, and if that is untrusted, then same restrictions/
mitigations could be done by the verifier as with (current) unprivileged
BPF, enabled via programmable policy as well. We wouldn't make any
static/fixed assumptions, but allow users to define them based on their
own use-cases. Haven't looked how feasible this would be, but something
to take into consideration when we rework the current [admittedly
suboptimal all-or-nothing] model we have. Is this something you had in
mind as well for your wip proposal, Andy?

Thanks,
Daniel
