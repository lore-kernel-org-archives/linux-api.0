From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: Re: [PATCH bpf-next v13 4/7] landlock: Add ptrace LSM hooks
Date: Tue, 5 Nov 2019 11:34:47 -0800
Message-ID: <20191105193446.s4pswwwhrmgk6hcx@ast-mbp.dhcp.thefacebook.com>
References: <20191104172146.30797-1-mic@digikod.net>
 <20191104172146.30797-5-mic@digikod.net>
 <20191105171824.dfve44gjiftpnvy7@ast-mbp.dhcp.thefacebook.com>
 <23acf523-dbc4-855b-ca49-2bbfa5e7117e@digikod.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <23acf523-dbc4-855b-ca49-2bbfa5e7117e@digikod.net>
Sender: linux-kernel-owner@vger.kernel.org
To: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
Cc: linux-kernel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>, Andy Lutomirski <luto@amacapital.net>, Casey Schaufler <casey@schaufler-ca.com>, Daniel Borkmann <daniel@iogearbox.net>, David Drysdale <drysdale@google.com>, Florent Revest <revest@chromium.org>, James Morris <jmorris@namei.org>, Jann Horn <jann@thejh.net>, John Johansen <john.johansen@canonical.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, KP Singh <kpsingh@chromium.org>, Michael Kerrisk <mtk.manpages@gmail.com>, =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mickael.salaun@ssi.gouv.fr>, Paul Moore <paul@paul-moore.com>, Sargun Dhillon <sargun@sargun.me>, "Serge E . Hallyn" <serge@hallyn.com>, Shuah Khan <shuah@kernel.org>, Stephen Smalley <sds@tycho.nsa.gov>, Te
List-Id: linux-api@vger.kernel.org

On Tue, Nov 05, 2019 at 07:01:41PM +0100, Mickaël Salaün wrote:
> 
> On 05/11/2019 18:18, Alexei Starovoitov wrote:
> > On Mon, Nov 04, 2019 at 06:21:43PM +0100, Mickaël Salaün wrote:
> >> Add a first Landlock hook that can be used to enforce a security policy
> >> or to audit some process activities.  For a sandboxing use-case, it is
> >> needed to inform the kernel if a task can legitimately debug another.
> >> ptrace(2) can also be used by an attacker to impersonate another task
> >> and remain undetected while performing malicious activities.
> >>
> >> Using ptrace(2) and related features on a target process can lead to a
> >> privilege escalation.  A sandboxed task must then be able to tell the
> >> kernel if another task is more privileged, via ptrace_may_access().
> >>
> >> Signed-off-by: Mickaël Salaün <mic@digikod.net>
> > ...
> >> +static int check_ptrace(struct landlock_domain *domain,
> >> +		struct task_struct *tracer, struct task_struct *tracee)
> >> +{
> >> +	struct landlock_hook_ctx_ptrace ctx_ptrace = {
> >> +		.prog_ctx = {
> >> +			.tracer = (uintptr_t)tracer,
> >> +			.tracee = (uintptr_t)tracee,
> >> +		},
> >> +	};
> > 
> > So you're passing two kernel pointers obfuscated as u64 into bpf program
> > yet claiming that the end goal is to make landlock unprivileged?!
> > The most basic security hole in the tool that is aiming to provide security.
> 
> How could you used these pointers without dedicated BPF helpers? This
> context items are typed as PTR_TO_TASK and can't be used without a
> dedicated helper able to deal with ARG_PTR_TO_TASK. Moreover, pointer
> arithmetic is explicitly forbidden (and I added tests for that). Did I
> miss something?

It's a pointer leak.

> 
> > 
> > I think the only way bpf-based LSM can land is both landlock and KRSI
> > developers work together on a design that solves all use cases.
> 
> As I said in a previous cover letter [1], that would be great. I think
> that the current Landlock bases (almost everything from this series
> except the seccomp interface) should meet both needs, but I would like
> to have the point of view of the KRSI developers.
> 
> [1] https://lore.kernel.org/lkml/20191029171505.6650-1-mic@digikod.net/
> 
> > BPF is capable
> > to be a superset of all existing LSMs whereas landlock and KRSI propsals today
> > are custom solutions to specific security concerns. BPF subsystem was extended
> > with custom things in the past. In networking we have lwt, skb, tc, xdp, sk
> > program types with a lot of overlapping functionality. We couldn't figure out
> > how to generalize them into single 'networking' program. Now we can and we
> > should. Accepting two partially overlapping bpf-based LSMs would be repeating
> > the same mistake again.
> 
> I'll let the LSM maintainers comment on whether BPF could be a superset
> of all LSM, but given the complexity of an access-control system, I have
> some doubts though. Anyway, we need to start somewhere and then iterate.
> This patch series is a first step.

I would like KRSI folks to speak up. So far I don't see any sharing happening
between landlock and KRSI. You're claiming this set is a first step. They're
claiming the same about their patches. I'd like to set a patchset that was
jointly developed.
