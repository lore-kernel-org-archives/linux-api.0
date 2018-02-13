From: Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>
Subject: Re: [PATCH -next 0/3] sysvipc: introduce STAT_ALL commands
Date: Tue, 13 Feb 2018 14:09:11 -0800
Message-ID: <20180213220911.e57z65efqx52pz53@linux-n805>
References: <20180213174136.6346-1-dave@stgolabs.net>
 <878tbw3ak4.fsf@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <878tbw3ak4.fsf-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, 13 Feb 2018, Eric W. Biederman wrote:

>Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org> writes:
>
>> Hi,
>>
>> The following patches adds the discussed[1] new command for shm
>> as well as for sems and msq as they are subject to the same discrepancies
>> for ipc object permission checks between the syscall and via procfs.
>> These new commands are justified in that (1) we are stuck with this
>> semantics as changing syscall and procfs can break userland; and (2) some
>> users can benefit from performance (for large amounts of shm segments,
>> for example) from not having to parse the procfs interface.
>>
>> Once (if) merged, I will submit the necesary manpage updates. But I'm
>> thinking something like:
>
>I am just going to kibitz for a moment.

Nice word that, kibitz.

>
>Could we name this _STAT_ANY or _STAT_NOPERM instead of _STAT_ALL.
>
>I keep thinking a name with _ALL in it should affect all ipc opbjects of
>a given type, not simply work any ipc object regardless of permissions.

Yeah, and _ALL similarly makes the difference of IPC_STAT and SHM_STAT wrt
the passed shmid that more adhoc.

I'm going to go with _STAT_ANY.

Thanks,
Davidlohr
