From: Jann Horn <jannh@google.com>
Subject: Re: [PATCH] pidfd: add NSpid entries to fdinfo
Date: Mon, 14 Oct 2019 17:09:58 +0200
Message-ID: <CAG48ez0SG3LLeLtqmf5Q8aZL3J8b5XwgNbgDr72jSnq2QBac8Q@mail.gmail.com>
References: <CAG48ez1hk9d-qAPcRy9QOgNuO8u3Y_hu_3=GZoFYLY+oMdo8xg@mail.gmail.com>
 <20191012101922.24168-1-christian.brauner@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191012101922.24168-1-christian.brauner@ubuntu.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Christian Kellner <christian@kellner.me>, Christian Kellner <ckellner@redhat.com>, Aleksa Sarai <cyphar@cyphar.com>, Elena Reshetova <elena.reshetova@intel.com>, Roman Gushchin <guro@fb.com>, "Dmitry V. Levin" <ldv@altlinux.org>, Linux API <linux-api@vger.kernel.org>, kernel list <linux-kernel@vger.kernel.org>, Michal Hocko <mhocko@suse.com>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, Al Viro <viro@zeniv.linux.org.uk>
List-Id: linux-api@vger.kernel.org

On Sat, Oct 12, 2019 at 12:19 PM Christian Brauner
<christian.brauner@ubuntu.com> wrote:
> Currently, the fdinfo file of contains the field Pid:

nit: something missing after "of"?

> It contains the pid a given pidfd refers to in the pid namespace of the
> opener's procfs instance.

s/opener's // here and in various places below? "the opener's" is
kinda misleading since it sounds as if it has something to do with
task identity.

> If the pid namespace of the process is not a descendant of the pid
> namespace of the procfs instance 0 will be shown as its pid. This is
> similar to calling getppid() on a process who's parent is out of it's

nit: s/who's/whose/

nit: s/it's/its/

> pid namespace (e.g. when moving a process into a sibling pid namespace
> via setns()).

You can't move a process into a PID namespace via setns(), you can
only set the PID namespace for its children; and even then, you can't
set that to a sibling PID namespace, you can only move into descendant
PID namespaces.

> Add an NSpid field for easy retrieval of the pid in all descendant pid
> namespaces:
> If pid namespaces are supported this field will contain the pid a given
> pidfd refers to for all descendant pid namespaces starting from the
> current pid namespace of the opener's procfs instance, i.e. the first

s/current // - neither tasks nor procfs instances can change which pid
namespace they're associated with

> pid entry for Pid and NSpid will be identical.

*the Pid field and the first entry in the NSpid field?

> If the pid namespace of the process is not a descendant of the pid
> namespace of the procfs instance 0 will be shown as its first NSpid and
> no other NSpid entries will be shown.
> Note that this differs from the Pid and NSpid fields in
> /proc/<pid>/status where Pid and NSpid are always shown relative to the
> pid namespace of the opener's procfs instace. The difference becomes
> obvious when sending around a pidfd between pid namespaces from
> different trees, i.e. where no ancestoral relation is present between
> the pid namespaces:
> 1. sending around pidfd:
> - create two new pid namespaces ns1 and ns2 in the initial pid namespace
>   (Also take care to create new mount namespaces in the new pid
>   namespace and mount procfs.)
> - create a process with a pidfd in ns1
> - send pidfd from ns1 to ns2
> - read /proc/self/fdinfo/<pidfd> and observe that Pid and NSpid entry
>   are 0
> - create a process with a pidfd in

truncated phrase?

> - open a pidfd for a process in the initial pid namespace
> 2. sending around /proc/<pid>/status fd:
> - create two new pid namespaces ns1 and ns2 in the initial pid namespace
>   (Also take care to create new mount namespaces in the new pid
>   namespace and mount procfs.)
> - create a process in ns1
> - open /proc/<pid>/status in the initial pid namespace for the process
>   you created in ns1
> - send statusfd from initial pid namespace to ns2
> - read statusfd and observe:
>   - that Pid will contain the pid of the process as seen from the init
>   - that NSpid will contain the pids of the process for all descendant
>     pid namespaces starting from the initial pid namespace

You don't need fd passing for case 2, you can just look at the procfs
instance that's mounted in the initial mount namespace. Using fd
passing in this example kinda obfuscates what's going on, in my
opinion.


> +/**
> + * pidfd_show_fdinfo - print information about a pidfd
> + * @m: proc fdinfo file
> + * @f: file referencing a pidfd
> + *
> + * Pid:
> + * This function will print the pid a given pidfd refers to in the pid
> + * namespace of the opener's procfs instance.
> + * If the pid namespace of the process is not a descendant of the pid
> + * namespace of the procfs instance 0 will be shown as its pid. This is
> + * similar to calling getppid() on a process who's parent is out of it's
> + * pid namespace (e.g. when moving a process into a sibling pid namespace
> + * via setns()).
> + * NSpid:
> + * If pid namespaces are supported then this function will also print the
> + * pid a given pidfd refers to for all descendant pid namespaces starting
> + * from the current pid namespace of the opener's procfs instance, i.e. the
> + * first pid entry for Pid and NSpid will be identical.
> + * If the pid namespace of the process is not a descendant of the pid
> + * namespace of the procfs instance 0 will be shown as its first NSpid and
> + * no other NSpid entries will be shown.
> + * Note that this differs from the Pid and NSpid fields in
> + * /proc/<pid>/status where Pid and NSpid are always shown relative to the
> + * pid namespace of the opener's procfs instace. The difference becomes
> + * obvious when sending around a pidfd between pid namespaces from
> + * different trees, i.e. where no ancestoral relation is present between
> + * the pid namespaces:
> + * 1. sending around pidfd:
> + * - create two new pid namespaces ns1 and ns2 in the initial pid namespace
> + *   (Also take care to create new mount namespaces in the new pid
> + *   namespace and mount procfs.)
> + * - create a process with a pidfd in ns1
> + * - send pidfd from ns1 to ns2
> + * - read /proc/self/fdinfo/<pidfd> and observe that Pid and NSpid entry
> + *   are 0
> + * - create a process with a pidfd in
> + * - open a pidfd for a process in the initial pid namespace
> + * 2. sending around /proc/<pid>/status fd:
> + * - create two new pid namespaces ns1 and ns2 in the initial pid namespace
> + *   (Also take care to create new mount namespaces in the new pid
> + *   namespace and mount procfs.)
> + * - create a process in ns1
> + * - open /proc/<pid>/status in the initial pid namespace for the process
> + *   you created in ns1
> + * - send statusfd from initial pid namespace to ns2
> + * - read statusfd and observe:
> + *   - that Pid will contain the pid of the process as seen from the init
> + *   - that NSpid will contain the pids of the process for all descendant
> + *     pid namespaces starting from the initial pid namespace
> + */

See above, same problems as in the commit message. Actually, since you
have a big comment block with this text, there's no reason to repeat
it in the commit message, right?

(By the way, only slightly related to this patch: At the moment, if
you have a pidfd to a task that has already been reaped, and the PID
has been reallocated to another task, the pidfd will still show up in
/proc/*/fdinfo/* as if it referred to a non-dead process, right? Might
be worth considering whether you want to probe ->tasks[PIDTYPE_PID] or
->tasks[PIDTYPE_TGID] for NULL-ness when printing fdinfo, or something
like that.)
