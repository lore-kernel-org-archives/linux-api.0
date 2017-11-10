From: =?UTF-8?B?TWFoZXNoIEJhbmRld2FyICjgpK7gpLngpYfgpLYg4KSs4KSC4KSh4KWH4KS14KS+4KSwKQ==?=
        <maheshb@google.com>
Subject: Re: [PATCH resend 1/2] capability: introduce sysctl for controlled
 user-ns capability whitelist
Date: Fri, 10 Nov 2017 12:31:09 +0900
Message-ID: <CAF2d9jhCbZA2J1WCc5MNUssiNSNeP5J8i9VNUETKBGhM4X4t8Q@mail.gmail.com>
References: <20171103004433.39954-1-mahesh@bandewar.net> <20171109172201.GA26229@mail.hallyn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171109172201.GA26229@mail.hallyn.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Mahesh Bandewar <mahesh@bandewar.net>, LKML <linux-kernel@vger.kernel.org>, Netdev <netdev@vger.kernel.org>, Kernel-hardening <kernel-hardening@lists.openwall.com>, Linux API <linux-api@vger.kernel.org>, Kees Cook <keescook@chromium.org>, "Eric W . Biederman" <ebiederm@xmission.com>, Eric Dumazet <edumazet@google.com>, David Miller <davem@davemloft.net>
List-Id: linux-api@vger.kernel.org

On Fri, Nov 10, 2017 at 2:22 AM, Serge E. Hallyn <serge@hallyn.com> wrote:
> Quoting Mahesh Bandewar (mahesh@bandewar.net):
>> From: Mahesh Bandewar <maheshb@google.com>
>>
>> Add a sysctl variable kernel.controlled_userns_caps_whitelist. This
>> takes input as capability mask expressed as two comma separated hex
>> u32 words. The mask, however, is stored in kernel as kernel_cap_t type.
>>
>> Any capabilities that are not part of this mask will be controlled and
>> will not be allowed to processes in controlled user-ns.
>>
>> Signed-off-by: Mahesh Bandewar <maheshb@google.com>
>> ---
>>  Documentation/sysctl/kernel.txt | 21 ++++++++++++++++++
>>  include/linux/capability.h      |  3 +++
>>  kernel/capability.c             | 47 +++++++++++++++++++++++++++++++++++++++++
>>  kernel/sysctl.c                 |  5 +++++
>>  4 files changed, 76 insertions(+)
>>
>> diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
>> index 694968c7523c..a1d39dbae847 100644
>> --- a/Documentation/sysctl/kernel.txt
>> +++ b/Documentation/sysctl/kernel.txt
>> @@ -25,6 +25,7 @@ show up in /proc/sys/kernel:
>>  - bootloader_version      [ X86 only ]
>>  - callhome                [ S390 only ]
>>  - cap_last_cap
>> +- controlled_userns_caps_whitelist
>>  - core_pattern
>>  - core_pipe_limit
>>  - core_uses_pid
>> @@ -187,6 +188,26 @@ CAP_LAST_CAP from the kernel.
>>
>>  ==============================================================
>>
>> +controlled_userns_caps_whitelist
>> +
>> +Capability mask that is whitelisted for "controlled" user namespaces.
>> +Any capability that is missing from this mask will not be allowed to
>> +any process that is attached to a controlled-userns. e.g. if CAP_NET_RAW
>> +is not part of this mask, then processes running inside any controlled
>> +userns's will not be allowed to perform action that needs CAP_NET_RAW
>> +capability. However, processes that are attached to a parent user-ns
>> +hierarchy that is *not* controlled and has CAP_NET_RAW can continue
>> +performing those actions. User-namespaces are marked "controlled" at
>> +the time of their creation based on the capabilities of the creator.
>> +A process that does not have CAP_SYS_ADMIN will create user-namespaces
>> +that are controlled.
>
> Hm.  I think that's fine (the way 'controlled' user namespaces are
> defined), but that is design decision in itself, and should perhaps be
> discussed.
>
> Did you consider other ways?  What about using CAP_SETPCAP?
>
I did try other ways e.g. using another bounding-set etc. but
eventually settled with this approach because of main two properties -
(a) This has creation time settings which can be turned on/off at
runtime (b) the run-time knob actually controls the behavior which can
range from no-op to very-drastic without needing the applications to
change and controlled by admin. Also there are always more than one
ways of solving the problem and there possibly could be better
alternative and I don't deny that. :/

Controlling individual capabilities are going to give very different
experience. So how the behavior of the process going to be for a
specific capability is probably out-of-scope for this patch-set. I
would like to offload that responsibility to the admin, as he/she
would be the best judge and knowledgable of the situation /
environment. This should be used as a tool to gain control.

>> +The value is expressed as two comma separated hex words (u32). This
>
> Why comma separated?  whitespace ok?  Leading 0x ok?  What is the
> default at boot?  (Obviously the patch tells me, I'm asking for it
> to be spelled out in the doc)
>
I tried multiple ways including representing capabilities in
string/name form for better readability but didn't want to add
additional complexities of dealing with strings and possible
string-related-issues for this. Also didn't want to reinvent the new
form so settled with something that is widely used (cpu
bounding/affinity/irq mapping etc.) and is capable of handling growing
bit set (currently 37 but possibly more later).

