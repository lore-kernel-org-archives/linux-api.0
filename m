From: Jann Horn <jannh@google.com>
Subject: Re: [RESEND RFC] translate_pid API
Date: Tue, 13 Mar 2018 13:47:43 -0700
Message-ID: <CAG48ez1ww-pVQ9R+d+P+smRR3eaEkJ-=9GW-O-QOvH-YZoFG8A@mail.gmail.com>
References: <1520875093-18174-1-git-send-email-nagarathnam.muthusamy@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1520875093-18174-1-git-send-email-nagarathnam.muthusamy@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Nagarathnam Muthusamy <nagarathnam.muthusamy@oracle.com>
Cc: kernel list <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Nagarajan.Muthukrishnan@oracle.com, Prakash Sangappa <prakash.sangappa@oracle.com>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Serge Hallyn <serge.hallyn@ubuntu.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Eugene Syromiatnikov <esyr@redhat.com>, xemul@parallels.com
List-Id: linux-api@vger.kernel.org

On Mon, Mar 12, 2018 at 10:18 AM,  <nagarathnam.muthusamy@oracle.com> wrote:
> Resending the RFC with participants of previous discussions
> in the list.
>
> Following patch which is a variation of a solution discussed
> in https://lwn.net/Articles/736330/ provides the users of
> pid namespace, the functionality of pid translation between
> namespaces using a namespace identifier. The topic of
> pid translation has been discussed in the community few times
> but there has always been a resistance to adding new solution
> for this problem.

> I will outline the planned usecase of pid namespace by oracle
> database and explain why any of the existing solution cannot
> be used to solve their problem.
>
> Consider a system in which several PID namespaces with multiple
> nested levels exists in parallel with monitor processes managing
> all the namespaces. PID translation is required for controlling
> and accessing information about the processes by the monitors
> and other processes down the hierarchy of namespaces. Controlling
> primarily involves sending signals or using ptrace by a process in
> parent namespace on any of the processes in its child namespace.
> Accessing information deals with the reading /proc/<pid>/* files
> of processes in child namespace. None of the processes have
> root/CAP_SYS_ADMIN privileges.

How are you dealing with PID reuse?

[...]
> diff --git a/fs/nsfs.c b/fs/nsfs.c
> index 36b0772..c635465 100644
> --- a/fs/nsfs.c
> +++ b/fs/nsfs.c
> @@ -222,8 +222,13 @@ int ns_get_name(char *buf, size_t size, struct task_struct *task,
>         const char *name;
>         ns = ns_ops->get(task);
>         if (ns) {
> -               name = ns_ops->real_ns_name ? : ns_ops->name;
> -               res = snprintf(buf, size, "%s:[%u]", name, ns->inum);
> +               if (!strcmp(ns_ops->name, "pidns_id")) {

Wouldn't it be cleaner to check for "ns_ops==&pidns_id_operations"?

> +                       res = snprintf(buf, size, "[%llu]",
> +                                      (unsigned long long)ns->ns_id);
> +               } else {
> +                       name = ns_ops->real_ns_name ? : ns_ops->name;
> +                       res = snprintf(buf, size, "%s:[%u]", name, ns->inum);
> +               }
>                 ns_ops->put(ns);
>         }
>         return res;
[...]
> diff --git a/include/linux/pid_namespace.h b/include/linux/pid_namespace.h
> index 49538b1..11d1d57 100644
> --- a/include/linux/pid_namespace.h
> +++ b/include/linux/pid_namespace.h
> @@ -11,6 +11,7 @@
>  #include <linux/kref.h>
>  #include <linux/ns_common.h>
>  #include <linux/idr.h>
> +#include <linux/list_bl.h>
>
>
>  struct fs_pin;
> @@ -44,6 +45,8 @@ struct pid_namespace {
>         kgid_t pid_gid;
>         int hide_pid;
>         int reboot;     /* group exit code if this pidns was rebooted */
> +       struct hlist_bl_node node;
> +       atomic_t lookups_pending;
>         struct ns_common ns;
>  } __randomize_layout;
>
[...]
> diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
> index 0b53eef..ff83aa8 100644
> --- a/kernel/pid_namespace.c
> +++ b/kernel/pid_namespace.c
[...]
> @@ -159,6 +201,30 @@ static void delayed_free_pidns(struct rcu_head *p)
>
>  static void destroy_pid_namespace(struct pid_namespace *ns)
>  {
> +       struct pid_namespace *ph;
> +       struct hlist_bl_head *head;
> +       struct hlist_bl_node *dup_node;
> +
> +       /*
> +        * Remove the namespace structure from hash table so
> +        * now new lookups can start on it.

s/now new/no new/

[...]
> @@ -474,9 +551,116 @@ static struct user_namespace *pidns_owner(struct ns_common *ns)
>         .get_parent     = pidns_get_parent,
>  };
>
> +/*
> + * translate_pid - convert pid in source pid-ns into target pid-ns.
> + * @pid: pid for translation
> + * @source: pid-ns id
> + * @target: pid-ns id
> + *
> + * Return pid in @target pid-ns, zero if task have no pid there,
> + * or -ESRCH of task with @pid is not found in @source pid-ns.

s/of/if/

> + */
> +SYSCALL_DEFINE3(translate_pid, pid_t, pid, u64, source,
> +               u64, target)
> +{
> +       struct pid_namespace *source_ns = NULL, *target_ns = NULL;
> +       struct pid *struct_pid;
> +       struct pid_namespace *ph;
> +       struct hlist_bl_head *shead = NULL;
> +       struct hlist_bl_head *thead = NULL;
> +       struct hlist_bl_node *dup_node;
> +       pid_t result;
> +
> +       if (!source) {
> +               source_ns = &init_pid_ns;
> +       } else {
> +               shead = pid_ns_hash_head(pid_ns_hash, source);
> +               hlist_bl_lock(shead);
> +               hlist_bl_for_each_entry(ph, dup_node, shead, node) {
> +                       if (source == ph->ns.ns_id) {
> +                               source_ns = ph;
> +                               break;
> +                       }
> +               }
> +               if (!source_ns) {
> +                       hlist_bl_unlock(shead);
> +                       return -EINVAL;
> +               }
> +       }
> +       if (!ptrace_may_access(source_ns->child_reaper,
> +                              PTRACE_MODE_READ_FSCREDS)) {

AFAICS this proposal breaks the visibility restrictions that
namespaces normally create. If there are two namespaces-based
containers that use the same UID range, I don't think they should be
able to learn information about each other, such as which PIDs are in
use in the other container; but as far as I can tell, your proposal
makes it possible to do that (unless an LSM or so is interfering). I
would prefer it if this API required visibility of the targeted PID
namespaces in the caller's PID namespace.

When doing ptrace access checks, please use the real creds in syscalls
like this one, not the fs creds. The fs creds are for filesystem
syscalls (in particular sys_open()), not for specialized syscalls like
ptrace() or this one.
