From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH 2/2] groups: Allow unprivileged processes to use setgroups
 to drop groups
Date: Mon, 17 Nov 2014 10:31:17 -0800
Message-ID: <CALCETrWy-3C1on3+2wE9aqcChBUCUY0i_4AL_Om8CSZ5QB18sQ@mail.gmail.com>
References: <3ccec8a13019b5e8ce7b1d7889677b778b070dc8.1416041823.git.josh@joshtriplett.org>
 <0895c1f268bc0b01cc6c8ed4607d7c3953f49728.1416041823.git.josh@joshtriplett.org>
 <546A3942.5040906@schaufler-ca.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <546A3942.5040906-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Casey Schaufler <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org>
Cc: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Nov 17, 2014 at 10:06 AM, Casey Schaufler
<casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org> wrote:
> On 11/15/2014 1:01 AM, Josh Triplett wrote:
>> Currently, unprivileged processes (without CAP_SETGID) cannot call
>> setgroups at all.  In particular, processes with a set of supplementary
>> groups cannot further drop permissions without obtaining elevated
>> permissions first.
>
> Has anyone put any thought into how this will interact with
> POSIX ACLs? I don't see that anywhere in the discussion.

That means that user namespaces are a problem, too, and we need to fix
it.  Or we should add some control to turn unprivileged user namespace
creation on and off and document that turning it on defeats POSIX ACLs
with a group entry that is more restrictive than the other entry.

--Andy

>
> Tizen takes advantage of the fact you can't drop groups. If
> a process can drop itself out of groups without privilege
> it can circumvent the system security policy.
>
> Back when the LSM was introduced a choice was made between
> authoritative hooks (which would have allowed this sort of thing)
> and restrictive hooks (which would not). Authoritative hooks were
> rejected because they would have "broken Linux". I hope that the
> people who spoke up then will speak up now.
>
> This is going to introduce a whole class of vulnerabilities.
> Don't even think of arguing that the reduction in use of privilege
> will make up for that. Developers have enough trouble with the
> difference between setuid() and seteuid() to expect them to use
> group dropping properly.
>
>>
>> Allow unprivileged processes to call setgroups with a subset of their
>> current groups; only require CAP_SETGID to add a group the process does
>> not currently have.
>>
>> The kernel already maintains the list of supplementary group IDs in
>> sorted order, and setgroups already needs to sort the new list, so this
>> just requires a linear comparison of the two sorted lists.
>>
>> This moves the CAP_SETGID test from setgroups into set_current_groups.
>>
>> Tested via the following test program:
>>
>> #include <err.h>
>> #include <grp.h>
>> #include <stdio.h>
>> #include <sys/types.h>
>> #include <unistd.h>
>>
>> void run_id(void)
>> {
>>     pid_t p = fork();
>>     switch (p) {
>>         case -1:
>>             err(1, "fork");
>>         case 0:
>>             execl("/usr/bin/id", "id", NULL);
>>             err(1, "exec");
>>         default:
>>             if (waitpid(p, NULL, 0) < 0)
>>                 err(1, "waitpid");
>>     }
>> }
>>
>> int main(void)
>> {
>>     gid_t list1[] = { 1, 2, 3, 4, 5 };
>>     gid_t list2[] = { 2, 3, 4 };
>>     run_id();
>>     if (setgroups(5, list1) < 0)
>>         err(1, "setgroups 1");
>>     run_id();
>>     if (setresgid(1, 1, 1) < 0)
>>         err(1, "setresgid");
>>     if (setresuid(1, 1, 1) < 0)
>>         err(1, "setresuid");
>>     run_id();
>>     if (setgroups(3, list2) < 0)
>>         err(1, "setgroups 2");
>>     run_id();
>>     if (setgroups(5, list1) < 0)
>>         err(1, "setgroups 3");
>>     run_id();
>>
>>     return 0;
>> }
>>
>> Without this patch, the test program gets EPERM from the second
>> setgroups call, after dropping root privileges.  With this patch, the
>> test program successfully drops groups 1 and 5, but then gets EPERM from
>> the third setgroups call, since that call attempts to add groups the
>> process does not currently have.
>>
>> Signed-off-by: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
>> ---
>>  kernel/groups.c | 33 ++++++++++++++++++++++++++++++---
>>  kernel/uid16.c  |  2 --
>>  2 files changed, 30 insertions(+), 5 deletions(-)
>>
>> diff --git a/kernel/groups.c b/kernel/groups.c
>> index f0667e7..fe7367d 100644
>> --- a/kernel/groups.c
>> +++ b/kernel/groups.c
>> @@ -153,6 +153,29 @@ int groups_search(const struct group_info *group_info, kgid_t grp)
>>       return 0;
>>  }
>>
>> +/* Compare two sorted group lists; return true if the first is a subset of the
>> + * second.
>> + */
>> +static bool is_subset(const struct group_info *g1, const struct group_info *g2)
>> +{
>> +     unsigned int i, j;
>> +
>> +     for (i = 0, j = 0; i < g1->ngroups; i++) {
>> +             kgid_t gid1 = GROUP_AT(g1, i);
>> +             kgid_t gid2;
>> +             for (; j < g2->ngroups; j++) {
>> +                     gid2 = GROUP_AT(g2, j);
>> +                     if (gid_lte(gid1, gid2))
>> +                             break;
>> +             }
>> +             if (j >= g2->ngroups || !gid_eq(gid1, gid2))
>> +                     return false;
>> +             j++;
>> +     }
>> +
>> +     return true;
>> +}
>> +
>>  /**
>>   * set_groups_sorted - Change a group subscription in a set of credentials
>>   * @new: The newly prepared set of credentials to alter
>> @@ -189,11 +212,17 @@ int set_current_groups(struct group_info *group_info)
>>  {
>>       struct cred *new;
>>
>> +     groups_sort(group_info);
>>       new = prepare_creds();
>>       if (!new)
>>               return -ENOMEM;
>> +     if (!ns_capable(current_user_ns(), CAP_SETGID)
>> +         && !is_subset(group_info, new->group_info)) {
>> +             abort_creds(new);
>> +             return -EPERM;
>> +     }
>>
>> -     set_groups(new, group_info);
>> +     set_groups_sorted(new, group_info);
>>       return commit_creds(new);
>>  }
>>
>> @@ -233,8 +262,6 @@ SYSCALL_DEFINE2(setgroups, int, gidsetsize, gid_t __user *, grouplist)
>>       struct group_info *group_info;
>>       int retval;
>>
>> -     if (!ns_capable(current_user_ns(), CAP_SETGID))
>> -             return -EPERM;
>>       if ((unsigned)gidsetsize > NGROUPS_MAX)
>>               return -EINVAL;
>>
>> diff --git a/kernel/uid16.c b/kernel/uid16.c
>> index 602e5bb..b27e167 100644
>> --- a/kernel/uid16.c
>> +++ b/kernel/uid16.c
>> @@ -176,8 +176,6 @@ SYSCALL_DEFINE2(setgroups16, int, gidsetsize, old_gid_t __user *, grouplist)
>>       struct group_info *group_info;
>>       int retval;
>>
>> -     if (!ns_capable(current_user_ns(), CAP_SETGID))
>> -             return -EPERM;
>>       if ((unsigned)gidsetsize > NGROUPS_MAX)
>>               return -EINVAL;
>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-api" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Andy Lutomirski
AMA Capital Management, LLC
