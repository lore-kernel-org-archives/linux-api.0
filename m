From: Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH] cgroup namespaces: add a 'nsroot=' mountinfo field
Date: Wed, 13 Apr 2016 16:31:07 -0700
Message-ID: <CAGr1F2HXJ1BdMFY+vF40O_khE+4S7OnbQPv-h1Q_AmGGhL7mzw@mail.gmail.com>
References: <20160321234133.GA22463@mail.hallyn.com> <20160413175736.GC3676@htj.duckdns.org>
 <20160413184639.GA29483@mail.hallyn.com> <20160413185033.GH3676@htj.duckdns.org>
 <20160413190152.GA29753@mail.hallyn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160413190152.GA29753-7LNsyQBKDXoIagZqoN9o3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Containers <containers-qjLDD68F18O7TbgM5vRIOg@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, cgroups mailinglist <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Apr 13, 2016 at 12:01 PM, Serge E. Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org> wrote:
> Quoting Tejun Heo (tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org):
>> Hello, Serge.
>>
>> On Wed, Apr 13, 2016 at 01:46:39PM -0500, Serge E. Hallyn wrote:
>> > It's not a leak of any information we're trying to hide.  I realize
>> > something like 8 years have passed, but I still basically go by the
>> > ksummit guidance that containers are ok but the kernel's first priority
>> > is to facilitate containers but not trick containers into thinking
>> > they're not containerized.  So long as the container is properly set
>> > up, I don't think there's anything the workload could do with the
>> > nsroot= info other than *know* that it is in a ns cgroup.
>> >
>> > If we did change that guidance, there's a slew of proc info that we
>> > could better virtualize :)
>>
>> I see.  I'm just wondering because the information here seems a bit
>> gratuituous.  Isn't the only thing necessary telling whether the root
>> is bind mounted or namescoped?  Wouldn't simple "nsroot" work for that
>> purpose?
>
> I don't think so - we could be in a cgroup namespace but still have
> access only to bind-mounted cgroups.  So we need to compare the
> superblock dentry root field to the nsroot= value.

Umm, I don't think this is such a good idea. The main purpose of
cgroup namespace was to prevent this exposure of system cgroup
hierarchy that used to happen because of /proc/self/cgroup. Wouldn't
showing that information in /proc/self/mountinfo defeat the purpose?

> One practical problem I've found with cgroup namespaces is that there
> is no way to disambiguate between a cgroupfs mount which was done in
> a cgroup namespace, and a bind mount of a cgroupfs directory.

Thats actually by design, no? Namespaced apps should not know/care if
they are running inside namespace. If they can find it out today, its
just because of certain side-effects. I fear adding explicit "nsroot"
or something in /proc/self/mountinfo now becomes an API making it hard
to virtualize user-apps again.

-- 
Aditya