> Otherwise looks good, thanks!
>
> Serge
>
>> +sysctl is avaialble in init-ns and users with CAP_SYS_ADMIN in init-ns
>> +are allowed to make changes.
>> +
>> +==============================================================
>> +
>>  core_pattern:
>>
>>  core_pattern is used to specify a core dumpfile pattern name.
>> diff --git a/include/linux/capability.h b/include/linux/capability.h
>> index b52e278e4744..6c0b9677c03f 100644
>> --- a/include/linux/capability.h
>> +++ b/include/linux/capability.h
>> @@ -13,6 +13,7 @@
>>  #define _LINUX_CAPABILITY_H
>>
>>  #include <uapi/linux/capability.h>
>> +#include <linux/sysctl.h>
>>
>>
>>  #define _KERNEL_CAPABILITY_VERSION _LINUX_CAPABILITY_VERSION_3
>> @@ -247,6 +248,8 @@ extern bool ptracer_capable(struct task_struct *tsk, struct user_namespace *ns);
>>
>>  /* audit system wants to get cap info from files as well */
>>  extern int get_vfs_caps_from_disk(const struct dentry *dentry, struct cpu_vfs_cap_data *cpu_caps);
>> +int proc_douserns_caps_whitelist(struct ctl_table *table, int write,
>> +                              void __user *buff, size_t *lenp, loff_t *ppos);
>>
>>  extern int cap_convert_nscap(struct dentry *dentry, void **ivalue, size_t size);
>>
>> diff --git a/kernel/capability.c b/kernel/capability.c
>> index f97fe77ceb88..62dbe3350c1b 100644
>> --- a/kernel/capability.c
>> +++ b/kernel/capability.c
>> @@ -28,6 +28,8 @@ EXPORT_SYMBOL(__cap_empty_set);
>>
>>  int file_caps_enabled = 1;
>>
>> +kernel_cap_t controlled_userns_caps_whitelist = CAP_FULL_SET;
>> +
>>  static int __init file_caps_disable(char *str)
>>  {
>>       file_caps_enabled = 0;
>> @@ -506,3 +508,48 @@ bool ptracer_capable(struct task_struct *tsk, struct user_namespace *ns)
>>       rcu_read_unlock();
>>       return (ret == 0);
>>  }
>> +
>> +/* Controlled-userns capabilities routines */
>> +#ifdef CONFIG_SYSCTL
>> +int proc_douserns_caps_whitelist(struct ctl_table *table, int write,
>> +                              void __user *buff, size_t *lenp, loff_t *ppos)
>> +{
>> +     DECLARE_BITMAP(caps_bitmap, CAP_LAST_CAP);
>> +     struct ctl_table caps_table;
>> +     char tbuf[NAME_MAX];
>> +     int ret;
>> +
>> +     ret = bitmap_from_u32array(caps_bitmap, CAP_LAST_CAP,
>> +                                controlled_userns_caps_whitelist.cap,
>> +                                _KERNEL_CAPABILITY_U32S);
>> +     if (ret != CAP_LAST_CAP)
>> +             return -1;
>> +
>> +     scnprintf(tbuf, NAME_MAX, "%*pb", CAP_LAST_CAP, caps_bitmap);
>> +
>> +     caps_table.data = tbuf;
>> +     caps_table.maxlen = NAME_MAX;
>> +     caps_table.mode = table->mode;
>> +     ret = proc_dostring(&caps_table, write, buff, lenp, ppos);
>> +     if (ret)
>> +             return ret;
>> +     if (write) {
>> +             kernel_cap_t tmp;
>> +
>> +             if (!capable(CAP_SYS_ADMIN))
>> +                     return -EPERM;
>> +
>> +             ret = bitmap_parse_user(buff, *lenp, caps_bitmap, CAP_LAST_CAP);
>> +             if (ret)
>> +                     return ret;
>> +
>> +             ret = bitmap_to_u32array(tmp.cap, _KERNEL_CAPABILITY_U32S,
>> +                                      caps_bitmap, CAP_LAST_CAP);
>> +             if (ret != CAP_LAST_CAP)
>> +                     return -1;
>> +
>> +             controlled_userns_caps_whitelist = tmp;
>> +     }
>> +     return 0;
>> +}
>> +#endif /* CONFIG_SYSCTL */
>> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
>> index d9c31bc2eaea..25c3f7b76ece 100644
>> --- a/kernel/sysctl.c
>> +++ b/kernel/sysctl.c
>> @@ -1226,6 +1226,11 @@ static struct ctl_table kern_table[] = {
>>               .extra2         = &one,
>>       },
>>  #endif
>> +     {
>> +             .procname       = "controlled_userns_caps_whitelist",
>> +             .mode           = 0644,
>> +             .proc_handler   = proc_douserns_caps_whitelist,
>> +     },
>>       { }
>>  };
>>
>> --
>> 2.15.0.403.gc27cc4dac6-goog
