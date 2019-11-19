From: "prakash.sangappa" <prakash.sangappa@oracle.com>
Subject: Re: [RESEND RFC PATCH 1/1] Selectively allow CAP_SYS_NICE capability
 inside user namespaces
Date: Mon, 18 Nov 2019 16:46:08 -0800
Message-ID: <9b2dd6f5-5b0b-9c9b-e853-5795c352e092@oracle.com>
References: <1574096478-11520-1-git-send-email-prakash.sangappa@oracle.com>
 <1574096478-11520-2-git-send-email-prakash.sangappa@oracle.com>
 <CAG48ez1i9LUd2DPoP9na9OyqXDZVRJZQqBbS1H6Dz_h7mtJ=Mw@mail.gmail.com>
Reply-To: prakash.sangappa@oracle.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAG48ez1i9LUd2DPoP9na9OyqXDZVRJZQqBbS1H6Dz_h7mtJ=Mw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jann Horn <jannh@google.com>
Cc: kernel list <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Thomas Gleixner <tglx@linutronix.de>, Peter Zijlstra <peterz@infradead.org>, "Serge E. Hallyn" <serge@hallyn.com>, Christian Brauner <christian@brauner.io>
List-Id: linux-api@vger.kernel.org



On 11/18/2019 11:30 AM, Jann Horn wrote:
> On Mon, Nov 18, 2019 at 6:04 PM Prakash Sangappa
> <prakash.sangappa@oracle.com> wrote:
>> Allow CAP_SYS_NICE to take effect for processes having effective uid of a
>> root user from init namespace.
> [...]
>> @@ -4548,6 +4548,8 @@ int can_nice(const struct task_struct *p, const int nice)
>>          int nice_rlim = nice_to_rlimit(nice);
>>
>>          return (nice_rlim <= task_rlimit(p, RLIMIT_NICE) ||
>> +               (ns_capable(__task_cred(p)->user_ns, CAP_SYS_NICE) &&
>> +               uid_eq(current_euid(), GLOBAL_ROOT_UID)) ||
>>                  capable(CAP_SYS_NICE));
> I very strongly dislike tying such a feature to GLOBAL_ROOT_UID.
> Wouldn't it be better to control this through procfs, similar to
> uid_map and gid_map? If you really need an escape hatch to become
> privileged outside a user namespace, then I'd much prefer a file
> "cap_map" that lets someone with appropriate capabilities in the outer
> namespace write a bitmask of capabilities that should have effect
> outside the container, or something like that. And limit that to bits
> where that's sane, like CAP_SYS_NICE.

Sounds reasonable. Adding a 'cap_map' file to user namespace, would give 
more control. We could allow the  capability in 'cap_map' to take effect 
only if corresponding capability is enabled for the user inside the user 
namespace Ex uid 0. Start with support for CAP_SYS_NICE?


>
> If we tie features like this to GLOBAL_ROOT_UID, more people are going
> to run their containers with GLOBAL_ROOT_UID. Which is a terrible,
> terrible idea. GLOBAL_ROOT_UID gives you privilege over all sorts of
> files that you shouldn't be able to access, and only things like mount
> namespaces and possibly LSMs prevent you from exercising that
> privilege. GLOBAL_ROOT_UID should only ever be given to processes that
> you trust completely.

Agreed.
