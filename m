From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [PATCH] userns,pidns: Verify the userns for new pid namespaces
Date: Tue, 02 May 2017 15:39:50 -0500
Message-ID: <87y3ufgfhl.fsf@xmission.com>
References: <149329634856.21195.14196911999722279118.stgit@localhost.localdomain>
        <87mvb16fv7.fsf@xmission.com>
        <12a73543-79ea-4bac-7e96-6ab237534af2@virtuozzo.com>
        <877f254yx0.fsf@xmission.com>
        <a9941daf-861b-453c-37b8-e95389a9959b@virtuozzo.com>
        <8737crt4dz.fsf@xmission.com> <87vapnrp7f.fsf_-_@xmission.com>
        <d67c8c06-2e6b-9cc0-df81-71d3cf4bb43d@virtuozzo.com>
        <fab323b8-a909-bbce-77d2-afbcd3b0452e@virtuozzo.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <fab323b8-a909-bbce-77d2-afbcd3b0452e-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org> (Kirill
        Tkhai's message of "Tue, 2 May 2017 13:04:37 +0300")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kirill Tkhai <ktkhai-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org
List-Id: linux-api@vger.kernel.org

Kirill Tkhai <ktkhai-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org> writes:
>>> diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
>>> index 2f735cbe05e8..7d8658fbabc8 100644
>>> --- a/kernel/user_namespace.c
>>> +++ b/kernel/user_namespace.c
>>> @@ -986,19 +986,25 @@ bool userns_may_setgroups(const struct user_namespace *ns)
>>>  }
>>>  
>>>  /*
>>> - * Returns true if @ns is the same namespace as or a descendant of
>>> - * @target_ns.
>>> + * Returns true if @child is the same namespace or a descendant of
>>> + * @ancestor.
>>>   */
>>> -bool current_in_userns(const struct user_namespace *target_ns)
>>> +bool in_userns(const struct user_namespace *ancestor,
>>> +	       const struct user_namespace *child)
>>>  {
>>> -	struct user_namespace *ns;
>>> -	for (ns = current_user_ns(); ns; ns = ns->parent) {
>>> -		if (ns == target_ns)
>>> +	const struct user_namespace *ns;
>>> +	for (ns = child; ns; ns = ns->parent) {
>>> +		if (ns == ancestor)
>>>  			return true;
>>>  	}
>>>  	return false;
>>>  }
>> 
>> We have user_namespace::level, so it's possible to stop iterations earlier
>> and save some cpu cycles:
>> 
>> 	for (ns = child; ns->level >= ancestor->level; ns = ns->parent)
>
> Just ">" here.
>
>> 		;
>> 	return (ns == ancestor);

Good observation.  Thank you.

Eric
